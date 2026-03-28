import 'package:flutter_test/flutter_test.dart';
import 'package:todos_explorer/models/todo_model.dart';
import 'package:todos_explorer/providers/todo_provider.dart';

void main() {
  group('TodoProvider Tests', () {
    late TodoProvider provider;

    setUp(() {
      provider = TodoProvider();
    });

    test('Initial state should be empty', () {
      print('🏃 Running test: Initial state checks...');
      expect(provider.todos, isEmpty);
      expect(provider.isLoading, false);
      expect(provider.currentFilter, FilterType.all);
      print('✅ Initial state verified correctly!');
    });

    test('Filter logic should work correctly', () {
      print('🏃 Running test: Filter logic switching...');
      provider.setFilter(FilterType.completed);
      expect(provider.currentFilter, FilterType.completed);
      
      provider.setFilter(FilterType.pending);
      expect(provider.currentFilter, FilterType.pending);
      print('✅ Filter logic verified correctly!');
    });

    test('Sort logic switching works', () {
      print('🏃 Running test: Sort logic switching...');
      provider.setSort(SortType.za);
      expect(provider.currentSort, SortType.za);
      
      provider.setSort(SortType.completedFirst);
      expect(provider.currentSort, SortType.completedFirst);
      print('✅ Sort logic verified correctly!');
    });

    test('Search query updates state', () {
      print('🏃 Running test: Search query logic...');
      provider.setSearch('test query');
      expect(provider.searchQuery, 'test query');
      print('✅ Search logic verified correctly!');
    });

    test('Favorite logic toggles correctly', () {
      print('🏃 Running test: Favorite toggling logic...');
      const todoId = 1;
      expect(provider.isFavorite(todoId), false);
      
      provider.toggleFavorite(todoId);
      expect(provider.isFavorite(todoId), true);
      
      provider.toggleFavorite(todoId);
      expect(provider.isFavorite(todoId), false);
      print('✅ Favorite logic verified correctly!');
    });
  });
}
