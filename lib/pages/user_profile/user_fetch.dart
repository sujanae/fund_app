import 'package:supabase_flutter/supabase_flutter.dart';

Future<List<Map<String, dynamic>>> fetchUserCampaigns(String email) async {
  final supabase = Supabase.instance.client;

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
