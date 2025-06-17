import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:notes_app/Authentication/Screens/PageDecider.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  double _opacity = 0;

  @override
  void initState() {
    super.initState();

    // Trigger fade-in animation
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        _opacity = 1.0;
      });
    });

    // Navigate to HomePage after 3 seconds
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Decider_Page()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(seconds: 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Lottie animation at the top
              SizedBox(
                width: 200,
                height: 200,
                child: Lottie.asset(
                  'assets/animations/splash.json',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 16),
              // App title text
              const Text(
                "We Listen But We Don't Judge",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
