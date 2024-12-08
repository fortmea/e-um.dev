import 'package:get/get.dart';


class OverlayController extends GetxController {
  final _showOverlay = false.obs;

  bool get isOverlayOn => _showOverlay.value;

  void toggleOverlay() {
    _showOverlay.value = !_showOverlay.value;
  }
}
