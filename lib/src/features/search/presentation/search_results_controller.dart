import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/flights_repository.dart';
import '../domain/flight.dart';
import 'search_controller.dart';

enum FlightFilter { cheapest, fastest, direct }

class SearchResultsNotifier extends StateNotifier<AsyncValue<List<Flight>>> {
  final FlightsRepository _repository;
  final Ref _ref;
  FlightFilter _currentFilter = FlightFilter.cheapest;

  SearchResultsNotifier(this._repository, this._ref) : super(const AsyncLoading()) {
    _fetchFlights();
  }

  Future<void> _fetchFlights() async {
    state = const AsyncLoading();
    final searchState = _ref.read(searchControllerProvider);
    
    state = await AsyncValue.guard(() async {
      final flights = await _repository.searchFlights(
        from: searchState.origin,
        to: searchState.destination,
        date: searchState.departureDate,
      );
      return _applyFilter(flights);
    });
  }

  void setFilter(FlightFilter filter) {
    _currentFilter = filter;
    if (state.hasValue) {
      state = AsyncData(_applyFilter(state.value!));
    }
  }

  List<Flight> _applyFilter(List<Flight> flights) {
    final list = List<Flight>.from(flights);
    switch (_currentFilter) {
      case FlightFilter.cheapest:
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case FlightFilter.fastest:
        // Mock duration sorting since we don't have duration in the model yet
        list.shuffle(); 
        break;
      case FlightFilter.direct:
        // Mock direct filter
        return list.take(1).toList();
    }
    return list;
  }

  FlightFilter get currentFilter => _currentFilter;
}

final searchResultsProvider = StateNotifierProvider<SearchResultsNotifier, AsyncValue<List<Flight>>>((ref) {
  return SearchResultsNotifier(ref.watch(flightsRepositoryProvider), ref);
});
