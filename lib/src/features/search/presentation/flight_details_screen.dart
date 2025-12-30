import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../constants/app_colors.dart';
import '../domain/flight.dart';

class FlightDetailsScreen extends StatelessWidget {
  final Flight flight;

  const FlightDetailsScreen({super.key, required this.flight});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Flight Details'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              // TODO: Implement share
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFlightInfoCard(),
                  const SizedBox(height: 24),
                  const Text(
                    'Baggage Information',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildBaggageRow(Icons.shopping_bag_outlined, 'Personal item', 'Included'),
                  _buildBaggageRow(Icons.backpack_outlined, 'Cabin bag', 'Included'),
                  _buildBaggageRow(Icons.luggage_outlined, 'Checked bag', 'From \$30'),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => context.go('/booking', extra: flight),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Select this flight', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Hero(
            tag: 'airline_icon_${flight.id}',
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.flight, color: AppColors.primary, size: 32),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLocation(flight.origin, DateFormat('HH:mm').format(flight.departureTime)),
              const Icon(Icons.arrow_forward, color: AppColors.primary, size: 24),
              _buildLocation(flight.destination, DateFormat('HH:mm').format(flight.arrivalTime)),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            DateFormat('EEEE, MMM d, y').format(flight.departureTime),
            style: const TextStyle(color: AppColors.textLight),
          ),
        ],
      ),
    );
  }

  Widget _buildLocation(String location, String time) {
    return Column(
      children: [
        Text(time, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        Text(location.split('(').first.trim(), style: const TextStyle(color: AppColors.textLight)),
      ],
    );
  }

  Widget _buildFlightInfoCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInfoRow(Icons.airline_seat_recline_normal, 'Airline', flight.airline),
            const Divider(height: 24),
            _buildInfoRow(Icons.confirmation_number_outlined, 'Flight Number', flight.flightNumber),
            const Divider(height: 24),
            _buildInfoRow(Icons.timer_outlined, 'Duration', '7h 15m'),
            const Divider(height: 24),
            _buildInfoRow(Icons.attach_money, 'Price', '${flight.currency} ${flight.price}'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textLight, size: 20),
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(color: AppColors.textLight)),
        const Spacer(),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildBaggageRow(IconData icon, String label, String status) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textLight),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(color: AppColors.textDark)),
          const Spacer(),
          Text(status, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
