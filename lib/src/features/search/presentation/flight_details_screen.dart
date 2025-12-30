import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/design_system.dart';
import '../domain/flight.dart';

class FlightDetailsScreen extends StatelessWidget {
  final Flight flight;

  const FlightDetailsScreen({super.key, required this.flight});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(DesignSystem.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatusBanner(),
                  const SizedBox(height: DesignSystem.spacingL),
                  _buildFlightPath(),
                  const SizedBox(height: DesignSystem.spacingL),
                  _buildInfoGrid(),
                  const SizedBox(height: DesignSystem.spacingL),
                  _buildSectionTitle('Baggage Information'),
                  _buildBaggageSection(),
                  const SizedBox(height: DesignSystem.spacingL),
                  _buildSectionTitle('Fare & Refund Policy'),
                  _buildPolicySection(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: _buildBottomAction(context),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: AppColors.textDark,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Flight ${flight.flightNumber}',
          style: DesignSystem.heading2.copyWith(fontSize: 18),
        ),
        centerTitle: true,
      ),
      actions: [
        IconButton(icon: const Icon(Icons.share_outlined), onPressed: () {}),
      ],
    );
  }

  Widget _buildStatusBanner() {
    return Container(
      padding: const EdgeInsets.all(DesignSystem.spacingM),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: DesignSystem.radiusMedium,
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.primary),
          const SizedBox(width: DesignSystem.spacingM),
          Expanded(
            child: Text(
              'This flight is currently ${flight.status}. Gate ${flight.gate}, Terminal ${flight.terminal}.',
              style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlightPath() {
    return Container(
      padding: const EdgeInsets.all(DesignSystem.spacingL),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: DesignSystem.radiusLarge,
        boxShadow: DesignSystem.softShadow,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLocationPoint(flight.origin, flight.departureTime, 'Departure'),
              Column(
                children: [
                  Text(flight.formattedDuration, style: DesignSystem.caption),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
                      Container(width: 80, height: 2, color: AppColors.primary.withOpacity(0.3)),
                      const Icon(Icons.flight_takeoff, color: AppColors.primary, size: 20),
                      Container(width: 80, height: 2, color: AppColors.primary.withOpacity(0.3)),
                      Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(flight.isDirect ? 'Direct' : '1 Stop', style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ),
              _buildLocationPoint(flight.destination, flight.arrivalTime, 'Arrival'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationPoint(String code, DateTime time, String label) {
    return Column(
      children: [
        Text(DateFormat('HH:mm').format(time), style: DesignSystem.heading2),
        Text(code, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
        Text(label, style: DesignSystem.caption),
      ],
    );
  }

  Widget _buildInfoGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: DesignSystem.spacingM,
      crossAxisSpacing: DesignSystem.spacingM,
      childAspectRatio: 2.5,
      children: [
        _buildGridItem(Icons.airline_seat_recline_normal, 'Airline', flight.airline),
        _buildGridItem(Icons.meeting_room_outlined, 'Terminal', flight.terminal),
        _buildGridItem(Icons.door_sliding_outlined, 'Gate', flight.gate),
        _buildGridItem(Icons.airplane_ticket_outlined, 'Class', 'Economy'),
      ],
    );
  }

  Widget _buildGridItem(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(DesignSystem.spacingM),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: DesignSystem.radiusMedium,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: DesignSystem.spacingM),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label, style: DesignSystem.caption),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DesignSystem.spacingM),
      child: Text(title, style: DesignSystem.heading2.copyWith(fontSize: 18)),
    );
  }

  Widget _buildBaggageSection() {
    return Container(
      padding: const EdgeInsets.all(DesignSystem.spacingM),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: DesignSystem.radiusLarge,
        boxShadow: DesignSystem.softShadow,
      ),
      child: Column(
        children: [
          _buildBaggageRow(Icons.shopping_bag_outlined, 'Personal item', 'Included'),
          const Divider(),
          _buildBaggageRow(Icons.backpack_outlined, 'Cabin bag', 'Included'),
          const Divider(),
          _buildBaggageRow(Icons.luggage_outlined, 'Checked bag', 'From \$30'),
        ],
      ),
    );
  }

  Widget _buildBaggageRow(IconData icon, String label, String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textLight),
          const SizedBox(width: DesignSystem.spacingM),
          Text(label),
          const Spacer(),
          Text(status, style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildPolicySection() {
    return Container(
      padding: const EdgeInsets.all(DesignSystem.spacingM),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: DesignSystem.radiusLarge,
        boxShadow: DesignSystem.softShadow,
      ),
      child: Column(
        children: [
          _buildPolicyItem(Icons.gavel_outlined, 'Fare Rules', flight.fareRules),
          const Divider(height: 32),
          _buildPolicyItem(Icons.replay_outlined, 'Refund Policy', flight.refundPolicy),
        ],
      ),
    );
  }

  Widget _buildPolicyItem(IconData icon, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: DesignSystem.spacingM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(description, style: DesignSystem.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomAction(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(DesignSystem.spacingL),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5)),
        ],
      ),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Total Price', style: TextStyle(color: AppColors.textLight)),
              Text(
                '${flight.currency} ${flight.price}',
                style: DesignSystem.heading2.copyWith(color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(width: DesignSystem.spacingL),
          Expanded(
            child: SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: () => context.go('/booking', extra: flight),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: DesignSystem.radiusMedium),
                  elevation: 0,
                ),
                child: const Text('Book Now', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
