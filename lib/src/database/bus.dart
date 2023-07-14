import "dart:async";
import "dart:convert";

import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:flutter_map/flutter_map.dart";
import "package:http/http.dart" as http;
import "package:latlong2/latlong.dart";

import "../../keys.dart";

class Bus {
  Bus({
    required this.latLng, //Latitude & Longitud
    //this.id, //ID
    this.rum, //Rumbo (en grados)
    //this.est, //Estado?
    required this.bus, //N° de Coche
    //this.bmt, //Matricula
    required this.bac, //Accesibilidad
    //this.bas, //Asientos
    //this.bpp, //Max Pasajero parados?
    required this.fec, //Fecha
    required this.hor, //Hora
    required this.lin, //Linea
    required this.tra, //Trayecto
    //this.sen,
    required this.lnm, //Destino
    required this.sal, //Salida
    //this.srv, //Servicio
    //this.ord,
    required this.p1c, //Parada 1 número
    required this.p1n, //Parada 1 nombre
    this.p2c, //Parada 2 número
    this.p2n, //Parada 2 nombre
    this.reg, //Regulación
    this.psj, //Pasajeros
    this.poc, //Porcentaje ocupado
    this.ico, //Icono
    // this.con     Conductor
    // this.cnm     Conductor
    // this.vel     Velocidad instantanea en km/h
    // this.maq     Maquina
    // this.nvc     Combustible
    // this.vol     Voltaje
  });

  factory Bus.fromJson(Map<String, dynamic> json) {
    var p = json["properties"];
    return Bus(
      latLng: LatLng(
        json["geometry"]["coordinates"][1],
        json["geometry"]["coordinates"][0],
      ),
      //id: p["id"],
      rum: p["rum"],
      //p["est"],
      bus: p["bus"],
      //p["bmt"],
      bac: p["bac"] ?? 0,
      //p["bas"],
      //p["bpp"],
      fec: p["fec"],
      hor: p["hor"],
      lin: p["lin"],
      tra: p["tra"],
      //p["sen"],
      lnm: p["lnm"],
      sal: p["sal"],
      //p["srv"],
      //p["ord"],
      p1c: p["p1c"],
      p1n: p["p1n"],
      p2c: p["p2c"],
      p2n: p["p2n"],
      reg: p["reg"],
      psj: p["psj"],
      poc: p["poc"],
      ico: p["ico"],
    );
  }

  LatLng latLng;

  //int id;

  int? rum;
  //String est;
  int bus;

  //String bmt;
  int bac;
  //int bas;
  //int bpp;
  String fec;
  String hor;
  int lin;
  int tra;

  //int sen;
  String lnm;
  String sal;

  //int srv;
  //int ord;
  int p1c;
  String p1n;
  int? p2c;
  String? p2n;
  int? reg;
  int? psj;
  int? poc;

  String? ico;

  Future bottomSheet(BuildContext context) {
    List<Widget> busDetails = [
      Row(children: [const Icon(Icons.directions_bus_rounded), Text("$bus")]),
      Row(children: [const Icon(Icons.departure_board), Text("$fec $hor")])
    ];
    if (psj != null) {
      busDetails.add(
        Row(
          children: [
            const Icon(Icons.hail),
            Text(psj != null
                ? "$psj ($poc% ${AppLocalizations.of(context)!.occupied})"
                : AppLocalizations.of(context)!.noInformation)
          ],
        ),
      );
    }

    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      context: context,
      builder: (builder) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
            title: Row(
              children: [
                const Icon(Icons.directions_bus_rounded),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("$lin/$tra"),
                      Text("$lnm ($sal)", overflow: TextOverflow.fade)
                    ],
                  ),
                )
              ],
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            automaticallyImplyLeading: false,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 8),
            child: Column(children: busDetails),
          ),
          Stepper(
            controlsBuilder: (BuildContext context, ControlsDetails details) =>
                Container(),
            steps: [
              Step(
                title: Text("$p1n ($p1c)"),
                subtitle: switch (reg) {
                  null => switch (ico?[2]) {
                      "r" => Text(AppLocalizations.of(context)!.late),
                      "o" => Text(AppLocalizations.of(context)!.inTime),
                      "a" => Text(AppLocalizations.of(context)!.early),
                      _ => null
                    },
                  > 0 => Text(
                      "${AppLocalizations.of(context)!.late} $reg ${AppLocalizations.of(context)!.minutes}."),
                  < 0 => Text(
                      "${AppLocalizations.of(context)!.early} ${-reg!} ${AppLocalizations.of(context)!.minutes}."),
                  _ => Text(AppLocalizations.of(context)!.inTime)
                },
                content: Container(),
                isActive: true,
              ),
              Step(
                title: p2n != null
                    ? Text("$p2n ($p2c)")
                    : Text(AppLocalizations.of(context)!.endOfLine),
                content: Container(),
                isActive: true,
              ),
            ],
          )
        ],
      ),
    );
  }

  Color getBackgroundColor(context) {
    Brightness brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;

    return switch (ico?[2]) {
          "r" => isDarkMode ? Colors.red[900] : Colors.red,
          "a" => isDarkMode ? Colors.blue[900] : Colors.blueAccent,
          "o" || _ => isDarkMode ? Colors.black : Colors.white
        } ??
        Colors.black;
    /*
    if (reg == null) {
      return isDarkMode ? Colors.black : Colors.white;
    }
    if (reg! > 0) {
      return isDarkMode ? Colors.red[900] : Colors.red;
    } else if (reg! < 0) {
      return isDarkMode ? Colors.blue[900] : Colors.blue;
    } else {
      return isDarkMode ? Colors.black : Colors.white;
    }*/
  }
  Color getForegroundColor(context) {
    Brightness brightness = Theme.of(context).brightness;
    bool isDarkMode = brightness == Brightness.dark;

    return switch (ico?[2]) {
          "r" => isDarkMode ? Colors.red : Colors.red[900],
          "a" => isDarkMode ? Colors.blueAccent : Colors.blue[900],
          "o" || _ => isDarkMode ? Colors.white : Colors.black
        } ??
        Colors.black;
    /*
    if (reg == null) {
      return isDarkMode ? Colors.black : Colors.white;
    }
    if (reg! > 0) {
      return isDarkMode ? Colors.red[900] : Colors.red;
    } else if (reg! < 0) {
      return isDarkMode ? Colors.blue[900] : Colors.blue;
    } else {
      return isDarkMode ? Colors.black : Colors.white;
    }*/
  }

  Marker toMarker({
    GestureTapCallback? onTap,
    GestureTapCallback? onDoubleTap,
  }) =>
      Marker(
        height: 40,
        width: 40,
        point: latLng,
        builder: (context) => DecoratedBox(
          decoration: BoxDecoration(
            color: getBackgroundColor(context),
            shape: BoxShape.circle,
          ),
          child: InkWell(
            onTap: onTap,
            onDoubleTap: onDoubleTap,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("$lin"),
                Transform.rotate(
                  angle: rum != null && ico?[0] != "p" && bac != 1
                      ? rum! * (3.1416 / 180)
                      : 0,
                  child: () {
                    if (bac == 1) {
                      return const Icon(Icons.accessible_rounded);
                    }
                    return switch (ico?[0]) {
                      "p" => const Icon(Icons.pause_rounded),
                      "o" || _ => const Icon(Icons.directions_bus_rounded)
                    };
                  }(),
                )
              ],
            ),
          ),
        ),
      );
}

class Buses with ChangeNotifier {
  Buses._() {
    forceUpdate();
    _timer = Timer.periodic(const Duration(seconds: 15), (_) {
      if (_buses.hasListeners) {
        forceUpdate();
      }
    });
  }

  late Timer _timer;

  final ValueNotifier<List<Bus>> _buses = ValueNotifier<List<Bus>>([]);
  ValueNotifier<List<Bus>> get busesNotifier => _buses;
  List<Bus> get buses => _buses.value;

  static Buses db = Buses._();

  static Future<List<Bus>> requestBuses() async {
    Map<String, String> headers = {
      "Content-Type": "application/geo+json; charset=UTF-8"
    };
    http.Response response =
        await http.get(Uri.parse(busURL), headers: headers);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      Map<String, dynamic> json = jsonDecode(response.body);
      List<Bus> buses =
          json["features"].map<Bus>((e) => Bus.fromJson(e)).toList();
      return buses;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(
        "Failed to get data. Error code: ${response.statusCode}, ${response.reasonPhrase}",
      );
    }
  }

  Future forceUpdate() async {
    List<Bus> list = await requestBuses();
    if (_buses.value != list) {
      return _buses.value = list;
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _buses.dispose();
    super.dispose();
  }
}
