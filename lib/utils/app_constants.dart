import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryBlue = Color(0xFF2196F3);
  static const Color backgroundGrey = Color(0xFFF5F5F5);

  static const Color completedGreen = Colors.green;
  static const Color pendingOrange = Colors.orange;
  static const Color errorRed = Colors.red;

  static const Color highlightColor = Color(0xFFFFF9C4);
  static const Color cardBgColor = Colors.white;

  static const Color chipAll = Color(0xFF607D8B);
  static const Color chipCompleted = Color(0xFF4CAF50);
  static const Color chipPending = Color(0xFFFF9800);
}

class AppConstants {
  static const String appTitle = 'Todos Explorer';
  static const String searchPlaceholder = 'Search todos...';
  static const String cacheKey = 'todos_cache';
  static const int apiLimit = 20;
}
