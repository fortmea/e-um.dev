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

  @override
  void initState() {
    super.initState();
    localeController.currentTitle = "home".i18n();
  }

  @override
  Widget build(BuildContext context) {
    return FScaffold(
        header: HeaderWidget(title: "home".i18n()),
        content: Column(
          children: [Text("Teste")],
        ));
  }
}
