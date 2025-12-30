import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/design_system.dart';
import '../domain/booking.dart';

class TicketScreen extends StatelessWidget {
  final Booking booking;

  const TicketScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final flight = booking.flight;
    if (flight == null) return const Scaffold(body: Center(child: Text('Flight data missing')));

    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        title: const Text('E-Ticket'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DesignSystem.spacingL),
        child: Column(
          children: [
            _buildTicketCard(context),
            const SizedBox(height: DesignSystem.spacingXL),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketCard(BuildContext context) {
    final flight = booking.flight!;
    final originCode = flight.origin.split('(').last.replaceAll(')', '');
    final destCode = flight.destination.split('(').last.replaceAll(')', '');

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: DesignSystem.radiusLarge,
        boxShadow: DesignSystem.mediumShadow,
      ),
      child: Column(
        children: [
          // Top section
          Padding(
            padding: const EdgeInsets.all(DesignSystem.spacingL),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('AIRLINE', style: DesignSystem.caption),
                        Text(flight.airline, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('FLIGHT', style: DesignSystem.caption),
                        Text(flight.flightNumber, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: DesignSystem.spacingXL),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildLocationInfo(originCode, flight.origin.split('(').first.trim(), DateFormat('HH:mm').format(flight.departureTime)),
                    const Icon(Icons.flight_takeoff, color: AppColors.primary, size: 40),
                    _buildLocationInfo(destCode, flight.destination.split('(').first.trim(), DateFormat('HH:mm').format(flight.arrivalTime)),
                  ],
                ),
              ],
            ),
          ),
          
          // Dotted line separator
          _buildDottedLine(),

          // Bottom section
          Padding(
            padding: const EdgeInsets.all(DesignSystem.spacingL),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDetailItem('PASSENGER', '${booking.passengers.first.firstName} ${booking.passengers.first.lastName}'),
                    _buildDetailItem('DATE', DateFormat('MMM d, y').format(flight.departureTime)),
                  ],
                ),
                const SizedBox(height: DesignSystem.spacingL),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDetailItem('SEAT', booking.seats.join(', ')),
                    _buildDetailItem('GATE', flight.gate),
                  ],
                ),
                const SizedBox(height: DesignSystem.spacingXL),
                // Mock Barcode
                Container(
                  height: 80,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: DesignSystem.radiusMedium,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(50, (index) => Container(
                      width: (index % 4 == 0) ? 4 : 2,
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      color: Colors.black87,
                      height: 50,
                    )),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  booking.id?.toUpperCase() ?? 'SKY-RE-778',
                  style: const TextStyle(letterSpacing: 6, fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textMedium),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationInfo(String code, String city, String time) {
    return Column(
      children: [
        Text(code, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        Text(city, style: DesignSystem.caption),
        const SizedBox(height: 8),
        Text(time, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primary)),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: DesignSystem.caption),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }

  Widget _buildDottedLine() {
    return Row(
      children: [
        Container(
          width: 20,
          height: 40,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate((constraints.constrainWidth() / 12).floor(), (index) => const SizedBox(width: 6, height: 2, child: DecoratedBox(decoration: BoxDecoration(color: AppColors.border)))),
                );
              },
            ),
          ),
        ),
        Container(
          width: 20,
          height: 40,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.download_outlined),
            label: const Text('Download Ticket'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: DesignSystem.radiusMedium),
              elevation: 0,
            ),
          ),
        ),
        const SizedBox(height: DesignSystem.spacingM),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.share_outlined),
            label: const Text('Share with Friends'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white, width: 2),
              shape: RoundedRectangleBorder(borderRadius: DesignSystem.radiusMedium),
            ),
          ),
        ),
      ],
    );
  }
}
