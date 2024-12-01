import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fund_app/pages/widgets/campaign_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final supabase = Supabase.instance.client;
  late Future<List<Map<String, dynamic>>> _campaignsFuture;

  @override
  void initState() {
    super.initState();
    _campaignsFuture = fetchCampaigns();
  }

  // Fetch campaigns data from Supabase
  Future<List<Map<String, dynamic>>> fetchCampaigns() async {
    try {
      // Fetch data from the 'campaigns' table
      final response = await supabase
          .from('campaigns') // Ensure the table name is correct
          .select() // Select all columns
          .execute(); // Execute the query

      if (response.error != null) {
        // If there was an error, throw it
        throw response.error!.message;
      }

      // If successful, return the list of campaigns
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      print('Error fetching campaigns: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Campaigns"),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _campaignsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No campaigns available.'));
          } else {
            final campaigns = snapshot.data!;
            return ListView.builder(
              itemCount: campaigns.length,
              itemBuilder: (context, index) {
                final campaign = campaigns[index];
                return CampaignWidget(
                  title: campaign['title'] ??
                      'No Title', // Adjust based on your table schema
                  targetAmount: campaign['target_amount'] ?? 0,
                  currentAmount: campaign['current_amount'] ?? 0,
                );
              },
            );
          }
        },
      ),
    );
  }
}
