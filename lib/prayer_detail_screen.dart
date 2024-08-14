import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart'; // Import Clipboard
import 'package:vibration/vibration.dart'; // Import Vibration
import 'package:fluttertoast/fluttertoast.dart'; // Import Fluttertoast

import 'app_settings.dart';
import 'settings_drawer.dart';

class PrayerDetailScreen extends StatefulWidget {
  final String name;
  final String image;

  PrayerDetailScreen({
    required this.name,
    required this.image,
  });

  @override
  _PrayerDetailScreenState createState() => _PrayerDetailScreenState();
}

class _PrayerDetailScreenState extends State<PrayerDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final appSettings = Provider.of<AppSettings>(context);
    final theme = appSettings.isDarkTheme ? ThemeData.dark() : ThemeData.light();
    final fontSize = appSettings.fontSize;
    final languageCode = appSettings.locale.languageCode;

    final localizedName = _getLocalizedPrayerName(widget.name, languageCode);
    final introText = _getIntroText(localizedName, languageCode);
    final prayerContent = _getPrayerContent(localizedName, languageCode);

    final isArabic = languageCode.startsWith('ar');
    final textDirection = isArabic ? TextDirection.rtl : TextDirection.ltr;

    return MaterialApp(
      theme: theme,
      home: Directionality(
        textDirection: textDirection,
        child: Scaffold(
          appBar: AppBar(
            title: Align(
              alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft,
              child: Text(localizedName),
            ),
            leading: Builder(
              builder: (BuildContext context) => IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer(); // Open the AppDrawer
                },
              ),
            ),
          ),
          drawer: AppDrawer(), // Include the settings drawer
          drawerEdgeDragWidth: MediaQuery.of(context).size.width, // Allow full edge swipe
          drawerScrimColor: Colors.black54,
          body: Stack(
            children: [
              ListView(
                padding: EdgeInsets.all(16.0),
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: Image.asset(
                      widget.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    introText,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  SizedBox(height: 20),
                  ExpansionTile(
                    initiallyExpanded: false,
                    title: Text(
                      isArabic ? 'تفاصيل الصلاة' : 'Prayer Details',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    children: prayerContent.map((prayerItem) {
                      return GestureDetector(
                        onLongPress: () {
                          _showPsalmDialog(context, prayerItem['title']!, prayerItem['text']!);
                        },
                        child: Card(
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: ExpansionTile(
                            title: GestureDetector(
                              onLongPress: () {
                                _showPsalmDialog(context, prayerItem['title']!, prayerItem['text']!);
                              },
                              child: Text(
                                prayerItem['title']!,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: GestureDetector(
                                  onLongPress: () {
                                    _showPsalmDialog(context, prayerItem['title']!, prayerItem['text']!);
                                  },
                                  child: Text(
                                    prayerItem['text']!,
                                    style: TextStyle(
                                      fontSize: fontSize,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                ],
              ),
              Align(
                alignment: Alignment.topCenter,
                child: GestureDetector(
                  onVerticalDragEnd: (details) {
                    if (details.primaryVelocity! > 0) {
                      Navigator.of(context).pop(); // Pops the current screen
                    }
                  },
                  child: Container(
                    height: 8,
                    width: 50,
                    margin: EdgeInsets.only(top: 7),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: GestureDetector(
                  onVerticalDragEnd: (details) {
                    if (details.primaryVelocity! > 0) {
                      Navigator.of(context).pop(); // Pops the current screen
                    }
                  },
                  child: Container(
                    height: 100, // Increased height for hitbox
                    decoration: BoxDecoration(
                      color: Colors.transparent, // Invisible hitbox
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Localized prayer names based on the language
  String _getLocalizedPrayerName(String prayerName, String languageCode) {
    final Map<String, String> localizedNames = {
      'Morning Prayer': languageCode.startsWith('ar') ? 'صلاة باكر' : 'Morning Prayer',
      'Third Hour Prayer': languageCode.startsWith('ar') ? 'صلاة الساعة الثالثة' : 'Third Hour Prayer',
      'Sixth Hour Prayer': languageCode.startsWith('ar') ? 'صلاة الساعة السادسة' : 'Sixth Hour Prayer',
      'Ninth Hour Prayer': languageCode.startsWith('ar') ? 'صلاة الساعة التاسعة' : 'Ninth Hour Prayer',
      'Eleventh Hour (Vespers)': languageCode.startsWith('ar') ? 'صلاة الساعة الحادية عشر (الغروب)' : 'Eleventh Hour (Vespers)',
      'Twelfth Hour (Compline)': languageCode.startsWith('ar') ? 'صلاة الساعة الثانية عشر (النوم)' : 'Twelfth Hour (Compline)',
      'Midnight Prayer': languageCode.startsWith('ar') ? 'صلاة نصف الليل' : 'Midnight Prayer',
    };

    return localizedNames[prayerName] ?? prayerName;
  }

  // Introductory texts based on the prayer name
  String _getIntroText(String prayerName, String languageCode) {
    final Map<String, String> introTexts = {
      'صلاة باكر': 'في هذه الصلاة نشكر الله على انقضاء الليل بسلام، ونطلب من أجل نهار مضيء بالأعمال الصالحة، وفيها نذكر قيامة السيد المسيح في باكر النهار فنمجده على قيامته.',
      'صلاة الساعة الثالثة': 'في مثل هذه الساعة حكم بيلاطس على السيد المسيح، وأيضًا في مثلها حل الروح القدس على التلاميذ الأطهار. في هذه الصلاة نطلب إضرام مواهب الروح القدس فينا. وهذه الساعة تقابل التاسعة صباحا بالتوقيت الإفرنجي..',
      'صلاة الساعة السادسة': 'محتوى صلاة الساعة السادسة.',
      'صلاة الساعة التاسعة': 'محتوى صلاة الساعة التاسعة.',
      'صلاة الساعة الحادية عشر (الغروب)': 'محتوى صلاة الساعة الحادية عشر (الغروب).',
      'صلاة الساعة الثانية عشر (النوم)': 'محتوى صلاة الساعة الثانية عشر (النوم).',
      'صلاة نصف الليل': 'محتوى صلاة نصف الليل.',
      'Morning Prayer': 'In this prayer, we thank God for the peaceful end of the night and ask for a day filled with good deeds, and we remember the resurrection of Jesus Christ at the beginning of the day and glorify Him for His resurrection.',
      'Third Hour Prayer': 'At this hour, Pilate passed judgment on Jesus, and at the same time, the Holy Spirit descended upon the apostles. In this prayer, we ask for the kindling of the gifts of the Holy Spirit within us. This hour corresponds to 9 AM in the Gregorian time.',
      'Sixth Hour Prayer': 'Content for the Sixth Hour Prayer.',
      'Ninth Hour Prayer': 'Content for the Ninth Hour Prayer.',
      'Eleventh Hour (Vespers)': 'Content for the Eleventh Hour Prayer.',
      'Twelfth Hour (Compline)': 'Content for the Twelfth Hour Prayer.',
      'Midnight Prayer': 'Content for the Midnight Prayer.',
    };

    return introTexts[prayerName] ?? '';
  }

  // Prayer content based on the prayer name
  List<Map<String, String>> _getPrayerContent(String prayerName, String languageCode) {
    final Map<String, List<Map<String, String>>> prayerContentMap = {
      'صلاة باكر': [
        {'title': 'Psalm 1', 'text': 'طوبى للرجل...'},
        {'title': 'Psalm 2', 'text': 'لماذا ارتجت الأمم...'},
        {'title': 'Gospel', 'text': 'إنجيل صلاة باكر...'}
      ],
      'صلاة الساعة الثالثة': [
        {'title': 'Psalm 50', 'text': 'ارحمني يا الله...'},
        {'title': 'Gospel', 'text': 'إنجيل الساعة الثالثة...'}
      ],
      'صلاة الساعة السادسة': [
        {'title': 'Psalm 54', 'text': 'اللهم باسمي...'},
        {'title': 'Gospel', 'text': 'إنجيل الساعة السادسة...'}
      ],
      'صلاة الساعة التاسعة': [
        {'title': 'Psalm 84', 'text': 'ما أحسن مساكنك...'},
        {'title': 'Gospel', 'text': 'إنجيل الساعة التاسعة...'}
      ],
      'صلاة الساعة الحادية عشر (الغروب)': [
        {'title': 'Psalm 141', 'text': 'يا رب إليك صرخت...'},
        {'title': 'Gospel', 'text': 'إنجيل الساعة الحادية عشر...'}
      ],
      'صلاة الساعة الثانية عشر (النوم)': [
        {'title': 'Psalm 4', 'text': 'سمعني حين أصرخ...'},
        {'title': 'Gospel', 'text': 'إنجيل الساعة الثانية عشر...'}
      ],
      'صلاة نصف الليل': [
        {'title': 'Psalm 63', 'text': 'يا الله إلهي إليك أبكر...'},
        {'title': 'Gospel', 'text': 'إنجيل صلاة نصف الليل...'}
      ],
      'Morning Prayer': [
        {'title': 'Psalm 1', 'text': 'Give ear, O Lord, to my words, and hear my cry. Attend to the voice of my supplication, O my King and my God, for to you I will pray. In the morning, O Lord, you will hear my voice; in the morning I will stand before you, and you will see me.For you are a God who does not desire iniquity, and no one who does evil shall dwell with you, nor shall transgressors abide before your eyes. O LORD, you hate all workers of iniquity; you will destroy all who speak lies. The bloody and deceitful man the LORD abhors. But as for me, in the multitude of your mercy I will enter your house; I will worship before your holy temple in your fear.Lead me, O LORD, in your righteousness. Because of my enemies, make your way straight before me. For there is no truth in their mouth; their heart is vain; their throat is an open grave; and with their tongue they have dealt deceitfully. Judge them, O God, and let them fall because of all their schemes; according to the multitude of their wickedness cut them off. For they have provoked you, O LORD.And let all who trust in you be glad; they shall rejoice forever, and you shall dwell in them. And all who love your name shall glory in you. For you, O Lord, have blessed the righteous; you have crowned us as a shield of favor. Alleluia.'},
        {'title': 'Psalm 2', 'text': 'Why do the nations rage...'},
        {'title': 'Gospel', 'text': 'Gospel of the Morning Prayer...'}
      ],
      'Third Hour Prayer': [
        {'title': 'Psalm 50', 'text': 'Have mercy on me, O God...'},
        {'title': 'Gospel', 'text': 'Gospel of the Third Hour...'}
      ],
      'Sixth Hour Prayer': [
        {'title': 'Psalm 54', 'text': 'O God, save me by Your name...'},
        {'title': 'Gospel', 'text': 'Gospel of the Sixth Hour...'}
      ],
      'Ninth Hour Prayer': [
        {'title': 'Psalm 84', 'text': 'How lovely is Your dwelling place...'},
        {'title': 'Gospel', 'text': 'Gospel of the Ninth Hour...'}
      ],
      'Eleventh Hour (Vespers)': [
        {'title': 'Psalm 141', 'text': 'O Lord, I call upon You...'},
        {'title': 'Gospel', 'text': 'Gospel of the Eleventh Hour...'}
      ],
      'Twelfth Hour (Compline)': [
        {'title': 'Psalm 4', 'text': 'Answer me when I call...'},
        {'title': 'Gospel', 'text': 'Gospel of the Twelfth Hour...'}
      ],
      'Midnight Prayer': [
        {'title': 'Psalm 63', 'text': 'O God, You are my God...'},
        {'title': 'Gospel', 'text': 'Gospel of the Midnight Prayer...'}
      ],
    };

    return prayerContentMap[prayerName] ?? [];
  }

  void _showPsalmDialog(BuildContext context, String title, String text) {
    double dialogFontSize = 16.0;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(
                title,
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              content: SingleChildScrollView( // Make content scrollable
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      text,
                      style: TextStyle(fontSize: dialogFontSize),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.zoom_in),
                      onPressed: () {
                        setState(() {
                          dialogFontSize += 2.0;
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.zoom_out),
                      onPressed: () {
                        setState(() {
                          dialogFontSize = dialogFontSize > 10.0 ? dialogFontSize - 2.0 : dialogFontSize;
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.copy),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: text)).then((_) {
                          // Delay showing the toast to ensure it appears
                          Future.delayed(Duration(milliseconds: 100), () {
                            Fluttertoast.showToast(
                              msg: 'Content copied to clipboard ✅',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black54,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );

                            Vibration.vibrate(); // Optional: Trigger vibration on copy
                          });
                        });
                      },
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}
