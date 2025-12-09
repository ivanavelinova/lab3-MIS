import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../widgets/recipe_card.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Recipe> recipes;
  final void Function(Recipe) toggleFavorite;

  const FavoritesScreen({
    Key? key,
    required this.recipes,
    required this.toggleFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favoriteRecipes = recipes.where((r) => r.isFavorite).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Омилени рецепти")),
      body: favoriteRecipes.isEmpty
          ? const Center(child: Text("Сè уште нема омилени рецепти"))
          : ListView.builder(
        itemCount: favoriteRecipes.length,
        itemBuilder: (context, index) {
          final recipe = favoriteRecipes[index];
          return RecipeCard(
            recipe: recipe,
            onFavoriteToggle: toggleFavorite,
          );
        },
      ),
    );
  }
}
