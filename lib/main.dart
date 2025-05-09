import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pudez_street_playground/pages/gift/gift_screen.dart';
import 'package:pudez_street_playground/pages/home/home_screen.dart';
import 'package:pudez_street_playground/pages/onboarding/onboarding_screen.dart';
import 'package:pudez_street_playground/pages/survey/survey_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Pretendard',
      ),
      routerConfig: GoRouter(
        initialLocation: '/onboarding',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const HomeScreen(),
            routes: [
              GoRoute(
                path: 'onboarding',
                builder: (context, state) => const OnboardingScreen(),
              ),
              GoRoute(
                path: 'survey',
                builder: (context, state) => const SurveyScreen(),
              ),
              GoRoute(
                path: 'gift',
                builder: (context, state) => const GiftScreen(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
