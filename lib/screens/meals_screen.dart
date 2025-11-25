import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/api_service.dart';
import 'meal_detail_screen.dart';

class MealsScreen extends StatefulWidget {
  final String category;

  const MealsScreen({required this.category});

  @override
  _MealsScreenState createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  final ApiService apiService = ApiService();
  List<Meal> meals = [];
  List<Meal> filteredMeals = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMeals();
  }

  void fetchMeals() async {
    try {
      final data = await apiService.getMealsByCategory(widget.category);
      setState(() {
        meals = data;
        filteredMeals = data;
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  void filterMeals(String query) async {
    if (query.isEmpty) {
      setState(() {
        filteredMeals = meals;
      });
      return;
    }

    try {
      final data = await apiService.searchMeals(query);
      setState(() {
        filteredMeals = data
            .where((meal) =>
                meal.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search meals...',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: filterMeals,
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: filteredMeals.length,
                    itemBuilder: (context, index) {
                      final meal = filteredMeals[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  MealDetailScreen(mealId: meal.id),
                            ),
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
                  ),
                ),
              ],
            ),
    );
  }
}
