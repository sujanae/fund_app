import 'package:supabase_flutter/supabase_flutter.dart';

Future<List<Map<String, dynamic>>> fetchCampaigns() async {
  final supabase = Supabase.instance.client;

  try {
    final response = await supabase
        .from('campaigns')
        .select() // Select all columns
        .order('created_at', ascending: false);

    // Convert integer amounts to double
    final processedCampaigns = response.map((campaign) {
      return {
        ...campaign,
        'target_amount': (campaign['goal_amount'] as num).toDouble(),
        'current_amount': (campaign['current_amount'] as num).toDouble(),
      };
    }).toList();

    return processedCampaigns;
  } catch (e) {
    print('Failed to fetch campaigns: $e');
    return []; // Return an empty list in case of error
  }
}
