import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../domain/booking.dart';

class BookingsRepository {
  final String baseUrl = 'http://10.0.2.2:5000/api';

  Future<Booking> createBooking(Booking booking) async {
    final uri = Uri.parse('$baseUrl/bookings');
    
    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(booking.toJson()),
      );
      
      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return Booking.fromJson(data['booking']);
      } else {
        throw Exception('Failed to create booking');
      }
    } catch (e) {
      print('Error creating booking: $e');
      rethrow;
    }
  }

  Future<Booking> getBooking(String id) async {
    final uri = Uri.parse('$baseUrl/bookings/$id');
    
    try {
      final response = await http.get(uri);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Booking.fromJson(data);
      } else {
        throw Exception('Failed to load booking');
      }
    } catch (e) {
      print('Error fetching booking: $e');
      rethrow;
    }
  }
}

final bookingsRepositoryProvider = Provider<BookingsRepository>((ref) {
  return BookingsRepository();
});
