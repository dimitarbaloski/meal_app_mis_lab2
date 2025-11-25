import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/meal_detail.dart';
import 'package:url_launcher/url_launcher.dart';

class MealDetailScreen extends StatefulWidget {
  final String mealId;

  const MealDetailScreen({required this.mealId});

  @override
  _MealDetailScreenState createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  final ApiService apiService = ApiService();
  MealDetail? meal;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMealDetail();
  }

  void fetchMealDetail() async {
    try {
      final data = await apiService.getMealDetail(widget.mealId);
      setState(() {
        meal = data;
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(meal?.name ?? 'Loading...'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(meal!.thumbnail),
                  SizedBox(height: 16),
                  Text(
                    meal!.name,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Instructions:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(meal!.instructions),
                  SizedBox(height: 16),
                  Text(
                    'Ingredients:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ...meal!.ingredients.entries.map((e) => Text('${e.key} - ${e.value}')),
                  SizedBox(height: 16),
                  if (meal!.youtube.isNotEmpty)
                    ElevatedButton(
                      onPressed: () {
                        launchUrl(Uri.parse(meal!.youtube));
                      },
                      child: Text('Watch on YouTube'),
                    ),
                ],
              ),
            ),
    );
  }
}
