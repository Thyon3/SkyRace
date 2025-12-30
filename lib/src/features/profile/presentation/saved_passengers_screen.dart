import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/design_system.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SavedPassengersScreen extends StatelessWidget {
  const SavedPassengersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Saved Passengers', 
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.secondary)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, color: AppColors.secondary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildPassengerCard(
            context,
            name: 'John Doe',
            passport: 'A12345678',
            type: 'Adult',
          ),
          const SizedBox(height: 16),
          _buildPassengerCard(
            context,
            name: 'Jane Doe',
            passport: 'B87654321',
            type: 'Adult',
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(LucideIcons.plus, size: 18),
            label: const Text('Add New Passenger'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPassengerCard(BuildContext context, {
    required String name,
    required String passport,
    required String type,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [DesignSystem.softShadow],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(LucideIcons.user, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.secondary,
                )),
                const SizedBox(height: 4),
                Text('Passport: $passport', style: TextStyle(
                  color: AppColors.secondary.withOpacity(0.5),
                  fontSize: 12,
                )),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(type, style: const TextStyle(
              color: AppColors.accent,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            )),
          ),
        ],
      ),
    );
  }
}
