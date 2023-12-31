import 'dart:io';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:imokay/pages/incentives/list.dart';
import 'package:imokay/util/notifications/incentives.dart';
import 'package:imokay/util/notifications/local.dart';
import 'package:imokay/util/theming/controller.dart';
import 'package:imokay/util/theming/themes.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    //Default Colors
    Color accentColor = Theme.of(
      context,
    ).colorScheme.secondary;

    Color favoritesColor = Theme.of(
      context,
    ).colorScheme.secondary;

    Color activeSoundColor = Theme.of(
      context,
    ).appBarTheme.backgroundColor!;

    //Notifications
    bool incentiveNotificationsMode = IncentiveNotifications.current();

    //Settings
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Settings",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Ionicons.ios_chevron_back),
        ),
      ),
      body: SafeArea(
        child: SettingsList(
          physics: const BouncingScrollPhysics(),
          lightTheme: SettingsThemeData(
            settingsListBackground: Theme.of(context).scaffoldBackgroundColor,
            titleTextColor: Theme.of(context).colorScheme.primary,
            settingsTileTextColor: Theme.of(context).colorScheme.primary,
            tileDescriptionTextColor: Theme.of(context).colorScheme.primary,
            leadingIconsColor: Theme.of(context).iconTheme.color,
          ),
          darkTheme: SettingsThemeData(
            settingsListBackground: Theme.of(context).scaffoldBackgroundColor,
            titleTextColor: Colors.white70,
            settingsTileTextColor: Theme.of(context).colorScheme.primary,
            tileDescriptionTextColor: Theme.of(context).colorScheme.primary,
            leadingIconsColor: Theme.of(context).iconTheme.color,
          ),
          sections: [
            SettingsSection(
              title: const Text("UI & Visuals"),
              tiles: [
                //Theme Mode
                SettingsTile.switchTile(
                  leading: const Icon(
                    Ionicons.brush,
                  ),
                  initialValue: ThemeController.current(context: context),
                  onToggle: (mode) {
                    ThemeController.setTheme(context: context, mode: mode);
                  },
                  title: const Text("Theme Mode"),
                  description: ThemeController.current(context: context)
                      ? const Text("Dark Mode")
                      : const Text("Light Mode"),
                ),

                //Custom Colors
                SettingsTile.navigation(
                  leading: const Icon(
                    Ionicons.color_fill,
                  ),
                  title: const Text("Colors"),
                  onPressed: (context) async {
                    await showModalBottomSheet(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(14.0),
                        ),
                      ),
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return SizedBox(
                          width: double.infinity,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Text(
                                  "Colors",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                              ListTile(
                                title: const Text("Accent Color"),
                                trailing: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.secondary,
                                  ),
                                ),
                                onTap: () async {
                                  //Show Dialog
                                  await showColorPickerDialog(
                                    context,
                                    accentColor,
                                  ).then((newColor) {
                                    setState(() {
                                      accentColor = newColor;
                                    });
                                  });
                                },
                              ),
                              ListTile(
                                title: const Text("Favorites Color"),
                                trailing: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: favoritesColor,
                                  ),
                                ),
                                onTap: () async {
                                  //Show Dialog
                                  await showColorPickerDialog(
                                    context,
                                    favoritesColor,
                                  ).then((newColor) {
                                    setState(() {
                                      favoritesColor = newColor;
                                    });
                                  });
                                },
                              ),
                              ListTile(
                                title: const Text("Active Sound Color"),
                                trailing: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: activeSoundColor,
                                  ),
                                ),
                                onTap: () async {
                                  //Show Dialog
                                  await showColorPickerDialog(
                                    context,
                                    activeSoundColor,
                                  ).then((newColor) {
                                    setState(() {
                                      activeSoundColor = newColor;
                                    });
                                  });
                                },
                              ),
                              const SizedBox(
                                height: 40.0,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  //Close Bottom Sheet
                                  Navigator.pop(context);

                                  //Save New Theme
                                  AdaptiveTheme.of(context).setTheme(
                                    light: Themes.light().copyWith(
                                      colorScheme:
                                          Themes.light().colorScheme.copyWith(
                                                secondary: accentColor,
                                              ),
                                      cardColor: activeSoundColor,
                                    ),
                                    dark: Themes.dark().copyWith(
                                      colorScheme:
                                          Themes.dark().colorScheme.copyWith(
                                                secondary: accentColor,
                                              ),
                                      cardColor: activeSoundColor,
                                    ),
                                  );

                                  LocalNotifications.toast(
                                    message: "New Theme Saved",
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).cardColor,
                                ),
                                child: const Text("Guardar Tema"),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),

                //Reset Theme
                SettingsTile.navigation(
                  leading: const Icon(Ionicons.reload),
                  title: const Text("Reset Theme"),
                  onPressed: (context) async {
                    await AdaptiveTheme.of(context).reset();
                    LocalNotifications.toast(message: "Theme Reset");
                  },
                ),
              ],
            ),

            //Incentives
            SettingsSection(
              title: const Text("Incentives"),
              tiles: [
                SettingsTile.switchTile(
                  enabled: !Platform.isIOS,
                  leading: const Icon(Ionicons.notifications),
                  initialValue: incentiveNotificationsMode,
                  onToggle: (status) async {
                    await IncentiveNotifications.setMode(mode: status);
                    setState(() {});
                  },
                  title: const Text("Incentive Notifications"),
                  description: const Text("Get Incentive Notifications"),
                ),
                SettingsTile.navigation(
                  enabled: !Platform.isIOS,
                  leading: const Icon(FontAwesome5Solid.smile_beam),
                  title: const Text("Incentives"),
                  onPressed: (context) {
                    //Show Incentives List
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const IncentivesList(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
