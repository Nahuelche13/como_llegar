import "package:como_llegar/src/views/pages/list_page.dart";
import "package:como_llegar/src/views/pages/map_page.dart";
import "package:como_llegar/src/views/pages/settings/settings_controller.dart";
import "package:como_llegar/src/views/pages/settings/settings_view.dart";
import "package:como_llegar/src/views/pages/stops_page.dart";
import 'package:como_llegar/src/views/pages/shape_page.dart';
import "package:flutter/material.dart";

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: SettingsController.controller,
        builder: (BuildContext context, Widget? child) => MaterialApp(
          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          restorationScopeId: "app",

          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          theme: ThemeData(useMaterial3: true),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
          ),
          themeMode: SettingsController.controller.themeMode,

          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          onGenerateRoute: (RouteSettings routeSettings) =>
              MaterialPageRoute<void>(
            settings: routeSettings,
            builder: (BuildContext context) => switch (routeSettings.name) {
              SettingsView.routeName => const SettingsView(),
              ListPage.routeName => const ListPage(),
              StopsPage.routeName => const StopsPage(),
              ShapePage.routeName => const ShapePage(),
              _ => const MapPage()
            },
          ),
        ),
      );
}
