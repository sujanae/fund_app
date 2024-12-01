import 'package:flutter/material.dart';
import 'package:fund_app/pages/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RaiseFundsPage extends StatefulWidget {
  const RaiseFundsPage({Key? key}) : super(key: key);

  @override
  State<RaiseFundsPage> createState() => _RaiseFundsPageState();
}

class _RaiseFundsPageState extends State<RaiseFundsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _targetAmountController = TextEditingController();

  final supabase = Supabase.instance.client;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final title = _titleController.text.trim();
      final description = _descriptionController.text.trim();
      final targetAmount = double.tryParse(_targetAmountController.text.trim());

      if (targetAmount == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Invalid target amount. Please enter a valid number.')),
        );
        return;
      }

      // Fetch the logged-in user's email
      final currentUser = supabase.auth.currentUser;
      if (currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No user is logged in.')),
        );
        return;
      }

      final userEmail = currentUser.email;

      try {
        // Insert data into 'campaigns' table
        final response = await supabase.from('campaigns').insert([
          {
            'title': title,
            'description': description,
            'goal_amount': targetAmount,
            'current_amount': 0,
            'user_email': userEmail, // Store the logged-in user's email
            'created_at': DateTime.now().toIso8601String(),
          }
        ]);

        // Log the full response to inspect its structure
        print('Supabase Response: ${response.toString()}');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Campaign created successfully!')),
        );

        // Clear the form fields
        _titleController.clear();
        _descriptionController.clear();
        _targetAmountController.clear();

        // Navigate back to the homepage (assuming it's the previous page)
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const HomePage()), // Replace with your homepage widget
        );
        // This will pop the current page off the stack and return to the previous page
      } catch (e) {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Raise Funds"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: "Campaign Title",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a campaign title.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: "Campaign Description",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a description.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _targetAmountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Target Amount",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a target amount.";
                    }
                    if (double.tryParse(value) == null) {
                      return "Please enter a valid number.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text("Create Campaign"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
