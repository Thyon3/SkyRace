import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/auth_repository.dart';
import '../domain/user.dart';

class AuthController extends StateNotifier<AsyncValue<User?>> {
  final AuthRepository _repository;

  AuthController(this._repository) : super(const AsyncData(null)) {
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    state = const AsyncLoading();
    final token = await _repository.getToken();
    if (token != null) {
      // In a real app, you'd fetch the user profile with the token
      // For now, we'll just set a mock user if token exists
      state = AsyncData(User(id: 'mock_user_id', name: 'John Doe', email: 'john@example.com', token: token));
    } else {
      state = const AsyncData(null);
    }
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repository.login(email, password));
  }

  Future<void> register(String name, String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repository.register(name, email, password));
  }

  Future<void> logout() async {
    await _repository.removeToken();
    state = const AsyncData(null);
  }

  Future<void> updateProfile(String name, String email) async {
    final currentUser = state.value;
    if (currentUser == null || currentUser.token == null) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repository.updateProfile(name, email, currentUser.token!));
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AsyncValue<User?>>((ref) {
  return AuthController(ref.watch(authRepositoryProvider));
});
