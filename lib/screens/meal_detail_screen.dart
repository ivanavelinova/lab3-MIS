import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/meal_detail.dart';
import '../services/api_service.dart';
import '../models/meal_summary.dart';

class MealDetailScreen extends StatefulWidget {
  final String mealId;
  final MealSummary? preloaded;      // Кога се отвора од list/grid
  final MealDetail? preloadedDetail; // Кога имаме рандом или детал

  const MealDetailScreen({super.key, required this.mealId, this.preloaded, this.preloadedDetail});

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  late Future<MealDetail> _future;

  @override
  void initState() {
    super.initState();
    if (widget.preloadedDetail != null) {
      _future = Future.value(widget.preloadedDetail!);
    } else {
      _future = ApiService.fetchMealDetail(widget.mealId);
    }
  }

  Future<void> _openYoutube(String url) async {
    if (url.isEmpty) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Не можам да отворaм YouTube')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.preloaded?.name ?? 'Рецепт'),
      ),
      body: FutureBuilder<MealDetail>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) return Center(child: Text('Грешка: ${snapshot.error}'));

          final m = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (m.thumbnail.isNotEmpty)
                  Center(child: Image.network(m.thumbnail, height: 220, fit: BoxFit.cover)),
                const SizedBox(height: 8),
                Text(m.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text('${m.category} • ${m.area}'),
                const SizedBox(height: 12),
                const Text('Инструкции', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(m.instructions),
                const SizedBox(height: 12),
                const Text('Состојки', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                ...m.ingredients.entries.map((e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text('${e.key} — ${e.value}'),
                )),
                const SizedBox(height: 12),
                if (m.youtube.isNotEmpty)
                  ElevatedButton.icon(
                    onPressed: () => _openYoutube(m.youtube),
                    icon: const Icon(Icons.youtube_searched_for),
                    label: const Text('Отвори на YouTube'),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
