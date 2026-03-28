import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todos_explorer/main.dart';
import 'package:todos_explorer/widgets/search_bar.dart';

void main() {
  testWidgets('App smoke test - verifies main layout and search bar', (WidgetTester tester) async {
    print('🏃 Running App Smoke Test: Verifying main screen structure...');
    
    await tester.pumpWidget(const MyApp());
    await tester.pump(); 

    print('🔍 Checking AppBar title...');
    expect(find.text('Todos Explorer'), findsOneWidget);

    print('🔍 Checking for SearchBarWidget existence...');
    expect(find.byType(SearchBarWidget), findsOneWidget);

    print('🔍 Checking for Filter Toggle switch...');
    expect(find.text('Search as Filter'), findsOneWidget);

    print('🔍 Checking for Search input TextField...');
    expect(find.byType(TextField), findsOneWidget);
    
    print('✅ App Smoke Test Passed Successfully!');
  });
}
