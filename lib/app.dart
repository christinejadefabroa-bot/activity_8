import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

class FabroaProjectApp extends StatelessWidget {
  const FabroaProjectApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Activity 8 Fabroa Project',
    initialRoute: '/',
    routes: {
      '/': (_) => const HomeScreen(),
      '/login': (_) => const LoginScreen(),
    },
  );
}
