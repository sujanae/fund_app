import 'package:flutter/material.dart';
import 'package:fund_app/pages/services/fetch_campaign.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:fund_app/pages/auth/auth_service.dart';
import 'package:fund_app/pages/chat_bot/chat_bot.dart';
import 'package:fund_app/pages/login_page.dart';
import 'package:fund_app/pages/user_profile/profile_page.dart';
import 'package:fund_app/pages/raise_fund/raisefund_page.dart';
import 'package:fund_app/pages/widgets/campaign_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final authService = AuthService();
  final SupabaseClient supabase = Supabase.instance.client;

  bool _isChatbotVisible = false;
  List<Map<String, dynamic>> _campaigns = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCampaigns();
  }

  Future<void> _loadCampaigns() async {
    try {
      final campaigns = await fetchCampaigns();
      setState(() {
        _campaigns = campaigns;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading campaigns: $e')),
      );
    }
  }

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

  // Refresh function to reload the campaigns when triggered
  Future<void> _onRefresh() async {
    await _loadCampaigns(); // Re-fetch campaigns when user pulls to refresh
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
          // Main content - List of campaigns with pull-to-refresh functionality
          RefreshIndicator(
            onRefresh: _onRefresh, // Trigger the refresh function on pull
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _campaigns.isEmpty
                    ? const Center(child: Text('No campaigns found'))
                    : ListView.builder(
                        itemCount: _campaigns.length,
                        itemBuilder: (context, index) {
                          final campaign = _campaigns[index];
                          return CampaignWidget(
                            title: campaign['title'] ?? 'No Title',
                            targetAmount: campaign['target_amount'] ?? 0,
                            currentAmount: campaign['current_amount'] ?? 0,
                          );
                        },
                      ),
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
