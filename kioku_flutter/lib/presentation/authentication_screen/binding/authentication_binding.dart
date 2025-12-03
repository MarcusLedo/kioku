import 'package:get/get.dart';
import '../controller/authentication_controller.dart';
import '../../../core/app_export.dart';

class AuthenticationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthenticationController());
  }
}
