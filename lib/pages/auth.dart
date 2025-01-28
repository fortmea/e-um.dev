import 'package:eum.dev/widget/loginbutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:eum.dev/controller/authcontroller.dart';
import 'package:eum.dev/controller/localecontroller.dart';
import 'package:eum.dev/util/responsive.dart';
import 'package:eum.dev/widget/header.dart';
import 'package:localization/localization.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
//  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  // GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();
  //final TextEditingController emailController = TextEditingController();
  // final TextEditingController passwordController = TextEditingController();
  AuthController controller = Get.find<AuthController>();
  LocaleController localeController = Get.find();

  bool register = false;
  bool showPassword = false;

  @override
  void initState() {
    super.initState();
    controller.isLoginFormValid.value = false;
    controller.isRegisterFormValid.value = false;
    localeController.currentTitle = getTitle();
  }

  /*@override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
*/
  String getTitle() {
    return (register ? 'register' : 'login').i18n();
  }

  @override
  Widget build(BuildContext context) {
    localeController.currentTitle = getTitle();
    return FScaffold(
        footer: Padding(
            padding: EdgeInsets.symmetric(
                horizontal:
                    responsivePadding(MediaQuery.sizeOf(context).width)),
            child: Column(children: [
              Text("agree-to-terms".i18n()),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FButton.icon(
                      onPress: () {
                        //print("${Uri.base}pages/politica.html");
                        launchUrl(
                            Uri.parse("/pages/politica.html"));
                      },
                      child: Row(children: [
                        Text("privacy-policy".i18n()),
                        const SizedBox(
                          width: 8,
                        ),
                        FIcon(FAssets.icons.externalLink)
                      ])),
                  const SizedBox(
                    width: 8,
                  ),
                  FButton.icon(
                      onPress: () {
                        launchUrl(
                            Uri.parse("/pages/termos.html"));
                      },
                      child: Row(children: [
                        Text("terms-use".i18n()),
                        const SizedBox(
                          width: 8,
                        ),
                        FIcon(FAssets.icons.externalLink)
                      ])),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
            ])),
        header: HeaderWidget(title: getTitle()),
        content: Padding(
            padding: EdgeInsets.symmetric(
                vertical: responsivePadding(MediaQuery.sizeOf(context).height),
                horizontal:
                    responsivePadding(MediaQuery.sizeOf(context).width)),
            child: const SingleChildScrollView(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                LoginButton(),
                /* Obx(
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
                FTabs(
                    onPress: (value) {
                      if (value == 0) {
                        setState(() {
                          register = false;
                        });
                      } else {
                        setState(() {
                          register = true;
                        });
                      }
                    },
                    tabs: [
                      FTabEntry(
                          label: Text("login".i18n()),
                          content: FCard(
                              child: Column(children: [
                            AuthWidget(
                                formKey: loginFormKey,
                                isLogin: true,
                                emailController: emailController,
                                passwordController: passwordController),
                            const FDivider(),
                            Obx(() {
                              return FButton(
                                prefix: controller.isLoading.value
                                    ? const FButtonSpinner()
                                    : null,
                                onPress: (controller.isLoading.value ||
                                        controller.isLoginFormValid.value ==
                                            false)
                                    ? null
                                    : () {
                                        controller.signIn(emailController.text,
                                            passwordController.text);
                                      },
                                label: Text("login".i18n()),
                              );
                            })
                          ]))),
                      FTabEntry(
                          label: Text("register".i18n()),
                          content: FCard(
                              child: Column(children: [
                            AuthWidget(
                                formKey: registerFormKey,
                                isLogin: false,
                                emailController: emailController,
                                passwordController: passwordController),
                            const FDivider(),
                            Obx(
                              () => FButton(
                                prefix: controller.isLoading.value
                                    ? const FButtonSpinner()
                                    : null,
                                onPress: (controller.isLoading.value ||
                                        controller.isRegisterFormValid.value ==
                                            false)
                                    ? null
                                    : () {
                                        controller.signUp(emailController.text,
                                            passwordController.text);
                                      },
                                label: Text("register".i18n()),
                              ),
                            )
                          ])))
                    ]),*/
              ],
            ))));
  }
}
