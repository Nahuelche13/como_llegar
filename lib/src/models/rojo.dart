import "dart:async";

import "package:como_llegar/src/models/bus.dart";
import "package:flutter/material.dart";
import "package:flutter_map/flutter_map.dart";
import "package:latlong2/latlong.dart";

class Rojo extends Bus {
  Rojo(
      {required super.latLng,
      required int? rum,
      required int bus,
      required int bac,
      required String fec,
      required String hor,
      required int lin,
      required int tra,
      required String lnm,
      required String sal,
      required int p1c,
      required String p1n,
      required int? p2c,
      required String? p2n,
      required int? reg,
      required int? psj,
      required int? poc,
      required String? ico})
      : _rum = rum,
        _bus = bus,
        _bac = bac,
        _fec = fec,
        _hor = hor,
        _lin = lin,
        _tra = tra,
        _lnm = lnm,
        _sal = sal,
        _p1c = p1c,
        _p1n = p1n,
        _p2c = p2c,
        _p2n = p2n,
        _reg = reg,
        _psj = psj,
        _poc = poc,
        _ico = ico;

  factory Rojo.fromJson(final dynamic json) {
    final p = json["properties"];
    return Rojo(
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

  //int id;

  final int? _rum;
  //String est;
  final int _bus;

  //String bmt;
  final int _bac;
  //int bas;
  //int bpp;
  final String _fec;
  final String _hor;
  final int _lin;
  final int _tra;

  //int sen;
  final String _lnm;
  final String _sal;

  //int srv;
  //int ord;
  final int _p1c;
  final String _p1n;
  final int? _p2c;
  final String? _p2n;
  final int? _reg;
  final int? _psj;
  final int? _poc;

  final String? _ico;

  @override
  Future<Column?> bottomSheet(final BuildContext context) {
    return showModalBottomSheet<Column>(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      context: context,
      builder: (final builder) => Column(
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
                      Text("$_lin/$_tra"),
                      Text("$_lnm ($_sal)", overflow: TextOverflow.fade),
                    ],
                  ),
                ),
              ],
            ),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            automaticallyImplyLeading: false,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 8),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.directions_bus_rounded),
                    Text("$_bus"),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.departure_board),
                    Text("$_fec $_hor"),
                  ],
                ),
                if (_psj != null)
                  Row(
                    children: [
                      const Icon(Icons.hail),
                      Text("$_psj ($_poc% ocupado)"),
                    ],
                  ),
              ],
            ),
          ),
          Stepper(
            controlsBuilder:
                (final BuildContext context, final ControlsDetails details) =>
                    Container(),
            steps: [
              Step(
                title: Text("$_p1n ($_p1c)"),
                subtitle: switch (_reg) {
                  null => switch (_ico?[2]) {
                      "r" => const Text("Tarde"),
                      "o" => const Text("En hora"),
                      "a" => const Text("Temprano"),
                      _ => null
                    },
                  > 0 => Text("Trade $_reg minutos."),
                  < 0 => Text("Adelantado ${-_reg!} minutos."),
                  _ => const Text("En hora")
                },
                content: Container(),
                isActive: true,
              ),
              Step(
                title: _p2n != null
                    ? Text("$_p2n ($_p2c)")
                    : const Text("Fin de línea"),
                content: Container(),
                isActive: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color getBackgroundColor(final context) {
    final brightness = Theme.of(context).brightness;
    final isDarkMode = brightness == Brightness.dark;

    return switch (_ico?[2]) {
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

  @override
  Color getForegroundColor(final context) {
    final brightness = Theme.of(context).brightness;
    final isDarkMode = brightness == Brightness.dark;

    return switch (_ico?[2]) {
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

  @override
  Icon getIcon() {
    return Icon(
      _bac == 0 ? Icons.directions_bus_rounded : Icons.accessible_rounded,
    );
  }

  @override
  String getTripId() => "$_lin-$_tra";
  @override
  List<String> getNextStops() => [_p1c.toString(), if(_p2c != null) _p2c.toString()];

  @override
  Text getTitle() => Text("$_lin $_lnm ($_sal)");
  @override
  int getOrd() => _lin;

  @override
  Text getSubtitle() => Text("$_p1n ($_p1c)");

  @override
  Marker toMarker({
    final GestureTapCallback? onTap,
    final GestureTapCallback? onDoubleTap,
    required BuildContext context,
  }) {
    return Marker(
      height: 50,
      width: 50,
      point: latLng,
      child: DecoratedBox(
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
              Text("$_lin"),
              Transform.rotate(
                angle: _rum != null && _ico?[0] != "p" && _bac != 1
                    ? _rum! * (3.1416 / 180)
                    : 0,
                child: () {
                  if (_bac == 1) {
                    return const Icon(Icons.accessible_rounded);
                  }
                  return switch (_ico?[0]) {
                    "p" => const Icon(Icons.pause_rounded),
                    "o" || _ => const Icon(Icons.directions_bus_rounded)
                  };
                }(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
