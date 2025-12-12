import 'package:flutter/material.dart';
import '../services/favorites_service.dart';
import '../models/meal.dart';
import 'meal_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  final favoritesService = FavoritesService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Омилени рецепти")),
      body: StreamBuilder<List<Meal>>(
        stream: favoritesService.getFavorites(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final meals = snapshot.data!;
          if (meals.isEmpty) return Center(child: Text("Нема омилени рецепти."));

          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.8,
            ),
            itemCount: meals.length,
            itemBuilder: (context, index) {
              final meal = meals[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => MealDetailScreen(mealId: meal.id)),
                  );
                },
                child: Card(
                  child: Column(
                    children: [
                      Image.network(
                        meal.thumbnail,
                        height: 100,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          meal.name,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
