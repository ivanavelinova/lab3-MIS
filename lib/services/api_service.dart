import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/meal_summary.dart';
import '../models/meal_detail.dart';

class ApiService {
  static const _base = 'https://www.themealdb.com/api/json/v1/1';

  static Future<List<Category>> fetchCategories() async {
    final url = Uri.parse('$_base/categories.php');
    final resp = await http.get(url);
    if (resp.statusCode != 200) throw Exception('HTTP ${resp.statusCode}');
    final jsonBody = json.decode(resp.body);
    final List list = jsonBody['categories'] ?? [];
    return list.map((e) => Category.fromJson(e)).toList();
  }

  static Future<List<MealSummary>> fetchMealsByCategory(String category) async {
    final url = Uri.parse('$_base/filter.php?c=${Uri.encodeComponent(category)}');
    final resp = await http.get(url);
    if (resp.statusCode != 200) throw Exception('HTTP ${resp.statusCode}');
    final jsonBody = json.decode(resp.body);
    final List list = jsonBody['meals'] ?? [];
    return list.map((e) => MealSummary.fromJson(e)).toList();
  }

  static Future<List<MealSummary>> searchMeals(String query) async {
    final url = Uri.parse('$_base/search.php?s=${Uri.encodeComponent(query)}');
    final resp = await http.get(url);
    if (resp.statusCode != 200) throw Exception('HTTP ${resp.statusCode}');
    final jsonBody = json.decode(resp.body);
    final List list = jsonBody['meals'] ?? [];
    return list.map((e) => MealSummary.fromJson(e)).toList();
  }

  static Future<MealDetail> fetchMealDetail(String id) async {
    final url = Uri.parse('$_base/lookup.php?i=${Uri.encodeComponent(id)}');
    final resp = await http.get(url);
    if (resp.statusCode != 200) throw Exception('HTTP ${resp.statusCode}');
    final jsonBody = json.decode(resp.body);
    final List list = jsonBody['meals'] ?? [];
    if (list.isEmpty) throw Exception('Meal not found');
    return MealDetail.fromJson(list[0]);
  }

  static Future<MealDetail> fetchRandomMeal() async {
    final url = Uri.parse('$_base/random.php');
    final resp = await http.get(url);
    if (resp.statusCode != 200) throw Exception('HTTP ${resp.statusCode}');
    final jsonBody = json.decode(resp.body);
    final List list = jsonBody['meals'] ?? [];
    if (list.isEmpty) throw Exception('No random meal');
    return MealDetail.fromJson(list[0]);
  }
}
