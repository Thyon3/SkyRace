import 'package:intl/intl.dart';

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
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
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
  final String status;
  final String gate;
  final String terminal;

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
    this.status = 'On Time',
    this.gate = 'TBD',
    this.terminal = '1',
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
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] ?? 'USD',
      isDirect: json['isDirect'] ?? true,
      fareRules: json['fareRules'] ?? '',
      refundPolicy: json['refundPolicy'] ?? '',
      seats: (json['seats'] as List?)?.map((s) => Seat.fromJson(s)).toList() ?? [],
      status: json['status'] ?? 'On Time',
      gate: json['gate'] ?? 'TBD',
      terminal: json['terminal'] ?? '1',
    );
  }

  String get formattedDuration {
    final hours = duration ~/ 60;
    final minutes = duration % 60;
    return '${hours}h ${minutes}m';
  }
}
