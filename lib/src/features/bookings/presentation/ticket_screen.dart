import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../constants/app_colors.dart';
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
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildTicketCard(context),
            const SizedBox(height: 32),
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
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          // Top section
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('AIRLINE', style: TextStyle(color: AppColors.textLight, fontSize: 10)),
                        Text(flight.airline, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('FLIGHT', style: TextStyle(color: AppColors.textLight, fontSize: 10)),
                        Text(flight.flightNumber, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildLocationInfo(originCode, flight.origin.split('(').first.trim(), DateFormat('HH:mm').format(flight.departureTime)),
                    const Icon(Icons.flight_takeoff, color: AppColors.primary, size: 32),
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
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDetailItem('PASSENGER', '${booking.passengers.first.firstName} ${booking.passengers.first.lastName}'),
                    _buildDetailItem('DATE', DateFormat('MMM d, y').format(flight.departureTime)),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDetailItem('SEAT', booking.seats.join(', ')),
                    _buildDetailItem('CLASS', 'Economy'),
                  ],
                ),
                const SizedBox(height: 32),
                // Mock Barcode
                Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(40, (index) => Container(
                      width: (index % 3 == 0) ? 4 : 2,
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      color: Colors.black87,
                      height: 40,
                    )),
                  ),
                ),
                const SizedBox(height: 8),
                Text(booking.id?.toUpperCase() ?? 'ABC123XYZ', style: const TextStyle(letterSpacing: 4, fontSize: 12, color: AppColors.textLight)),
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
        Text(code, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        Text(city, style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
        const SizedBox(height: 4),
        Text(time, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary)),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textLight, fontSize: 10)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
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
                  children: List.generate((constraints.constrainWidth() / 10).floor(), (index) => const SizedBox(width: 5, height: 1, child: DecoratedBox(decoration: BoxDecoration(color: Colors.grey)))),
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
          child: ElevatedButton.icon(
            onPressed: () {
              // TODO: Implement PDF Download
            },
            icon: const Icon(Icons.download_outlined),
            label: const Text('Download PDF'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              // TODO: Implement Share
            },
            icon: const Icon(Icons.share_outlined),
            label: const Text('Share Ticket'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }
}
