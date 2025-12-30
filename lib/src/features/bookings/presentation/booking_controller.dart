import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/bookings_repository.dart';
import '../domain/booking.dart';

class BookingController extends StateNotifier<AsyncValue<Booking?>> {
  final BookingsRepository _repository;

  BookingController(this._repository) : super(const AsyncData(null));

  Future<void> bookFlight({
    required String flightId,
    required List<Passenger> passengers,
    required double totalPrice,
  }) async {
    state = const AsyncLoading();
    
    final booking = Booking(
      flightId: flightId,
      passengers: passengers,
      totalPrice: totalPrice,
    );

    state = await AsyncValue.guard(() => _repository.createBooking(booking));
  }
}

final bookingControllerProvider = StateNotifierProvider<BookingController, AsyncValue<Booking?>>((ref) {
  return BookingController(ref.watch(bookingsRepositoryProvider));
});
