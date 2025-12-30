import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/user.dart';

class AuthRepository {
  final String baseUrl = 'http://10.0.2.2:5000/api';

  Future<User> login(String email, String password) async {
    final uri = Uri.parse('$baseUrl/auth/login');
    
    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final user = User.fromJson(data['user']).copyWith(token: data['token']);
        await _saveToken(data['token']);
        return user;
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      print('Error logging in: $e');
      rethrow;
    }
  }

  Future<User> register(String name, String email, String password) async {
    final uri = Uri.parse('$baseUrl/auth/register');
    
    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'name': name, 'email': email, 'password': password}),
      );
      
      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        final user = User.fromJson(data['user']).copyWith(token: data['token']);
        await _saveToken(data['token']);
        return user;
      } else {
        throw Exception('Failed to register');
      }
    } catch (e) {
      print('Error registering: $e');
      rethrow;
    }
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  Future<User> updateProfile(String name, String email, String token) async {
    final uri = Uri.parse('$baseUrl/auth/profile');
    
    try {
      final response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'name': name, 'email': email}),
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return User.fromJson(data['user']).copyWith(token: token);
      } else {
        throw Exception('Failed to update profile');
      }
    } catch (e) {
      print('Error updating profile: $e');
      rethrow;
    }
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});
