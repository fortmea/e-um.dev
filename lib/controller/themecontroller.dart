import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:eum.dev/helper/sharedpreferences.dart';

class ThemeController extends GetxController {
  SharedPrefsHelper helper = Get.find();
  final isDark = false.obs;
  FThemeData currentTheme() {
    return isDark.value == true ? FThemes.zinc.dark : FThemes.zinc.light;
  }

  void changeTheme() {
    isDark.value = !isDark.value;
    helper.saveBool('isDark', isDark.value);
  }

  @override
  void onInit() {
    super.onInit();
    isDark.value = helper.getBool('isDark');
  }
}
