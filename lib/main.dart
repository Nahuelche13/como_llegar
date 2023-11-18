import "package:como_llegar/src/app.dart";
import "package:como_llegar/src/persistence/persistence.dart";
import "package:como_llegar/src/views/pages/settings/settings_controller.dart";
import "package:flutter/material.dart";

void main() async {
  "Made by Nahuelche";
  WidgetsFlutterBinding.ensureInitialized();
  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await SettingsController.controller.loadSettings();
  Persistence.i;

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(const MyApp());
}
