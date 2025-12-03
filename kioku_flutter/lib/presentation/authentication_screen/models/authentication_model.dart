import 'package:get/get.dart';
import '../../../core/app_export.dart';

/// This class is used in the [AuthenticationScreen] screen with GetX.

class AuthenticationModel {
  Rx<String>? username;
  Rx<String>? password;
  Rx<bool>? isRememberMe;
  Rx<String>? errorMessage;

  AuthenticationModel({
    this.username,
    this.password,
    this.isRememberMe,
    this.errorMessage,
  }) {
    username = username ?? Rx("");
    password = password ?? Rx("");
    isRememberMe = isRememberMe ?? Rx(false);
    errorMessage = errorMessage ?? Rx("");
  }
}
