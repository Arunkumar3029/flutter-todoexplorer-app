import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        textAlignVertical: TextAlignVertical.center,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: "Search todos...",
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
          prefixIcon: Icon(Icons.search, color: Colors.blue[600], size: 22),
          suffixIcon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: _controller.text.isNotEmpty
                ? IconButton(
                    key: const ValueKey('clear_button'),
                    icon: Icon(Icons.cancel, color: Colors.grey[400], size: 20),
                    onPressed: () {
                      _controller.clear();
                      context.read<TodoProvider>().setSearch('');
                      setState(() {});
                    },
                  )
                : const SizedBox.shrink(key: ValueKey('no_button')),
          ),

          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        onChanged: (value) {
          context.read<TodoProvider>().setSearch(value);
          setState(() {}); // update clear icon visibility
        },
      ),
    );
  }
}