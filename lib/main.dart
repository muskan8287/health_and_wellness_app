import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import "dart:async";
import 'login.dart';
import 'HomePage.dart';
import 'signup.dart';
import 'appointments.dart';
import 'medication.dart';
import 'Fitness_Page.dart';
import 'sleep.dart';
import 'water_remainder.dart';
import 'nutrition_screen.dart';
import 'fitness.dart';// Import the login page

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print("Error initializing Firebase: $e");
  }
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: 'Health App',
      initialRoute: '/login', // Set the initial route
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/home': (context) => const HomePage(),
        '/appointment': (context) => AppointmentsPage(),
        '/medication': (context) => MedicationAlarmScreen(),
        '/FitnessPage': (context) => FitnessPage(),
        '/sleep': (context) => SleepPage(),
        '/fitness': (context) => FitnessScreen(),
        '/water': (context) => WaterReminder(),
        '/nutrition': (context) => RecipeScreen(),
      },
    );
  }
}


