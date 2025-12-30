import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/search/presentation/search_screen.dart';
import '../features/search/presentation/search_results_screen.dart';
import '../features/bookings/presentation/booking_screen.dart';
import '../features/search/domain/flight.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SearchScreen(),
        routes: [
          GoRoute(
            path: 'results',
            builder: (context, state) => const SearchResultsScreen(),
            routes: [
              GoRoute(
                path: 'book',
                builder: (context, state) {
                  final flight = state.extra as Flight;
                  return BookingScreen(flight: flight);
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
