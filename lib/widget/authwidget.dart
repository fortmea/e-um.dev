import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:localization/localization.dart';
import 'package:mercury/constant/regex.dart';
import 'package:mercury/controller/authcontroller.dart';

class AuthWidget extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;
  final bool isLogin;

  const AuthWidget({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.isLogin,
    required this.formKey,
  });

  @override
  _AuthWidgetState createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  AuthController authController = Get.find();
  final GlobalKey<FormState> forgotPasswordFormKey = GlobalKey<FormState>();
  bool showPassword = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        onChanged: () {
          if (widget.formKey.currentState?.validate() == true) {
            if (widget.isLogin) {
              authController.isLoginFormValid.value = true;
            } else {
              authController.isRegisterFormValid.value = true;
            }
          } else {
            if (widget.isLogin) {
              authController.isLoginFormValid.value = false;
            } else {
              authController.isRegisterFormValid.value = false;
            }
          }
        },
        key: widget.formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FTextField.email(
              label: Text("email".i18n()),
              hint: "email-hint".i18n(),
              controller: widget.emailController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => authController.validateEmail(value),
            ),
            const SizedBox(
              height: 10,
            ),
            FTextField.password(
              label: Text("password".i18n()),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) =>
                  authController.validatePassword(value ?? ""),
              hint: "password-hint".i18n(),
              obscureText: !showPassword,
              controller: widget.passwordController,
              suffix: FButton.icon(
                  style: FButtonStyle.ghost,
                  onPress: () {
                    setState(() {
                      showPassword = !showPassword;
                    });
                  },
                  child: FIcon(
                      showPassword ? FAssets.icons.eye : FAssets.icons.eyeOff)),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                widget.isLogin
                    ? FButton(
                        style: FButtonStyle.ghost,
                        onPress: () {
                          showAdaptiveDialog(
                              context: context,
                              builder: (context) => Obx(
                                    () => FDialog(
                                      direction: Axis.horizontal,
                                      title: Text('forgot-password'.i18n()),
                                      body: SingleChildScrollView(
                                          child: Form(
                                              key: forgotPasswordFormKey,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text('forgot-password-message'
                                                      .i18n()),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  FTextField.email(
                                                    onChange: (value) {
                                                      authController
                                                          .validateEmail(value,
                                                              changeState:
                                                                  true);
                                                    },
                                                    validator: (value) {
                                                      return authController
                                                          .validateEmail(value);
                                                    },
                                                    autovalidateMode:
                                                        AutovalidateMode
                                                            .onUserInteraction,
                                                  )
                                                ],
                                              ))),
                                      actions: [
                                        FButton(
                                            style: FButtonStyle.outline,
                                            label: Text('cancel'.i18n()),
                                            onPress: () =>
                                                Navigator.of(context).pop()),
                                        FButton(
                                            label: Text('submit'.i18n()),
                                            onPress: authController
                                                    .enableSendResetButton.value
                                                ? () {
                                                    Navigator.of(context).pop();
                                                  }
                                                : null),
                                      ],
                                    ),
                                  ));
                        },
                        label: Text("forgot-password".i18n()),
                      )
                    : Container()
              ],
            )
          ],
        ));
  }
}
