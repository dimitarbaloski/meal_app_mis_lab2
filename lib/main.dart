import 'package:flutter/material.dart';
import 'screens/categories_screen.dart';
import 'screens/meal_detail_screen.dart';
import 'services/api_service.dart';
import 'services/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:timezone/data/latest_all.dart' as tzdata; // for initialization
import 'package:timezone/timezone.dart' as tz;             // for TZDateTime

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize timezone data
  tzdata.initializeTimeZones();

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recipe App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NotificationService notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    initNotifications();
  }

  Future<void> initNotifications() async {
  await notificationService.init();

  try {
    // Get a random meal from your ApiService
    final randomMeal = await ApiService().getRandomMeal();

    // Show notification immediately
    await notificationService.showRandomRecipeNotification(randomMeal.name);

    print('Notification sent for recipe: ${randomMeal.name}');
  } catch (e) {
    print('Failed to show notification: $e');
  }
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Categories'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: 200,
              height: 60,
              child: ElevatedButton.icon(
                label: const Text(
                  'Random Meal',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () async {
                  try {
                    final randomMeal = await ApiService().getRandomMeal();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            MealDetailScreen(mealId: randomMeal.id),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Failed to load random meal'),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
           Expanded(
            child: CategoriesScreen(),
          ),
        ],
      ),
    );
  }
}
