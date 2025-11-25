import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/category_card.dart';
import '../models/category.dart';
import 'meals_screen.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final ApiService apiService = ApiService();
  List<Category> categories = [];
  List<Category> filteredCategories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  void fetchCategories() async {
    try {
      final data = await apiService.getCategories();
      setState(() {
        categories = data;
        filteredCategories = data;
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  void filterCategories(String query) {
    final filtered = categories
        .where((category) =>
            category.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      filteredCategories = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search categories...',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: filterCategories,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredCategories.length,
                    itemBuilder: (context, index) {
                      final category = filteredCategories[index];
                      return CategoryCard(
                        category: category,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MealsScreen(category: category.name),
                            ),
                          );
                        }
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
