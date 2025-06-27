import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:playarena/theme/theme_config.dart';
import 'package:playarena/theme/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart'; // ✅ NEW
import ' providers/auth_provider.dart';
import ' providers/locale_provider.dart';
import ' providers/owner_provider.dart';
import ' providers/user_provider.dart';
import 'l10n/app_localizations.dart';
import 'screens/splash_screen.dart';
import 'screens/user_or_owner_selection_screen.dart';
import 'screens/users/user_login_screen.dart';
import 'screens/users/user_signup_screen.dart';
import 'screens/users/user_home_screen.dart';
import 'screens/users/user_profile_screen.dart';
import 'screens/users/my_bookings_screen.dart';
import 'screens/users/user_settings_screen.dart';
import 'screens/owners/owner_login_screen.dart';
import 'screens/owners/owner_signup_screen.dart';
import 'screens/owners/owner_dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // ✅ Preload SharedPreferences so we can decide initial route
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  final loggedRole = prefs.getString('loggedRole'); // 'user' or 'owner'

  // ✅ Decide which screen to start with
  Widget initialScreen = const SplashScreen();
  if (isLoggedIn) {
    if (loggedRole == 'user') {
      initialScreen = const UserHomeScreen();
    } else if (loggedRole == 'owner') {
      initialScreen = const OwnerDashboardScreen();
    }
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppAuthProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => OwnerProvider()),
      ],
      child: MyApp(initialScreen: initialScreen), // ✅ Pass down
    ),
  );
}

class MyApp extends StatelessWidget {
  final Widget initialScreen;
  const MyApp({super.key, required this.initialScreen}); // ✅ Receive initial screen

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PlayArena',

      // 🔥 Theme
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeProvider.currentTheme,

      // 🌍 Localization
      locale: localeProvider.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,

      // ✅ Start from the appropriate screen
      home: initialScreen,

      routes: {
        '/select-role': (context) => const UserOrOwnerSelectionScreen(),
        '/user/bookings': (context) => const UserBookingScreen(),
        '/user/settings': (context) => const UserSettingsScreen(),
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
