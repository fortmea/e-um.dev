import 'package:eum.dev/constant/colors.dart';
import 'package:eum.dev/controller/authcontroller.dart';
import 'package:eum.dev/controller/themecontroller.dart';
import 'package:eum.dev/util/responsive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:localization/localization.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginButton extends StatefulWidget {
  const LoginButton({super.key});

  @override
  State<LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  final AuthController controller = Get.find();
  final ThemeController themeController = Get.find();
  @override
  Widget build(BuildContext context) {
    return !controller.isLoggedIn()
        ? Obx(() => FButton.icon(
              style:
                  themeController.currentTheme().buttonStyles.outline.copyWith(
                        iconContentStyle: const FButtonIconContentStyle(
                            enabledColor: githubCollaborationAccent1,
                            disabledColor: Colors.grey),
                      ),
              onPress: () {
                controller.supabase.auth.signInWithOAuth(
                  OAuthProvider.github,
                  authScreenLaunchMode: kIsWeb
                      ? LaunchMode.platformDefault
                      : LaunchMode
                          .externalApplication, // Launch the auth screen in a new webview on mobile.
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => Text(
                        "auth-button".i18n(),
                        style: themeController
                            .currentTheme()
                            .buttonStyles
                            .outline
                            .contentStyle
                            .enabledTextStyle
                            .copyWith(color: githubCollaborationAccent1),
                      )),
                  const SizedBox(
                    width: 10,
                  ),
                  FIcon(FAssets.icons.github)
                ],
              ),
            ))
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
                FAvatar(
                  fallback: Text(controller.user.value!.email!.substring(0, 2)),
                  size: 32,
                  image: NetworkImage(
                      controller.user.value?.userMetadata?['avatar_url']),
                ),
                const SizedBox(
                  width: 10,
                ),
                !isMobile(context.width)
                    ? Text(controller.user.value?.userMetadata?['preferred_username'])
                    : Container(),
                !isMobile(context.width)
                    ? const SizedBox(
                        width: 10,
                      )
                    : Container(),
                DecoratedBox(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: const SizedBox(
                      width: 4,
                      height: 25,
                    )),
                const SizedBox(
                  width: 10,
                ),
                FIcon(FAssets.icons.logOut)
              ],
            ));
  }
}
