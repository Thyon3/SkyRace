import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../constants/app_colors.dart';
import '../../auth/presentation/auth_controller.dart';

class LoyaltyScreen extends ConsumerWidget {
  const LoyaltyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final user = authState.value;

    if (user == null) {
      return const Scaffold(body: Center(child: Text('Please login to view loyalty status')));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('SkyRewards'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textDark,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTierCard(user.loyaltyTier, user.loyaltyPoints),
            const SizedBox(height: 32),
            const Text(
              'How to earn points',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildEarningMethod(Icons.flight_takeoff, 'Book Flights', 'Earn 1 point for every \$1 spent on tickets.'),
            _buildEarningMethod(Icons.hotel, 'Hotel Bookings', 'Earn 2 points for every \$1 spent on partner hotels.'),
            _buildEarningMethod(Icons.share, 'Refer Friends', 'Earn 500 points for every friend who joins.'),
            const SizedBox(height: 32),
            const Text(
              'Tier Benefits',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildTierBenefit('Bronze', 'Standard support, earn points on all flights.'),
            _buildTierBenefit('Silver', 'Priority check-in, 10% bonus points.', isActive: user.loyaltyTier == 'Silver'),
            _buildTierBenefit('Gold', 'Lounge access, 25% bonus points, free seat selection.', isActive: user.loyaltyTier == 'Gold'),
            _buildTierBenefit('Platinum', 'First class upgrades, 50% bonus points, dedicated concierge.', isActive: user.loyaltyTier == 'Platinum'),
          ],
        ),
      ),
    );
  }

  Widget _buildTierCard(String tier, int points) {
    Color tierColor;
    switch (tier) {
      case 'Silver': tierColor = Colors.blueGrey.shade300; break;
      case 'Gold': tierColor = Colors.amber.shade600; break;
      case 'Platinum': tierColor = Colors.deepPurple.shade400; break;
      default: tierColor = Colors.brown.shade400;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [tierColor, tierColor.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: tierColor.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        children: [
          Text(
            tier.toUpperCase(),
            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 4),
          ),
          const SizedBox(height: 16),
          Text(
            points.toString(),
            style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold),
          ),
          const Text(
            'SkyPoints',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 24),
          LinearProgressIndicator(
            value: (points % 5000) / 5000,
            backgroundColor: Colors.white24,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          const SizedBox(height: 12),
          Text(
            '${5000 - (points % 5000)} points to next tier',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildEarningMethod(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.secondary, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(description, style: const TextStyle(color: AppColors.textLight, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTierBenefit(String tier, String benefit, {bool isActive = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isActive ? AppColors.primary : Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(isActive ? Icons.check_circle : Icons.circle_outlined, color: isActive ? AppColors.primary : Colors.grey.shade300),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tier, style: TextStyle(fontWeight: FontWeight.bold, color: isActive ? AppColors.primary : AppColors.textDark)),
                Text(benefit, style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
