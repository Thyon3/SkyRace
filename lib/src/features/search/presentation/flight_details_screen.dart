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
                  const Text('Baggage Allowance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _buildBaggageItem(Icons.shopping_bag_outlined, 'Personal item', 'Included'),
                  _buildBaggageItem(Icons.luggage_outlined, 'Cabin bag', 'Included'),
                  _buildBaggageItem(Icons.work_outline, 'Checked bag', 'From \$35'),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => context.go('/results/book', extra: flight),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLocation(flight.origin, DateFormat('HH:mm').format(flight.departureTime)),
              const Icon(Icons.flight_takeoff, color: AppColors.primary, size: 32),
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

  Widget _buildBaggageItem(IconData icon, String label, String status) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Text(label),
          const Spacer(),
          Text(status, style: TextStyle(color: status == 'Included' ? Colors.green : AppColors.textLight, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
