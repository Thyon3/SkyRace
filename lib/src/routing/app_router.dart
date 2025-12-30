import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/register_screen.dart';
import '../features/search/presentation/search_screen.dart';
import '../features/search/presentation/search_results_screen.dart';
import '../features/bookings/presentation/booking_screen.dart';
import '../features/bookings/presentation/ticket_screen.dart';
import '../features/bookings/domain/booking.dart';
import '../features/search/domain/flight.dart';
import '../features/auth/presentation/auth_controller.dart';
import '../features/home/presentation/main_screen.dart';
import '../features/search/presentation/flight_details_screen.dart';
import '../features/auth/presentation/edit_profile_screen.dart';
import '../features/home/presentation/help_center_screen.dart';
import '../features/home/presentation/settings_screen.dart';
import '../features/home/presentation/loyalty_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isLoggedIn = authState.value != null;
      final isAuthRoute = state.matchedLocation == '/login' || state.matchedLocation == '/register';

      if (!isLoggedIn && !isAuthRoute) {
        if (state.matchedLocation == '/' || state.matchedLocation == '/results' || state.matchedLocation == '/results/details') {
          return null;
        }
        return '/login';
      }

      if (isLoggedIn && isAuthRoute) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const MainScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/results',
        builder: (context, state) => const SearchResultsScreen(),
        routes: [
          GoRoute(
            path: 'details',
            builder: (context, state) {
              final flight = state.extra as Flight;
              return FlightDetailsScreen(flight: flight);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/booking',
        builder: (context, state) {
          final flight = state.extra as Flight;
          return BookingScreen(flight: flight);
        },
      ),
      GoRoute(
        path: '/edit-profile',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/help-center',
        builder: (context, state) => const HelpCenterScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/loyalty',
        builder: (context, state) => const LoyaltyScreen(),
      ),
      GoRoute(
        path: '/ticket',
        builder: (context, state) => TicketScreen(booking: state.extra as Booking),
      ),
    ],
  );
});
