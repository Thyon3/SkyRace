import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/search_state.dart';

class SearchController extends StateNotifier<SearchState> {
  SearchController() : super(SearchState());

  void setOrigin(String origin) {
    state = state.copyWith(origin: origin);
  }

  void setDestination(String destination) {
    state = state.copyWith(destination: destination);
  }

  void setDepartureDate(DateTime date) {
    state = state.copyWith(departureDate: date);
  }

  void setReturnDate(DateTime date) {
    state = state.copyWith(returnDate: date);
  }

  void setPassengers(int count) {
    state = state.copyWith(passengers: count);
  }

  void setTripType(TripType type) {
    state = state.copyWith(tripType: type);
  }

  void setSearchFromHistory(String search) {
    final parts = search.split(' to ');
    if (parts.length == 2) {
      state = state.copyWith(origin: parts[0], destination: parts[1]);
    }
  }
}

final searchControllerProvider = StateNotifierProvider<SearchController, SearchState>((ref) {
  return SearchController();
});
