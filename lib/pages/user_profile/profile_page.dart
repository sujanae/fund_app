import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final supabase = Supabase.instance.client;
  late Future<List<Map<String, dynamic>>> userCampaigns;

  @override
  void initState() {
    super.initState();
    userCampaigns = fetchUserCampaigns(getCurrentUserEmail());
  }

  String getCurrentUserEmail() {
    // Replace with actual user email fetching logic
    return supabase.auth.currentUser?.email ?? "unknown@example.com";
  }

  Future<List<Map<String, dynamic>>> fetchUserCampaigns(String email) async {
    try {
      final response = await supabase
          .from('campaigns')
          .select()
          .eq('user_email', email)
          .order('created_at', ascending: false) as List<dynamic>;

      return response.map((e) => Map<String, dynamic>.from(e)).toList();
    } catch (e) {
      throw Exception('Failed to fetch campaigns: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final email = getCurrentUserEmail();

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
              'Email: $email',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Your Campaigns:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: userCampaigns,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('No campaigns found.'),
                    );
                  } else {
                    final campaigns = snapshot.data!;
                    return ListView.builder(
                      itemCount: campaigns.length,
                      itemBuilder: (context, index) {
                        final campaign = campaigns[index];
                        return UserCampaignWidget(campaign: campaign);
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserCampaignWidget extends StatelessWidget {
  final Map<String, dynamic> campaign;

  const UserCampaignWidget({required this.campaign, super.key});

  @override
  Widget build(BuildContext context) {
    String createdAtDate = 'Unknown';

    if (campaign['created_at'] != null) {
      try {
        final dateTime = DateTime.parse(campaign['created_at']);
        createdAtDate =
            '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
      } catch (e) {
        // Fallback if parsing fails
        createdAtDate = 'Invalid Date';
      }
    }
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              campaign['title'] ?? 'No Title',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              campaign['description'] ?? 'No Description',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              'Goal Amount: \$${campaign['goal_amount'] ?? 0}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              'Current Amount: \$${campaign['current_amount'] ?? 0}',
              style: const TextStyle(fontSize: 16, color: Colors.green),
            ),
            const SizedBox(height: 8),
            Text(
              'Created At: $createdAtDate',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
