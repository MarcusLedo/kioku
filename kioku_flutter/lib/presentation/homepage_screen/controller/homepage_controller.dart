import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import '../models/homepage_model.dart';
import '../../../services/supabase_deck_service.dart';
import '../../../services/supabase_auth_service.dart';
import '../../../services/supabase_study_service.dart';

class HomepageController extends GetxController {
  Rx<HomepageModel> homepageModelObj = HomepageModel().obs;

  final SupabaseDeckService _deckService = SupabaseDeckService();
  final SupabaseAuthService _authService = SupabaseAuthService();
  final SupabaseStudyService _studyService = SupabaseStudyService();

  var selectedIndex = 0.obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var _isNavigating = false;

  // User data
  var userName = 'Usuário'.obs;
  var currentStreak = 0.obs;
  var totalDecks = 0.obs;

  // Decks data
  var recentDecks = <Map<String, dynamic>>[].obs;

  // Study dates (set of dates when user studied)
  var studyDates = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  @override
  void onReady() {
    super.onReady();
    // Refresh streak data when screen is ready
    _loadDailyStreakData();
  }

  Future<void> _loadUserData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Get current user
      final user = _authService.currentUser;
      if (user == null) {
        // Usa postFrameCallback para evitar navegação durante build
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Get.offAllNamed('/authentication-screen');
        });
        return;
      }

      // Get user profile
      final profile = await _authService.getUserProfile();
      if (profile != null) {
        userName.value = profile['full_name'] ?? 'Usuário';
        currentStreak.value = profile['current_streak'] ?? 0;
      }

      // Load decks
      await _loadDecks();
      
      // Load daily streak data
      await _loadDailyStreakData();
    } catch (e) {
      errorMessage.value = 'Erro ao carregar dados: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadDecks() async {
    try {
      final decks = await _deckService.getUserDecks();
      recentDecks.value = decks.take(3).toList();
      totalDecks.value = decks.length;
    } catch (e) {
      errorMessage.value = 'Erro ao carregar decks: ${e.toString()}';
    }
  }

  Future<void> _loadDailyStreakData() async {
    try {
      final dates = await _studyService.getStudyDates();
      studyDates.value = dates;
    } catch (e) {
      // Silently fail - streak data is not critical
      print('Erro ao carregar datas de estudo: ${e.toString()}');
    }
  }

  Future<void> refreshData() async {
    await _loadUserData();
    await _loadDailyStreakData();
  }

  // Check if user studied on a specific date
  // Returns: true if studied (green), false if not (gray)
  bool didStudyOnDate(DateTime date) {
    final dateStr = date.toIso8601String().split('T')[0];
    return studyDates.contains(dateStr);
  }

  void onBottomNavTap(int index) {
    // Evita navegação se já estiver no índice selecionado
    if (selectedIndex.value == index && index == 0) {
      return;
    }
    
    // Evita navegação simultânea
    if (_isNavigating) {
      return;
    }
    
    _isNavigating = true;
    selectedIndex.value = index;
    
    // Usa postFrameCallback para garantir que a navegação aconteça após o frame
    SchedulerBinding.instance.addPostFrameCallback((_) {
      // Usa offNamed para substituir a rota atual ao invés de empilhar
      if (index == 1) {
        Get.offNamed('/deck-listing-screen');
      } else if (index == 2) {
        Get.offNamed('/account-screen');
      }
      
      // Reset flag após um pequeno delay
      Future.delayed(Duration(milliseconds: 300), () {
        _isNavigating = false;
      });
    });
  }

  void onSettingsTap() {
    Get.toNamed('/settings-screen');
  }

  void onViewAllDecks() {
    Get.toNamed('/deck-listing-screen');
  }

  void onDeckTap(String deckId, String deckTitle) {
    Get.toNamed(
      '/deck-details-screen',
      arguments: {
        'deckId': deckId,
        'title': deckTitle,
      },
    );
  }

  @override
  void onClose() {
    super.onClose();
  }
}