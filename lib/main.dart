import 'package:flutter/material.dart';
import 'package:fund_app/pages/onboarding_page/onboarding_view.dart';
import 'package:fund_app/theme/dark_mode.dart';
import 'package:fund_app/theme/light_mode.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:device_preview/device_preview.dart';

void main() async {
  await Supabase.initialize(
      url: 'https://pvhkirsatpmhpjqsswfy.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InB2aGtpcnNhdHBtaHBqcXNzd2Z5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzIyNzE5NDQsImV4cCI6MjA0Nzg0Nzk0NH0.p1XVMPuB-tawipSMf5MJkbICQaEVxZTcRbK80Okodoc');
  // runApp(DevicePreview(builder: (context) => const MyApp()));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const OnboardingView(),
      theme: lightMode,
      darkTheme: darkMode,
    );
  }
}
