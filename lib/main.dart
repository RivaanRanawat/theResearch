import 'package:flutter/material.dart';
import 'package:research/router.dart';
import 'package:research/theme/pallete.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Pallete.primaryColor,
        ),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
