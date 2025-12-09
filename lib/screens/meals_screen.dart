import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../widgets/recipe_card.dart';

class MealsScreen extends StatelessWidget {
  final String categoryName;
  final List<Recipe> recipes;
  final void Function(Recipe) toggleFavorite;

  const MealsScreen({
    Key? key,
    required this.categoryName,
    required this.recipes,
    required this.toggleFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(categoryName)),
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (ctx, index) {
          final recipe = recipes[index];
          return RecipeCard(
            recipe: recipe,
            onFavoriteToggle: toggleFavorite, // ова го поврзуваме
          );
        },
      ),
    );
  }
}
