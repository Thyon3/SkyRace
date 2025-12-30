import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/search/presentation/search_screen.dart';
import '../features/search/presentation/search_results_screen.dart';

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
          ),
        ],
      ),
    ],
  );
});
