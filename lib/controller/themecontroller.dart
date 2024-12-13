import 'package:get/get.dart';
import 'package:mercury/helper/sharedpreferences.dart';

class ThemeController extends GetxController {
  SharedPrefsHelper helper = Get.find();
  final isDark = false.obs;
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
