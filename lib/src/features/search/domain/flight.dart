class Flight {
  final String id;
  final String airline;
  final String flightNumber;
  final String origin;
  final String destination;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final double price;
  final String currency;

  Flight({
    required this.id,
    required this.airline,
    required this.flightNumber,
    required this.origin,
    required this.destination,
    required this.departureTime,
    required this.arrivalTime,
    required this.price,
    required this.currency,
  });

  factory Flight.fromJson(Map<String, dynamic> json) {
    return Flight(
      id: json['_id'] ?? '',
      airline: json['airline'] ?? '',
      flightNumber: json['flightNumber'] ?? '',
      origin: json['origin'] ?? '',
      destination: json['destination'] ?? '',
      departureTime: DateTime.parse(json['departureTime']),
      arrivalTime: DateTime.parse(json['arrivalTime']),
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] ?? 'USD',
    );
  }
}
