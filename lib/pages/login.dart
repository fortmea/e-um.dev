import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:mercury/controller/authcontroller.dart';
import 'package:mercury/util/responsivepadding.dart';
import 'package:mercury/widget/header.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
        header: HeaderWidget(title: "Register"),
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
                FCard(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FTextField.email(
                        controller: emailController,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      FTextField.password(
                        obscureText: !showPassword,
                        controller: passwordController,
                        suffix: FButton.icon(
                            style: FButtonStyle.ghost,
                            onPress: () {
                              setState(() {
                                showPassword = !showPassword;
                              });
                            },
                            child: FIcon(!showPassword
                                ? FAssets.icons.eye
                                : FAssets.icons.eyeClosed)),
                      ),
                      const FDivider(axis: Axis.horizontal),
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
                          label: Text("Fazer Login"),
                        ),
                      )
                    ],
                  ),
                )
              ],
            )));
  }
}
