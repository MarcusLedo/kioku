import 'package:get/get.dart';
import '../controller/association_controller.dart';

class AssociationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AssociationController());
  }
}
