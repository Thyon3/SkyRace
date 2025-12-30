class Seat {
  final String number;
  final String type;
  final bool isOccupied;
  final double price;

  Seat({
    required this.number,
    required this.type,
    required this.isOccupied,
    required this.price,
  });

  factory Seat.fromJson(Map<String, dynamic> json) {
    return Seat(
      number: json['number'] ?? '',
      type: json['type'] ?? 'economy',
      isOccupied: json['isOccupied'] ?? false,
      price: (json['price'] as num).toDouble(),
    );
  }
}

class Flight {
  final String id;
  final String airline;
  final String flightNumber;
  final String origin;
  final String destination;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final int duration;
  final double price;
  final String currency;
  final bool isDirect;
  final String fareRules;
  final String refundPolicy;
  final List<Seat> seats;

  Flight({
    required this.id,
    required this.airline,
    required this.flightNumber,
    required this.origin,
    required this.destination,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.price,
    required this.currency,
    required this.isDirect,
    required this.fareRules,
    required this.refundPolicy,
    required this.seats,
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
      duration: json['duration'] ?? 0,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] ?? 'USD',
      isDirect: json['isDirect'] ?? true,
      fareRules: json['fareRules'] ?? 'Standard fare rules apply.',
      refundPolicy: json['refundPolicy'] ?? 'Refundable within 24 hours.',
      seats: (json['seats'] as List?)?.map((e) => Seat.fromJson(e)).toList() ?? [],
    );
  }
}
