import 'dart:math';
import 'package:flutter/material.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late String randomVerse;

  final List<String> englishVerses = [
    "Pray without ceasing. (1 Thessalonians 5:17)",
    "Ask, and it will be given to you. (Matthew 7:7)",
    "The Lord is near to all who call on him. (Psalm 145:18)",
    "The prayer of a righteous person has great power. (James 5:16)",
    "Do not be anxious about anything. (Philippians 4:6)",
    "Pray at all times in the Spirit. (Ephesians 6:18)",
    "Seek the Lord while he may be found. (Isaiah 55:6)",
    "Continue steadfastly in prayer. (Colossians 4:2)",
    "Call to me and I will answer you. (Jeremiah 33:3)",
    "Rejoice in hope, be patient in tribulation, be constant in prayer. (Romans 12:12)"
  ];

  final List<String> arabicVerses = [
    "صلوا بلا انقطاع. (تسالونيكي الأولى 5:17)",
    "اسألوا تعطوا. (متى 7:7)",
    "الرب قريب لكل الذين يدعونه. (مزمور 145:18)",
    "صلاة البار تقتدر كثيرًا في فعلها. (يعقوب 5:16)",
    "لا تهتموا بشيء. (فيلبي 4:6)",
    "صلوا في كل وقت في الروح. (أفسس 6:18)",
    "اطلبوا الرب ما دام يوجد. (إشعياء 55:6)",
    "واظبوا على الصلاة. (كولوسي 4:2)",
    "ادعني فأجيبك. (إرميا 33:3)",
    "فرحين في الرجاء، صابرين في الضيق، مواظبين على الصلاة. (رومية 12:12)"
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward(); // Start fade-in animation
    Future.delayed(const Duration(seconds: 5), () { // Increase duration to 5 seconds
      _controller.reverse().then((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Determine app language
    bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    // Select a random verse based on the language
    final List<String> verses = isArabic ? arabicVerses : englishVerses;
    randomVerse = verses[Random().nextInt(verses.length)];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 300,
                height: 400,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 4.0,
                  ),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25.0),
                  child: Image.asset(
                    'assets/splash_image.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 20), // Space between the image and verse
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  randomVerse,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
