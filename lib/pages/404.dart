import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:localization/localization.dart';
import 'package:mercury/widget/header.dart';

class NotFoundPage extends StatefulWidget {
  const NotFoundPage({super.key});

  @override
  State<NotFoundPage> createState() => _NotFoundPageState();
}

class _NotFoundPageState extends State<NotFoundPage> {
  @override
  Widget build(BuildContext context) {
    return FScaffold(
        header: HeaderWidget(title: "page-not-found".i18n()),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FCard(
              image: FIcon(FAssets.icons.fileQuestion),
              title: Text("error".i18n()),
              subtitle: Text("page-not-found".i18n()),
            )
          ],
        ));
  }
}
