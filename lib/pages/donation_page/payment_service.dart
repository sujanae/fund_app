import 'package:supabase_flutter/supabase_flutter.dart';

class PaymentService {
  final SupabaseClient _supabase;

  PaymentService(this._supabase);

  Future<bool> processDonation({
    required String campaignId,
    required double currentAmount,
    required int donationAmount,
    String? donorEmail, // Make this optional
  }) async {
    try {
      // Get current user's email if not provided
      donorEmail ??= _supabase.auth.currentUser?.email;

      // Validate email
      if (donorEmail == null || donorEmail.isEmpty) {
        throw Exception('No email available for donation');
      }

      // Step 1: Update `campaigns` table to increment `current_amount`
      final updatedAmount = currentAmount + donationAmount;
      final campaignUpdateResponse = await _supabase.from('campaigns').update(
          {'current_amount': updatedAmount}).eq('campaign_id', campaignId);

      if (campaignUpdateResponse.error != null) {
        throw Exception(campaignUpdateResponse.error!.message);
      }

      // Step 2: Insert donation into `Donations` table
      final donationInsertResponse = await _supabase.from('Donations').insert({
        'donation_id': DateTime.now().millisecondsSinceEpoch.toString(),
        'campaign_id': campaignId,
        'donar_email': donorEmail,
        'amount': donationAmount,
        'created_at': DateTime.now().toIso8601String(),
      });

      if (donationInsertResponse.error != null) {
        throw Exception(donationInsertResponse.error!.message);
      }

      return true;
    } catch (e) {
      print('Donation processing error: $e');
      return false;
    }
  }
}
