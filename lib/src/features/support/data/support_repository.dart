import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../auth/data/auth_repository.dart';
import '../domain/support_ticket.dart';

class SupportRepository {
  final String baseUrl = 'http://10.0.2.2:5000/api';

  Future<List<SupportTicket>> getTickets(String token) async {
    final uri = Uri.parse('$baseUrl/support');
    
    try {
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List tickets = data['data'];
        return tickets.map((e) => SupportTicket.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load tickets');
      }
    } catch (e) {
      print('Error loading tickets: $e');
      rethrow;
    }
  }

  Future<SupportTicket> createTicket(
    String token, {
    required String subject,
    required String message,
    required String category,
    required String priority,
  }) async {
    final uri = Uri.parse('$baseUrl/support');
    
    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'subject': subject,
          'message': message,
          'category': category,
          'priority': priority,
        }),
      );
      
      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return SupportTicket.fromJson(data['data']);
      } else {
        throw Exception('Failed to create ticket');
      }
    } catch (e) {
      print('Error creating ticket: $e');
      rethrow;
    }
  }

  Future<SupportTicket> addResponse(String token, String ticketId, String message) async {
    final uri = Uri.parse('$baseUrl/support/$ticketId/response');
    
    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'message': message}),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return SupportTicket.fromJson(data['data']);
      } else {
        throw Exception('Failed to add response');
      }
    } catch (e) {
      print('Error adding response: $e');
      rethrow;
    }
  }
}

final supportRepositoryProvider = Provider<SupportRepository>((ref) {
  return SupportRepository();
});

final userTicketsProvider = FutureProvider<List<SupportTicket>>((ref) async {
  final repository = ref.watch(supportRepositoryProvider);
  final authRepository = ref.watch(authRepositoryProvider);
  final token = await authRepository.getToken();
  
  if (token == null) return [];
  return repository.getTickets(token);
});
