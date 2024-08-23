import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_settings.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appSettings = Provider.of<AppSettings>(context);

    // Determine the text based on the selected language
    final String drawerTitle = appSettings.locale.languageCode == 'ar' ? 'الأجبية' : 'Agpeya';
    final String settingsTitle = appSettings.locale.languageCode == 'ar' ? 'إعدادات' : 'Settings';
    final String aboutTitle = appSettings.locale.languageCode == 'ar' ? 'حول التطبيق' : 'About';

    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/drawer_image.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.5), // Dim the image
                  BlendMode.darken,
                ),
              ),
            ),
            child: Center( // Center the text within the DrawerHeader
              child: Text(
                drawerTitle,
                style: TextStyle(
                  fontSize: 30.0, // Set a bigger and constant font size
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(5.0, 5.0),
                      blurRadius: 20.0,
                      color: Colors.black.withOpacity(1),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ExpansionTile(
            leading: const Icon(Icons.settings),
            title: Text(settingsTitle, style: TextStyle(fontSize: appSettings.fontSize)),
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.brightness_6),
                title: Text('Dark Mode', style: TextStyle(fontSize: appSettings.fontSize)),
                trailing: Switch(
                  value: appSettings.isDarkTheme,
                  activeColor: Colors.blue,
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
                  activeColor: Colors.blue,
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
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(aboutTitle, style: TextStyle(fontSize: appSettings.fontSize)),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(aboutTitle),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Image.asset('assets/developer_logo.png', height: 100), // Developer's logo
                        SizedBox(height: 20),
                        Text(
                          appSettings.locale.languageCode == 'ar'
                              ? 'تم تطوير التطبيق بواسطة:\nكارل عماد و مارتن ماجد'
                              : 'Developed by:\nCarl Emad & Martin Maged',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: appSettings.fontSize),
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text(
                          appSettings.locale.languageCode == 'ar' ? 'إغلاق' : 'Close',
                          style: TextStyle(fontSize: appSettings.fontSize),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
