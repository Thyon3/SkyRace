import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/design_system.dart';

class FlightStatusScreen extends StatefulWidget {
  const FlightStatusScreen({super.key});

  @override
  State<FlightStatusScreen> createState() => _FlightStatusScreenState();
}

class _FlightStatusScreenState extends State<FlightStatusScreen> {
  final _flightNumberController = TextEditingController();
  bool _hasSearched = false;
  final List<String> _trackedFlights = ['SK204', 'SK102', 'AA450']; // Mock history

  @override
  void dispose() {
    _flightNumberController.dispose();
    super.dispose();
  }

  void _searchFlight([String? flightNumber]) {
    final number = flightNumber ?? _flightNumberController.text;
    if (number.isEmpty) return;
    
    setState(() {
      if (flightNumber != null) _flightNumberController.text = flightNumber;
      _hasSearched = true;
      if (!_trackedFlights.contains(number.toUpperCase())) {
        _trackedFlights.insert(0, number.toUpperCase());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Flight Status'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        leading: _hasSearched ? IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => setState(() => _hasSearched = false),
        ) : null,
      ),
      body: Column(
        children: [
          _buildSearchHeader(),
          Expanded(
            child: _hasSearched ? _buildStatusResults() : _buildEmptyState(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Container(
      padding: const EdgeInsets.all(DesignSystem.spacingM),
      color: Colors.white,
      child: Column(
        children: [
          TextField(
            controller: _flightNumberController,
            decoration: InputDecoration(
              hintText: 'Enter Flight Number (e.g. SK123)',
              prefixIcon: const Icon(Icons.flight),
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(borderRadius: DesignSystem.radiusMedium, borderSide: BorderSide.none),
            ),
            onSubmitted: (_) => _searchFlight(),
          ),
          const SizedBox(height: DesignSystem.spacingM),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _searchFlight,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: DesignSystem.radiusMedium),
                elevation: 0,
              ),
              child: const Text('Check Status', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 40),
          Icon(Icons.track_changes, size: 80, color: AppColors.textLight.withOpacity(0.3)),
          const SizedBox(height: DesignSystem.spacingM),
          const Text('Track any flight in real-time', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const Text('Enter a flight number to see its current status', style: TextStyle(color: AppColors.textLight)),
          
          if (_trackedFlights.isNotEmpty) ...[
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Recent Searches', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  TextButton(onPressed: () => setState(() => _trackedFlights.clear()), child: const Text('Clear')),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _trackedFlights.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.history, color: AppColors.textLight),
                  title: Text(_trackedFlights[index], style: const TextStyle(fontWeight: FontWeight.bold)),
                  trailing: const Icon(Icons.chevron_right, size: 20),
                  onTap: () => _searchFlight(_trackedFlights[index]),
                );
              },
            ),
          ],
        ],
      ),
    );
  }


  Widget _buildStatusResults() {
    return ListView(
      padding: const EdgeInsets.all(DesignSystem.spacingM),
      children: [
        _buildStatusCard(
          flightNumber: _flightNumberController.text.toUpperCase(),
          status: 'On Time',
          origin: 'JFK',
          destination: 'LHR',
          departure: '10:30 AM',
          arrival: '10:45 PM',
          gate: 'B12',
          terminal: '4',
        ),
      ],
    );
  }

  Widget _buildStatusCard({
    required String flightNumber,
    required String status,
    required String origin,
    required String destination,
    required String departure,
    required String arrival,
    required String gate,
    required String terminal,
  }) {
    return Container(
      padding: const EdgeInsets.all(DesignSystem.spacingL),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: DesignSystem.radiusLarge,
        boxShadow: DesignSystem.softShadow,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('SkyRace Air', style: DesignSystem.caption),
                  Text(flightNumber, style: DesignSystem.heading2),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: DesignSystem.radiusFull,
                ),
                child: Text(status, style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: DesignSystem.spacingXL),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLocationInfo(origin, 'Departure', departure),
              const Icon(Icons.flight_takeoff, color: AppColors.primary, size: 32),
              _buildLocationInfo(destination, 'Arrival', arrival),
            ],
          ),
          const Divider(height: DesignSystem.spacingXL),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildDetailItem('Terminal', terminal),
              _buildDetailItem('Gate', gate),
              _buildDetailItem('Baggage', 'Belt 4'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationInfo(String code, String label, String time) {
    return Column(
      children: [
        Text(code, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        Text(label, style: DesignSystem.caption),
        const SizedBox(height: 4),
        Text(time, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: DesignSystem.caption),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }
}
