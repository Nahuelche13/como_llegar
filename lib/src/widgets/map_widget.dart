import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../keys.dart';
import '../pages/settings/settings_controller.dart';

class MapWidget extends StatelessWidget {
  final LatLng center;
  final List<Widget> children;
  final MapController? mapController;
  final TapCallback? onTap;

  const MapWidget(
      {Key? key,
      required this.children,
      required this.center,
      this.mapController,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return snapshot.hasData
              ? FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                      crs: const Epsg3857(),
                      center: center,
                      minZoom: 12,
                      zoom: 14,
                      maxZoom: 18,
                      maxBounds: LatLngBounds(
                          const LatLng(-35, -55.35), const LatLng(-34.75, -54.5)),
                      onTap: onTap),
                  nonRotatedChildren: [
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        '© ${maps[SettingsController.controller.mapMode]!["attribution"]!}',
                        style: TextStyle(
                            color: Colors.black,
                            backgroundColor: Colors.grey[300]),
                      ),
                    )
                  ],
                  children: <Widget>[
                        TileLayer(
                          tileProvider: CachedTileProvider(),
                          urlTemplate: maps[
                              SettingsController.controller.mapMode]!["url"]!,
                        )
                      ] +
                      children)
              : const CircularProgressIndicator();
        });
  }
}

class CachedTileProvider extends TileProvider {
  CachedTileProvider();
  @override
  ImageProvider getImage(dynamic coordinates, TileLayer options) =>
      CachedNetworkImageProvider(getTileUrl(coordinates, options));
}
