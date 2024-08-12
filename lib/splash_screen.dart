import 'package:flutter/material.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000), // Duration for fade-in/out
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward(); // Start fade-in animation
    Future.delayed(const Duration(seconds: 3), () {
      _controller.reverse().then((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      });
    });
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
          child: Container(
            width: 300, // Increased width
            height: 400, // Increased height (greater than width)
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black, // Border color
                width: 4.0, // Border width
              ),
              borderRadius: BorderRadius.circular(30.0), // Adjust border radius if needed
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25.0), // Adjust the value for desired roundness
              child: Image.asset(
                'assets/splash_image.png', // Ensure your image is in assets
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
