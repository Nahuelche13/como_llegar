import "package:flutter/material.dart";
import "package:flutter_map/flutter_map.dart";
import "package:latlong2/latlong.dart";

abstract class Bus {
  Bus({required this.latLng});
  final LatLng latLng;

  Marker toMarker({
    final GestureTapCallback? onTap,
    final GestureTapCallback? onDoubleTap,
    required BuildContext context,
  });

  int getOrd();
  Future bottomSheet(final BuildContext context);

  String getTripId();
  List<String> getNextStops();

  Icon getIcon();
  Text getTitle();
  Text getSubtitle();
  Color getForegroundColor(final context);
}
