import 'package:eum.dev/widget/loginbutton.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:eum.dev/constant/colors.dart';
import 'package:eum.dev/controller/authcontroller.dart';
import 'package:eum.dev/controller/localecontroller.dart';
import 'package:eum.dev/controller/themecontroller.dart';
import 'package:localization/localization.dart';
import 'package:eum.dev/util/responsive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HeaderWidget extends StatefulWidget {
  final String title;
  const HeaderWidget({super.key, required this.title});

  @override
  _HeaderWidgetState createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget>
    with TickerProviderStateMixin {
  final localeController = Get.find<LocaleController>();
  late FPopoverController popoverController;
  final controller = Get.find<AuthController>();
  final themeController = Get.find<ThemeController>();
  @override
  void initState() {
    super.initState();
    popoverController = FPopoverController(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      FHeader(
          actions: [
            FPopover(
                controller: popoverController,
                followerBuilder: (context, value, child) {
                  return Padding(
                      padding: const EdgeInsets.all(8),
                      child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FButton.icon(
                                  style: FButtonStyle.ghost,
                                  onPress: () {
                                    localeController.changeLocale('pt', 'BR');
                                  },
                                  child: Row(children: [
                                    SvgPicture.asset(
                                      '${kIsWeb ? kDebugMode ? "" : "assets/" : "assets/assets/"}img/br.svg',
                                      semanticsLabel: 'portuguese'.i18n(),
                                      width: 18,
                                      height: 18,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text("portuguese".i18n())
                                  ])),
                              FButton.icon(
                                  style: FButtonStyle.ghost,
                                  onPress: () {
                                    localeController.changeLocale('en', 'US');
                                  },
                                  child: Row(children: [
                                    SvgPicture.asset(
                                      '${kIsWeb ? kDebugMode ? "" : "assets/" : "assets/assets/"}img/us.svg',
                                      semanticsLabel: 'english'.i18n(),
                                      width: 18,
                                      height: 18,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text("english".i18n())
                                  ]))
                            ],
                          )));
                },
                target: FButton.icon(
                    onPress: popoverController.toggle,
                    child: Row(children: [
                      /* Text("language".i18n()),
                    const SizedBox(
                      width: 10,
                    ),*/
                      FIcon(FAssets.icons.languages)
                    ]))),
            FButton.icon(
                onPress: () {
                  themeController.changeTheme();
                },
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () {
                          return FIcon(!themeController.isDark.value
                              ? FAssets.icons.moonStar
                              : FAssets.icons.sun);
                        },
                      )
                    ])),
            controller.user.value == null
                ? FButton.icon(
                    onPress: () {
                      context.go('/login');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("to-login-page".i18n()),
                        const SizedBox(
                          width: 10,
                        ),
                        FIcon(FAssets.icons.logIn)
                      ],
                    ),
                  )
                : const LoginButton()
          ],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FButton.icon(
                child: FIcon(FAssets.icons.house),
                onPress: () {
                  context.go('/');
                },
              ),
            ],
          )),
    ]);
  }
}
