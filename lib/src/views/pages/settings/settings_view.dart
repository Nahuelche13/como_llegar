import "package:como_llegar/keys.dart";
import "package:como_llegar/src/views/pages/settings/settings_controller.dart";
import "package:flutter/material.dart";

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the SettingsController is updated and
/// Widgets that listen to the SettingsController are rebuilt.
class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  static const String routeName = "/settings";

  @override
  Widget build(final BuildContext context) => Scaffold(
        restorationId: "settings",
        appBar: AppBar(
          title: const Text("Configuración"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          // Glue the SettingsController to the theme selection DropdownButton.
          //
          // When a user selects a theme from the dropdown list, the
          // SettingsController is updated, which rebuilds the MaterialApp.
          child: AnimatedBuilder(
            animation: SettingsController.controller,
            builder: (final BuildContext context, final Widget? child) => ListView(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text("Mapa"),
                    DropdownButton<String>(
                      // Read the selected themeMode from the controller
                      value: SettingsController.controller.mapMode,
                      // Call the updateThemeMode method any time the user selects a theme.
                      onChanged: SettingsController.controller.updateMapMode,
                      items: maps.keys
                          .map(
                            (final String key) => DropdownMenuItem(
                              value: key,
                              child: Text(key),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text("Tema"),
                    DropdownButton<ThemeMode>(
                      // Read the selected themeMode from the controller
                      value: SettingsController.controller.themeMode,
                      // Call the updateThemeMode method any time the user selects a theme.
                      onChanged: SettingsController.controller.updateThemeMode,
                      items: const <DropdownMenuItem<ThemeMode>>[
                        DropdownMenuItem(
                          value: ThemeMode.system,
                          child: Text("Sistema"),
                        ),
                        DropdownMenuItem(
                          value: ThemeMode.light,
                          child: Text("Claro"),
                        ),
                        DropdownMenuItem(
                          value: ThemeMode.dark,
                          child: Text("Oscuro"),
                        ),
                      ],
                    ),
                  ],
                ),
                const Text(
                  "ATENCIÓN! Los recorridos, horarios y paradas pueden estar desactualizados, erróneos o ser inexistentes.",
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ),
      );
}
