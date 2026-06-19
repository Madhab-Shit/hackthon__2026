import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:hacathon_2026/controller/add_expresscontroller.dart';
import 'package:hacathon_2026/controller/dashbord_controller.dart';
import 'package:hacathon_2026/controller/emergency_mode_provider.dart';
import 'package:hacathon_2026/controller/expenses_list_controller.dart';
import 'package:hacathon_2026/controller/goal_provider.dart';
import 'package:hacathon_2026/controller/expense_provider.dart';
import 'package:hacathon_2026/controller/signup_signin_controller.dart';
import 'package:hacathon_2026/firebase_options.dart';
import 'package:hacathon_2026/screen/splashScreen/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ExpenseProvider()),
        ChangeNotifierProvider(create: (_) => GolesProvider()),
        ChangeNotifierProvider(create: (_) => GoalProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => ExpensesListProvider()),
        ChangeNotifierProvider(create: (_) => EmergencyModeProvider()..load()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, value, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Green Track',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepOrange,
              primary: const Color(0xFFFF7043),
              secondary: const Color(0xFFFFA726),
            ),
            scaffoldBackgroundColor: const Color(0xFFF9F9F9),
            fontFamily: 'Roboto',
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF7043),
                foregroundColor: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // SplashScreen ekhane call hobe
          home: const SplashScreen(),
        );
      },
    );
  }
}
