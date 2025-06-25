import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:playarena/theme/theme_config.dart';
import 'package:playarena/theme/theme_provider.dart';
import 'package:provider/provider.dart';

import ' providers/auth_provider.dart';
import ' providers/owner_provider.dart';
import ' providers/user_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/user_or_owner_selection_screen.dart';

import 'screens/users/user_login_screen.dart';
import 'screens/users/user_signup_screen.dart';
import 'screens/users/user_home_screen.dart';
import 'screens/users/user_profile_screen.dart';

import 'screens/owners/owner_login_screen.dart';
import 'screens/owners/owner_signup_screen.dart';
import 'screens/owners/owner_dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppAuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AppAuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => OwnerProvider()),// ✅ Added for Theme Switch
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PlayArena',

      theme: lightTheme,            // ✅ Light theme
      darkTheme: darkTheme,         // ✅ Dark theme
      themeMode: themeProvider.currentTheme, // ✅ Follow theme provider

      home: const SplashScreen(),   // ✅ Initial screen

      // ✅ Named Routes
      routes: {
        '/select-role': (context) => const UserOrOwnerSelectionScreen(),

        '/user/login': (context) => const UserLoginScreen(),
        '/user/signup': (context) => const UserSignUpScreen(),
        '/user/home': (context) => const UserHomeScreen(),
        '/user/profile': (context) => const UserProfileScreen(),
        '/owner/login': (context) => const OwnerLoginScreen(),
        '/owner/signup': (context) => const OwnerSignUpScreen(),
        '/owner/dashboard': (context) => const OwnerDashboardScreen(),
      },
    );
  }
}
