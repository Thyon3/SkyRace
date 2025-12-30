class SearchState {
  final String? origin;
  final String? destination;
  final DateTime? departureDate;
  final DateTime? returnDate;
  final int passengers;

  SearchState({
    this.origin,
    this.destination,
    this.departureDate,
    this.returnDate,
    this.passengers = 1,
  });

  SearchState copyWith({
    String? origin,
    String? destination,
    DateTime? departureDate,
    DateTime? returnDate,
    int? passengers,
  }) {
    return SearchState(
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      departureDate: departureDate ?? this.departureDate,
      returnDate: returnDate ?? this.returnDate,
      passengers: passengers ?? this.passengers,
    );
  }
}
