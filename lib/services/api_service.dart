import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/meal.dart';
import '../models/meal_detail.dart';

class ApiService {
  final String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  Future<List<Category>> getCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/categories.php'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List categoriesJson = data['categories'];
      return categoriesJson.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<Meal>> getMealsByCategory(String category) async {
  final response = await http.get(
      Uri.parse('$baseUrl/filter.php?c=$category'));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    List mealsJson = data['meals'];
    return mealsJson.map((json) => Meal.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load meals');
  }
}

// Пребарување јадења во категорија (или глобално)
Future<List<Meal>> searchMeals(String query) async {
  final response =
      await http.get(Uri.parse('$baseUrl/search.php?s=$query'));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    List? mealsJson = data['meals'];
    if (mealsJson != null) {
      return mealsJson.map((json) => Meal.fromJson(json)).toList();
    } else {
      return [];
    }
  } else {
    throw Exception('Failed to search meals');
  }
}

// Детален рецепт
Future<MealDetail> getMealDetail(String id) async {
  final response =
      await http.get(Uri.parse('$baseUrl/lookup.php?i=$id'));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return MealDetail.fromJson(data['meals'][0]);
  } else {
    throw Exception('Failed to load meal detail');
  }
}

// Рандом рецепт
Future<MealDetail> getRandomMeal() async {
  final response = await http.get(Uri.parse('$baseUrl/random.php'));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return MealDetail.fromJson(data['meals'][0]);
  } else {
    throw Exception('Failed to load random meal');
  }
}

}
