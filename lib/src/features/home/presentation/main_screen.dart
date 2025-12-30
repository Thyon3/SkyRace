import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../search/presentation/search_screen.dart';
import '../../search/presentation/flight_status_screen.dart';
import '../../bookings/presentation/my_bookings_screen.dart';
import '../../auth/presentation/auth_controller.dart';
import '../../utils/theme_controller.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/design_system.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const SearchScreen(),
    const FlightStatusScreen(),
    const MyBookingsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -2)),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textLight,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(icon: Icon(Icons.track_changes), label: 'Status'),
            BottomNavigationBarItem(icon: Icon(Icons.confirmation_number_outlined), label: 'Bookings'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final themeMode = ref.watch(themeControllerProvider);
    final user = authState.value;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profile'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textDark,
      ),
      body: user == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.account_circle_outlined, size: 100, color: AppColors.textLight.withOpacity(0.3)),
                  const SizedBox(height: DesignSystem.spacingM),
                  const Text('Sign in to manage your trips', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: DesignSystem.spacingM),
                  ElevatedButton(
                    onPressed: () => context.go('/login'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: DesignSystem.radiusMedium),
                    ),
                    child: const Text('Login / Sign Up', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(DesignSystem.spacingM),
              child: Column(
                children: [
                  _buildProfileHeader(user),
                  const SizedBox(height: DesignSystem.spacingL),
                  _buildLoyaltySummary(context, user.loyaltyTier, user.loyaltyPoints),
                  const SizedBox(height: DesignSystem.spacingL),
                  _buildMenuSection([
                    _buildMenuItem(Icons.person_outline, 'Edit Profile', () => context.push('/edit-profile')),
                    _buildMenuItem(Icons.star_outline, 'SkyRewards', () => context.push('/loyalty'), subtitle: 'View points and benefits'),
                    _buildMenuItem(Icons.people_outline, 'Saved Passengers', () {}),
                  ]),
                  const SizedBox(height: DesignSystem.spacingM),
                  _buildMenuSection([
                    _buildMenuItem(Icons.settings_outlined, 'Settings', () => context.push('/settings')),
                    _buildMenuItem(Icons.help_outline, 'Help Center', () => context.push('/help-center')),
                  ]),
                  const SizedBox(height: DesignSystem.spacingXL),
                  _buildLogoutButton(ref, context),
                  const SizedBox(height: DesignSystem.spacingXL),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileHeader(dynamic user) {
    return Container(
      padding: const EdgeInsets.all(DesignSystem.spacingL),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: DesignSystem.radiusLarge,
        boxShadow: DesignSystem.softShadow,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: const Icon(Icons.person, size: 40, color: AppColors.primary),
          ),
          const SizedBox(width: DesignSystem.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name, style: DesignSystem.heading2),
                Text(user.email, style: DesignSystem.caption),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(List<Widget> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: DesignSystem.radiusLarge,
        boxShadow: DesignSystem.softShadow,
      ),
      child: Column(children: items),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap, {String? subtitle}) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: subtitle != null ? Text(subtitle, style: DesignSystem.caption) : null,
      trailing: const Icon(Icons.chevron_right, size: 20, color: AppColors.textLight),
      onTap: onTap,
    );
  }

  Widget _buildLoyaltySummary(BuildContext context, String tier, int points) {
    return InkWell(
      onTap: () => context.push('/loyalty'),
      child: Container(
        padding: const EdgeInsets.all(DesignSystem.spacingL),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: DesignSystem.radiusLarge,
          boxShadow: DesignSystem.mediumShadow,
        ),
        child: Row(
          children: [
            const Icon(Icons.stars, color: Colors.white, size: 40),
            const SizedBox(width: DesignSystem.spacingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tier.toUpperCase(),
                    style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.2),
                  ),
                  Text(
                    '$points SkyPoints',
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(WidgetRef ref, BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Logout'),
              content: const Text('Are you sure you want to logout?'),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ref.read(authControllerProvider.notifier).logout();
                  },
                  child: const Text('Logout', style: TextStyle(color: AppColors.error)),
                ),
              ],
            ),
          );
        },
        icon: const Icon(Icons.logout, color: AppColors.error),
        label: const Text('Logout', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
