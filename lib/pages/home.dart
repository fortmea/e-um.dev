import 'package:eum.dev/controller/authcontroller.dart';
import 'package:eum.dev/util/responsive.dart';
import 'package:eum.dev/widget/faq.dart';
import 'package:eum.dev/widget/recordmanagerwidget.dart';
import 'package:eum.dev/widget/welcomewidget.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:localization/localization.dart';
import 'package:eum.dev/controller/localecontroller.dart';
import 'package:eum.dev/widget/header.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LocaleController localeController = Get.find();
  AuthController authController = Get.find();
  @override
  void initState() {
    super.initState();
    localeController.currentTitle = "home".i18n();
  }

  @override
  Widget build(BuildContext context) {
    return FScaffold(
      header: HeaderWidget(title: "".i18n()),
      footer: Obx(() => FBottomNavigationBar(
              onChange: (int value) {
                localeController.index.value = value;
              },
              index: localeController.index.value,
              children: [
                FBottomNavigationBarItem(
                  icon: FIcon(FAssets.icons.list),
                  label: Text('home'.i18n()),
                ),
                FBottomNavigationBarItem(
                  icon: FIcon(FAssets.icons.messageCircleQuestion),
                  label: Text('questions-answers'.i18n()),
                ),
                /*FBottomNavigationBarItem(
                  icon: FIcon(FAssets.icons.circleHelp),
                  label: Text('about-contact'.i18n()),
                ),*/
              ])),
      content: Padding(
          padding: EdgeInsets.symmetric(
              vertical: responsivePadding(MediaQuery.sizeOf(context).height),
              horizontal: responsivePadding(MediaQuery.sizeOf(context).width)),
          child: SingleChildScrollView(child: Obx(
            () {
              switch (localeController.index.value) {
                case 0:
                  return Obx(() => authController.user.value == null
                      ? const WelcomeWidget()
                      : RecordManagerWidget(formKey: GlobalKey()));
                case 1:
                  return FaqWidget();

                default:
                  return const Text("how?");
              }
            },
          ))),
    );
  }
}
