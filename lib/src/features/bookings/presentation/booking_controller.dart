import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/bookings_repository.dart';
import '../domain/booking.dart';
import '../../auth/presentation/auth_controller.dart';

class BookingController extends StateNotifier<AsyncValue<Booking?>> {
  final BookingsRepository _repository;
  final Ref _ref;

  BookingController(this._repository, this._ref) : super(const AsyncData(null));

  Future<void> bookFlight({
    required String flightId,
    required List<Passenger> passengers,
    required double totalPrice,
    required List<String> seats,
  }) async {
    final user = _ref.read(authControllerProvider).value;
    if (user == null || user.token == null) {
      state = AsyncError('User not authenticated', StackTrace.current);
      return;
    }

    state = const AsyncLoading();
    
    final booking = Booking(
      flightId: flightId,
      passengers: passengers,
      totalPrice: totalPrice,
      seats: seats,
    );

    state = await AsyncValue.guard(() => _repository.createBooking(booking, user.token!));
  }
}

final bookingControllerProvider = StateNotifierProvider<BookingController, AsyncValue<Booking?>>((ref) {
  return BookingController(ref.watch(bookingsRepositoryProvider), ref);
});

final userBookingsProvider = FutureProvider<List<Booking>>((ref) async {
  final user = ref.watch(authControllerProvider).value;
  if (user == null || user.token == null) return [];
  
  final repository = ref.watch(bookingsRepositoryProvider);
  return repository.getUserBookings(user.token!);
});
