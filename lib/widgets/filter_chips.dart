import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';

class FilterChips extends StatelessWidget {
  const FilterChips({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TodoProvider>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildElegantChip(
            label: "All",
            isSelected: provider.currentFilter == FilterType.all,
            onTap: () => provider.setFilter(FilterType.all),
          ),
          _buildElegantChip(
            label: "Completed",
            isSelected: provider.currentFilter == FilterType.completed,
            onTap: () => provider.setFilter(FilterType.completed),
          ),
          _buildElegantChip(
            label: "Pending",
            isSelected: provider.currentFilter == FilterType.pending,
            onTap: () => provider.setFilter(FilterType.pending),
          ),
        ],
      ),
    );
  }

  Widget _buildElegantChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.blue[700] : Colors.grey[600],
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height: 3,
            width: isSelected ? 30 : 0,
            decoration: BoxDecoration(
              color: Colors.blue[700],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}