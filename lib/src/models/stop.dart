import 'package:como_llegar/src/models/stoptime.dart';
import 'package:como_llegar/src/persistence/persistence.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class Stop {
  final String code;
  final String name;
  final LatLng latLng;

  Stop({required this.code, required this.name, required this.latLng});

  factory Stop.fromMap(Map<String, dynamic> json) {
    return Stop(
      code: json["stop_code"],
      name: json["stop_name"],
      latLng: LatLng(json["stop_lat"], json["stop_lon"]),
    );
  }

  Future bottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (context) => GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          color: const Color.fromRGBO(0, 0, 0, 0.001),
          child: GestureDetector(
            onTap: () {},
            child: DraggableScrollableSheet(
              initialChildSize: 0.4,
              minChildSize: 0.2,
              maxChildSize: 0.75,
              builder: (_, controller) => Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0),
                  ),
                ),
                child: Column(
                  children: [
                    AppBar(
                      title: Text(name),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(25),
                        ),
                      ),
                    ),
                    FutureBuilder(
                      future: Persistence.stoptime(code),
                      builder: ((BuildContext context,
                          AsyncSnapshot<Iterable<Stoptime>> snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.data!.isEmpty) {
                          return const ListTile(title: Text("Sin información"));
                        } else {
                          return Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              controller: controller,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, i) => ListTile(
                                leading: const Icon(Icons.directions_bus),
                                title: Text(
                                  snapshot.data!.elementAt(i).tripHeadsign,
                                ),
                                trailing: Text(
                                  snapshot.data!.elementAt(i).arrivalTime,
                                ),
                              ),
                            ),
                          );
                        }
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Marker toMarker(BuildContext context) {
    return Marker(
      point: latLng,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.inversePrimary,
          shape: BoxShape.circle,
        ),
        child: InkWell(
          child: const Icon(Icons.local_parking_rounded),
          onTap: () => bottomSheet(context),
        ),
      ),
    );
  }
}
