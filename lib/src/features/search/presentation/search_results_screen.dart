import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/design_system.dart';
import '../domain/flight.dart';
import 'search_results_controller.dart';
import 'flight_card_shimmer.dart';

class SearchResultsScreen extends ConsumerWidget {
  const SearchResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flightsAsync = ref.watch(searchResultsProvider);
    final controller = ref.read(searchResultsProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Available Flights'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: _buildFilterBar(ref, controller),
        ),
      ),
      body: flightsAsync.when(
        data: (flights) {
          if (flights.isEmpty) {
            return _buildEmptyState();
          }
          return ListView.builder(
            padding: const EdgeInsets.all(DesignSystem.spacingM),
            itemCount: flights.length,
            itemBuilder: (context, index) {
              return FlightCard(flight: flights[index]);
            },
          );
        },
        loading: () => Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(DesignSystem.spacingM),
              child: Text('Finding the best deals for you...', style: TextStyle(color: AppColors.textLight)),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingM),
                itemCount: 5,
                itemBuilder: (context, index) => const FlightCardShimmer(),
              ),
            ),
          ],
        ),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildFilterBar(WidgetRef ref, SearchResultsNotifier controller) {
    final currentFilter = controller.currentFilter;
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingM, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFilterChip('Cheapest', currentFilter == FlightFilter.cheapest, () => controller.setFilter(FlightFilter.cheapest)),
          _buildFilterChip('Fastest', currentFilter == FlightFilter.fastest, () => controller.setFilter(FlightFilter.fastest)),
          _buildFilterChip('Direct only', currentFilter == FlightFilter.direct, () => controller.setFilter(FlightFilter.direct)),
          _buildFilterChip('Airlines', false, () {}),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onTap(),
        backgroundColor: Colors.white,
        selectedColor: AppColors.primary.withOpacity(0.1),
        checkmarkColor: AppColors.primary,
        labelStyle: TextStyle(
          color: isSelected ? AppColors.primary : AppColors.textDark,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 13,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: DesignSystem.radiusFull,
          side: BorderSide(color: isSelected ? AppColors.primary : Colors.grey.shade300),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.flight_takeoff, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: DesignSystem.spacingM),
          const Text(
            'No flights found',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try adjusting your search criteria',
            style: TextStyle(color: AppColors.textLight),
          ),
        ],
      ),
    );
  }
}

class FlightCard extends StatelessWidget {
  final Flight flight;

  const FlightCard({super.key, required this.flight});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: DesignSystem.spacingM),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: DesignSystem.radiusLarge,
        boxShadow: DesignSystem.softShadow,
      ),
      child: InkWell(
        onTap: () => context.go('/results/details', extra: flight),
        borderRadius: DesignSystem.radiusLarge,
        child: Padding(
          padding: const EdgeInsets.all(DesignSystem.spacingL),
          child: Column(
            children: [
              Row(
                children: [
                  Hero(
                    tag: 'airline_icon_${flight.id}',
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: DesignSystem.radiusMedium,
                      ),
                      child: const Icon(Icons.flight, color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(width: DesignSystem.spacingM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(flight.airline, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text(flight.flightNumber, style: DesignSystem.caption),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${flight.currency} ${flight.price.toInt()}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: AppColors.primary),
                      ),
                      const Text('per person', style: TextStyle(fontSize: 10, color: AppColors.textLight)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: DesignSystem.spacingXL),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTimeColumn(DateFormat('HH:mm').format(flight.departureTime), flight.origin, CrossAxisAlignment.start),
                  Expanded(
                    child: Column(
                      children: [
                        Text(flight.formattedDuration, style: DesignSystem.caption),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(width: 4, height: 4, decoration: const BoxDecoration(color: AppColors.border, shape: BoxShape.circle)),
                            const Expanded(child: Divider(thickness: 1, color: AppColors.border)),
                            const Icon(Icons.flight_takeoff, size: 16, color: AppColors.primary),
                            const Expanded(child: Divider(thickness: 1, color: AppColors.border)),
                            Container(width: 4, height: 4, decoration: const BoxDecoration(color: AppColors.border, shape: BoxShape.circle)),
                          ],
                        ),
                        Text(
                          flight.isDirect ? 'Direct' : '1 Stop',
                          style: TextStyle(color: flight.isDirect ? AppColors.success : AppColors.warning, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  _buildTimeColumn(DateFormat('HH:mm').format(flight.arrivalTime), flight.destination, CrossAxisAlignment.end),
                ],
              ),
              const Divider(height: DesignSystem.spacingXL),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.work_outline, size: 14, color: AppColors.textLight),
                      const SizedBox(width: 4),
                      Text('Cabin bag included', style: DesignSystem.caption),
                    ],
                  ),
                  if (flight.status != 'On Time')
                    Text(flight.status, style: const TextStyle(color: AppColors.error, fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeColumn(String time, String code, CrossAxisAlignment align) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(time, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark)),
        Text(code, style: const TextStyle(color: AppColors.textLight, fontSize: 14, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
