import "package:flutter/material.dart";

import "../database/bus.dart";
import "../widgets/drawer_widget.dart";
import "map_page.dart";

class ListPage extends StatelessWidget {
  const ListPage({super.key});
  static const routeName = "/list";

  @override
  Widget build(BuildContext context) => Scaffold(
        restorationId: "list",
        appBar: AppBar(
          title: const Text("Lista"),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.refresh_rounded),
              tooltip: "Recargar",
              onPressed: Buses.db.forceUpdate,
            ),
          ],
        ),
        drawer: drawerWidget(context),
        body: ValueListenableBuilder(
          valueListenable: Buses.db.busesNotifier,
          builder: (BuildContext context, List<Bus> buses, Widget? child) {
            buses.sort((a, b) => a.lin.compareTo(b.lin));
            return ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: buses.length,
              itemBuilder: (BuildContext context, int i) {
                Bus bus = buses[i];
                return ListTile(
                  iconColor: bus.getForegroundColor(context),
                  leading: Icon(
                    bus.bac == 0
                        ? Icons.directions_bus_rounded
                        : Icons.accessible_rounded,
                  ),
                  title: Text("${bus.lin} ${bus.lnm} (${bus.sal})"),
                  subtitle: Text("${bus.p1n} (${bus.p1c})"),
                  onTap: () {
                    Navigator.popAndPushNamed(
                      context,
                      MapPage.routeName,
                      arguments: bus,
                    );
                    bus.bottomSheet(context).then((value) {
                      //OnDismiss
                    });
                  },
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            );
          },
        ),
      );
}
