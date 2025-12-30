class Location {
  final String name;
  final String code;
  final String city;
  final String country;

  Location({
    required this.name,
    required this.code,
    required this.city,
    required this.country,
  });

  String get displayName => '$city ($code)';
}

final popularLocations = [
  Location(name: 'John F. Kennedy International Airport', code: 'JFK', city: 'New York', country: 'USA'),
  Location(name: 'London Heathrow Airport', code: 'LHR', city: 'London', country: 'UK'),
  Location(name: 'Charles de Gaulle Airport', code: 'CDG', city: 'Paris', country: 'France'),
  Location(name: 'Tokyo Haneda Airport', code: 'HND', city: 'Tokyo', country: 'Japan'),
  Location(name: 'Dubai International Airport', code: 'DXB', city: 'Dubai', country: 'UAE'),
  Location(name: 'Singapore Changi Airport', code: 'SIN', city: 'Singapore', country: 'Singapore'),
];
