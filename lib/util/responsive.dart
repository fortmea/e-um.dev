import 'package:forui/forui.dart';
import 'package:get/get.dart';

double responsivePadding(double size) {
  final breakpoints = Get.find<FThemeData>().breakpoints;

  return switch (size) {
    _ when size < breakpoints.sm => 16,
    _ when size < breakpoints.md => 32,
    _ when size < breakpoints.lg => 64,
    _ when size < breakpoints.xl => 128,
    _ when size < breakpoints.xl2 => 256,
    _ => 512,
  };
}

bool isMobile(double width) {
  final breakpoints = Get.find<FThemeData>().breakpoints;
  return width < breakpoints.lg;
}
