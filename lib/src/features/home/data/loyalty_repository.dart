import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../auth/data/auth_repository.dart';

class LoyaltyTransactionModel {
  final String id;
  final String type;
  final int points;
  final String description;
  final DateTime createdAt;

  LoyaltyTransactionModel({
    required this.id,
    required this.type,
    required this.points,
    required this.description,
    required this.createdAt,
  });

  factory LoyaltyTransactionModel.fromJson(Map<String, dynamic> json) {
    return LoyaltyTransactionModel(
      id: json['_id'] ?? '',
      type: json['type'] ?? 'EARNED',
      points: json['points'] ?? 0,
      description: json['description'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class LoyaltyRepository {
  final String baseUrl = 'http://10.0.2.2:5000/api';

  Future<List<LoyaltyTransactionModel>> getHistory(String token) async {
    final uri = Uri.parse('$baseUrl/loyalty/history');
    try {
      final response = await http.get(uri, headers: {
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List list = data['data'];
        return list.map((e) => LoyaltyTransactionModel.fromJson(e)).toList();
      }
      throw Exception('Failed to load loyalty history');
    } catch (e) {
      print('Error loading loyalty history: $e');
      rethrow;
    }
  }
}

final loyaltyRepositoryProvider = Provider<LoyaltyRepository>((ref) {
  return LoyaltyRepository();
});

final loyaltyHistoryProvider = FutureProvider<List<LoyaltyTransactionModel>>((ref) async {
  final repository = ref.watch(loyaltyRepositoryProvider);
  final authRepository = ref.watch(authRepositoryProvider);
  final token = await authRepository.getToken();
  if (token == null) return [];
  return repository.getHistory(token);
});
