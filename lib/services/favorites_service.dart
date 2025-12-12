import 'package:shared_preferences/shared_preferences.dart';
import '../models/meal.dart';

class FavoritesService {
  static const String key = "favorites_list";

  Future<List<String>> _getStoredIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key) ?? [];
  }

  Future<void> addFavorite(Meal meal) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> ids = await _getStoredIds();

    if (!ids.contains(meal.id)) {
      ids.add(meal.id);
      await prefs.setStringList(key, ids);

      // Optional: Save meal data too if needed later
      await prefs.setString("meal_${meal.id}_name", meal.name);
      await prefs.setString("meal_${meal.id}_thumb", meal.thumbnail);
    }
  }

  Future<void> removeFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> ids = await _getStoredIds();

    ids.remove(id);
    await prefs.setStringList(key, ids);

    // Remove meal data
    prefs.remove("meal_${id}_name");
    prefs.remove("meal_${id}_thumb");
  }

  Future<bool> isFavorite(String id) async {
    List<String> ids = await _getStoredIds();
    return ids.contains(id);
  }

  Stream<List<Meal>> getFavorites() async* {
    final prefs = await SharedPreferences.getInstance();
    yield* Stream.periodic(const Duration(milliseconds: 300), (_) {
      List<String> ids = prefs.getStringList(key) ?? [];

      return ids.map((id) {
        return Meal(
          id: id,
          name: prefs.getString("meal_${id}_name") ?? "",
          thumbnail: prefs.getString("meal_${id}_thumb") ?? "",
        );
      }).toList();
    });
  }
}
