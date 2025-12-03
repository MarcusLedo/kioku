import 'package:get/get.dart';
import '../models/association_model.dart';
import '../../../services/supabase_flashcard_service.dart';
import '../../../services/supabase_auth_service.dart';

class AssociationController extends GetxController {
  Rx<AssociationModel> associationModelObj = AssociationModel().obs;

  final SupabaseFlashcardService _flashcardService = SupabaseFlashcardService();
  final SupabaseAuthService _authService = SupabaseAuthService();

  RxInt selectedIndex = 1.obs;
  RxBool isLoading = true.obs;
  RxString errorMessage = ''.obs;

  RxList<Map<String, dynamic>> associations = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadAssociations();
  }

  Future<void> _loadAssociations() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Verify authentication
      final user = _authService.currentUser;
      if (user == null) {
        Get.offAllNamed('/authentication-screen');
        return;
      }

      // Load all associations (you may need to add this method to SupabaseFlashcardService)
      // For now, loading as empty list
      associations.value = [];
    } catch (e) {
      errorMessage.value = 'Erro ao carregar associações: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshAssociations() async {
    await _loadAssociations();
  }

  void onBottomNavTap(int index) {
    selectedIndex.value = index;
    if (index == 0) {
      Get.offNamed('/homepage-screen');
    } else if (index == 1) {
      Get.offNamed('/deck-listing-screen');
    } else if (index == 2) {
      Get.offNamed('/account-screen');
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}