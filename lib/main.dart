import 'package:dinereserve/core/theme/light_theme.dart';
import 'package:dinereserve/feature/splash/presentation/view/splash_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Dinereserve());
}

class Dinereserve extends StatelessWidget {
  const Dinereserve({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: light(),
      home: SplashView(),
    );
  }
}
