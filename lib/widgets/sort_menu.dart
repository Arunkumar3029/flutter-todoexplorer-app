import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';

class SortMenu extends StatelessWidget {
  const SortMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<SortType>(
      icon: const Icon(Icons.sort),
      onSelected: (value) {
        context.read<TodoProvider>().setSort(value);
      },
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: SortType.az,
          child: Text("Title A → Z"),
        ),
        PopupMenuItem(
          value: SortType.za,
          child: Text("Title Z → A"),
        ),
        PopupMenuItem(
          value: SortType.completedFirst,
          child: Text("Completed First"),
        ),
        PopupMenuItem(
          value: SortType.incompleteFirst,
          child: Text("Incomplete First"),
        ),
      ],
    );
  }
}