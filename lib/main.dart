import 'package:flutter/material.dart';
import 'package:nvcti/presentation/common/theme.dart';
import 'package:nvcti/presentation/screens/register_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: RegisterScreen(),
    );
  }
}
