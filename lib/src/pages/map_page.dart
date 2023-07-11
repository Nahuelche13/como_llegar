import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../database/bus.dart';
import '../widgets/drawer_widget.dart';
import '../widgets/geolocation.dart';
import '../widgets/map_widget.dart';

class MapPage extends StatelessWidget {
  static const routeName = '/map';

  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    Object? args = ModalRoute.of(context)?.settings.arguments;
    LatLng center = const LatLng(-34.91, -54.95);

    if (args is LatLng) {
      center = args;
    }

    return Scaffold(
      restorationId: 'map',
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.map),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: AppLocalizations.of(context)!.reloadBuses,
            onPressed: () => Buses.db.forceUpdate(),
          ),
        ],
      ),
      drawer: drawerWidget(context),
      body: MapWidget(
        center: center,
        children: [
          ValueListenableBuilder<List<Bus>>(
              valueListenable: Buses.db.busesNotifier,
              builder: (BuildContext context, List<Bus> buses, Widget? child) {
                return MarkerLayer(
                  markers: buses
                      .map<Marker>(
                        (e) => e.toMarker(
                          onTap: () {
                            e.bottomSheet(context);
                          },
                        ),
                      )
                      .toList(),
                );
              }), //Buses
          ValueListenableBuilder<List<Marker>>(
            valueListenable: Location.db.locationsNotifier,
            builder:
                (BuildContext context, List<Marker> locations, Widget? child) =>
                    MarkerLayer(markers: locations),
          ), //Location
        ],
      ),
    );
  }
}