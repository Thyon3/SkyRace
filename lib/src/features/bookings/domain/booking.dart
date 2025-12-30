import '../../search/domain/flight.dart';

class Passenger {
  final String firstName;
  final String lastName;
  final String? passportNumber;

  Passenger({
    required this.firstName,
    required this.lastName,
    this.passportNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'passportNumber': passportNumber,
    };
  }

  factory Passenger.fromJson(Map<String, dynamic> json) {
    return Passenger(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      passportNumber: json['passportNumber'],
    );
  }
}

class Booking {
  final String? id;
  final String? flightId;
  final Flight? flight;
  final List<Passenger> passengers;
  final List<String> seats;
  final double totalPrice;
  final String status;
  final DateTime? createdAt;

  Booking({
    this.id,
    this.flightId,
    this.flight,
    required this.passengers,
    required this.seats,
    required this.totalPrice,
    this.status = 'pending',
    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'flightId': flightId,
      'passengers': passengers.map((p) => p.toJson()).toList(),
      'seats': seats,
      'totalPrice': totalPrice,
    };
  }

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['_id'],
      flightId: json['flight'] is String ? json['flight'] : (json['flight'] is Map ? json['flight']['_id'] : null),
      flight: json['flight'] is Map ? Flight.fromJson(json['flight']) : null,
      passengers: (json['passengers'] as List)
          .map((p) => Passenger.fromJson(p))
          .toList(),
      seats: List<String>.from(json['seats'] ?? []),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      status: json['status'] ?? 'pending',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }
}
