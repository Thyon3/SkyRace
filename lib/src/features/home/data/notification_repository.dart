import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../auth/data/auth_repository.dart';

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? 'SYSTEM',
      isRead: json['isRead'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class NotificationRepository {
  final String baseUrl = 'http://10.0.2.2:5000/api';

  Future<List<NotificationModel>> getNotifications(String token) async {
    final uri = Uri.parse('$baseUrl/notifications');
    try {
      final response = await http.get(uri, headers: {
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List list = data['data'];
        return list.map((e) => NotificationModel.fromJson(e)).toList();
      }
      throw Exception('Failed to load notifications');
    } catch (e) {
      print('Error loading notifications: $e');
      rethrow;
    }
  }

  Future<void> markAsRead(String token, String id) async {
    final uri = Uri.parse('$baseUrl/notifications/$id/read');
    await http.put(uri, headers: {
      'Authorization': 'Bearer $token',
    });
  }

  Future<void> markAllAsRead(String token) async {
    final uri = Uri.parse('$baseUrl/notifications/read-all');
    await http.put(uri, headers: {
      'Authorization': 'Bearer $token',
    });
  }
}

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository();
});

final notificationsProvider = FutureProvider<List<NotificationModel>>((ref) async {
  final repository = ref.watch(notificationRepositoryProvider);
  final authRepository = ref.watch(authRepositoryProvider);
  final token = await authRepository.getToken();
  if (token == null) return [];
  return repository.getNotifications(token);
});
