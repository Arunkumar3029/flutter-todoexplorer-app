import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:todos_explorer/models/todo_model.dart';
import 'package:todos_explorer/providers/todo_provider.dart';
import 'package:todos_explorer/widgets/todo_card.dart';

void main() {
  testWidgets('TodoCard displays correct information and highlights search', (
    WidgetTester tester,
  ) async {
    final todo = Todo(
      userId: 1,
      id: 101,
      title: 'Finish Flutter Project',
      completed: true,
    );

    final provider = TodoProvider();
    provider.setSearch('Flutter');

    print(
      '🏃 Running Widget Test: Testing TodoCard with search highlighting...',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ChangeNotifierProvider<TodoProvider>.value(
            value: provider,
            child: TodoCard(todo: todo),
          ),
        ),
      ),
    );

    print('🔍 Verifying text content (Title, ID, Status)...');
    expect(find.text('Finish Flutter Project'), findsOneWidget);
    expect(find.textContaining('ID: 101'), findsOneWidget);
    expect(find.text('Completed'), findsOneWidget);

    print('🎨 Verifying search highlighting color (Yellow)...');
    final card = tester.widget<Card>(find.byType(Card));
    expect(card.color, const Color(0xFFFFF9C4));

    print('✅ TodoCard Widget Test Passed Successfully!');
  });
}
