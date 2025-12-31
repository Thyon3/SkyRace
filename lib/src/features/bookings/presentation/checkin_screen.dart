import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skyrace/src/core/theme/app_colors.dart';
import 'package:skyrace/src/core/theme/design_system.dart';
import 'package:skyrace/src/features/bookings/data/checkin_repository.dart';

class CheckInScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> booking;
  const CheckInScreen({super.key, required this.booking});

  @override
  ConsumerState<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends ConsumerState<CheckInScreen> {
  final List<String> _selectedPassengerIds = [];
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final passengers = widget.booking['passengers'] as List;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Online Check-in'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textDark,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(DesignSystem.spacingL),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Flight', style: DesignSystem.caption),
                      Text(widget.booking['flight']['flightNumber'], style: DesignSystem.heading3),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Booking ID', style: DesignSystem.caption),
                      Text(widget.booking['_id'].substring(0, 8).toUpperCase(), style: DesignSystem.heading3),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: DesignSystem.spacingM),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingL),
            child: Text('Select passengers to check-in:', style: DesignSystem.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(DesignSystem.spacingL),
              itemCount: passengers.length,
              itemBuilder: (context, index) {
                final p = passengers[index];
                final isCheckedIn = p['isCheckedIn'] ?? false;
                final id = p['_id'];

                return Container(
                  margin: const EdgeInsets.only(bottom: DesignSystem.spacingM),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: DesignSystem.radiusMedium,
                    boxShadow: DesignSystem.softShadow,
                  ),
                  child: CheckboxListTile(
                    title: Text('${p['firstName']} ${p['lastName']}'),
                    subtitle: Text(isCheckedIn ? 'Checked-in' : 'Ready for Check-in'),
                    value: isCheckedIn || _selectedPassengerIds.contains(id),
                    enabled: !isCheckedIn,
                    onChanged: (val) {
                      setState(() {
                        if (val == true) {
                          _selectedPassengerIds.add(id);
                        } else {
                          _selectedPassengerIds.remove(id);
                        }
                      });
                    },
                    secondary: Icon(isCheckedIn ? Icons.check_circle : Icons.person_outline, color: isCheckedIn ? Colors.green : AppColors.primary),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(DesignSystem.spacingL),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _selectedPassengerIds.isEmpty || _isLoading ? null : _handleCheckIn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: DesignSystem.radiusMedium),
                ),
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Confirm Check-in', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleCheckIn() async {
    setState(() => _isLoading = true);
    try {
      await ref.read(checkInRepositoryProvider).performCheckIn(
        widget.booking['_id'],
        _selectedPassengerIds,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Check-in successful!'), backgroundColor: Colors.green),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
