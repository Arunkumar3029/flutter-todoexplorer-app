import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todos_explorer/widgets/animate_todocard.dart';
import '../providers/todo_provider.dart';
import '../widgets/search_bar.dart';
import '../widgets/filter_chips.dart';
import '../widgets/sort_menu.dart';
import '../widgets/todo_card.dart';
import 'favorite_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TodoProvider>().fetchTodos();
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 300) {
        context.read<TodoProvider>().loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TodoProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos Explorer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.star, color: Colors.amber),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoriteScreen()),
              );
            },
          ),
          const SortMenu(),
        ],
      ),
      body: Column(
        children: [
          const Padding(padding: EdgeInsets.all(8.0), child: SearchBarWidget()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.filter_list_alt,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Search as Filter",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                Transform.scale(
                  scale: 0.75,
                  child: Switch(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    activeColor: Colors.blue[700],
                    value: provider.isSearchFilterMode,
                    onChanged: (value) {
                      provider.toggleSearchMode(value);
                    },
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: FilterChips(),
          ),
          Expanded(child: TodoListView(scrollController: _scrollController)),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 56,
          alignment: Alignment.center,
          child: Text(
            "Showing ${provider.todos.length} of ${provider.totalCount} todos",
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}

class TodoListView extends StatelessWidget {
  final ScrollController scrollController;

  const TodoListView({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TodoProvider>();

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.todos.isEmpty) {
      return const Center(child: Text("No todos found"));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        int crossAxisCount = constraints.maxWidth ~/ 350;
        if (crossAxisCount < 2) crossAxisCount = 2;

        return RefreshIndicator(
          onRefresh: () => context.read<TodoProvider>().fetchTodos(),
          child: CustomScrollView(
            controller: scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              if (isMobile)
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final todo = provider.todos[index];
                    return AnimatedTodoCard(
                      index: index,
                      child: TodoCard(todo: todo),
                    );
                  }, childCount: provider.todos.length),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.all(12),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 3.2,
                    ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final todo = provider.todos[index];
                      return AnimatedTodoCard(
                        index: index,
                        child: TodoCard(todo: todo),
                      );
                    }, childCount: provider.todos.length),
                  ),
                ),

              if (provider.hasMore)
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 32.0),
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    ),
                  ),
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 20)),
            ],
          ),
        );
      },
    );
  }
}
