import 'package:get/get.dart';
import '../controller/flashcard_study_controller.dart';

class FlashcardStudyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FlashcardStudyController());
  }
}
