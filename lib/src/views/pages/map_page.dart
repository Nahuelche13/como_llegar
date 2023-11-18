import "package:como_llegar/src/models/bus.dart";
import "package:como_llegar/src/persistence/persistence.dart";
import "package:como_llegar/src/views/widgets/drawer_widget.dart";
import "package:como_llegar/src/views/widgets/geolocation.dart";
import "package:como_llegar/src/views/widgets/map_widget.dart";
import "package:flutter/material.dart";
import "package:flutter_map/flutter_map.dart";
import "package:latlong2/latlong.dart";

import 'package:como_llegar/src/models/stop.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});
  static const String routeName = "/map";

  @override
  Widget build(final BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    var center = const LatLng(-34.91, -54.95);

    final ValueNotifier<Iterable<Stop>> stops = ValueNotifier<List<Stop>>([]);
    ValueNotifier<Polygon> path = ValueNotifier<Polygon>(Polygon(points: []));
    final MapController controller = MapController();

    if (args is LatLng) {
      center = args;
    } else if (args is Bus) {
      center = args.latLng;
    }

    return Scaffold(
      restorationId: "map",
      appBar: AppBar(
        title: const Text("Mapa"),
        actions: const <Widget>[
          IconButton(
            icon: Icon(Icons.refresh_rounded),
            tooltip: "Recargar",
            onPressed: Persistence.update,
          ),
        ],
      ),
      drawer: drawerWidget(context),
      body: MapWidget(
        mapController :controller,
        center: center,
        children: <Widget>[
          ValueListenableBuilder<Iterable<Stop>>(
            valueListenable: stops,
            builder: (
              final BuildContext context,
              final Iterable<Stop> data,
              final Widget? child,
            ) =>
                MarkerLayer(
                    markers: data.map((e) => e.toMarker(context)).toList()),
          ),
          ValueListenableBuilder<Polygon>(
            valueListenable: path,
            builder: (
              final BuildContext context,
              final Polygon data,
              final Widget? child,
            ) =>
                PolygonLayer(
              polygons: [data],
            ),
          ),
          ValueListenableBuilder<Iterable<Bus>>(
            valueListenable: Persistence.busesNotifier,
            builder: (
              final BuildContext context,
              final Iterable<Bus> buses,
              final Widget? child,
            ) =>
                MarkerLayer(
              markers: buses
                  .map<Marker>(
                    (final Bus e) => e.toMarker(
                      onTap: () {
                        controller.move(e.latLng, controller.camera.zoom);
                        e.bottomSheet(context);

                        () async {
                          stops.value =
                              (await Persistence.stops(e.getNextStops())).toList();

                          path.value = Polygon(
                            points: await Persistence.shape(e.getTripId()),
                          );
                        }();
                      },
                      context: context,
                    ),
                  )
                  .toList(),
            ),
          ), //Buses
          ValueListenableBuilder<List<Marker>>(
            valueListenable: Location.db.locationsNotifier,
            builder: (
              final BuildContext context,
              final List<Marker> locations,
              final Widget? child,
            ) =>
                MarkerLayer(markers: locations),
          ), //Location
        ],
      ),
    );
  }
}
