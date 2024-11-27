import 'package:flutter/material.dart';
import 'package:fund_app/pages/onboarding_page/onboarding_view.dart';
import 'package:fund_app/theme/dark_mode.dart';
import 'package:fund_app/theme/light_mode.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:device_preview/device_preview.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  final supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
  final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
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
