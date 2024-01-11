import 'package:get/get.dart';

import '../controllers/daftarruang_controller.dart';

class DaftarruangBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DaftarruangController>(
      () => DaftarruangController(),
    );
  }
}
