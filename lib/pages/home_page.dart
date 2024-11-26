import 'package:flutter/material.dart';
import 'package:fund_app/pages/auth/auth_service.dart';
import 'package:fund_app/pages/chat_bot/chat_bot.dart';
import 'package:fund_app/pages/login_page.dart';
import 'package:fund_app/pages/profile_page.dart';
import 'package:fund_app/pages/raise_fund/raisefund_page.dart';
import 'package:fund_app/pages/widgets/campaign_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final authService = AuthService();

  bool _isChatbotVisible = false;

  void _toggleChatbotVisibility() {
    setState(() {
      _isChatbotVisible = !_isChatbotVisible;
    });
  }

  void _logout() async {
    try {
      await authService.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error logging out: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Campaigns"),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text("Home"),
              leading: const Icon(Icons.home),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: const Text("Profile"),
              leading: const Icon(Icons.person),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
            ),
            ListTile(
              title: const Text("Raise Funds"),
              leading: const Icon(Icons.add),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RaiseFundsPage()));
                // Navigate to Raise Funds Page (implement as needed)
              },
            ),
            const Divider(),
            ListTile(
              title: const Text("Logout"),
              leading: const Icon(Icons.exit_to_app),
              onTap: _logout,
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Main content
          ListView(
            children: const [
              CampaignWidget(
                title: "Help Students with Supplies",
                targetAmount: 5000,
                currentAmount: 1500,
              ),
              CampaignWidget(
                title: "Build a Library for Local School",
                targetAmount: 10000,
                currentAmount: 4000,
              ),
              CampaignWidget(
                title: "For Students Innovative Project",
                targetAmount: 10000,
                currentAmount: 0,
              ),
              CampaignWidget(
                title: "Graphics Card for AI/ML Researchers",
                targetAmount: 1000,
                currentAmount: 0,
              ),
            ],
          ),
          // Chatbot widget
          if (_isChatbotVisible)
            Positioned(
              bottom: 10,
              right: 10,
              child: ChatBotWidget(
                onClose: _toggleChatbotVisibility,
              ),
            ),

          // Floating Action Button to toggle chatbot visibility
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: _toggleChatbotVisibility,
              child: const Icon(Icons.chat),
            ),
          ),
        ],
      ),
    );
  }
}
