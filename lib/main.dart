import 'package:flutter/material.dart';
import 'package:insuranceapp/constants/colors.dart';
import 'package:insuranceapp/views/splash/splashscreen.dart';
import 'package:insuranceapp/views/authentication/login_screen.dart';
import 'package:insuranceapp/views/vehicles/add_vehicle.dart';
import 'package:insuranceapp/views/policies/add_policy.dart';
import 'package:insuranceapp/views/claims/claim_form.dart';
import 'package:insuranceapp/views/marketplace/marketplace.dart';
import 'package:insuranceapp/services/supabase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await SupabaseConfig.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Insurance App',
      theme: ThemeData(scaffoldBackgroundColor: AppColors.bgColor),
      home: SplashScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/add-vehicle': (context) => const AddVehiclePage(),
        '/add-policy': (context) => const AddPolicyPage(),
        '/claim-form': (context) => const ClaimFormPage(),
        '/marketplace': (context) => const MarketplacePage(),
      },
    );
  }
}
