import "package:como_llegar/src/views/pages/list_page.dart";
import "package:como_llegar/src/views/pages/map_page.dart";
import "package:como_llegar/src/views/pages/settings/settings_view.dart";
import "package:como_llegar/src/views/pages/shape_page.dart";
import "package:como_llegar/src/views/pages/stops_page.dart";
import "package:flutter/material.dart";

Drawer drawerWidget(final BuildContext context) => Drawer(
      child: ListView(
        restorationId: "drawer",
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.directions_bus_rounded),
                  Text("Cómo llegar"),
                ],
              ),
            ),
          ),
          ListTile(
            title: const Text("Mapa"),
            leading: const Icon(Icons.map_rounded),
            onTap: () {
              Navigator.restorablePopAndPushNamed(context, MapPage.routeName);
            },
          ),
          ListTile(
            title: const Text("Lista"),
            leading: const Icon(Icons.list_rounded),
            onTap: () {
              Navigator.restorablePopAndPushNamed(context, ListPage.routeName);
            },
          ),
          ListTile(
            title: const Text("Paradas"),
            leading: const Icon(Icons.local_parking),
            onTap: () {
              Navigator.restorablePopAndPushNamed(context, StopsPage.routeName);
            },
          ),
          ListTile(
            title: const Text("Rutas"),
            leading: const Icon(Icons.route),
            onTap: () {
              Navigator.restorablePopAndPushNamed(context, ShapePage.routeName);
            },
          ),
          ListTile(
            title: const Text("Configuración"),
            leading: const Icon(Icons.settings),
            onTap: () {
              Navigator.restorablePopAndPushNamed(
                context,
                SettingsView.routeName,
              );
            },
          ),
        ],
      ),
    );
