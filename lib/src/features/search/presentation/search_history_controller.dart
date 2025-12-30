import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchHistoryNotifier extends StateNotifier<List<String>> {
  SearchHistoryNotifier() : super([]) {
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList('search_history') ?? [];
    state = history;
  }

  Future<void> _saveHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('search_history', state);
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
    await _saveHistory();
  }

  Future<void> clearHistory() async {
    state = [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('search_history');
  }

  Future<void> removeSearch(String search) async {
    state = state.where((s) => s != search).toList();
    await _saveHistory();
  }
}

final searchHistoryProvider = StateNotifierProvider<SearchHistoryNotifier, List<String>>((ref) {
  return SearchHistoryNotifier();
});
