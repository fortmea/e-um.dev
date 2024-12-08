import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mercury/controller/overlaycontroller.dart';

class LocaleController extends GetxController {
  final Rx<Locale> _currentLocale;

  LocaleController({required Rx<Locale> currentLocale})
      : _currentLocale = currentLocale;

  Locale get currentLocale => _currentLocale.value;

  void changeLocale(String languageCode, [String? countryCode]) {
    final overlayController = Get.find<OverlayController>();
    _currentLocale.value = Locale(languageCode, countryCode);
    Get.updateLocale(_currentLocale.value);
    overlayController.toggleOverlay();
    Future.delayed(const Duration(milliseconds: 1000), () {
      Get.updateLocale(_currentLocale.value);
      overlayController.toggleOverlay();
    });
  }
}
