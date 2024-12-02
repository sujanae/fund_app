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
  // Donation amount options
  final List<int> donationAmounts = [100, 500, 1000];

  // State variables
  int selectedAmount = 100;
  bool isLoading = false;
  String? _currentUserEmail;

  // Form controllers
  final accountNameController = TextEditingController();
  final accountNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCurrentUserEmail();
  }

  @override
  void dispose() {
    // Clean up controllers
    accountNameController.dispose();
    accountNumberController.dispose();
    super.dispose();
  }

  // Fetch current user's email
  void _getCurrentUserEmail() {
    final user = Supabase.instance.client.auth.currentUser;
    setState(() {
      _currentUserEmail = user?.email;
    });
  }

  // Format account number with spaces
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

  // Show snackbar messages
  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  // Validate input fields
  bool _validateInputs() {
    if (accountNameController.text.trim().isEmpty) {
      _showSnackBar('Please enter account name', isError: true);
      return false;
    }

    if (accountNumberController.text.trim().isEmpty) {
      _showSnackBar('Please enter account number', isError: true);
      return false;
    }

    if (_currentUserEmail == null) {
      _showSnackBar('User not logged in', isError: true);
      return false;
    }

    return true;
  }

  // Process donation
  void completeDonation() async {
    // Validate inputs first
    if (!_validateInputs()) return;

    // Set loading state
    setState(() {
      isLoading = true;
    });

    try {
      final supabase = Supabase.instance.client;

      // Step 1: Update campaign current amount
      final updatedAmount = widget.currentAmount + selectedAmount;
      await supabase
          .from('campaigns')
          .update({'current_amount': updatedAmount}).eq(
              'campaign_id', widget.campaignId);

      // Step 2: Insert donation record
      await supabase.from('Donations').insert({
        'donation_id': DateTime.now().millisecondsSinceEpoch.toString(),
        'campaign_id': widget.campaignId,
        'donar_email': _currentUserEmail,
        'amount': selectedAmount,
        'created_at': DateTime.now().toIso8601String(),
      });

      // Notify parent and show success
      widget.onDonationComplete(selectedAmount);
      Navigator.pop(context);
      _showSnackBar('Donation successful!');
    } catch (e) {
      // Handle any errors
      _showSnackBar('Error processing donation: $e', isError: true);
      print('Donation error: $e');
    } finally {
      // Reset loading state
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
              // Campaign Details Card
              _buildCampaignDetailsCard(),
              const SizedBox(height: 20),

              // Account Details Section
              _buildAccountDetailsSection(),
              const SizedBox(height: 20),

              // Donation Amount Selection
              _buildDonationAmountSection(),
              const SizedBox(height: 20),

              // Donate Button
              _buildDonateButton(),
            ],
          ),
        ),
      ),
    );
  }

  // Campaign Details Card Widget
  Widget _buildCampaignDetailsCard() {
    return Card(
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
    );
  }

  // Account Details Section Widget
  Widget _buildAccountDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            prefixIcon: Icon(Icons.person),
          ),
        ),
        const SizedBox(height: 15),
        TextField(
          controller: accountNumberController,
          decoration: const InputDecoration(
            labelText: "Account Number",
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.credit_card),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            TextInputFormatter.withFunction((oldValue, newValue) {
              String newText = formatAccountNumber(newValue.text);
              return TextEditingValue(
                text: newText,
                selection: TextSelection.collapsed(offset: newText.length),
              );
            }),
          ],
        ),
      ],
    );
  }

  // Donation Amount Selection Widget
  Widget _buildDonationAmountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Select Donation Amount:",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: donationAmounts.map((amount) {
            return ChoiceChip(
              label: Text("\$ $amount"),
              selected: selectedAmount == amount,
              onSelected: (_) => setState(() => selectedAmount = amount),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Donate Button Widget
  Widget _buildDonateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : completeDonation,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                "Donate Now",
                style: TextStyle(fontSize: 16),
              ),
      ),
    );
  }
}
