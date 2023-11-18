import "package:cached_network_image/cached_network_image.dart";
import "package:como_llegar/keys.dart";
import "package:como_llegar/src/views/pages/settings/settings_controller.dart";
import "package:flutter/material.dart";
import "package:flutter_map/flutter_map.dart";
import "package:latlong2/latlong.dart";
import "package:shared_preferences/shared_preferences.dart";

class MapWidget extends StatelessWidget {
  const MapWidget({
    required this.children,
    required this.center,
    super.key,
    this.mapController,
    this.onTap,
  });

  final LatLng center;
  final List<Widget> children;
  final MapController? mapController;
  final TapCallback? onTap;

  @override
  Widget build(final BuildContext context) => FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (
          final BuildContext context,
          final AsyncSnapshot<SharedPreferences> snapshot,
        ) =>
            !snapshot.hasData
                ? const CircularProgressIndicator()
                : FlutterMap(
                    mapController: mapController,
                    options: MapOptions(
                      onTap: onTap,
                      initialCenter: center,
                      minZoom: 12,
                      initialZoom: 14,
                      maxZoom: 18,
                      cameraConstraint: CameraConstraint.contain(
                        bounds: LatLngBounds(
                          const LatLng(-35, -55.35),
                          const LatLng(-34.75, -54.5),
                        ),
                      ),
                    ),
                    children: <Widget>[
                      TileLayer(
                        tileProvider: CachedTileProvider(),
                        urlTemplate:
                            maps[SettingsController.controller.mapMode]?.url,
                      ),
                      RichAttributionWidget(
                        showFlutterMapAttribution: false,
                        attributions: [
                          TextSourceAttribution(maps[SettingsController.controller.mapMode]?.attribution ?? '')
                        ]
                      ),
                      ...children,
                    ],
                  ),
      );
}

class CachedTileProvider extends TileProvider {
  CachedTileProvider();
  @override
  ImageProvider getImage(
    final TileCoordinates coordinates,
    final TileLayer options,
  ) =>
      CachedNetworkImageProvider(getTileUrl(coordinates, options));
}
