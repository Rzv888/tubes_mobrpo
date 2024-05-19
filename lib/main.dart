import 'package:flutter/material.dart';
import 'package:flutter_tubes_galon/features/authentication/screens/login/login.dart';
import 'package:flutter_tubes_galon/features/authentication/screens/onboarding/widgets/onboarding_page.dart';
import 'package:flutter_tubes_galon/features/authentication/screens/register/register.dart';
import 'package:flutter_tubes_galon/features/authentication/screens/onboarding/onboarding.dart';
import 'package:flutter_tubes_galon/utils/theme/theme.dart';
import 'package:get/get.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://zsgzpckauumzmywrbzym.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpzZ3pwY2thdXVtem15d3JienltIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTYxNDc4ODcsImV4cCI6MjAzMTcyMzg4N30.jQGqiFVGu0zooWUFxemyCx0ORBZTndFSixWwRM_CBxQ',
  );
  runApp(MyApp());
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
        home: const OnboardingScreen());
  }
}
