import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../../config/theme/color.dart';

class AnimatedSplashScreenView extends StatefulWidget {
  const AnimatedSplashScreenView({super.key});

  @override
  State<AnimatedSplashScreenView> createState() => _AnimatedSplashScreenViewState();
}

class _AnimatedSplashScreenViewState extends State<AnimatedSplashScreenView> {

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: backgroundColor,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Colors.transparent,
      ));
    });
    Future.delayed(const Duration(seconds: 3, milliseconds: 40), () {
      context.go('/');
    });
  }

  @override
  Widget build(BuildContext context) {
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarColor: primaryColor,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarDividerColor: Colors.transparent,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ));

    return Scaffold(
      backgroundColor: primaryColor,
      body: Lottie.asset(
        'lib/assets/images/splash-screen.json',
        frameRate: FrameRate.max,
        fit: BoxFit.fill,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        filterQuality: FilterQuality.high,
        options: LottieOptions(
            enableApplyingOpacityToLayers: true
        ),
      ),
    );
  }
}