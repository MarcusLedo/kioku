import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_edit_text.dart';
import '../../widgets/custom_image_view.dart';
import './controller/authentication_controller.dart';

class AuthenticationScreen extends GetWidget<AuthenticationController> {
  AuthenticationScreen({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.cyan_A700,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            padding: EdgeInsets.only(top: 80.h),
            child: Column(
              spacing: 80.h,
              children: [
                _buildKiokuIcon(),
                _buildLoginCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKiokuIcon() {
    return CustomImageView(
      imagePath: ImageConstant.imgVector,
      width: 152.h,
      height: 136.h,
    );
  }

  Widget _buildLoginCard() {
    return Container(
      width: 280.h,
      decoration: BoxDecoration(
        color: appTheme.gray_50,
        borderRadius: BorderRadius.circular(32.h),
      ),
      padding: EdgeInsets.symmetric(horizontal: 30.h, vertical: 14.h),
      child: Column(
        children: [
          _buildLoginTitle(),
          _buildUsernameField(),
          _buildPasswordField(),
          _buildForgotPasswordLink(),
          _buildRegisterLink(),
          _buildLoginButton(),
        ],
      ),
    );
  }

  Widget _buildLoginTitle() {
    return Container(
      margin: EdgeInsets.only(top: 6.h),
      child: Text(
        "LOGIN",
        style: TextStyleHelper.instance.title20BoldOpenSans,
      ),
    );
  }

  Widget _buildUsernameField() {
    return Container(
      margin: EdgeInsets.only(top: 10.h, left: 2.h),
      child: Column(
        spacing: 4.h,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Usuário",
            style: TextStyleHelper.instance.body15RegularOpenSans,
          ),
          // Verifica se o GetX controller ainda está registrado antes de usar
          Get.isRegistered<AuthenticationController>() && !controller.isDisposed
              ? CustomEditText(
                  controller: controller.emailController,
                  hintText: "Digite seu usuário",
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      margin: EdgeInsets.only(top: 8.h, left: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Senha",
            style: TextStyleHelper.instance.body15RegularOpenSans,
          ),
          SizedBox(height: 4.h),
          Obx(() {
            // Verifica se o GetX controller ainda está registrado antes de usar
            if (!Get.isRegistered<AuthenticationController>() || controller.isDisposed) {
              return SizedBox.shrink();
            }
            return CustomEditText(
              controller: controller.passwordController,
              hintText: "Digite sua senha",
              keyboardType: TextInputType.visiblePassword,
              obscureText: controller.obscurePassword.value,
              suffixIcon: IconButton(
                icon: Icon(
                  !controller.obscurePassword.value
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: appTheme.cyan_900,
                  size: 20.h,
                ),
                onPressed: controller.isDisposed 
                    ? null 
                    : controller.togglePasswordVisibility,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildForgotPasswordLink() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.only(top: 8.h),
        child: Text(
          "Esqueceu senha? Clique aqui",
          style: TextStyleHelper.instance.body14LightOpenSans,
        ),
      ),
    );
  }

  Widget _buildRegisterLink() {
    return GestureDetector(
      onTap: controller.onSignUpTap,
      child: Container(
        margin: EdgeInsets.only(top: 2.h),
        child: Text(
          "Cadastre-se aqui!",
          style: TextStyleHelper.instance.body14LightOpenSans,
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Obx(() => CustomButton(
          text: "Entrar",
          width: 100.h,
          onPressed: controller.isLoading.value
              ? null
              : controller.onLoginTap,
          margin: EdgeInsets.only(top: 14.h),
        ));
  }
}