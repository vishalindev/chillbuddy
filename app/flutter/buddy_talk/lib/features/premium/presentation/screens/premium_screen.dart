import 'package:flutter/material.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final plans = [
      ('Weekly', '₹149 / week'),
      ('Monthly', '₹499 / month'),
      ('6-Month', '₹2,199 / 6 months'),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Buddy Talk Premium', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text('Get advanced matching, unlimited calls, and no ads.'),
        const SizedBox(height: 16),
        ...plans.map(
          (plan) => Card(
            child: ListTile(
              title: Text(plan.$1),
              subtitle: Text(plan.$2),
              trailing: ElevatedButton(onPressed: () {}, child: const Text('Choose')),
            ),
          ),
        ),
      ],
    );
  }
}
