import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:mercury/controller/authcontroller.dart';
import 'package:mercury/controller/localecontroller.dart';
import 'package:mercury/controller/themecontroller.dart';
import 'package:localization/localization.dart';
import 'package:mercury/util/responsive.dart';

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
    return FHeader(
        actions: [
          FPopover(
              controller: popoverController,
              followerBuilder: (context, value, child) {
                return Padding(
                    padding: const EdgeInsets.all(8),
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FButton.icon(
                                style: FButtonStyle.ghost,
                                onPress: () {
                                  localeController.changeLocale('pt', 'BR');
                                },
                                child: Row(children: [
                                  SvgPicture.asset(
                                    '${kIsWeb ? "" : "assets/"}img/br.svg',
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
                                    '${kIsWeb ? "" : "assets/"}img/us.svg',
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
                    Text("language".i18n()),
                    const SizedBox(
                      width: 10,
                    ),
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
                        return FIcon(themeController.isDark.value
                            ? FAssets.icons.moonStar
                            : FAssets.icons.sun);
                      },
                    )
                  ])),
          !controller.isLoggedIn()
              ? FButton.icon(
                  onPress: () {
                    context.pushReplacement('/auth');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("auth-button".i18n()),
                      const SizedBox(
                        width: 10,
                      ),
                      FIcon(controller.isLoggedIn()
                          ? FAssets.icons.logOut
                          : FAssets.icons.logIn)
                    ],
                  ),
                )
              : FButton.icon(
                  onPress: () {
                    showAdaptiveDialog(
                      context: context,
                      builder: (context) => FDialog(
                        direction: Axis.horizontal,
                        title: Text('logout'.i18n()),
                        body: Text('logout-message'.i18n()),
                        actions: [
                          FButton(
                              style: FButtonStyle.outline,
                              label: Text('cancel'.i18n()),
                              onPress: () => Navigator.of(context).pop()),
                          FButton(
                              label: Text('continue'.i18n()),
                              onPress: () {
                                controller.signOut();
                                Navigator.of(context).pop();
                              }),
                        ],
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Text(controller.user.value!.email!),
                      const SizedBox(
                        width: 10,
                      ),
                      FIcon(FAssets.icons.logOut)
                    ],
                  )),
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
            const SizedBox(
              width: 10,
            ),
            Expanded(
                child: !isMobile(MediaQuery.sizeOf(context).width)
                    ? Text(widget.title)
                    : Container()),
          ],
        ));
  }
}
