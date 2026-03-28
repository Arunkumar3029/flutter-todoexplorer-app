import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/todo_model.dart';
import '../providers/todo_provider.dart';
import '../utils/app_constants.dart';

class TodoCard extends StatelessWidget {
  final Todo todo;

  const TodoCard({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TodoProvider>();

    final query = provider.searchQuery.toLowerCase();

    final isMatch =
        query.isNotEmpty && todo.title.toLowerCase().contains(query);

    return Card(
      color: isMatch ? AppColors.highlightColor : AppColors.cardBgColor,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: InkWell(
          onTap: () => provider.toggleTodoStatus(todo.id),
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Icon(
              todo.completed ? Icons.check_circle : Icons.circle_outlined,
              color: todo.completed ? AppColors.completedGreen : Colors.grey,
            ),
          ),
        ),
        title: Tooltip(
          message: todo.title,
          child: Text(
            todo.title,
            style: const TextStyle(fontWeight: FontWeight.w600),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        subtitle: Text('ID: ${todo.id} • User: ${todo.userId}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () => provider.toggleFavorite(todo.id),
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: Icon(
                    provider.isFavorite(todo.id)
                        ? Icons.star
                        : Icons.star_border,
                    key: ValueKey(provider.isFavorite(todo.id)),
                    color: provider.isFavorite(todo.id)
                        ? Colors.amber
                        : Colors.grey,
                  ),
                ),
              ),
            ),

            SizedBox(
              width: 65,
              child: Text(
                todo.completed ? 'Completed' : 'Pending',
                style: TextStyle(
                  color: todo.completed
                      ? AppColors.completedGreen
                      : AppColors.pendingOrange,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
