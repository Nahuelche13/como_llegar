import "dart:async";
import "dart:convert";

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import "package:como_llegar/keys.dart";
import "package:como_llegar/src/models/bus.dart";
import "package:como_llegar/src/models/rojo.dart";
import "package:como_llegar/src/models/stop.dart";
import "package:como_llegar/src/models/stoptime.dart";
import "package:como_llegar/src/models/trips.dart";
import "package:flutter/foundation.dart";
import "package:http/http.dart" as http;
import "package:latlong2/latlong.dart";

class Persistence {
  late Database db;

  Persistence._() {
    init();
  }

  void init() async {
    db = await openDatabase(join(await getDatabasesPath(), 'como_llegar.db'),
        version: 1, onCreate: _onCreate);

    const window = 1000 * 60 * 60 * 24 * 30;
    var table = await db.query("last_update");
    int lastUpdate = 0;
    if (table.isNotEmpty) {
      lastUpdate = table.first["timestamp"] as int;
    }

    if (lastUpdate < DateTime.now().millisecondsSinceEpoch - window) {
      final batch = db.batch();
      batch.update("last_update", {"timestamp": lastUpdate});

      var response = await http.get(Uri.parse("${gtfsURL}stops.txt"));
      var rows = response.body.split("\n");

      batch.delete("stops");
      for (int i = 1; i < rows.length; i++) {
        final columns = rows[i].split(",");
        if (columns.length >= 5) {
          batch.insert("stops", {
            "stop_id": columns[0],
            "stop_code": columns[1],
            "stop_name": columns[2].replaceAll('"', ''),
            "stop_lat": columns[4],
            "stop_lon": columns[5],
          });
        }
      }

      response = await http.get(Uri.parse("${gtfsURL}routes.txt"));
      rows = response.body.split("\n");
      batch.delete("routes");
      for (int i = 1; i < rows.length; i++) {
        final columns = rows[i].split(",");
        if (columns.length >= 3) {
          batch.insert("routes", {
            "route_id": columns[0],
            "route_short_name": columns[2].replaceAll('"', ''),
            "route_long_name": columns[3].replaceAll('"', ''),
          });
        }
      }

      response = await http.get(Uri.parse("${gtfsURL}trips.txt"));
      rows = response.body.split("\n");
      batch.delete("trips");
      for (int i = 1; i < rows.length; i++) {
        final columns = rows[i].split(",");
        if (columns.length >= 7) {
          batch.insert("trips", {
            "route_id": columns[0],
            "service_id": columns[1],
            "trip_id": columns[2],
            "trip_headsign": columns[3].replaceAll('"', ''),
            "trip_short_name": columns[4].replaceAll('"', ''),
            "direction_id": columns[5],
            "shape_id": columns[6],
          });
        }
      }

      response = await http.get(Uri.parse("${gtfsURL}stop_times.txt"));
      rows = response.body.split("\n");
      batch.delete("stop_times");
      for (int i = 1; i < rows.length; i++) {
        final columns = rows[i].split(",");
        if (columns.length >= 4) {
          batch.insert("stop_times", {
            "trip_id": columns[0],
            "arrival_time": columns[1],
            "stop_id": columns[3],
            "stop_sequence": columns[4],
          });
        }
      }

      response = await http.get(Uri.parse("${gtfsURL}shapes.txt"));
      rows = response.body.split("\n");
      batch.delete("shapes");
      for (int i = 1; i < rows.length; i++) {
        final columns = rows[i].split(",");
        if (columns.length >= 3) {
          batch.insert("shapes", {
            "shape_id": columns[0],
            "shape_pt_lat": columns[1],
            "shape_pt_lon": columns[2],
            "shape_pt_sequence": columns[3],
          });
        }
      }

      batch.commit();
    }
  }

  void _onCreate(Database db, int version) async {
    await db.execute('CREATE TABLE last_update(timestamp integer);');
    await db.execute("""
CREATE TABLE stops
(
  stop_id                text PRIMARY KEY,
  stop_code              text NULL,
  stop_name              text NULL,
  stop_lat               double precision NULL,
  stop_lon               double precision NULL
);
""");
    await db.execute("""
CREATE TABLE routes
(
  route_id               text PRIMARY KEY,
  route_short_name       text NULL,
  route_long_name        text NULL CHECK (route_short_name IS NOT NULL OR route_long_name IS NOT NULL)
);
""");
    await db.execute("""
CREATE TABLE trips
(
  route_id               text NOT NULL REFERENCES routes ON DELETE CASCADE ON UPDATE CASCADE,
  service_id             text NOT NULL,
  trip_id                text NOT NULL PRIMARY KEY,
  trip_headsign          text NULL,
  trip_short_name        text NULL,
  direction_id           boolean NULL,
  shape_id               text NULL
);
""");
    await db.execute("""
CREATE TABLE stop_times
(
  trip_id                text NOT NULL REFERENCES trips ON DELETE CASCADE ON UPDATE CASCADE,
  arrival_time           interval NULL,
  stop_id                text NOT NULL REFERENCES stops ON DELETE CASCADE ON UPDATE CASCADE,
  stop_sequence          integer NOT NULL CHECK (stop_sequence >= 0)
);
""");
    await db.execute("""
CREATE TABLE shapes
(
  shape_id               text NOT NULL,
  shape_pt_lat           double precision NOT NULL,
  shape_pt_lon           double precision NOT NULL,
  shape_pt_sequence      integer NOT NULL CHECK (shape_pt_sequence >= 0)
);
""");
  }

  static Persistence i = Persistence._();

  static ValueNotifier<Iterable<Bus>> get busesNotifier => _Rojos.i._buses;
  static update() async => _Rojos.i.update();

  static Future<Iterable<Stop>> allStops() async {
    var stopsMap = await i.db.query("stops");
    return List.generate(stopsMap.length, (i) => Stop.fromMap(stopsMap[i]));
  }

  static Future<Iterable<Stop>> stops(Iterable<String> ids) async {
    var stopsMap = await i.db.query("stops");
    return stopsMap
        .where((element) => ids.contains(element["stop_code"]))
        .map((e) => Stop.fromMap(e));
  }

  static Future<Iterable<Stoptime>> stoptime(String code) async {
    var stoptimesMap = await i.db.rawQuery("""
      SELECT t.trip_headsign, st.arrival_time, st.stop_id
      FROM stop_times st
      JOIN trips t WHERE st.stop_id == ? AND st.trip_id == t.trip_id""",
        [code]);
    return stoptimesMap.map((e) => Stoptime.fromMap(e));
  }

  static Future<Iterable<Trip>> allTrips() async {
    var tripsMap = await i.db.rawQuery("SELECT DISTINCT trip_id, trip_headsign, trip_short_name, shapes.shape_id FROM trips INNER JOIN shapes ON shapes.shape_id==trips.shape_id");
    return tripsMap.map((e) =>
        Trip.fromMap(e));
  }

  static Future<List<LatLng>> shape(String id) async {
    var tripsMap = await i.db.query("shapes",
        where: 'shape_id = ?',
        whereArgs: [id],
        columns: ["shape_pt_lat", "shape_pt_lon"]);
    return tripsMap
        .map(
          (e) => LatLng(
            e["shape_pt_lat"] as double,
            e["shape_pt_lon"] as double,
          ),
        )
        .toList();
  }
}

class _Rojos with ChangeNotifier {
  _Rojos._() {
    update();
    _timer = Timer.periodic(const Duration(seconds: 15), (final _) {
      if (_buses.hasListeners) {
        update();
      }
    });
  }

  late Timer _timer;

  final ValueNotifier<Iterable<Bus>> _buses = ValueNotifier<List<Bus>>([]);

  static _Rojos i = _Rojos._();

  static const headers = <String, String>{
    "Content-Type": "application/geo+json; charset=UTF-8",
  };

  static Future<Iterable<Bus>> requestBuses() async {
    final response = await http.get(Uri.parse(busURL), headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonDecoded = json.decode(response.body);
      final List<dynamic> listOfFeatures = jsonDecoded["features"];
      return listOfFeatures.map<Bus>(Rojo.fromJson).toList();
    } else {
      throw Exception(
        "Failed to get data. Error code: ${response.statusCode}, ${response.reasonPhrase}",
      );
    }
  }

  void update() async => _buses.value = await requestBuses();

  @override
  void dispose() {
    _timer.cancel();
    _buses.dispose();
    super.dispose();
  }
}
