import 'package:dinereserve/core/router/app_router.dart';
import 'package:dinereserve/core/theme/light_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Dinereserve());
}

class Dinereserve extends StatelessWidget {
  const Dinereserve({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: light(),
      routerConfig: AppRouter.router,
    );
  }
}
