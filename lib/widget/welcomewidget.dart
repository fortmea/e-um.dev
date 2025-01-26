import 'package:eum.dev/constant/regex.dart';
import 'package:eum.dev/controller/recordcontroller.dart';
import 'package:eum.dev/util/responsive.dart';
import 'package:eum.dev/widget/loginbutton.dart';
import 'package:eum.dev/widget/outlinetextwidget.dart';
import 'package:extended_text/extended_text.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:localization/localization.dart';

class WelcomeWidget extends StatefulWidget {
  const WelcomeWidget({super.key});

  @override
  State<WelcomeWidget> createState() => _WelcomeWidgetState();
}

class _WelcomeWidgetState extends State<WelcomeWidget>
    with TickerProviderStateMixin {
  RecordController controller = Get.find();
  GradientConfig gradientConfig = GradientConfig(
    gradient: const LinearGradient(
      colors: <Color>[
        Colors.green,
        Colors.yellow,
        Colors.white,
        Colors.blue,
      ],
    ),
    ignoreRegex: numberRegex,
    ignoreWidgetSpan: true,
    renderMode: GradientRenderMode.selection,
  );
  @override
  Widget build(BuildContext context) {
    final mobile = isMobile(context.width);
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(
            child: Wrap(
          children: [
            Text(
              textAlign: TextAlign.start,
              "free-domains".i18n(),
              style: TextStyle(fontSize: mobile ? 30 : 60),
            ),
          ],
        ))
      ]),
      const SizedBox(
        height: 16,
      ),
      (Obx(() {
        return controller.servedDomains.value > 0
            ? Builder(
                builder: (context) {
                  controller.initializeCounter(
                      this, controller.servedDomains.value);
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                  child: Wrap(children: [
                                Obx(() => OutlineText(
                                    strokeColor: Colors.black87,
                                    strokeWidth: 4,
                                    ExtendedText.rich(
                                        style: TextStyle(
                                            fontSize: mobile ? 28 : 56),
                                        gradientConfig: gradientConfig,
                                        TextSpan(
                                          text: "domains-served".i18n([
                                            controller.counterController
                                                .currentValue.value
                                                .toString()
                                          ]),
                                        ))))
                              ])),
                            ]))
                      ]);
                },
              )
            : Container();
      })),
      const FDivider(),
      Row(children: [
        Expanded(
            child: Wrap(spacing: 5, children: [
          Text(
            "claim-now".i18n(),
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(
            width: 200,
            child: LoginButton(),
          )
        ]))
      ]),
    ]);
  }
}
