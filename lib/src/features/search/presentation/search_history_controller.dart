import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SearchHistoryNotifier extends StateNotifier<List<String>> {
  SearchHistoryNotifier() : super([]) {
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('search_history') ?? [];
    state = history;
  }

  Future<void> addSearch(String query) async {
    if (state.contains(query)) {
      state = [query, ...state.where((e) => e != query)];
    } else {
      state = [query, ...state];
    }
    
    if (state.length > 5) {
      state = state.sublist(0, 5);
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('search_history', state);
  }

  Future<void> clearHistory() async {
    state = [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('search_history');
  }
}

final searchHistoryProvider = StateNotifierProvider<SearchHistoryNotifier, List<String>>((ref) {
  return SearchHistoryNotifier();
});
