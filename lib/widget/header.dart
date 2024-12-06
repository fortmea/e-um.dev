import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:mercury/controller/authcontroller.dart';
import 'package:mercury/controller/themecontroller.dart';

class HeaderWidget extends StatelessWidget {
  final String title;
  const HeaderWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    return FHeader(
        actions: [
          FButton.icon(
              onPress: () {
                final themeController = Get.find<ThemeController>();
                themeController.changeTheme(
                  themeController.themeData == FThemes.zinc.dark
                      ? FThemes.zinc.light
                      : FThemes.zinc.dark,
                );
              },
              child: FIcon(FAssets.icons.sun)),
          controller.user.value == null
              ? FButton.icon(
                  onPress: () {
                    context.go('/register');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Login / Register"),
                      SizedBox(
                        width: 6,
                      ),
                      FIcon(FAssets.icons.logIn)
                    ],
                  ),
                )
              : FButton.icon(
                  onPress: () {
                    controller.signOut();
                  },
                  child: Row(
                    children: [
                      Text(controller.user.value!.email!),
                      SizedBox(
                        width: 10,
                      ),
                      FIcon(FAssets.icons.logOut)
                    ],
                  )),
        ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(title),
          ],
        ));
  }
}
