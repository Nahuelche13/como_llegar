import 'package:como_llegar/src/models/stop.dart';
import 'package:como_llegar/src/persistence/persistence.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../widgets/drawer_widget.dart';
import '../widgets/map_widget.dart';

class StopsPage extends StatelessWidget {
  static const routeName = '/stops';

  const StopsPage({super.key});

  @override
  Widget build(BuildContext context) {
    RouteSettings? settings = ModalRoute.of(context)?.settings;
    LatLng args = settings?.arguments is LatLng
        ? settings?.arguments as LatLng
        : const LatLng(-34.91, -54.95);

    return Scaffold(
      restorationId: 'stops',
      appBar: AppBar(title: const Text("Paradas")),
      drawer: drawerWidget(context),
      body: FutureBuilder(
        future: Persistence.allStops(),
        builder:
            (BuildContext context, AsyncSnapshot<Iterable<Stop>> snapshot) {
          if (snapshot.connectionState case ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return MapWidget(
              center: args,
              children: <Widget>[
                MarkerLayer(
                  markers:
                      snapshot.data!.map((s) => s.toMarker(context)).toList(),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
