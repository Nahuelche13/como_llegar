import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_map/flutter_map.dart";
import "package:geolocator/geolocator.dart";
import "package:latlong2/latlong.dart";

class Location with ChangeNotifier {
  Location._() {
    _determinePosition().then((value) {
      _setMarker(value);

      positionStream = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      ).listen(_setMarker);
    });
  }
  late StreamSubscription<Position> positionStream;

  final ValueNotifier<List<Marker>> _locations =
      ValueNotifier<List<Marker>>([]);

  ValueNotifier<List<Marker>> get locationsNotifier => _locations;

  List<Marker> get locations => _locations.value;

  static Location db = Location._();

  @override
  Future<void> dispose() async {
    await positionStream.cancel();
    _locations.dispose();
    super.dispose();
  }

  void _setMarker(Position position) {
    _locations.value = [
      Marker(
        height: 40,
        width: 40,
        point: LatLng(position.latitude, position.longitude),
        builder: (context) => DecoratedBox(
          decoration: BoxDecoration(
            color: () {
              Brightness brightness = Theme.of(context).brightness;
              bool isDarkMode = brightness == Brightness.dark;
              return isDarkMode ? Colors.black : Colors.white;
            }(),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.person_pin_circle_rounded,
            color: () {
              Brightness brightness = Theme.of(context).brightness;
              bool isDarkMode = brightness == Brightness.dark;
              return isDarkMode ? Colors.white : Colors.black;
            }(),
          ),
        ),
      ),
    ];
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Location services are disabled.");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location permissions are denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        "Location permissions are permanently denied, we cannot request permissions.",
      );
    }
    return Geolocator.getCurrentPosition();
  }
}
