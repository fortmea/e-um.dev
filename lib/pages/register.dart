import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:mercury/controller/authcontroller.dart';
import 'package:mercury/util/responsivepadding.dart';
import 'package:mercury/widget/authwidget.dart';
import 'package:mercury/widget/header.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  AuthController controller = Get.find<AuthController>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  var showPassword = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FScaffold(
        header: const HeaderWidget(title: "Login and Register"),
        content: Padding(
            padding: EdgeInsets.all(
                responsivePadding(MediaQuery.sizeOf(context).width)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(
                  () {
                    return Column(children: [
                      controller.message.value != null
                          ? FAlert(
                              title: Text(controller.message.value!.title),
                              subtitle: Text(controller.message.value!.message),
                              style: controller.message.value!.error
                                  ? FAlertStyle.destructive
                                  : FAlertStyle.primary,
                            )
                          : Container(),
                      const SizedBox(
                        height: 16,
                      ),
                    ]);
                  },
                ),
                FTabs(tabs: [
                  FTabEntry(
                      label: const Text("Login"),
                      content: FCard(
                          child: Column(children: [
                        AuthWidget(
                            emailController: emailController,
                            passwordController: passwordController),
                        const FDivider(),
                        Obx(
                          () => FButton(
                            prefix: controller.isLoading.value
                                ? const FButtonSpinner()
                                : null,
                            onPress: controller.isLoading.value
                                ? null
                                : () {
                                    controller.signIn(emailController.text,
                                        passwordController.text);
                                  },
                            label: const Text("Login"),
                          ),
                        )
                      ]))),
                  FTabEntry(
                      label: const Text("Register"),
                      content: FCard(
                          child: Column(children: [
                        AuthWidget(
                            emailController: emailController,
                            passwordController: passwordController),
                        const FDivider(),
                        Obx(
                          () => FButton(
                            prefix: controller.isLoading.value
                                ? const FButtonSpinner()
                                : null,
                            onPress: controller.isLoading.value
                                ? null
                                : () {
                                    controller.signUp(emailController.text,
                                        passwordController.text);
                                  },
                            label: const Text("Registrar"),
                          ),
                        )
                      ])))
                ]),
              ],
            )));
  }
}
