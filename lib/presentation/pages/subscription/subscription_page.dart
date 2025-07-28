import 'package:flutter/material.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title:
            Text('El Music Premium', style: theme.appBarTheme.titleTextStyle),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: theme.iconTheme,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Dapatkan Akses Tanpa Batas',
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Nikmati jutaan lagu tanpa iklan, dengarkan offline, dan kualitas audio terbaik.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(178),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 40),
            _buildFeatureItem(
                context, Icons.check_circle, 'Dengarkan musik tanpa iklan'),
            _buildFeatureItem(
                context, Icons.check_circle, 'Lewati lagu sepuasnya'),
            _buildFeatureItem(context, Icons.check_circle,
                'Mainkan di mana saja, bahkan offline'),
            _buildFeatureItem(
                context, Icons.check_circle, 'Kualitas audio lossless'),
            const SizedBox(height: 40),
            _buildPlanCard(
              context,
              title: 'Bulanan',
              price: 'Rp 59.000/bulan',
              isSelected: true,
            ),
            const SizedBox(height: 16),
            _buildPlanCard(
              context,
              title: 'Tahunan',
              price: 'Rp 590.000/tahun',
              subtitle: 'Hemat 2 bulan!',
              isSelected: false,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Mulai Berlangganan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(
    BuildContext context, {
    required String title,
    required String price,
    String? subtitle,
    required bool isSelected,
  }) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? theme.colorScheme.primary : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            if (subtitle != null)
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(subtitle,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.colorScheme.primary)),
              ),
            const SizedBox(height: 8),
            Text(price, style: theme.textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
