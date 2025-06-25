// app_logo.dart
import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size;
  const AppLogo({super.key, this.size = 100});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/PlayArena splash screen logo.jpg',
      height: size,
    );
  }
}
