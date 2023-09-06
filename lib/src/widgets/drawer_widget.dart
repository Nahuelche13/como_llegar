import "package:flutter/material.dart";

import "../pages/list_page.dart";
import "../pages/map_page.dart";
import "../pages/settings/settings_view.dart";

Drawer drawerWidget(BuildContext context) => Drawer(
      child: ListView(
        restorationId: "drawer",
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.directions_bus_rounded),
                  Text("Cómo llegar")
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
