import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../constants/app_colors.dart';
import '../../search/domain/flight.dart';
import '../domain/booking.dart';
import 'booking_controller.dart';

class BookingScreen extends ConsumerStatefulWidget {
  final Flight flight;

  const BookingScreen({super.key, required this.flight});

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _passportController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _passportController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingControllerProvider);

    ref.listen<AsyncValue<Booking?>>(bookingControllerProvider, (previous, next) {
      next.whenOrNull(
        data: (booking) {
          if (booking != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Booking Successful!')),
            );
            context.go('/');
          }
        },
        error: (err, stack) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $err')),
          );
        },
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Passenger Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFlightSummary(),
              const SizedBox(height: 24),
              const Text(
                'Passenger 1',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passportController,
                decoration: const InputDecoration(
                  labelText: 'Passport Number',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: bookingState.isLoading
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            ref.read(bookingControllerProvider.notifier).bookFlight(
                                  flightId: widget.flight.id,
                                  passengers: [
                                    Passenger(
                                      firstName: _firstNameController.text,
                                      lastName: _lastNameController.text,
                                      passportNumber: _passportController.text,
                                    ),
                                  ],
                                  totalPrice: widget.flight.price,
                                );
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppColors.primary,
                  ),
                  child: bookingState.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Confirm Booking',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFlightSummary() {
    return Card(
      color: AppColors.secondary,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.flight.origin} to ${widget.flight.destination}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(widget.flight.airline),
            const SizedBox(height: 8),
            Text(
              'Total Price: ${widget.flight.currency} ${widget.flight.price}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
