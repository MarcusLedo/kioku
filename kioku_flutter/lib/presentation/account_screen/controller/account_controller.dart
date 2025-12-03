import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/account_model.dart';
import '../../../services/supabase_auth_service.dart';
import '../../../core/app_export.dart';

class AccountController extends GetxController {
  Rx<AccountModel> accountModelObj = AccountModel().obs;

  final SupabaseAuthService _authService = SupabaseAuthService();

  RxInt selectedIndex = 2.obs;
  RxBool isLoading = true.obs;
  RxString errorMessage = ''.obs;

  // User data
  RxString userName = 'Usuário'.obs;
  RxString userEmail = ''.obs;
  RxString avatarUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
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
        userEmail.value = profile['email'] ?? '';
        avatarUrl.value = profile['avatar_url'] ?? '';
      }
    } catch (e) {
      errorMessage.value = 'Erro ao carregar dados: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    await _loadUserData();
  }

  Future<void> signOut() async {
    try {
      await _authService.signOut();
      Get.offAllNamed('/authentication-screen');
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Não foi possível sair: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void onBottomNavTap(int index) {
    // Evita navegação se já estiver no índice selecionado
    if (selectedIndex.value == index && index == 2) {
      return;
    }
    
    selectedIndex.value = index;
    
    // Usa postFrameCallback para garantir que a navegação aconteça após o frame
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (index == 0) {
        Get.offNamed('/homepage-screen');
      } else if (index == 1) {
        Get.offNamed('/deck-listing-screen');
      }
    });
  }

  void onProfileTap() {
    Get.toNamed('/profile-screen');
  }

  void onSettingsTap() {
    Get.toNamed('/settings-screen');
  }

  void onDecksTap() {
    Get.toNamed('/deck-listing-screen');
  }

  void onAssociationsTap() {
    Get.toNamed('/association-screen');
  }

  void showDeleteAccountConfirmationDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.h),
        ),
        title: Text(
          'Confirmar Exclusão de Conta',
          style: TextStyleHelper.instance.title20BoldOpenSans,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tem certeza que deseja excluir sua conta permanentemente?',
              style: TextStyleHelper.instance.body15RegularOpenSans,
            ),
            SizedBox(height: 16.h),
            Text(
              'Esta ação irá:',
              style: TextStyleHelper.instance.body14LightOpenSans.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              '• Deletar todos os seus decks e flashcards',
              style: TextStyleHelper.instance.body14LightOpenSans,
            ),
            Text(
              '• Deletar todo o histórico de estudos',
              style: TextStyleHelper.instance.body14LightOpenSans,
            ),
            Text(
              '• Deletar todas as estatísticas e dados',
              style: TextStyleHelper.instance.body14LightOpenSans,
            ),
            Text(
              '• Remover sua conta permanentemente',
              style: TextStyleHelper.instance.body14LightOpenSans,
            ),
            SizedBox(height: 16.h),
            Text(
              'Esta ação NÃO pode ser desfeita!',
              style: TextStyleHelper.instance.body14LightOpenSans.copyWith(
                color: Colors.red[700],
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancelar',
              style: TextStyleHelper.instance.body15RegularOpenSans.copyWith(
                color: appTheme.greyCustom,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back(); // Fecha o diálogo de confirmação
              await deleteAccount();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[700],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.h),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 24.h,
                vertical: 12.h,
              ),
            ),
            child: Text(
              'Excluir Conta',
              style: TextStyleHelper.instance.body15RegularOpenSans.copyWith(
                color: appTheme.white_A700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> deleteAccount() async {
    try {
      isLoading.value = true;

      // Delete user account (this will cascade delete all related data)
      await _authService.deleteUserAccount();

      // Navigate to authentication screen
      Get.offAllNamed('/authentication-screen');

      Get.snackbar(
        'Conta Excluída',
        'Sua conta foi excluída com sucesso.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[900],
      );
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Não foi possível excluir a conta: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}