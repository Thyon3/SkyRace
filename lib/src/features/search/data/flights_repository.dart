import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../domain/flight.dart';

class FlightsRepository {
  // Use 10.0.2.2 for Android emulator, localhost for iOS/Web
  // Ideally this should be in a config
  final String baseUrl = 'http://10.0.2.2:5000/api'; 

  Future<List<Flight>> searchFlights({
    String? from,
    String? to,
    DateTime? date,
  }) async {
    final queryParams = <String, String>{};
    if (from != null) queryParams['from'] = from;
    if (to != null) queryParams['to'] = to;
    if (date != null) queryParams['date'] = date.toIso8601String();

    final uri = Uri.parse('$baseUrl/flights/search').replace(queryParameters: queryParams);
    
    try {
      final response = await http.get(uri);
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Flight.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load flights');
      }
    } catch (e) {
      // Fallback for testing on devices where localhost might fail or if backend is down
      // Return empty list or rethrow
      print('Error fetching flights: $e');
      throw e;
    }
  }
}

final flightsRepositoryProvider = Provider<FlightsRepository>((ref) {
  return FlightsRepository();
});
