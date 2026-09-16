import 'dart:async';
import 'package:ever_salon/constants/app_colors.dart';
import 'package:ever_salon/constants/app_translations.dart';
import 'package:ever_salon/screen/auth/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoScale;
  late Animation<double> _textFade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    // Logo Pop/Scale Animation
    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutBack),
      ),
    );

    // Text Fade-in Animation
    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );

    _controller.forward();

    // 3.5 Seconds baad Onboarding par jaane ke liye
    Timer(const Duration(milliseconds: 3500), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        (route) => false,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // MediaQuery for exact screen responsiveness
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/images/splash_bg.png'),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.1),

              // Animated Girl Logo
              ScaleTransition(
                scale: _logoScale,
                child: Image.asset(
                  'assets/images/girl_logo.png',
                  height: screenHeight * 0.22, // 22% of screen height
                  width: screenWidth * 0.5, // 50% of screen width
                  fit: BoxFit.contain,
                ),
              ),

              SizedBox(height: screenHeight * 0.025),

              // Animated Title & Tagline
              FadeTransition(
                opacity: _textFade,
                child: Column(
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: context.tr('splash_ever'),
                            style: TextStyle(
                              fontSize:
                                  screenWidth * 0.1, // Responsive Font Size
                              fontWeight: FontWeight.bold,
                              color: AppColors.textWhite,
                              fontFamily: 'serif',
                              shadows: const [
                                Shadow(
                                  color: Colors.black38,
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                          ),
                          TextSpan(
                            text: context.tr('splash_salon'),
                            style: TextStyle(
                              fontSize: screenWidth * 0.1,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryPink,
                              fontFamily: 'serif',
                              shadows: const [
                                Shadow(
                                  color: Colors.black38,
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.01),

                    Text(
                      context.tr('splash_tagline'),
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        color: AppColors.textWhite,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 2),

              // Animated Dots & Loading Text
              FadeTransition(
                opacity: _textFade,
                child: Column(
                  children: [
                    Text(
                      context.tr('splash_loading'),
                      style: TextStyle(
                        fontSize: screenWidth * 0.032,
                        color: Colors.white70,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.04),
            ],
          ),
        ),
      ),
    );
  }
}
