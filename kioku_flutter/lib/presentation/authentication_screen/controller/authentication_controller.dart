import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import '../models/authentication_model.dart';
import '../../../services/supabase_auth_service.dart';

class AuthenticationController extends GetxController {
  Rx<AuthenticationModel> authenticationModelObj = AuthenticationModel().obs;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final SupabaseAuthService _authService = SupabaseAuthService();

  RxBool isLoading = false.obs;
  RxBool obscurePassword = true.obs;
  
  bool _isDisposed = false;

  @override
  void onInit() {
    super.onInit();
    // Check if user is already authenticated
    if (_authService.isAuthenticated) {
      // Usa postFrameCallback para evitar navegação durante build
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Get.offAllNamed('/homepage-screen');
      });
    }
  }

  @override
  void onClose() {
    _isDisposed = true;
    // Limpa os dados dos controllers
    emailController.clear();
    passwordController.clear();
    // Descarta os controllers - agora é seguro porque o CustomEditText
    // usa controllers locais que são gerenciados pelo ciclo de vida do widget
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
  
  bool get isDisposed => _isDisposed;

  void togglePasswordVisibility() {
    if (_isDisposed) return;
    obscurePassword.value = !obscurePassword.value;
  }

  Future<void> onLoginTap() async {
    if (_isDisposed) return;
    if (!_validateInputs()) return;

    isLoading.value = true;

    try {
      final response = await _authService.signIn(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (response.user != null) {
        Get.offAllNamed('/homepage-screen');
        Get.snackbar(
          'Sucesso',
          'Login realizado com sucesso!',
          backgroundColor: Colors.green[100],
          colorText: Colors.green[900],
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (error) {
      Get.snackbar(
        'Erro',
        'Email ou senha incorretos',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      if (!_isDisposed) {
        isLoading.value = false;
      }
    }
  }

  void onSignUpTap() {
    Get.toNamed('/signup-screen');
  }

  bool _validateInputs() {
    if (_isDisposed) return false;
    
    if (emailController.text.trim().isEmpty) {
      Get.snackbar(
        'Erro',
        'Por favor, insira seu email',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (!GetUtils.isEmail(emailController.text.trim())) {
      Get.snackbar(
        'Erro',
        'Por favor, insira um email válido',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (passwordController.text.isEmpty) {
      Get.snackbar(
        'Erro',
        'Por favor, insira sua senha',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (passwordController.text.length < 6) {
      Get.snackbar(
        'Erro',
        'A senha deve ter pelo menos 6 caracteres',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    return true;
  }
}
