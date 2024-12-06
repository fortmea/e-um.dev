import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:mercury/widget/header.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return FScaffold(
        header: HeaderWidget(title: "Home"),
        content: Column(
          children: [Text("Teste")],
        ));
  }
}
