import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Static list of campaigns for user 'sujan@gmail.com'
    final campaigns = [
      {
        'title': 'Student Fund',
        'description': 'Sample test campaign for students.',
        'goal_amount': '123356',
        'current_amount': '0',
      },
      {
        'title': 'Project Prototype Fund',
        'description':
            'Raising funds to build a prototype for a college science project.',
        'goal_amount': '15000',
        'current_amount': '1000',
      },
      {
        'title': 'Educational Supplies',
        'description':
            'Providing textbooks, notebooks, and stationery for low-income students.',
        'goal_amount': '10000',
        'current_amount': '500',
      },
    ];

    // Static email for 'sujan@gmail.com'
    final String currentEmail = 'sujan@gmail.com';

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
            const SizedBox(height: 20),
            const Text(
              'Your Campaigns:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: campaigns.length,
                itemBuilder: (context, index) {
                  final campaign = campaigns[index];
                  return UserCampaignWidget(campaign);
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
  final Map<String, String> campaign;

  const UserCampaignWidget(this.campaign, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              campaign['title'] ?? 'No Title',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              campaign['description'] ?? 'No Description',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  'Goal: \$${campaign['goal_amount']}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 20),
                Text(
                  'Raised: \$${campaign['current_amount']}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
