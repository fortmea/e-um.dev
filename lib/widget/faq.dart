import 'package:eum.dev/controller/authcontroller.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:localization/localization.dart';
import 'package:url_launcher/url_launcher.dart';

class FaqWidget extends StatelessWidget {
  FaqWidget({super.key});
  final AuthController authController = Get.find();
  final GoRouter router = Get.find<GoRouter>();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FAccordion(items: [
          FAccordionItem(
              title: Text("privacy-policy-terms-use".i18n()),
              child: Column(
                children: [
                  Text("privacy-policy-terms-use-description".i18n()),
                  const SizedBox(
                    height: 8,
                  ),
                  FButton.icon(
                      onPress: () {
                        //print("${Uri.base}pages/politica.html");
                        launchUrl(Uri.parse("${Uri.base}pages/politica.html"));
                      },
                      child: Row(children: [
                        Text("privacy-policy".i18n()),
                        const SizedBox(
                          width: 8,
                        ),
                        FIcon(FAssets.icons.externalLink)
                      ])),
                  const SizedBox(
                    height: 8,
                  ),
                  FButton.icon(
                      onPress: () {
                        launchUrl(Uri.parse("${Uri.base}pages/termos.html"));
                      },
                      child: Row(children: [
                        Text("terms-use".i18n()),
                        const SizedBox(
                          width: 8,
                        ),
                        FIcon(FAssets.icons.externalLink)
                      ]))
                ],
              )),
          FAccordionItem(
              title: Text("what-domain".i18n()),
              child: Text("what-domain-description".i18n())),
          FAccordionItem(
              title: Text("a-cname".i18n()),
              child: Text("a-cname-description".i18n())),
          FAccordionItem(
              title: Text("why-use".i18n()),
              child: Text("why-use-description".i18n())),
          FAccordionItem(
              title: Text("how-to-delete".i18n()),
              child: Column(children: [
                Text("how-to-delete-description".i18n()),
                const SizedBox(
                  height: 8,
                ),
                FButton(
                  onPress: authController.isLoggedIn()
                      ? () {
                          showAdaptiveDialog(
                            context: context,
                            builder: (context) => FDialog(
                              direction: Axis.horizontal,
                              title: Text('delete-account'.i18n()),
                              body: Text('delete-account-message'.i18n()),
                              actions: [
                                FButton(
                                    style: FButtonStyle.outline,
                                    label: Text('cancel'.i18n()),
                                    onPress: () => Navigator.of(context).pop()),
                                FButton(
                                    label: Text('continue'.i18n()),
                                    onPress: () {
                                      authController.deleteAccount();
                                      Navigator.of(context).pop();
                                    }),
                              ],
                            ),
                          );
                        }
                      : () {},
                  label: Text("delete-account".i18n()),
                )
              ])),
          FAccordionItem(
              title: Text("copyright-dmca-claims".i18n()),
              child: Text("copyright-dmca-claims-description".i18n()))
        ]),
      ],
    );
  }
}
