import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../constants/app_colors.dart';
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
            icon: const Icon(Icons.notifications_none),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Price alerts enabled for this search')),
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: _buildFilterBar(ref, controller),
        ),
      ),
      body: flightsAsync.when(
        data: (flights) {
          if (flights.isEmpty) {
            return _buildEmptyState();
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: flights.length,
            itemBuilder: (context, index) {
              return FlightCard(flight: flights[index]);
            },
          );
        },
        loading: () => Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Finding the best deals for you...', style: TextStyle(color: AppColors.textLight)),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
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
          const SizedBox(height: 16),
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
    final duration = flight.arrivalTime.difference(flight.departureTime);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => context.go('/results/details', extra: flight),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
                  Hero(
                    tag: 'airline_icon_${flight.id}',
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.flight, color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          flight.airline,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          flight.flightNumber,
                          style: const TextStyle(color: AppColors.textLight, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${flight.currency} ${flight.price.toInt()}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTimeColumn(
                    DateFormat('HH:mm').format(flight.departureTime),
                    flight.origin.split('(').first.trim(),
                    CrossAxisAlignment.start,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '${hours}h ${minutes}m',
                          style: const TextStyle(color: AppColors.textLight, fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Expanded(child: Divider(thickness: 1)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Icon(Icons.flight_takeoff, size: 16, color: Colors.grey.shade400),
                            ),
                            const Expanded(child: Divider(thickness: 1)),
                          ],
                        ),
                        const Text(
                          'Direct',
                          style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  _buildTimeColumn(
                    DateFormat('HH:mm').format(flight.arrivalTime),
                    flight.destination.split('(').first.trim(),
                    CrossAxisAlignment.end,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeColumn(String time, String city, CrossAxisAlignment align) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(
          time,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
        ),
        Text(
          city,
          style: const TextStyle(color: AppColors.textLight, fontSize: 14),
        ),
      ],
    );
  }
}
