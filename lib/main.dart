import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pudez_street_playground/pages/home/home-screen.dart';
import 'package:pudez_street_playground/pages/onboarding/onboarding-screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
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
            ],
          ),
        ],
      ),
    );
  }
}
