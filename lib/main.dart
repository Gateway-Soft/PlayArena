import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 🎨 Theme
import ' providers/auth_provider.dart';
import ' providers/locale_provider.dart';
import ' providers/owner_provider.dart';
import ' providers/user_provider.dart';
import 'theme/theme_config.dart';
import 'theme/theme_provider.dart';

// 🌐 Localization
import 'l10n/app_localizations.dart';

// 🔰 Core Screens
import 'screens/splash_screen.dart';
import 'screens/user_or_owner_selection_screen.dart';
import 'screens/about_app_screen.dart';
import 'screens/forgot_password_screen.dart';

// 👤 User Screens
import 'screens/users/user_login_screen.dart';
import 'screens/users/user_signup_screen.dart';
import 'screens/users/user_home_screen.dart';
import 'screens/users/user_profile_screen.dart';
import 'screens/users/user_settings_screen.dart';
import 'screens/users/my_bookings_screen.dart';

// 🧑‍💼 Owner Screens
import 'screens/owners/owner_login_screen.dart';
import 'screens/owners/owner_signup_screen.dart';
import 'screens/owners/owner_home_screen.dart';
import 'screens/owners/owner_profile_screen.dart';
import 'screens/owners/owner_settings_screen.dart';
import 'screens/owners/owner_dashboard_screen.dart';
import 'screens/owners/add_turf_screen.dart';
import 'screens/owners/edit_turf_screen.dart';
import 'screens/owners/my_turf_list_screen.dart';
import 'screens/owners/slot_management_screen.dart';
import 'screens/owners/view_bookings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final prefs = await SharedPreferences.getInstance();
  final role = prefs.getString('user_role'); // For future role-based routing

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppAuthProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => OwnerProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Widget? initialScreen;
  const MyApp({super.key, this.initialScreen});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PlayArena',

      // 🎨 Themes
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeProvider.currentTheme,

      // 🌍 Localization
      locale: localeProvider.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,

      // 🏁 Entry screen
      home: initialScreen ?? const SplashScreen(),

      // 🧭 Routes
      routes: {
        // 🌐 Core
        '/splash': (context) => const SplashScreen(),
        '/select-role': (context) => const UserOrOwnerSelectionScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/about': (context) => const AboutAppScreen(),

        // 👤 User
        '/user/login': (context) => const UserLoginScreen(),
        '/login': (context) => const UserLoginScreen(),
        '/user/signup': (context) => const UserSignUpScreen(),
        '/user/home': (context) => const UserHomeScreen(),
        '/user/profile': (context) => const UserProfileScreen(),
        '/user/settings': (context) => const UserSettingsScreen(),
        '/user/bookings': (context) => const UserBookingScreen(),

        // 🧑‍💼 Owner
        '/owner/login': (context) => const OwnerLoginScreen(),
        '/owner/signup': (context) => const OwnerSignUpScreen(),
        '/owner/home': (context) => const OwnerHomeScreen(),
        '/owner/profile': (context) => const OwnerProfileScreen(),
        '/owner/settings': (context) => const OwnerSettingsScreen(),
        '/owner/dashboard': (context) => const OwnerDashboardScreen(),
        '/owner/add-turf': (context) => const AddTurfScreen(),
        '/owner/edit-turf': (context) => const EditTurfScreen(turfId: ''),
        '/owner/my-turf-list': (context) => const MyTurfListScreen(),
        '/owner/slot-management': (context) => const SlotManagementScreen(turfId: '',),
        '/owner/view-bookings': (context) => const ViewBookingsScreen(turfId: '',),
      },
    );
  }
}