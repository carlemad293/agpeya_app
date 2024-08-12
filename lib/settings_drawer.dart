import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_settings.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appSettings = Provider.of<AppSettings>(context);

    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Settings',
              style: TextStyle(fontSize: appSettings.fontSize, color: Colors.white),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.brightness_6),
            title: Text('Dark Theme', style: TextStyle(fontSize: appSettings.fontSize)),
            trailing: Switch(
              value: appSettings.isDarkTheme,
              activeColor: Colors.blue,  // Set the active color to blue
              onChanged: (value) {
                appSettings.toggleTheme();
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.text_fields),
            title: Text('Font Size', style: TextStyle(fontSize: appSettings.fontSize)),
            subtitle: Slider(
              value: appSettings.fontSize,
              min: 12.0,
              max: 30.0,
              activeColor: Colors.blue,  // Set the active color to blue
              onChanged: (newSize) {
                appSettings.updateFontSize(newSize);
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text('Change Language', style: TextStyle(fontSize: appSettings.fontSize)),
            trailing: DropdownButton<String>(
              value: appSettings.locale.languageCode,
              items: const [
                DropdownMenuItem(value: 'ar', child: Text('Arabic')),
                DropdownMenuItem(value: 'en', child: Text('English')),
              ],
              onChanged: (newLang) {
                appSettings.changeLocale(newLang!);
              },
            ),
          ),
        ],
      ),
    );
  }
}
