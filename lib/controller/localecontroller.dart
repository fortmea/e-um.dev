import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mercury/controller/overlaycontroller.dart';

class LocaleController extends GetxController {
  final Rx<Locale> _currentLocale;
  final Rx<String> _title = ''.obs;
  LocaleController({required Rx<Locale> currentLocale})
      : _currentLocale = currentLocale;
  String get currentTitle => _title.value;
  set currentTitle(String value) {
    Future.delayed(Duration(milliseconds: 1)).then((_) {
      _title.value = value;
    });
  }

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
