import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../domain/booking.dart';

class BookingsRepository {
  final String baseUrl = 'http://10.0.2.2:5000/api';

  Future<Booking> createBooking(Booking booking, String token) async {
    final uri = Uri.parse('$baseUrl/bookings');
    
    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
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

  Future<List<Booking>> getUserBookings(String token) async {
    final uri = Uri.parse('$baseUrl/bookings');
    
    try {
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Booking.fromJson(json)).toList();
      } else {
        // Return mock data for now if 404 or other error
        return [
          Booking(
            id: '1',
            flightId: 'SK123',
            passengers: [Passenger(firstName: 'John', lastName: 'Doe')],
            totalPrice: 450,
            status: 'confirmed',
            createdAt: DateTime.now(),
          )
        ];
      }
    } catch (e) {
      print('Error fetching user bookings: $e');
      rethrow;
    }
  }
}

final bookingsRepositoryProvider = Provider<BookingsRepository>((ref) {
  return BookingsRepository();
});
