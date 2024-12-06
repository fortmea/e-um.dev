import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:mercury/controller/authcontroller.dart';
import 'package:mercury/controller/themecontroller.dart';
import 'package:mercury/util/router.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  await Supabase.initialize(
    url: 'https://tjjlopeifkrzsmzmwjix.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRqamxvcGVpZmtyenNtem13aml4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzMzMjMzNzgsImV4cCI6MjA0ODg5OTM3OH0.xwk-KCuRY2z5J5kfJSc5JczhUY0YTrWNCq2Qr3O4mlE',
  );
  Get.put<FThemeData>(FThemes.zinc.dark);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp.router(
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        Get.put<ScaffoldMessengerState>(ScaffoldMessenger.of(context));
        Get.put<AuthController>(AuthController());
        Get.put<ThemeController>(
            ThemeController()); // Inicialize o ThemeController.
        return Obx(() {
          final themeController = Get.find<ThemeController>();
          return FTheme(
            data: themeController.themeData,
            child: child ?? Text("WTF"),
          );
        });
      },
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      routeInformationProvider: router.routeInformationProvider,
    );
  }
}
