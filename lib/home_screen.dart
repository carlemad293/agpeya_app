import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_settings.dart';
import 'settings_drawer.dart';
import 'prayer_detail_screen.dart'; // Import the PrayerDetailScreen
import 'package:intl/intl.dart';

// Other parts of your HomeScreen code...

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
    Timer.periodic(Duration(seconds: 1), (timer) {
      _updateDates();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateDates();
  }

  void _updateDates() {
    final now = DateTime.now();
    final locale = Localizations.localeOf(context).toString();

    final gregorianDate = locale.startsWith('ar')
        ? DateFormat('EEEE dd MMMM, yyyy', locale).format(now)
        : DateFormat('EEEE d MMMM, yyyy', locale).format(now);

    final copticDate = _convertToCopticDate(now, locale);

    setState(() {
      _copticDate = copticDate;
      _gregorianDate = gregorianDate;
    });
  }

  String _convertToCopticDate(DateTime date, String locale) {
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

    final copticMonthNames = {
      'en': ['Toot', 'Baba', 'Hatoor', 'Kiahk', 'Tooba', 'Amshir', 'Baramhat', 'Baramouda', 'Bashans', 'Baouna', 'Abeeb', 'Mesra', 'Nasie'],
      'ar': ['توت', 'بابه', 'هاتور', 'كيهك', 'طوبة', 'أمشير', 'برمهات', 'برمودة', 'بشنس', 'بؤونة', 'أبيب', 'مسرى', 'نسيئ']
    };

    final copticMonthName = copticMonthNames[locale.startsWith('ar') ? 'ar' : 'en']![copticMonth - 1];

    return '${copticDay + 1} $copticMonthName ${copticYear + 1}';
  }

  @override
  Widget build(BuildContext context) {
    final appSettings = Provider.of<AppSettings>(context);
    final locale = Localizations.localeOf(context).toString();

    final localizedTitle = locale.startsWith('ar') ? 'أجبية' : 'Agpeya';

    final prayers = locale.startsWith('ar')
        ? [
      {'name': 'صلاة باكر', 'image': 'assets/morning.png'},
      {'name': 'صلاة الساعة الثالثة', 'image': 'assets/third_hour.png'},
      {'name': 'صلاة الساعة السادسة', 'image': 'assets/sixth_hour.png'},
      {'name': 'صلاة الساعة التاسعة', 'image': 'assets/ninth_hour.png'},
      {'name': 'صلاة الساعة الحادية عشر (الغروب)', 'image': 'assets/eleventh_hour.png'},
      {'name': 'صلاة الساعة الثانية عشر (النوم)', 'image': 'assets/twelfth_hour.png'},
      {'name': 'صلاة نصف الليل', 'image': 'assets/midnight_first_service.png'},
    ]
        : [
      {'name': 'Morning Prayer', 'image': 'assets/morning.png'},
      {'name': 'Third Hour Prayer', 'image': 'assets/third_hour.png'},
      {'name': 'Sixth Hour Prayer', 'image': 'assets/sixth_hour.png'},
      {'name': 'Ninth Hour Prayer', 'image': 'assets/ninth_hour.png'},
      {'name': 'Eleventh Hour (Vespers)', 'image': 'assets/eleventh_hour.png'},
      {'name': 'Twelfth Hour (Compline)', 'image': 'assets/twelfth_hour.png'},
      {'name': 'Midnight Prayer', 'image': 'assets/midnight_first_service.png'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(localizedTitle),
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
                    size: 40,
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

                    Navigator.of(context).push(
                      _createRoute(PrayerDetailScreen(
                        name: prayerName,
                        image: prayerImage,
                      )),
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
                                  color: Colors.black,
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
        const slideBegin = Offset(0.0, 1.0); // Slide from the bottom
        const slideEnd = Offset.zero; // Final position
        const slideCurve = Curves.easeInOut;
        final slideTween = Tween(begin: slideBegin, end: slideEnd).chain(CurveTween(curve: slideCurve));
        final slideAnimation = animation.drive(slideTween);

        const fadeBegin = 0.0; // Start completely transparent
        const fadeEnd = 1.0; // End completely opaque
        const fadeCurve = Curves.easeInOut;
        final fadeTween = Tween(begin: fadeBegin, end: fadeEnd).chain(CurveTween(curve: fadeCurve));
        final fadeAnimation = animation.drive(fadeTween);

        return SlideTransition(
          position: slideAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: child,
          ),
        );
      },
    );
  }
}
