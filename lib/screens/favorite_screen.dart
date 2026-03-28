import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';
import '../widgets/todo_card.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TodoProvider>();
    
    
    final favoriteTodos = provider.todos.where((t) => provider.isFavorite(t.id)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Todos'),
      ),
      body: favoriteTodos.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star_border, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No favorites yet!',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: favoriteTodos.length,
              itemBuilder: (context, index) {
                final todo = favoriteTodos[index];
                return TodoCard(todo: todo);
              },
            ),
    );
  }
}
