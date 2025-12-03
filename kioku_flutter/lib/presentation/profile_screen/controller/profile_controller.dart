import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../models/profile_model.dart';
import '../../../services/supabase_auth_service.dart';
import '../../../services/supabase_storage_service.dart';
import '../../../core/app_export.dart';

class ProfileController extends GetxController {
  Rx<ProfileModel> profileModelObj = ProfileModel().obs;

  final SupabaseAuthService _authService = SupabaseAuthService();
  final SupabaseStorageService _storageService = SupabaseStorageService();
  final ImagePicker _imagePicker = ImagePicker();

  RxInt selectedIndex = 2.obs;
  RxBool isLoading = true.obs;
  RxString errorMessage = ''.obs;

  // User data
  RxString userName = 'Usuário'.obs;
  RxString userEmail = ''.obs;
  RxString avatarUrl = ''.obs;
  RxInt currentStreak = 0.obs;
  RxInt longestStreak = 0.obs;
  RxInt totalStudyTime = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
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

      // Get user email from auth
      userEmail.value = user.email ?? '';

      // Get user profile
      final profile = await _authService.getUserProfile();
      if (profile != null) {
        userName.value = profile['full_name'] ?? 'Usuário';
        // Se o email não estiver no profile, mantém o do auth
        if (profile['email'] != null && profile['email'].toString().isNotEmpty) {
          userEmail.value = profile['email'] ?? user.email ?? '';
        }
        avatarUrl.value = profile['avatar_url'] ?? '';
        currentStreak.value = profile['current_streak'] ?? 0;
        longestStreak.value = profile['longest_streak'] ?? 0;
        totalStudyTime.value = profile['total_study_time'] ?? 0;
      }
    } catch (e) {
      errorMessage.value = 'Erro ao carregar perfil: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshProfile() async {
    await _loadUserProfile();
  }

  Future<void> updateProfile({
    String? fullName,
    String? avatarUrl,
  }) async {
    try {
      isLoading.value = true;

      final user = _authService.currentUser;
      if (user == null) {
        Get.offAllNamed('/authentication-screen');
        return;
      }

      await _authService.updateUserProfile({
        if (fullName != null) 'full_name': fullName,
        if (avatarUrl != null) 'avatar_url': avatarUrl,
      });

      await _loadUserProfile();

      Get.snackbar(
        'Sucesso',
        'Perfil atualizado com sucesso!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Não foi possível atualizar o perfil: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
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
    selectedIndex.value = index;
    if (index == 0) {
      Get.offNamed('/homepage-screen');
    } else if (index == 1) {
      Get.offNamed('/deck-listing-screen');
    }
  }

  void onEditProfile() {
    final nameController = TextEditingController(text: userName.value);
    String? selectedImagePath;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.h),
        ),
        child: StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.all(24.h),
              width: 360.h,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Editar Perfil',
                    style: TextStyleHelper.instance.title20BoldOpenSans,
                  ),
                  SizedBox(height: 24.h),
                  // Foto de perfil
                  Center(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            // Mostrar opções: câmera ou galeria
                            final source = await Get.dialog<ImageSource>(
                              Dialog(
                                child: Container(
                                  padding: EdgeInsets.all(20.h),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Selecionar foto de perfil',
                                        style: TextStyleHelper.instance.body15RegularOpenSans.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 20.h),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ElevatedButton.icon(
                                            onPressed: () => Get.back(result: ImageSource.camera),
                                            icon: Icon(Icons.camera_alt),
                                            label: Text('Câmera'),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: appTheme.cyan_A700,
                                              foregroundColor: appTheme.white_A700,
                                            ),
                                          ),
                                          ElevatedButton.icon(
                                            onPressed: () => Get.back(result: ImageSource.gallery),
                                            icon: Icon(Icons.photo_library),
                                            label: Text('Galeria'),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: appTheme.cyan_A700,
                                              foregroundColor: appTheme.white_A700,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );

                            if (source != null) {
                              try {
                                final XFile? pickedFile = await _imagePicker.pickImage(
                                  source: source,
                                  imageQuality: 80,
                                  maxWidth: 800,
                                  maxHeight: 800,
                                );

                                if (pickedFile != null) {
                                  setState(() {
                                    selectedImagePath = pickedFile.path;
                                  });
                                }
                              } catch (e) {
                                Get.snackbar(
                                  'Erro',
                                  'Não foi possível selecionar a imagem: ${e.toString()}',
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                              }
                            }
                          },
                          child: Stack(
                            children: [
                              Container(
                                width: 100.h,
                                height: 100.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: appTheme.cyan_A700,
                                    width: 3.h,
                                  ),
                                  color: appTheme.gray_50,
                                ),
                                child: ClipOval(
                                  child: selectedImagePath != null
                                      ? Image.file(
                                          File(selectedImagePath!),
                                          fit: BoxFit.cover,
                                        )
                                      : avatarUrl.value.isNotEmpty
                                          ? Image.network(
                                              avatarUrl.value,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) {
                                                return Icon(
                                                  Icons.person,
                                                  size: 50.h,
                                                  color: appTheme.greyCustom,
                                                );
                                              },
                                            )
                                          : Icon(
                                              Icons.person,
                                              size: 50.h,
                                              color: appTheme.greyCustom,
                                            ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: EdgeInsets.all(4.h),
                                  decoration: BoxDecoration(
                                    color: appTheme.cyan_A700,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: appTheme.white_A700,
                                      width: 2.h,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.camera_alt,
                                    size: 16.h,
                                    color: appTheme.white_A700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Toque para alterar a foto',
                          style: TextStyleHelper.instance.body14LightOpenSans.copyWith(
                            color: appTheme.greyCustom,
                            fontSize: 12.fSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'Nome',
                    style: TextStyleHelper.instance.body15RegularOpenSans.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: 'Digite seu nome',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.h),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.h,
                        vertical: 12.h,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: Text(
                          'Cancelar',
                          style: TextStyleHelper.instance.body15RegularOpenSans
                              .copyWith(color: appTheme.greyCustom),
                        ),
                      ),
                      SizedBox(width: 12.h),
                      ElevatedButton(
                        onPressed: () async {
                          if (nameController.text.trim().isEmpty) {
                            Get.snackbar(
                              'Erro',
                              'Por favor, insira um nome',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                            return;
                          }

                          Get.back();

                          // Upload da imagem se houver
                          String? uploadedImageUrl;
                          if (selectedImagePath != null) {
                            try {
                              isLoading.value = true;
                              uploadedImageUrl = await _storageService.uploadAvatar(
                                File(selectedImagePath!),
                              );
                            } catch (e) {
                              Get.snackbar(
                                'Erro',
                                'Não foi possível fazer upload da imagem: ${e.toString()}',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                              isLoading.value = false;
                              return;
                            }
                          }

                          await updateProfile(
                            fullName: nameController.text.trim(),
                            avatarUrl: uploadedImageUrl,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: appTheme.cyan_A700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.h),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.h,
                            vertical: 12.h,
                          ),
                        ),
                        child: Text(
                          'Salvar',
                          style: TextStyleHelper.instance.body15RegularOpenSans
                              .copyWith(color: appTheme.white_A700),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void onSettings() {
    Get.toNamed('/settings-screen');
  }

  @override
  void onClose() {
    super.onClose();
  }
}