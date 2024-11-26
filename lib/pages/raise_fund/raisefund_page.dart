import 'package:flutter/material.dart';

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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Collect data from the form
      final title = _titleController.text.trim();
      final description = _descriptionController.text.trim();
      final targetAmount = double.tryParse(_targetAmountController.text.trim());

      // Perform backend submission logic
      // Example: Send this data to Supabase or any database

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Campaign created successfully!')),
      );

      // Clear form fields after submission
      _titleController.clear();
      _descriptionController.clear();
      _targetAmountController.clear();

      Navigator.pop(context); // Navigate back to the previous page
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
