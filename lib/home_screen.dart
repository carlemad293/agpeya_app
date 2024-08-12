import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'app_settings.dart';
import 'settings_drawer.dart';
import 'prayer_content.dart';
import 'prayer_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  String _copticDate = '';
  String _gregorianDate = '';
  bool _isDateVisible = true;

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
    final appSettings = Provider.of<AppSettings>(context);

    final prayers = [
      {'name': 'صلاة باكر', 'image': 'assets/morning.png'},
      {'name': 'صلاة الساعة الثالثة', 'image': 'assets/third_hour.png'},
      {'name': 'صلاة الساعة السادسة', 'image': 'assets/sixth_hour.png'},
      {'name': 'صلاة الساعة التاسعة', 'image': 'assets/ninth_hour.png'},
      {'name': 'صلاة الساعة الحادية عشر (الغروب)', 'image': 'assets/eleventh_hour.png'},
      {'name': 'صلاة الساعة الثانية عشر (النوم)', 'image': 'assets/twelfth_hour.png'},
      {'name': 'صلاة نصف الليل', 'image': 'assets/midnight_first_service.png'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Agpeya'),
      ),
      body: Column(
        children: [
          AnimatedSize(
            duration: Duration(milliseconds: 300),
            child: Column(
              children: [
                Visibility(
                  visible: _isDateVisible,
                  child: Column(
                    children: [
                      Text(
                        _gregorianDate,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 4),
                      Text(
                        _copticDate,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isDateVisible = !_isDateVisible;
                    });
                  },
                  child: Icon(
                    _isDateVisible ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    size: 40, // Increased size of the arrow
                  ),
                ),
              ],
            ),
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
                    final prayerName = prayers[index]['name']!;
                    final prayerImage = prayers[index]['image']!;

                    final introText = introductoryTexts[prayerName] ?? '';
                    final content = agpeyaContent[prayerName] ?? '';

                    if (introText.isNotEmpty && content is! List) {
                      Navigator.of(context).push(
                        _createRoute(PrayerDetailScreen(
                          name: prayerName,
                          image: prayerImage,
                          introText: introText,
                          content: content,
                        )),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Content not available for $prayerName'),
                        ),
                      );
                    }
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

  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        final offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
}
