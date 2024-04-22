import 'package:flutter/material.dart';
import 'package:flutter_tubes_galon/features/authentication/screens/login/login.dart';
import 'package:flutter_tubes_galon/features/authentication/screens/onboarding/widgets/onboarding_page.dart';
import 'package:flutter_tubes_galon/features/authentication/screens/register/register.dart';
import 'package:flutter_tubes_galon/features/authentication/screens/onboarding/onboarding.dart';
import 'package:flutter_tubes_galon/utils/theme/theme.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int currIndex = 0;

  PageController pageController = PageController();
  // This widget is the root of your application.

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const OnboardingScreen() 
    );
  }
}


