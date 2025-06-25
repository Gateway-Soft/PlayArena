import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';



// 🚀 Screens
import ' providers/auth_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/user_or_owner_selection_screen.dart';

import 'screens/users/user_login_screen.dart';
import 'screens/users/user_signup_screen.dart';
import 'screens/users/user_home_screen.dart';

import 'screens/owners/owner_login_screen.dart';
import 'screens/owners/owner_signup_screen.dart';
import 'screens/owners/owner_dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppAuthProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'PlayArena',
        theme: ThemeData(primarySwatch: Colors.indigo),
        home: const SplashScreen(),
        routes: {
          '/select-role': (context) => const UserOrOwnerSelectionScreen(),
          '/user/login': (context) => const UserLoginScreen(),
          '/user/signup': (context) => const UserSignUpScreen(),
          '/owner/login': (context) => const OwnerLoginScreen(),
          '/owner/signup': (context) => const OwnerSignUpScreen(),
          '/user/home': (context) => const UserHomeScreen(),
          '/owner/dashboard': (context) => const OwnerDashboardScreen(),
        },
      )
      ,
    );
  }
}
