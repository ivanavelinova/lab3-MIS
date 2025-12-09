import 'package:flutter/material.dart';
import '../models/recipe.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final void Function(Recipe) onFavoriteToggle;

  const RecipeCard({
    Key? key,
    required this.recipe,
    required this.onFavoriteToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(recipe.imageUrl, width: 50, fit: BoxFit.cover),
        title: Text(recipe.title),
        trailing: IconButton(
          icon: Icon(
            recipe.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: Colors.red,
          ),
          onPressed: () => onFavoriteToggle(recipe),
        ),
      ),
    );
  }
}
