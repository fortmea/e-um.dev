import 'package:eum.dev/constant/nametypes.dart';
import 'package:eum.dev/controller/recordcontroller.dart';
import 'package:eum.dev/controller/themecontroller.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:localization/localization.dart';

class RecordManagerWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  const RecordManagerWidget({
    super.key,
    required this.formKey,
  });

  @override
  State<RecordManagerWidget> createState() => _RecordManagerWidgetState();
}

class _RecordManagerWidgetState extends State<RecordManagerWidget>
    with TickerProviderStateMixin {
  RecordController controller = Get.find();
  ThemeController themeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(children: [
          FAccordion(items: [
            FAccordionItem(
                title: Obx(() => Text("registered-domains".i18n([
                      controller.domainCount.toString(),
                      controller.domainLimit.toString()
                    ]))),
                child: Obx(() {
                  return controller.domainCount > 0
                      ? Column(children: [
                          Obx(() => ListView.separated(
                                separatorBuilder: (context, index) {
                                  return const SizedBox(
                                    height: 16,
                                  );
                                },
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: controller.domainCount.value,
                                itemBuilder: (context, index) {
                                  return Obx(() => FTile(
                                      suffixIcon: FButton.icon(
                                          onPress: () {
                                            showAdaptiveDialog(
                                              context: context,
                                              builder: (context) => FDialog(
                                                direction: Axis.horizontal,
                                                title: Text('delete'.i18n()),
                                                body: Text(
                                                    'delete-message'.i18n()),
                                                actions: [
                                                  FButton(
                                                      style:
                                                          FButtonStyle.outline,
                                                      label:
                                                          Text('cancel'.i18n()),
                                                      onPress: () =>
                                                          Navigator.of(context)
                                                              .pop()),
                                                  FButton(
                                                      label: Text(
                                                          'continue'.i18n()),
                                                      onPress: () {
                                                        controller.deleteDomain(
                                                            controller
                                                                .domainsList
                                                                .value[index]);
                                                        Navigator.of(context)
                                                            .pop();
                                                      }),
                                                ],
                                              ),
                                            );
                                          },
                                          child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text("delete".i18n()),
                                                const SizedBox(
                                                  width: 4,
                                                ),
                                                FIcon(
                                                  FAssets.icons.trash,
                                                  size: 16,
                                                ),
                                              ])),
                                      title: Row(children: [
                                        Text(controller
                                            .domainsList.value[index].name),
                                        FIcon(FAssets.icons.arrowRight),
                                        Text(controller
                                            .domainsList.value[index].target),
                                      ])));
                                },
                              ))
                        ])
                      : Text("no-domain-registered".i18n());
                }))
          ]),
          const FDivider(),
          FCard(
              title: Text("register-domain".i18n()),
              child: Form(
                  autovalidateMode: AutovalidateMode.always,
                  onChanged: () {
                    if (widget.formKey.currentState?.validate() == true &&
                        (controller.targetController.value.text != "") &&
                        (controller.subdomainController.value.text != "")) {
                      controller.isFormValid.value = true;
                    } else {
                      controller.isFormValid.value = false;
                    }
                  },
                  key: widget.formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () {
                          return Column(children: [
                            controller.message.value != null
                                ? FAlert(
                                    title:
                                        Text(controller.message.value!.title),
                                    subtitle:
                                        Text(controller.message.value!.message),
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
                      Obx(() => FTextField(
                          label: Text("subdomain".i18n()),
                          hint: "subdomain-hint".i18n(),
                          style: themeController
                              .currentTheme()
                              .textFieldStyle
                              .copyWith(
                                  enabledStyle: themeController
                                      .currentTheme()
                                      .textFieldStyle
                                      .enabledStyle
                                      .copyWith(
                                          contentTextStyle: themeController
                                              .currentTheme()
                                              .textFieldStyle
                                              .enabledStyle
                                              .contentTextStyle
                                              .copyWith(fontSize: 20))),
                          controller: controller.subdomainController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) =>
                              controller.validateSubdomain(value ?? ""),
                          suffix: Obx(() => FCard(
                                style: themeController
                                    .currentTheme()
                                    .cardStyle
                                    .copyWith(
                                        decoration: const BoxDecoration()),
                                title: const Text(".e-um.dev.br"),
                              )))),
                      const SizedBox(
                        height: 10,
                      ),
                      FTextField(
                        label: Text("target".i18n()),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) =>
                            controller.validateTarget(value ?? ""),
                        hint: "target-hint".i18n(),
                        controller: controller.targetController,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const FDivider(
                        axis: Axis.horizontal,
                      ),
                      FSelectMenuTile<Nametypes>(
                        groupController: controller.selectorController,
                        popoverController: FPopoverController(vsync: this),
                        divider: FTileDivider.full,
                        menuAnchor: Alignment.topLeft,
                        tileAnchor: Alignment.bottomLeft,
                        shift: FPortalFollowerShift.flip,
                        hideOnTapOutside: true,
                        autoHide: true,
                        errorBuilder: (context, error) => Text(error),
                        prefixIcon: FIcon(FAssets.icons.logs),
                        title: Text('record-type'.i18n()),
                        details: ListenableBuilder(
                            listenable: controller.selectorController,
                            builder: (context, _) {
                              return Text(switch (controller
                                  .selectorController.values.firstOrNull) {
                                Nametypes.CNAME => 'CNAME',
                                Nametypes.A => 'A',
                                null => 'CNAME',
                                Object() => throw UnimplementedError(),
                              });
                            }),
                        suffixIcon: FIcon(FAssets.icons.chevronsUpDown),
                        menu: [
                          FSelectTile(
                            title: Text("CNAME".i18n()),
                            value: Nametypes.CNAME,
                          ),
                          FSelectTile(
                            title: Text("A".i18n()),
                            value: Nametypes.A,
                          ),
                        ],
                      ),
                      const FDivider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Obx(() => FButton.icon(
                              onPress: controller.isFormValid.value
                                  ? () {
                                      controller.registerDomain();
                                    }
                                  : null,
                              child: Row(
                                children: [
                                  Text("create-domain".i18n()),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  FIcon(
                                    FAssets.icons.circlePlus,
                                    size: 16,
                                  ),
                                ],
                              )))
                        ],
                      )
                    ],
                  )))
        ]));
  }
}
