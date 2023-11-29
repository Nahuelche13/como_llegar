import "package:como_llegar/src/persistence/persistence.dart";
import "package:como_llegar/src/views/widgets/drawer_widget.dart";
import "package:como_llegar/src/views/widgets/map_widget.dart";
import "package:flutter/material.dart";
import "package:flutter_map/flutter_map.dart";
import "package:latlong2/latlong.dart";

class ShapePage extends StatelessWidget {
  const ShapePage({super.key});

  static const String routeName = "/shapes";

  @override
  Widget build(final BuildContext context) {
    var center = const LatLng(-34.91, -54.95);

    ValueNotifier<Polygon> path = ValueNotifier<Polygon>(Polygon(points: []));
    int? selectedRadio = 0;

    return Scaffold(
      restorationId: "map",
      appBar: AppBar(title: const Text("Rutas")),
      drawer: drawerWidget(context),
      floatingActionButton: FutureBuilder(
        future: Persistence.allTrips(),
        builder: (context, data) {
          if (data.hasData) {
            return FloatingActionButton(
              child: const Icon(Icons.route),
              onPressed: () => {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.background,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(25.0),
                                topRight: Radius.circular(25.0),
                              ),
                            ),
                            child: ListView.builder(
                              itemCount: data.data?.length,
                              itemBuilder: (context, index) {
                                return RadioListTile(
                                  value: index,
                                  groupValue: selectedRadio,
                                  title: Text(
                                    "${data.data!.elementAt(index).tripShortName} ${data.data!.elementAt(index).tripHeadsign}",
                                  ),
                                  onChanged: (int? value) async {
                                    path.value = Polygon(
                                      points: await Persistence.shape(
                                          data.data!.elementAt(index).shapeId),
                                    );
                                    setState(() => selectedRadio = value);
                                  },
                                );
                              },
                            ));
                      },
                    );
                  },
                ),
              },
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
      body: MapWidget(
        center: center,
        children: <Widget>[
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
        ],
      ),
    );
  }
}
