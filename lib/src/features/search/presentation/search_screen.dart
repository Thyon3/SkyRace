import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/design_system.dart';
import '../domain/search_state.dart';
import '../domain/location.dart';
import 'search_controller.dart';
import 'search_history_controller.dart';
import 'location_picker.dart';
import 'passenger_selector.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(searchControllerProvider);
    final controller = ref.read(searchControllerProvider.notifier);
    final history = ref.watch(searchHistoryProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(DesignSystem.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTripTypeSelector(searchState, controller),
                  const SizedBox(height: DesignSystem.spacingM),
                  _buildSearchCard(context, searchState, controller),
                  const SizedBox(height: DesignSystem.spacingL),
                  _buildSectionTitle('Recent Searches', history.isNotEmpty),
                  _buildSearchHistory(history, ref, context),
                  const SizedBox(height: DesignSystem.spacingL),
                  _buildSectionTitle('Popular Destinations', true),
                  _buildPopularDestinations(controller),
                  const SizedBox(height: DesignSystem.spacingXL),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: AppColors.primary,
      flexibleSpace: FlexibleSpaceBar(
        title: Text('SkyRace', style: DesignSystem.heading2.copyWith(color: Colors.white)),
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
              ),
            ),
            Positioned(
              right: -50,
              top: -50,
              child: Icon(Icons.flight_takeoff, size: 200, color: Colors.white.withOpacity(0.1)),
            ),
            Padding(
              padding: const EdgeInsets.all(DesignSystem.spacingL),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Where to next?',
                    style: DesignSystem.heading1.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: DesignSystem.spacingXS),
                  Text(
                    'Find the best deals on flights worldwide',
                    style: DesignSystem.bodyMedium.copyWith(color: Colors.white.withOpacity(0.8)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool showAction) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DesignSystem.spacingM),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: DesignSystem.heading2.copyWith(fontSize: 20)),
          if (showAction)
            TextButton(
              onPressed: () {},
              child: const Text('See all'),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchCard(BuildContext context, SearchState state, SearchController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: DesignSystem.radiusLarge,
        boxShadow: DesignSystem.mediumShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(DesignSystem.spacingL),
        child: Column(
          children: [
            _buildLocationField(
              context,
              icon: Icons.radio_button_unchecked,
              label: 'From',
              value: state.origin,
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
              padding: EdgeInsets.only(left: 40),
              child: Divider(height: 1, color: AppColors.border),
            ),
            _buildLocationField(
              context,
              icon: Icons.location_on_outlined,
              label: 'To',
              value: state.destination,
              onTap: () async {
                final loc = await showModalBottomSheet<Location>(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => const LocationPicker(title: 'Destination'),
                );
                if (loc != null) controller.setDestination(loc.displayName);
              },
            ),
            const SizedBox(height: DesignSystem.spacingM),
            Row(
              children: [
                Expanded(
                  child: _buildDateField(
                    context,
                    label: 'Departure',
                    date: state.departureDate,
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
                if (state.tripType == TripType.returnTrip) ...[
                  const SizedBox(width: DesignSystem.spacingM),
                  Expanded(
                    child: _buildDateField(
                      context,
                      label: 'Return',
                      date: state.returnDate,
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: state.departureDate ?? DateTime.now(),
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
            const SizedBox(height: DesignSystem.spacingM),
            _buildPassengerField(context, state, controller),
            const SizedBox(height: DesignSystem.spacingL),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  if (state.origin != null && state.destination != null) {
                    ref.read(searchHistoryProvider.notifier).addSearch(
                      '${state.origin} to ${state.destination}',
                    );
                  }
                  context.go('/results');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: DesignSystem.radiusMedium),
                  elevation: 0,
                ),
                child: const Text('Search Flights', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationField(BuildContext context, {required IconData icon, required String label, String? value, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: DesignSystem.spacingM),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 24),
            const SizedBox(width: DesignSystem.spacingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: DesignSystem.caption),
                  Text(
                    value ?? 'Select City',
                    style: DesignSystem.bodyLarge.copyWith(
                      fontWeight: value != null ? FontWeight.bold : FontWeight.normal,
                      color: value != null ? AppColors.textDark : AppColors.textLight,
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

  Widget _buildDateField(BuildContext context, {required String label, DateTime? date, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(DesignSystem.spacingM),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: DesignSystem.radiusMedium,
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: DesignSystem.caption),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  date != null ? DateFormat('MMM d, y').format(date) : 'Add date',
                  style: DesignSystem.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPassengerField(BuildContext context, SearchState state, SearchController controller) {
    return InkWell(
      onTap: () async {
        final passengers = await showModalBottomSheet<int>(
          context: context,
          builder: (context) => PassengerSelector(initialPassengers: state.passengers),
        );
        if (passengers != null) controller.setPassengers(passengers);
      },
      child: Container(
        padding: const EdgeInsets.all(DesignSystem.spacingM),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: DesignSystem.radiusMedium,
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const Icon(Icons.person_outline, color: AppColors.primary),
            const SizedBox(width: DesignSystem.spacingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Passengers', style: DesignSystem.caption),
                  Text(
                    '${state.passengers} Passenger${state.passengers > 1 ? 's' : ''}',
                    style: DesignSystem.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, color: AppColors.textLight),
          ],
        ),
      ),
    );
  }

  Widget _buildTripTypeSelector(SearchState state, SearchController controller) {
    return Row(
      children: [
        _TripTypeChip(
          label: 'Return',
          isSelected: state.tripType == TripType.returnTrip,
          onTap: () => controller.setTripType(TripType.returnTrip),
        ),
        const SizedBox(width: DesignSystem.spacingS),
        _TripTypeChip(
          label: 'One-way',
          isSelected: state.tripType == TripType.oneWay,
          onTap: () => controller.setTripType(TripType.oneWay),
        ),
        const SizedBox(width: DesignSystem.spacingS),
        _TripTypeChip(
          label: 'Multi-city',
          isSelected: state.tripType == TripType.multiCity,
          onTap: () => controller.setTripType(TripType.multiCity),
        ),
      ],
    );
  }

  Widget _buildSearchHistory(List<String> history, WidgetRef ref, BuildContext context) {
    if (history.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(DesignSystem.spacingM),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: DesignSystem.radiusMedium,
          border: Border.all(color: AppColors.border),
        ),
        child: const Text('Your recent searches will appear here', style: TextStyle(color: AppColors.textLight)),
      );
    }
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: history.length,
        separatorBuilder: (_, __) => const SizedBox(width: DesignSystem.spacingS),
        itemBuilder: (context, index) => ActionChip(
          label: Text(history[index]),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: DesignSystem.radiusFull, side: const BorderSide(color: AppColors.border)),
          onPressed: () => ref.read(searchControllerProvider.notifier).setSearchFromHistory(history[index]),
        ),
      ),
    );
  }

  Widget _buildPopularDestinations(SearchController controller) {
    final destinations = [
      {'city': 'Paris', 'country': 'France', 'image': 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34', 'code': 'CDG'},
      {'city': 'Tokyo', 'country': 'Japan', 'image': 'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf', 'code': 'NRT'},
      {'city': 'Rome', 'country': 'Italy', 'image': 'https://images.unsplash.com/photo-1552832230-c0197dd311b5', 'code': 'FCO'},
      {'city': 'New York', 'country': 'USA', 'image': 'https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9', 'code': 'JFK'},
    ];

    return SizedBox(
      height: 240,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: destinations.length,
        separatorBuilder: (_, __) => const SizedBox(width: DesignSystem.spacingM),
        itemBuilder: (context, index) {
          final dest = destinations[index];
          return InkWell(
            onTap: () => controller.setDestination('${dest['city']} (${dest['code']})'),
            child: Container(
              width: 180,
              decoration: BoxDecoration(
                borderRadius: DesignSystem.radiusLarge,
                image: DecorationImage(image: NetworkImage(dest['image']!), fit: BoxFit.cover),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: DesignSystem.radiusLarge,
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                  ),
                ),
                padding: const EdgeInsets.all(DesignSystem.spacingM),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(dest['city']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                    Text(dest['country']!, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TripTypeChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TripTypeChip({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.primary,
      backgroundColor: Colors.white,
      labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.textMedium, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
      shape: RoundedRectangleBorder(borderRadius: DesignSystem.radiusFull, side: BorderSide(color: isSelected ? AppColors.primary : AppColors.border)),
    );
  }
}
