import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hacathon_2026/controller/add_expresscontroller.dart';
import 'package:hacathon_2026/controller/dashbord_controller.dart';
import 'package:hacathon_2026/controller/signup_signin_controller.dart';
import 'package:hacathon_2026/firebase_options.dart';
import 'package:hacathon_2026/screen/authcheck/authcheck.dart';
import 'package:hacathon_2026/screen/login%20screnn/login_screen.dart';
import 'package:hacathon_2026/screen/profileScreen/profile_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        // Jokhoni OnboardingProvider uncomment korben, theek evabe likhben (without child)
        // ChangeNotifierProvider(create: (_) => OnboardingProvider()),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
          // Ekhane 'child' hobe na!
        ),
        ChangeNotifierProvider(
          create: (_) => ExpenseProvider(),
          // Ekhane 'child' hobe na!
        ),
        ChangeNotifierProvider(create: (_) => GoalProvider()),
      ],
      // MultiProvider er main child hobe apnar puro app (MyApp)
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
          title: 'Flutter Demo',
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
          home: const AuthChecker(), // const add kora hoyeche
        );
      },
    );
  }
}
