import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../domain/location.dart';

class LocationPicker extends StatefulWidget {
  final String title;
  const LocationPicker({super.key, required this.title});

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredLocations = popularLocations.where((loc) {
      final query = _searchQuery.toLowerCase();
      return loc.city.toLowerCase().contains(query) ||
          loc.code.toLowerCase().contains(query) ||
          loc.name.toLowerCase().contains(query);
    }).toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Search city or airport',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: filteredLocations.length,
              itemBuilder: (context, index) {
                final loc = filteredLocations[index];
                return ListTile(
                  leading: const Icon(Icons.flight_takeoff, color: AppColors.primary),
                  title: Text(loc.city, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${loc.name} (${loc.code})'),
                  onTap: () => Navigator.pop(context, loc),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
