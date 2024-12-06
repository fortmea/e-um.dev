import 'package:forui/forui.dart';
import 'package:get/get.dart';

double responsivePadding(double width) {
  final breakpoints = Get.find<FThemeData>().breakpoints;

  return switch (width) {
    _ when width < breakpoints.sm => 16,
    _ when width < breakpoints.md => 32,
    _ when width < breakpoints.lg => 64,
    _ when width < breakpoints.xl => 96,
    _ when width < breakpoints.xl2 => 128,
    _ => 256, 
  };
}
