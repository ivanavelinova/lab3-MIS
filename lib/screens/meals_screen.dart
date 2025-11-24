import 'package:flutter/material.dart';
import '../models/meal_summary.dart';
import '../services/api_service.dart';
import '../widgets/meal_card.dart';
import 'meal_detail_screen.dart';
import '../models/meal_detail.dart';

class MealsScreen extends StatefulWidget {
  final String categoryName;
  final MealDetail? initialRandomMeal;

  const MealsScreen({super.key, required this.categoryName, this.initialRandomMeal});

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  late Future<List<MealSummary>> _future;
  List<MealSummary> _all = [];
  List<MealSummary> _filtered = [];
  final _ctrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Ако имаме рандом MealDetail, отвориме детал веднаш
    if (widget.initialRandomMeal != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MealDetailScreen(
              mealId: widget.initialRandomMeal!.id,
              preloadedDetail: widget.initialRandomMeal, // ✅ исправено
            ),
          ),
        );
      });
    }

    _future = ApiService.fetchMealsByCategory(widget.categoryName);
    _future.then((value) {
      setState(() {
        _all = value;
        _filtered = value;
      });
    }).catchError((e) {});
  }

  void _search(String q) async {
    if (q.trim().isEmpty) {
      setState(() => _filtered = _all);
      return;
    }
    try {
      final results = await ApiService.searchMeals(q);
      setState(() => _filtered = results.where((m) => m.name.toLowerCase().contains(q.toLowerCase())).toList());
    } catch (_) {
      setState(() => _filtered = []);
    }
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
        title: Text(widget.categoryName),
      ),
      body: FutureBuilder<List<MealSummary>>(
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
                    labelText: 'Пребарај јадења',
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
                    childAspectRatio: 0.9,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: _filtered.length,
                  itemBuilder: (context, index) {
                    final m = _filtered[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MealDetailScreen(mealId: m.id, preloaded: m),
                          ),
                        );
                      },
                      child: MealCard(meal: m),
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
