import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../constants/app_colors.dart';
import '../../auth/presentation/auth_controller.dart';
import '../../auth/domain/user.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final user = authState.value;
    
    if (user == null) return const Scaffold(body: Center(child: Text('Please login to view settings')));

    final prefs = user.preferences;

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
            _buildSettingsItem(
              context,
              Icons.language, 
              'Language', 
              prefs.language == 'en' ? 'English' : 'Spanish',
              () => _showLanguagePicker(context, ref, prefs),
            ),
            _buildSettingsItem(
              context,
              Icons.monetization_on_outlined, 
              'Currency', 
              prefs.currency,
              () => _showCurrencyPicker(context, ref, prefs),
            ),
            _buildSettingsItem(
              context,
              Icons.scale_outlined, 
              'Weight Unit', 
              prefs.weightUnit ?? 'kg',
              () => _showWeightPicker(context, ref, prefs),
            ),
            _buildSettingsItem(

              context,
              Icons.dark_mode_outlined, 
              'Theme', 
              prefs.theme.toUpperCase(),
              () => _showThemePicker(context, ref, prefs),
            ),
          ]),
          const SizedBox(height: 24),
          _buildSettingsSection('Notifications', [
            _buildSettingsItem(context, Icons.notifications_outlined, 'Push Notifications', 'On', () {}),
            _buildSettingsItem(context, Icons.email_outlined, 'Email Notifications', 'Off', () {}),
          ]),
          const SizedBox(height: 24),
          _buildSettingsSection('Legal', [
            _buildSettingsItem(context, Icons.description_outlined, 'Terms of Service', '', () {}),
            _buildSettingsItem(context, Icons.privacy_tip_outlined, 'Privacy Policy', '', () {}),
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
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildSettingsItem(BuildContext context, IconData icon, String title, String value, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary, size: 22),
      title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value.isNotEmpty)
            Text(value, style: const TextStyle(color: AppColors.textLight, fontSize: 14)),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
        ],
      ),
      onTap: onTap,
    );
  }

  void _showLanguagePicker(BuildContext context, WidgetRef ref, UserPreferences current) {
    _showPicker(context, 'Select Language', ['English', 'Spanish'], (val) {
      ref.read(authControllerProvider.notifier).updatePreferences(
        current.copyWith(language: val == 'English' ? 'en' : 'es')
      );
    });
  }

  void _showCurrencyPicker(BuildContext context, WidgetRef ref, UserPreferences current) {
    _showPicker(context, 'Select Currency', ['USD', 'EUR', 'GBP'], (val) {
      ref.read(authControllerProvider.notifier).updatePreferences(
        current.copyWith(currency: val)
      );
    });
  }

  void _showThemePicker(BuildContext context, WidgetRef ref, UserPreferences current) {
    _showPicker(context, 'Select Theme', ['Light', 'Dark'], (val) {
      ref.read(authControllerProvider.notifier).updatePreferences(
        current.copyWith(theme: val.toLowerCase())
      );
    });
  }

  void _showWeightPicker(BuildContext context, WidgetRef ref, UserPreferences current) {
    _showPicker(context, 'Select Weight Unit', ['kg', 'lb'], (val) {
      ref.read(authControllerProvider.notifier).updatePreferences(
        current.copyWith(weightUnit: val)
      );
    });
  }


  void _showPicker(BuildContext context, String title, List<String> options, Function(String) onSelect) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          ...options.map((opt) => ListTile(
            title: Text(opt),
            onTap: () {
              onSelect(opt);
              Navigator.pop(context);
            },
          )),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
