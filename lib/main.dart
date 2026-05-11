import 'package:flutter/material.dart';
import 'package:gestion_gastos/screens/summary_screen.dart';
import 'package:gestion_gastos/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestion de Gastos',
      theme: AppTheme.lightTheme,
      home: Scaffold(
        body: const SummaryScreen(),
      )
    );
  }
}
