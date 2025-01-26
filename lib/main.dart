import 'dart:io';

import 'package:eum.dev/controller/recordcontroller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:eum.dev/controller/authcontroller.dart';
import 'package:eum.dev/controller/localecontroller.dart';
import 'package:eum.dev/controller/overlaycontroller.dart';
import 'package:eum.dev/controller/themecontroller.dart';
import 'package:eum.dev/helper/sharedpreferences.dart';
import 'package:eum.dev/util/router.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:eum.dev/widget/animatedwidget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:localization/localization.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  await dotenv.load(fileName: "env/env.env");
  await Supabase.initialize(
    url: dotenv.env["url"] ?? "",
    anonKey: (dotenv.env["key"] ?? ""),
  );

  final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
  Get.put(FThemes.zinc.dark);
  Get.put(router);
  Get.put(OverlayController());
  Get.put(RecordController());
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
    overlayController.toggleOverlay();
    print("LOL");
    print("Evento $event" );
    switch (event) {
      case AuthChangeEvent.initialSession:
        break;
      case AuthChangeEvent.signedIn:
        routerObj.go('/');
        break;
      case AuthChangeEvent.signedOut:
        routerObj.go('/');
        break;
      case AuthChangeEvent.passwordRecovery:
        // handle password recovery
        break;
      case AuthChangeEvent.tokenRefreshed:
        // handle token refreshed
        break;
      case AuthChangeEvent.userUpdated:
        print("Usuário atualizado");
        break;
      case AuthChangeEvent.userDeleted:
        print("Usuário apagado");
        break;
      case AuthChangeEvent.mfaChallengeVerified:
        // handle mfa challenge verified
        break;
    }
    Future.delayed(const Duration(milliseconds: 500), () {
      overlayController.toggleOverlay();
    });
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
