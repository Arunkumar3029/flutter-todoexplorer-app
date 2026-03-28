import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo_model.dart';
import '../services/api_service.dart';
import '../utils/app_constants.dart';

enum FilterType { all, completed, pending }

enum SortType { az, za, completedFirst, incompleteFirst }

class TodoProvider extends ChangeNotifier {
  List<Todo> _allTodos = [];
  List<Todo> _visibleTodos = [];

  String _searchQuery = '';
  bool _isSearchFilterMode = false; 

  FilterType _filter = FilterType.all;
  SortType _sort = SortType.az;

  bool isLoading = false;
  String? error;

  int _page = 1;

  bool isLoadingMore = false;
  bool hasMore = true;
  Set<int> _favoriteIds = {};
  
  List<Todo> get todos => _visibleTodos;
  int get totalCount => _allTodos.length;
  String get searchQuery => _searchQuery;
  FilterType get currentFilter => _filter;
  SortType get currentSort => _sort;
  bool get isSearchFilterMode => _isSearchFilterMode;
  bool isFavorite(int id) => _favoriteIds.contains(id);

  void toggleFavorite(int id) {
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }
    notifyListeners();
  }

  void toggleTodoStatus(int id) {
    final index = _allTodos.indexWhere((t) => t.id == id);
    if (index != -1) {
      _allTodos[index] = _allTodos[index].copyWith(
        completed: !_allTodos[index].completed,
      );
      applyFilters(); 
    }
  }

  Future<void> _loadFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString(AppConstants.cacheKey);

    if (cachedData != null) {
      final List data = jsonDecode(cachedData);

      _allTodos = data.map((e) => Todo.fromJson(e)).toList();
      applyFilters();
    }
  }

  Future<void> _saveToCache() async {
    final prefs = await SharedPreferences.getInstance();

    final jsonString = jsonEncode(
      _allTodos
          .map(
            (e) => {
              "userId": e.userId,
              "id": e.id,
              "title": e.title,
              "completed": e.completed,
            },
          )
          .toList(),
    );

    await prefs.setString(AppConstants.cacheKey, jsonString);
  }

  
  Future<void> fetchTodos() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();
      _page = 1;
      hasMore = true;

      final data = await ApiService.fetchTodos(_page, AppConstants.apiLimit);

      _allTodos = data;
      await _saveToCache();
      applyFilters();
    } on ApiException catch (e) {
      await _loadFromCache();
      error = e.message;
    } catch (e) {
      await _loadFromCache();
      error = 'An unexpected error occurred';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    if (isLoadingMore || !hasMore) return;

    try {
      isLoadingMore = true;
      notifyListeners();

      _page++;

      final newData = await ApiService.fetchTodos(_page, AppConstants.apiLimit);

      if (newData.isEmpty) {
        hasMore = false;
      } else {
        _allTodos.addAll(newData);
      }

      applyFilters();
    } on ApiException catch (e) {
      error = e.message;
    } catch (e) {
      error = 'Failed to load more items';
    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }

  
  void setSearch(String query) {
    _searchQuery = query;
    applyFilters();
  }

  
  void toggleSearchMode(bool value) {
    _isSearchFilterMode = value;
    applyFilters();
  }

  
  void setFilter(FilterType filter) {
    _filter = filter;
    applyFilters();
  }

  
  void setSort(SortType sort) {
    _sort = sort;
    applyFilters();
  }

  
  void applyFilters() {
    List<Todo> temp = List.from(_allTodos);

    
    if (_filter == FilterType.completed) {
      temp = temp.where((t) => t.completed).toList();
    } else if (_filter == FilterType.pending) {
      temp = temp.where((t) => !t.completed).toList();
    }

    
    if (_searchQuery.isNotEmpty && _isSearchFilterMode) {
      
      temp = temp
          .where(
            (t) => t.title.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }
    

    
    switch (_sort) {
      case SortType.az:
        temp.sort((a, b) => a.title.compareTo(b.title));
        break;

      case SortType.za:
        temp.sort((a, b) => b.title.compareTo(a.title));
        break;

      case SortType.completedFirst:
        temp.sort((a, b) => (b.completed ? 1 : 0) - (a.completed ? 1 : 0));
        break;

      case SortType.incompleteFirst:
        temp.sort((a, b) => (a.completed ? 1 : 0) - (b.completed ? 1 : 0));
        break;
    }

    _visibleTodos = temp;
    notifyListeners();
  }
}
