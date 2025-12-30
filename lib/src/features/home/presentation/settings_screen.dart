import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textDark,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSettingsSection('Preferences', [
            _buildSettingsItem(Icons.language, 'Language', 'English'),
            _buildSettingsItem(Icons.monetization_on_outlined, 'Currency', 'USD'),
          ]),
          const SizedBox(height: 24),
          _buildSettingsSection('Notifications', [
            _buildSettingsItem(Icons.notifications_outlined, 'Push Notifications', 'On'),
            _buildSettingsItem(Icons.email_outlined, 'Email Notifications', 'Off'),
          ]),
          const SizedBox(height: 24),
          _buildSettingsSection('Legal', [
            _buildSettingsItem(Icons.description_outlined, 'Terms of Service', ''),
            _buildSettingsItem(Icons.privacy_tip_outlined, 'Privacy Policy', ''),
          ]),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textLight),
          ),
        ),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildSettingsItem(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textLight),
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value.isNotEmpty)
            Text(value, style: const TextStyle(color: AppColors.textLight)),
          const Icon(Icons.chevron_right, size: 20),
        ],
      ),
      onTap: () {},
    );
  }
}
