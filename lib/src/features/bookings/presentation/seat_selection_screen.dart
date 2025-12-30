import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../constants/app_colors.dart';
import '../../search/domain/flight.dart';

class SeatSelectionScreen extends StatefulWidget {
  final Flight flight;
  final int passengerCount;
  final Function(List<String>) onSeatsSelected;

  const SeatSelectionScreen({
    super.key,
    required this.flight,
    required this.passengerCount,
    required this.onSeatsSelected,
  });

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  final List<String> _selectedSeats = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Select Seats'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textDark,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _buildPlaneNose(),
                  const SizedBox(height: 32),
                  _buildSeatGrid(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildLegendItem(Colors.grey.shade300, 'Available'),
          _buildLegendItem(AppColors.primary, 'Selected'),
          _buildLegendItem(Colors.grey.shade600, 'Occupied'),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textLight)),
      ],
    );
  }

  Widget _buildPlaneNose() {
    return Container(
      width: 200,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(100)),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: const Center(
        child: Text('Front of Plane', style: TextStyle(color: AppColors.textLight, fontSize: 12)),
      ),
    );
  }

  Widget _buildSeatGrid() {
    final seats = widget.flight.seats;
    if (seats.isEmpty) return const Text('No seat data available');

    // Group seats by row
    final Map<int, List<Seat>> rows = {};
    for (var seat in seats) {
      final rowNum = int.parse(seat.number.replaceAll(RegExp(r'[^0-9]'), ''));
      rows.putIfAbsent(rowNum, () => []).add(seat);
    }

    return Column(
      children: rows.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(entry.key.toString().padLeft(2, '0'), style: const TextStyle(color: AppColors.textLight, fontSize: 12)),
              const SizedBox(width: 16),
              ...entry.value.asMap().entries.map((seatEntry) {
                final seat = seatEntry.value;
                final isAisle = seatEntry.key == 3; // Aisle after 3rd seat
                return Row(
                  children: [
                    if (isAisle) const SizedBox(width: 24),
                    _buildSeat(seat),
                    const SizedBox(width: 8),
                  ],
                );
              }),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSeat(Seat seat) {
    final isSelected = _selectedSeats.contains(seat.number);
    final isOccupied = seat.isOccupied;

    Color color = Colors.grey.shade300;
    if (isOccupied) color = Colors.grey.shade600;
    if (isSelected) color = AppColors.primary;

    return GestureDetector(
      onTap: isOccupied
          ? null
          : () {
              setState(() {
                if (isSelected) {
                  _selectedSeats.remove(seat.number);
                } else if (_selectedSeats.length < widget.passengerCount) {
                  _selectedSeats.add(seat.number);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('You can only select ${widget.passengerCount} seats')),
                  );
                }
              });
            },
      child: Container(
        width: 32,
        height: 36,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Text(
            seat.number.replaceAll(RegExp(r'[0-9]'), ''),
            style: TextStyle(
              color: isSelected || isOccupied ? Colors.white : AppColors.textDark,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5)),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_selectedSeats.length}/${widget.passengerCount} Selected',
                  style: const TextStyle(color: AppColors.textLight, fontSize: 14),
                ),
                Text(
                  _selectedSeats.isEmpty ? 'Select seats' : _selectedSeats.join(', '),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _selectedSeats.length == widget.passengerCount
                  ? () => widget.onSeatsSelected(_selectedSeats)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Confirm', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
