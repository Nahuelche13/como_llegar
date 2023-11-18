import "package:como_llegar/src/models/bus.dart";
import "package:como_llegar/src/persistence/persistence.dart";
import "package:como_llegar/src/views/pages/map_page.dart";
import "package:como_llegar/src/views/widgets/drawer_widget.dart";
import "package:flutter/material.dart";

class ListPage extends StatelessWidget {
  const ListPage({super.key});
  static const String routeName = "/list";

  @override
  Widget build(final BuildContext context) => Scaffold(
        restorationId: "list",
        appBar: AppBar(
          title: const Text("Lista"),
          actions: const <Widget>[
            IconButton(
              icon: Icon(Icons.refresh_rounded),
              tooltip: "Recargar",
              onPressed: Persistence.update,
            ),
          ],
        ),
        drawer: drawerWidget(context),
        body: ValueListenableBuilder(
          valueListenable: Persistence.busesNotifier,
          builder: (
            final BuildContext context,
            final Iterable<Bus> buses,
            final Widget? child,
          ) {
            (buses as List<Bus>)
                .sort((a, b) => a.getOrd().compareTo(b.getOrd()));
            return ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: buses.length,
              itemBuilder: (final BuildContext context, final int i) {
                final bus = buses.elementAt(i);
                return ListTile(
                  iconColor: bus.getForegroundColor(context),
                  leading: bus.getIcon(),
                  title: bus.getTitle(),
                  subtitle: bus.getSubtitle(),
                  onTap: () {
                    Navigator.popAndPushNamed(
                      context,
                      MapPage.routeName,
                      arguments: bus,
                    );
                    bus.bottomSheet(context).then(
                      (final value) {
                        //OnDismiss
                      },
                    );
                  },
                );
              },
              separatorBuilder: (final _, final __) => const Divider(),
            );
          },
        ),
      );
}
