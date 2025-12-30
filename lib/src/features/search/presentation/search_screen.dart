import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../constants/app_colors.dart';
import '../domain/search_state.dart';
import '../domain/location.dart';
import 'search_controller.dart';
import 'search_history_controller.dart';
import 'location_picker.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(searchControllerProvider);
    final controller = ref.read(searchControllerProvider.notifier);
    final history = ref.watch(searchHistoryProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: _buildTripTypeSelector(searchState, controller),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildLocationInput(
                          context,
                          icon: Icons.radio_button_unchecked,
                          label: 'From',
                          value: searchState.origin,
                          onTap: () async {
                            final loc = await showModalBottomSheet<Location>(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) => const LocationPicker(title: 'Departure'),
                            );
                            if (loc != null) controller.setOrigin(loc.displayName);
                          },
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 40.0),
                          child: Divider(height: 1),
                        ),
                        _buildLocationInput(
                          context,
                          icon: Icons.location_on_outlined,
                          label: 'To',
                          value: searchState.destination,
                          onTap: () async {
                            final loc = await showModalBottomSheet<Location>(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) => const LocationPicker(title: 'Destination'),
                            );
                            if (loc != null) controller.setDestination(loc.displayName);
                          },
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildDateInput(
                                context,
                                icon: Icons.calendar_today_outlined,
                                label: 'Departure',
                                date: searchState.departureDate,
                                onTap: () async {
                                  final date = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.now().add(const Duration(days: 365)),
                                  );
                                  if (date != null) controller.setDepartureDate(date);
                                },
                              ),
                            ),
                            if (searchState.tripType == TripType.returnTrip) ...[
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildDateInput(
                                  context,
                                  icon: Icons.calendar_today_outlined,
                                  label: 'Return',
                                  date: searchState.returnDate,
                                  onTap: () async {
                                    final date = await showDatePicker(
                                      context: context,
                                      initialDate: searchState.departureDate ?? DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.now().add(const Duration(days: 365)),
                                    );
                                    if (date != null) controller.setReturnDate(date);
                                  },
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildPassengerInput(searchState, controller),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (searchState.origin != null && searchState.destination != null) {
                                ref.read(searchHistoryProvider.notifier).addSearch(
                                  '${searchState.origin} to ${searchState.destination}',
                                );
                              }
                              context.go('/results');
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Explore',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (history.isNotEmpty) _buildSearchHistory(history, ref),
              _buildPopularDestinations(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchHistory(List<String> history, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Recent Searches', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () => ref.read(searchHistoryProvider.notifier).clearHistory(),
                child: const Text('Clear'),
              ),
            ],
          ),
          Wrap(
            spacing: 8,
            children: history.map((search) => ActionChip(
              label: Text(search, style: const TextStyle(fontSize: 12)),
              onPressed: () {
                // TODO: Populate search fields from history
              },
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'SkyRace',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Search cheap flights\naround the world',
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripTypeSelector(SearchState state, SearchController controller) {
    return Row(
      children: [
        _TripTypeButton(
          label: 'Return',
          isSelected: state.tripType == TripType.returnTrip,
          onTap: () => controller.setTripType(TripType.returnTrip),
        ),
        const SizedBox(width: 8),
        _TripTypeButton(
          label: 'One-way',
          isSelected: state.tripType == TripType.oneWay,
          onTap: () => controller.setTripType(TripType.oneWay),
        ),
      ],
    );
  }

  Widget _buildLocationInput(
    BuildContext context, {
    required IconData icon,
    required String label,
    String? value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value ?? label,
                    style: TextStyle(
                      color: value != null ? AppColors.textDark : AppColors.textLight,
                      fontSize: 16,
                      fontWeight: value != null ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateInput(
    BuildContext context, {
    required IconData icon,
    required String label,
    DateTime? date,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textLight, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(color: AppColors.textLight, fontSize: 10),
                  ),
                  Text(
                    date != null ? DateFormat('MMM d').format(date) : 'Add date',
                    style: const TextStyle(
                      color: AppColors.textDark,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPassengerInput(SearchState state, SearchController controller) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          const Icon(Icons.person_outline, color: AppColors.textLight, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '${state.passengers} Passenger${state.passengers > 1 ? 's' : ''}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline, size: 20),
            onPressed: state.passengers > 1 ? () => controller.setPassengers(state.passengers - 1) : null,
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline, size: 20),
            onPressed: () => controller.setPassengers(state.passengers + 1),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularDestinations() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Popular Destinations',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildDestinationCard('Paris', 'France', 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34'),
                _buildDestinationCard('Tokyo', 'Japan', 'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf'),
                _buildDestinationCard('Rome', 'Italy', 'https://images.unsplash.com/photo-1552832230-c0197dd311b5'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDestinationCard(String city, String country, String imageUrl) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withOpacity(0.8), Colors.transparent],
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(city, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            Text(country, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class _TripTypeButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TripTypeButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.primary : AppColors.textLight,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
