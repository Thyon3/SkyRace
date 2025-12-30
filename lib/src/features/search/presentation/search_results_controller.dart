import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/flights_repository.dart';
import '../domain/flight.dart';
import '../domain/search_state.dart';
import 'search_controller.dart';

final searchResultsProvider = FutureProvider.autoDispose<List<Flight>>((ref) async {
  final searchState = ref.watch(searchControllerProvider);
  final repository = ref.watch(flightsRepositoryProvider);
  
  // If no search criteria, return empty or popular flights
  // For now, let's just fetch all if nothing specified (or handle in repo)
  
  return repository.searchFlights(
    from: searchState.origin,
    to: searchState.destination,
    date: searchState.departureDate,
  );
});
