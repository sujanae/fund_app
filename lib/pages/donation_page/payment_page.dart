import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PaymentPage extends StatefulWidget {
  final String campaignId;
  final String campaignTitle;
  final String campaignDescription;
  final double campaignGoalAmount;
  final double currentAmount;
  final ValueChanged<int> onDonationComplete;

  const PaymentPage({
    required this.campaignId,
    required this.campaignTitle,
    required this.campaignDescription,
    required this.campaignGoalAmount,
    required this.currentAmount,
    required this.onDonationComplete,
    super.key,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int selectedAmount = 100;
  bool isLoading = false;

  final accountNameController = TextEditingController();
  final accountNumberController = TextEditingController();

  // Custom function to format account number input
  String formatAccountNumber(String input) {
    String cleanInput =
        input.replaceAll(RegExp(r'\D'), ''); // Remove non-digits
    String formatted = '';
    for (int i = 0; i < cleanInput.length; i++) {
      if (i > 0 && i % 4 == 0) {
        formatted += ' '; // Add space after every 4 digits
      }
      formatted += cleanInput[i];
    }
    return formatted;
  }

  // Complete donation and update Supabase tables
  void completeDonation() async {
    if (accountNameController.text.isEmpty ||
        accountNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields.")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Get Supabase client
      final supabase = Supabase.instance.client;

      // Step 1: Update `campaigns` table to increment `current_amount`
      final updatedAmount = widget.currentAmount + selectedAmount;
      final campaignUpdateResponse = await supabase
          .from('campaigns')
          .update({'current_amount': updatedAmount}).eq(
              'campaign_id', widget.campaignId);

      if (campaignUpdateResponse.error != null) {
        throw Exception(campaignUpdateResponse.error!.message);
      }

      // Step 2: Insert donation into `Donations` table
      final donationInsertResponse = await supabase.from('Donations').insert({
        'donation_id': DateTime.now().millisecondsSinceEpoch.toString(),
        'campaign_id': widget.campaignId,
        'donar_email': 'donar@example.com', // Replace with actual user email
        'amount': selectedAmount,
        'created_at': DateTime.now().toIso8601String(),
      });
      if (donationInsertResponse.error != null) {
        print("Insert failed: ${donationInsertResponse.error!.message}");
      } else {
        print("Insert successful!");
      }

      if (donationInsertResponse.error != null) {
        throw Exception(donationInsertResponse.error!.message);
      }

      // Success: Notify parent widget and pop page
      widget.onDonationComplete(selectedAmount);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Donation successful!")),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error processing donation: $e")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Donation Page"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Campaign Details Section
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.campaignTitle,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.campaignDescription,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Goal Amount: \$${widget.campaignGoalAmount.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Current Amount: \$${widget.currentAmount.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Existing Payment Form
              const Text(
                "Enter Account Details:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: accountNameController,
                decoration: const InputDecoration(
                  labelText: "Account Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: accountNumberController,
                decoration: const InputDecoration(
                  labelText: "Account Number",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // Allow only digits
                  TextInputFormatter.withFunction((oldValue, newValue) {
                    String newText = formatAccountNumber(newValue.text);
                    return TextEditingValue(
                      text: newText,
                      selection:
                          TextSelection.collapsed(offset: newText.length),
                    );
                  }),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "Select Donation Amount:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [100, 500, 1000].map((amount) {
                  return ChoiceChip(
                    label: Text("\$ $amount"),
                    selected: selectedAmount == amount,
                    onSelected: (_) => setState(() => selectedAmount = amount),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : completeDonation,
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text("Donate Now"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
