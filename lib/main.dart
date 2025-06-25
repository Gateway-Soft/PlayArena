import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import ' providers/auth_provider.dart';
import 'firebase_options.dart';
import 'theme/theme_config.dart';
import 'utils/app_routes.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const PlayArenaApp());
}

class PlayArenaApp extends StatelessWidget {
  const PlayArenaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthProvider>(
      create: (_) => AuthProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'PlayArena',
        theme: AppThemeConfig.lightTheme,
        initialRoute: '/',
        routes: AppRoutes.routes,
      ),
    );
  }
}
