import 'package:get/get.dart';
import '../controller/deck_listing_controller.dart';

class DeckListingBinding extends Bindings {
  @override
  void dependencies() {
    // Remove o controller existente se houver, para garantir que seja recriado
    if (Get.isRegistered<DeckListingController>()) {
      Get.delete<DeckListingController>();
    }
    Get.lazyPut(() => DeckListingController());
  }
}
