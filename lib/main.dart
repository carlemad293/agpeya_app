// main.dart

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'app_settings.dart';
import 'home_screen.dart';  // Assuming you have a HomeScreen widget
import 'splash_screen.dart';  // Assuming you have a SplashScreen widget

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppSettings>(
      create: (context) => AppSettings(),
      child: Consumer<AppSettings>(
        builder: (context, settings, child) {
          return MaterialApp(
            locale: settings.locale ?? Locale('en'), // Default to English if locale is null
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('ar'),
              Locale('en'),
            ],
            theme: ThemeData(
              primarySwatch: Colors.blue,
              brightness: settings.isDarkTheme ? Brightness.dark : Brightness.light,
              textTheme: TextTheme(
                bodyMedium: TextStyle(fontSize: settings.fontSize ?? 16.0), // Default font size
              ),
            ),
            home: SplashScreen(), // Assuming SplashScreen is a valid widget
          );
        },
      ),
    );
  }
}
