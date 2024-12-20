import 'package:flutter/material.dart';
import 'package:fund_app/pages/donation_page/payment_page.dart';

class CampaignWidget extends StatefulWidget {
  final String campaignId;
  final String title;
  final String description;
  final double targetAmount;
  final double currentAmount;

  const CampaignWidget({
    required this.campaignId,
    required this.title,
    required this.description,
    required this.targetAmount,
    required this.currentAmount,
    super.key,
  });

  @override
  State<CampaignWidget> createState() => _CampaignWidgetState();
}

class _CampaignWidgetState extends State<CampaignWidget> {
  double currentAmount = 0.0;

  @override
  void initState() {
    super.initState();
    currentAmount = widget.currentAmount;
  }

  void updateProgress(int donationAmount) {
    setState(() {
      currentAmount += donationAmount;
    });
  }

  @override
  Widget build(BuildContext context) {
    double progress = (currentAmount / widget.targetAmount).clamp(0.0, 1.0);

    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // Text(
            //   widget.description,
            //   style: const TextStyle(
            //     fontSize: 16,
            //     color: Colors.grey,
            //   ),
            // ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation(Colors.green),
            ),
            const SizedBox(height: 5),
            Text(
              "\$${currentAmount.toStringAsFixed(2)} / \$${widget.targetAmount.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentPage(
                        campaignId: widget.campaignId,
                        campaignTitle: widget.title,
                        campaignDescription: widget.description,
                        campaignGoalAmount: widget.targetAmount,
                        onDonationComplete: (amount) {
                          updateProgress(amount);
                        },
                        currentAmount: currentAmount,
                      ),
                    ),
                  );
                },
                child: const Text("Donate Now"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
