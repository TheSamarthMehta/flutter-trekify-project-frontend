// lib/controllers/trek_details_binding.dart
import 'package:get/get.dart';
import 'package:trekify/controllers/trek_details_controller.dart';

class TrekDetailsBinding extends Bindings {
  @override
  void dependencies() {
    // Lazily inject TrekDetailsController, it will be created when needed.
    Get.lazyPut<TrekDetailsController>(() => TrekDetailsController());
  }
}