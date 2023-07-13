import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";

import "../pages/list_page.dart";
import "../pages/map_page.dart";
import "../pages/settings/settings_view.dart";

Drawer drawerWidget(BuildContext context) => Drawer(
      child: ListView(
        restorationId: "drawer",
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.directions_bus_rounded),
                  Text(AppLocalizations.of(context)!.appTitle)
                ],
              ),
            ),
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.map),
            leading: const Icon(Icons.map_rounded),
            onTap: () {
              Navigator.restorablePopAndPushNamed(context, MapPage.routeName);
            },
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.list),
            leading: const Icon(Icons.list_rounded),
            onTap: () {
              Navigator.restorablePopAndPushNamed(context, ListPage.routeName);
            },
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.settings),
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
