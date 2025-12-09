import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/recipe.dart';

class FirebaseService {
  static final _db = FirebaseFirestore.instance;

  static Future<void> updateFavorite(Recipe recipe) async {
    await _db.collection('favorites').doc(recipe.id).set({
      'id': recipe.id,
      'title': recipe.title,
      'imageUrl': recipe.imageUrl,
      'isFavorite': recipe.isFavorite,
    });
  }
}
