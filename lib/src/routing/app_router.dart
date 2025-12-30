import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/search/presentation/search_screen.dart';
import '../features/search/presentation/search_results_screen.dart';
import '../features/bookings/presentation/booking_screen.dart';
import '../features/search/domain/flight.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/register_screen.dart';
import '../features/auth/presentation/auth_controller.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isLoggedIn = authState.value != null;
      final isLoggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/register';

      if (!isLoggedIn && !isLoggingIn && state.matchedLocation.contains('book')) {
        return '/login';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
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
