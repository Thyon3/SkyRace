import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skyrace/src/features/auth/data/auth_repository.dart';

class CheckInRepository {
  final Dio _dio;

  CheckInRepository(this._dio);

  Future<Map<String, dynamic>> performCheckIn(String bookingId, List<String> passengerIds) async {
    try {
      final response = await _dio.post('/api/checkin', data: {
        'bookingId': bookingId,
        'passengerIds': passengerIds,
      });
      return response.data;
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? 'Check-in failed';
    }
  }

  Future<Map<String, dynamic>> getBoardingPass(String bookingId, String passengerId) async {
    try {
      final response = await _dio.get('/api/checkin/$bookingId/$passengerId');
      return response.data;
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? 'Failed to load boarding pass';
    }
  }
}

final checkInRepositoryProvider = Provider<CheckInRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return CheckInRepository(dio);
});
