import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../constants/app_colors.dart';
import '../domain/flight.dart';
import 'search_results_controller.dart';

class SearchResultsScreen extends ConsumerWidget {
  const SearchResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flightsAsync = ref.watch(searchResultsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results'),
      ),
      body: flightsAsync.when(
        data: (flights) {
          if (flights.isEmpty) {
            return const Center(child: Text('No flights found'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: flights.length,
            itemBuilder: (context, index) {
              return FlightCard(flight: flights[index]);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
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

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  flight.airline,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${flight.currency} ${flight.price}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('HH:mm').format(flight.departureTime),
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(flight.origin),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '${hours}h ${minutes}m',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const Icon(Icons.flight_takeoff, color: Colors.grey),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      DateFormat('HH:mm').format(flight.arrivalTime),
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(flight.destination),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
