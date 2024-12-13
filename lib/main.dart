import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:mercury/controller/authcontroller.dart';
import 'package:mercury/controller/localecontroller.dart';
import 'package:mercury/controller/overlaycontroller.dart';
import 'package:mercury/controller/themecontroller.dart';
import 'package:mercury/helper/sharedpreferences.dart';
import 'package:mercury/util/router.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:mercury/widget/animatedwidget.dart';
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
  Get.put(FThemes.zinc.dark);
  Get.put(router);
  Get.put(OverlayController());
  Get.put(LocaleController(currentLocale: systemLocale.obs));
  Get.put(SharedPrefsHelper());

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //Key appKey = UniqueKey();
  late final GoRouter routerObj;
  late final LocaleController localeController;
  late final OverlayController overlayController;

  @override
  void initState() {
    super.initState();
    routerObj = Get.find<GoRouter>();
    localeController = Get.find<LocaleController>();
    overlayController = Get.find<OverlayController>();

    LocalJsonLocalization.delegate.directories = [
      kIsWeb ? "/i18n" : "assets/i18n"
    ];

    // Configurar controlador de autenticação e evento
    final authController = Get.put(AuthController());
    authController.authEventSubscriber(authEventHandler);
  }

  void authEventHandler(AuthChangeEvent event, Session? session) {
    switch (event) {
      case AuthChangeEvent.initialSession:
        break;
      case AuthChangeEvent.signedIn:
        print("Signed in");
        setState(() {
          // appKey = UniqueKey();
        });
        routerObj.go('/');
        break;
      case AuthChangeEvent.signedOut:
        setState(() {
          // appKey = UniqueKey();
        });
        routerObj.go('/');
        break;
      case AuthChangeEvent.passwordRecovery:
        // handle password recovery
        break;
      case AuthChangeEvent.tokenRefreshed:
        // handle token refreshed
        break;
      case AuthChangeEvent.userUpdated:
        // handle user updated
        break;
      case AuthChangeEvent.userDeleted:
        // handle user deleted
        break;
      case AuthChangeEvent.mfaChallengeVerified:
        // handle mfa challenge verified
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put<ThemeController>(ThemeController());
    return Obx(() {
      return GetMaterialApp.router(
        //getPages: getPages,
        localizationsDelegates: [
          FLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          LocalJsonLocalization.delegate,
        ],
        supportedLocales: const [Locale('en', 'US'), Locale('pt', 'BR')],
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return Obx(() => CustomAnimatedWidget(
              animate: themeController.isDark,
              animationType: AnimationType.fadeRebound,
              child: FTheme(
                data: themeController.isDark.value
                    ? FThemes.zinc.dark
                    : FThemes.zinc.light,
                child: Obx(() => Title(
                      color: Colors.red,
                      title: localeController.currentTitle,
                      child: !overlayController.isOverlayOn
                          ? child ?? Text("error".i18n())
                          : FScaffold(
                              content: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Obx(
                                      () => CircularProgressIndicator(
                                        color: themeController.isDark.value
                                            ? Colors.white
                                            : Colors.black,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            )),
                    )),
              )));
        },
        locale: localeController.currentLocale,
        routeInformationParser: routerObj.routeInformationParser,
        routerDelegate: routerObj.routerDelegate,
        routeInformationProvider: routerObj.routeInformationProvider,
      );
    });
  }
}
