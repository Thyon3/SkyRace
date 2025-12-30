enum TripType { oneWay, returnTrip }

class SearchState {
  final String? origin;
  final String? destination;
  final DateTime? departureDate;
  final DateTime? returnDate;
  final int passengers;
  final TripType tripType;

  SearchState({
    this.origin,
    this.destination,
    this.departureDate,
    this.returnDate,
    this.passengers = 1,
    this.tripType = TripType.returnTrip,
  });

  SearchState copyWith({
    String? origin,
    String? destination,
    DateTime? departureDate,
    DateTime? returnDate,
    int? passengers,
    TripType? tripType,
  }) {
    return SearchState(
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      departureDate: departureDate ?? this.departureDate,
      returnDate: returnDate ?? this.returnDate,
      passengers: passengers ?? this.passengers,
      tripType: tripType ?? this.tripType,
    );
  }
}
