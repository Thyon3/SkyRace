import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../constants/app_colors.dart';
import '../../search/domain/flight.dart';
import '../domain/booking.dart';
import 'booking_controller.dart';
import '../../search/presentation/search_controller.dart';
import '../../search/domain/search_state.dart';
import 'seat_selection_screen.dart';

class BookingScreen extends ConsumerStatefulWidget {
  final Flight flight;

  const BookingScreen({super.key, required this.flight});

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passportController = TextEditingController();

  List<String> _selectedSeats = [];

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passportController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep == 0) {
      if (_formKey.currentState!.validate()) {
        setState(() => _currentStep++);
      }
    } else {
      setState(() => _currentStep++);
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingControllerProvider);
    final searchState = ref.watch(searchControllerProvider);
    final totalPassengers = searchState.passengers;
    final totalPrice = (widget.flight.price + 45) * totalPassengers;

    ref.listen<AsyncValue>(bookingControllerProvider, (previous, next) {
      next.whenOrNull(
        data: (success) {
          if (success != null) {
            _showSuccessDialog();
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(_getStepTitle()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _previousStep,
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textDark,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildStepIndicator(),
          Expanded(
            child: _buildCurrentStep(totalPassengers, totalPrice),
          ),
        ],
      ),
    );
  }

  String _getStepTitle() {
    switch (_currentStep) {
      case 0: return 'Passenger Details';
      case 1: return 'Select Seats';
      case 2: return 'Payment';
      default: return 'Checkout';
    }
  }

  Widget _buildStepIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      color: Colors.white,
      child: Row(
        children: [
          _buildStepCircle(0, 'Info'),
          _buildStepLine(0),
          _buildStepCircle(1, 'Seats'),
          _buildStepLine(1),
          _buildStepCircle(2, 'Pay'),
        ],
      ),
    );
  }

  Widget _buildStepCircle(int step, String label) {
    bool isActive = _currentStep >= step;
    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : Colors.grey.shade300,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              (step + 1).toString(),
              style: TextStyle(color: isActive ? Colors.white : Colors.grey, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: isActive ? AppColors.primary : Colors.grey, fontSize: 10)),
      ],
    );
  }

  Widget _buildStepLine(int step) {
    bool isActive = _currentStep > step;
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 8, marginBottom: 14),
        color: isActive ? AppColors.primary : Colors.grey.shade300,
      ),
    );
  }

  Widget _buildCurrentStep(int totalPassengers, double totalPrice) {
    switch (_currentStep) {
      case 0:
        return _buildPassengerStep(totalPassengers, totalPrice);
      case 1:
        return SeatSelectionScreen(
          flight: widget.flight,
          passengerCount: totalPassengers,
          onSeatsSelected: (seats) {
            setState(() {
              _selectedSeats = seats;
              _currentStep++;
            });
          },
        );
      case 2:
        return _buildPaymentStep(totalPassengers, totalPrice);
      default:
        return const Center(child: Text('Unknown Step'));
    }
  }

  Widget _buildPassengerStep(int totalPassengers, double totalPrice) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildFlightSummaryCard(totalPassengers),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Primary Passenger Details',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textDark),
                  ),
                  if (totalPassengers > 1)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        'You are booking for $totalPassengers passengers',
                        style: const TextStyle(color: AppColors.textLight, fontSize: 14),
                      ),
                    ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _firstNameController,
                    label: 'First Name',
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _lastNameController,
                    label: 'Last Name',
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _emailController,
                    label: 'Contact Email',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _passportController,
                    label: 'Passport Number',
                    icon: Icons.badge_outlined,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _nextStep,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Continue to Seat Selection', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentStep(int totalPassengers, double totalPrice) {
    final bookingState = ref.watch(bookingControllerProvider);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Booking Summary', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildSummaryItem('Flight', '${widget.flight.airline} (${widget.flight.flightNumber})'),
          _buildSummaryItem('Passengers', totalPassengers.toString()),
          _buildSummaryItem('Seats', _selectedSeats.join(', ')),
          const Divider(height: 32),
          _buildPriceBreakdown(totalPassengers, totalPrice),
          const SizedBox(height: 32),
          const Text('Payment Method', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildPaymentMethodCard('Credit / Debit Card', Icons.credit_card, true),
          _buildPaymentMethodCard('Google Pay', Icons.account_balance_wallet, false),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: bookingState.isLoading
                  ? null
                  : () {
                      ref.read(bookingControllerProvider.notifier).bookFlight(
                            flightId: widget.flight.id,
                            passengers: [
                              Passenger(
                                firstName: _firstNameController.text,
                                lastName: _lastNameController.text,
                                passportNumber: _passportController.text,
                              ),
                            ],
                            totalPrice: totalPrice,
                            seats: _selectedSeats,
                          );
                    },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: bookingState.isLoading
                  ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Text('Pay ${widget.flight.currency} ${totalPrice.toInt()}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textLight)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodCard(String title, IconData icon, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.shade200, width: isSelected ? 2 : 1),
      ),
      child: Row(
        children: [
          Icon(icon, color: isSelected ? AppColors.primary : AppColors.textLight),
          const SizedBox(width: 16),
          Text(title, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
          const Spacer(),
          if (isSelected) const Icon(Icons.check_circle, color: AppColors.primary),
        ],
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String label, required IconData icon, TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
      ),
      validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
    );
  }

  Widget _buildFlightSummaryCard(int passengers) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.secondary, borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.flight, color: AppColors.primary, size: 20)),
              const SizedBox(width: 12),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(widget.flight.airline, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('${widget.flight.flightNumber} • $passengers Passenger${passengers > 1 ? 's' : ''}', style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
              ]),
              const Spacer(),
              Text(DateFormat('EEE, MMM d').format(widget.flight.departureTime), style: const TextStyle(color: AppColors.textLight)),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _buildLocationSummary(widget.flight.origin, DateFormat('HH:mm').format(widget.flight.departureTime)),
              const Expanded(child: Padding(padding: EdgeInsets.symmetric(horizontal: 12.0), child: Icon(Icons.arrow_forward, color: Colors.grey, size: 16))),
              _buildLocationSummary(widget.flight.destination, DateFormat('HH:mm').format(widget.flight.arrivalTime)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSummary(String location, String time) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(time, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      Text(location.split('(').first.trim(), style: const TextStyle(color: AppColors.textLight)),
    ]);
  }

  Widget _buildPriceBreakdown(int passengers, double totalPrice) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
      child: Column(
        children: [
          _buildPriceRow('Flight Fare ($passengers x ${widget.flight.price.toInt()})', widget.flight.price * passengers),
          _buildPriceRow('Taxes & Fees ($passengers x 45)', 45.0 * passengers),
          const Divider(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Amount', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('${widget.flight.currency} ${totalPrice.toInt()}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textLight)),
          Text('${widget.flight.currency} $amount', style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 24),
            const Text('Booking Confirmed!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text('Your flight has been booked successfully. You can find your ticket in My Bookings.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textLight)),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.go('/'),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Text('Go to Home'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
