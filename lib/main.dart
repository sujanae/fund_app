import 'package:flutter/material.dart';
import 'package:fund_app/constants.dart';
import 'package:fund_app/pages/onboarding_page/onboarding_view.dart';
import 'package:fund_app/theme/dark_mode.dart';
import 'package:fund_app/theme/light_mode.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:device_preview/device_preview.dart';

void main() async {
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
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
