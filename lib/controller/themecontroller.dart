import 'package:get/get.dart';
import 'package:forui/forui.dart'; // Supondo que você está usando o ForUI.

class ThemeController extends GetxController {
  final _themeData = FThemes.zinc.dark.obs;

  FThemeData get themeData => _themeData.value;

  void changeTheme(FThemeData newTheme) {
    _themeData.value = newTheme;
  }
}
