import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/recipe.dart';
import '../services/api_service.dart';
import '../widgets/category_card.dart';
import 'meals_screen.dart';
import 'favorites_screen.dart';

class CategoriesScreen extends StatefulWidget {
  final List<Recipe> recipes;
  final void Function(Recipe) toggleFavorite;

  const CategoriesScreen({
    Key? key,
    required this.recipes,
    required this.toggleFavorite,
  }) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  late Future<List<Category>> _future;
  List<Category> _all = [];
  List<Category> _filtered = [];
  final _ctrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _future = ApiService.fetchCategories();
    _future.then((value) {
      setState(() {
        _all = value;
        _filtered = value;
      });
    }).catchError((e) {
      // handle error
    });
  }

  void _search(String q) {
    setState(() {
      _filtered = q.trim().isEmpty
          ? _all
          : _all.where((c) => c.name.toLowerCase().contains(q.toLowerCase())).toList();
    });
  }

  void _openCategory(Category cat) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MealsScreen(
          categoryName: cat.name,
          recipes: widget.recipes.where((r) => r.category == cat.name).toList(),
          toggleFavorite: widget.toggleFavorite,
        ),
      ),
    );
  }

  void _openFavorites() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FavoritesScreen(recipes: widget.recipes, toggleFavorite: (Recipe p1) {  },),
      ),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Категории'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            tooltip: 'Омилени рецепти',
            onPressed: _openFavorites,
          ),
        ],
      ),
      body: FutureBuilder<List<Category>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Грешка: ${snapshot.error}'));
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _ctrl,
                  decoration: const InputDecoration(
                    labelText: 'Пребарај категории',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: _search,
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: _filtered.length,
                  itemBuilder: (context, index) {
                    final cat = _filtered[index];
                    return GestureDetector(
                      onTap: () => _openCategory(cat),
                      child: CategoryCard(category: cat),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
