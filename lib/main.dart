import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:loyalties/screens/loyalties.dart';

final theme = ThemeData().copyWith(
  scaffoldBackgroundColor: Colors.deepPurple,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: Colors.pinkAccent,
  ),
  textTheme: GoogleFonts.robotoTextTheme(),
);

void main() {
  runApp(const ProviderScope(child: App()));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loyalties',
      theme: theme,
      home: const LoyaltiesScreen(),
    );
  }
}
