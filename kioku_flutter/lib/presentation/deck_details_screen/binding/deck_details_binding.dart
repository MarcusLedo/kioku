import 'package:get/get.dart';
import '../controller/deck_details_controller.dart';

class DeckDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DeckDetailsController());
  }
}
