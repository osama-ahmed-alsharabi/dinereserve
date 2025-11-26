import 'package:dinereserve/core/helpers/service_locator.dart';
import 'package:dinereserve/core/router/app_router.dart';
import 'package:dinereserve/core/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://aqvagkphjqcdqnrpvebu.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFxdmFna3BoanFjZHFucnB2ZWJ1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM4NDMzMjAsImV4cCI6MjA3OTQxOTMyMH0.coGyz5okv_PbJH01lDSb10tqcRbUKz_wYeNas_M9eCI',
  );
  await setupServiceLocator();
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
