import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:mercury/controller/authcontroller.dart';
import 'package:mercury/controller/localecontroller.dart';
import 'package:mercury/controller/overlaycontroller.dart';
import 'package:mercury/controller/storagecontroller.dart';
import 'package:mercury/controller/themecontroller.dart';
import 'package:mercury/helper/sharedpreferences.dart';
import 'package:mercury/util/router.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:localization/localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  await Supabase.initialize(
    url: 'https://tjjlopeifkrzsmzmwjix.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRqamxvcGVpZmtyenNtem13aml4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzMzMjMzNzgsImV4cCI6MjA0ODg5OTM3OH0.xwk-KCuRY2z5J5kfJSc5JczhUY0YTrWNCq2Qr3O4mlE',
  );
  final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
  Get.put<FThemeData>(FThemes.zinc.dark);
  Get.put<GoRouter>(router);
  Get.put<OverlayController>(OverlayController());
  Get.put(LocaleController(currentLocale: systemLocale.obs));
  Get.put(SharedPrefsHelper());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeController = Get.find<LocaleController>();
    final overlayController = Get.find<OverlayController>();
    LocalJsonLocalization.delegate.directories = ['/i18n'];

    return Obx(() {
      return GetMaterialApp.router(
        localizationsDelegates: [
          FLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          LocalJsonLocalization.delegate
        ],
        supportedLocales: const [Locale('en', 'US'), Locale('pt', 'BR')],
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          Get.put<ScaffoldMessengerState>(ScaffoldMessenger.of(context));
          Get.put<AuthController>(AuthController());
          Get.put<ThemeController>(ThemeController());

          final themeController = Get.find<ThemeController>();
          return Obx(() {
            return FTheme(
                data: themeController.isDark.value
                    ? FThemes.zinc.dark
                    : FThemes.zinc.light,
                child: Obx(() {
                  return !overlayController.isOverlayOn
                      ? (child ?? Text("error".i18n()))
                      : const FScaffold(
                          content: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            )
                          ],
                        ));
                }));
          });
        },
        locale: localeController.currentLocale,
        routeInformationParser: router.routeInformationParser,
        routerDelegate: router.routerDelegate,
        routeInformationProvider: router.routeInformationProvider,
      );
    });
  }
}
