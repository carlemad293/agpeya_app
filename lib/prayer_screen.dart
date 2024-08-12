import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_settings.dart';
import 'main.dart';

class PrayerScreen extends StatelessWidget {
  final String prayerName;

  PrayerScreen(this.prayerName);

  @override
  Widget build(BuildContext context) {
    final fontSize = Provider.of<AppSettings>(context).fontSize;
    return Scaffold(
      appBar: AppBar(
        title: Text(prayerName),
      ),
      body: PageView(
        children: [
          Center(
            child: Text(
              prayerName,
              style: TextStyle(fontSize: fontSize),
            ),
          ),
          // Add additional pages for prayer text as needed
        ],
      ),
    );
  }
}
