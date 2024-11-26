import 'package:flutter/material.dart';
import 'package:fund_app/pages/auth/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final authService = AuthService(); // Create an instance of AuthService

  @override
  Widget build(BuildContext context) {
    // Fetch the current email (Assuming you have a method to get it)
    final currentEmail = authService.getCurrentUserEmail();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              'Email: $currentEmail',
              style: const TextStyle(fontSize: 18),
            ),
            // Add more profile info or functionality here
          ],
        ),
      ),
    );
  }
}
