import 'package:eum.dev/helper/sharedpreferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eum.dev/controller/overlaycontroller.dart';

class LocaleController extends GetxController {
  final SharedPrefsHelper helper =
      Get.find(); // Helper para salvar/carregar preferências
  final Rx<Locale> _currentLocale;
  final Rx<String> _title = ''.obs;
  final Rx<int> index = 0.obs;

  LocaleController({required Rx<Locale> currentLocale})
      : _currentLocale = currentLocale;

  String get currentTitle => _title.value;
  set currentTitle(String value) {
    Future.delayed(const Duration(milliseconds: 1)).then((_) {
      _title.value = value;
    });
  }

  Locale get currentLocale => _currentLocale.value;

  void changeLocale(String languageCode, [String? countryCode]) {
    final overlayController = Get.find<OverlayController>();
    final newLocale = Locale(languageCode, countryCode);

    _currentLocale.value = newLocale;
    Get.updateLocale(newLocale);
    helper.saveString(
        'locale', '${newLocale.languageCode}_${newLocale.countryCode ?? ''}');

    overlayController.toggleOverlay();
    Future.delayed(const Duration(milliseconds: 1000), () {
      Get.updateLocale(newLocale);
      overlayController.toggleOverlay();
    });
  }

  @override
  void onInit() {
    super.onInit();
    _loadLocale();
  }

  void _loadLocale() {
    final savedLocale = helper.getString('locale');
    if (savedLocale != null) {
      final parts = savedLocale.split('_');
      final languageCode = parts[0];
      final countryCode = parts.length > 1 ? parts[1] : null;
      _currentLocale.value = Locale(languageCode, countryCode);
      Get.updateLocale(_currentLocale.value);
    }
  }
}
