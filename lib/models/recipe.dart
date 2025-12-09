class Recipe {
  final String id;
  final String title;
  final String imageUrl;
  final String category;
  bool isFavorite;

  Recipe({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.category,
    this.isFavorite = false,
  });
}
