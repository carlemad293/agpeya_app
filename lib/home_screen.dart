import 'dart:async'; // Import for Timer
import 'package:intl/intl.dart'; // Import for DateFormat
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_settings.dart';
import 'settings_drawer.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appSettings = Provider.of<AppSettings>(context);

    final prayers = [
      {'name': 'صلاة باكر', 'image': 'assets/morning.png'},
      {'name': 'صلاة الساعة الثالثة', 'image': 'assets/third_hour.png'},
      {'name': 'صلاة الساعة السادسة', 'image': 'assets/sixth_hour.png'},
      {'name': 'صلاة الساعة التاسعة', 'image': 'assets/ninth_hour.png'},
      {'name': 'صلاة الساعة الحادية عشر (الغروب)', 'image': 'assets/eleventh_hour.png'},
      {'name': 'صلاة الساعة الثانية عشر (النوم)', 'image': 'assets/twelfth_hour.png'},
      {'name': 'صلاة نصف الليل ', 'image': 'assets/midnight_first_service.png'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Agpeya'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CopticDateWidget(), // Add the CopticDateWidget here
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
              ),
              itemCount: prayers.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                        _createRoute(prayers[index]['name']!, prayers[index]['image']!)
                    );
                  },
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              prayers[index]['image']!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            prayers[index]['name']!,
                            style: TextStyle(
                              fontSize: appSettings.fontSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  offset: Offset(2.0, 2.0),
                                  blurRadius: 3.0,
                                  color: Colors.black.withOpacity(0.5),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
    );
  }

  Route _createRoute(String prayerName, String prayerImage) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => PrayerDetailScreen(
        name: prayerName,
        image: prayerImage,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }
}

class CopticDateWidget extends StatefulWidget {
  @override
  _CopticDateWidgetState createState() => _CopticDateWidgetState();
}

class _CopticDateWidgetState extends State<CopticDateWidget> {
  String _copticDate = '';
  String _gregorianDate = '';

  @override
  void initState() {
    super.initState();
    _updateDates();
    Timer.periodic(Duration(seconds: 1), (timer) {
      _updateDates();
    });
  }

  void _updateDates() {
    final now = DateTime.now();
    final copticDate = _convertToCopticDate(now);
    // Specify the locale to prevent changes when the app's language changes
    final gregorianDate = DateFormat('EEEE, MMMM d, yyyy', 'en_US').format(now);
    setState(() {
      _copticDate = copticDate;
      _gregorianDate = gregorianDate;
    });
  }

  String _convertToCopticDate(DateTime date) {
    final a = ((14 - date.month) / 12).floor();
    final m = date.month + 12 * a - 3;
    final y = date.year + (4800 - a) - 1;
    final jdn = date.day + ((153 * m + 2) / 5).floor() + 365 * y + (y / 4).floor() - (y / 100).floor() + (y / 400).floor() - 32045;
    final copticEpoch = 1824665;
    final copticJdn = jdn - copticEpoch;
    final copticYear = (copticJdn / 365.25).floor();
    final copticDayOfYear = copticJdn - (copticYear * 365.25).floor();
    final copticMonth = (copticDayOfYear / 30).floor() + 1;
    final copticDay = copticDayOfYear - (copticMonth - 1) * 30;

    final copticMonthNames = [
      'Toot', 'Baba', 'Hatoor', 'Kiahk', 'Tooba', 'Amshir', 'Baramhat', 'Baramouda', 'Bashans', 'Baouna', 'Abeeb', 'Mesra', 'Nasie'
    ];
    final copticMonthName = copticMonthNames[copticMonth - 1];

    return '${copticDay + 1} $copticMonthName ${copticYear + 1}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center, // Center aligns the text
      children: [
        Text(
          _gregorianDate,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold, // Makes the text bold
          ),
          textAlign: TextAlign.center, // Centers the text horizontally
        ),
        SizedBox(height: 4),
        Text(
          _copticDate,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold, // Makes the text bold
          ),
          textAlign: TextAlign.center, // Centers the text horizontally
        ),
      ],
    );
  }
}

class PrayerDetailScreen extends StatelessWidget {
  final String name;
  final String image;

  PrayerDetailScreen({required this.name, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(image),
            SizedBox(height: 20),
            Text(
              name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
