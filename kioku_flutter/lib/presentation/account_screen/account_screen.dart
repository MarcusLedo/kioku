import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import './controller/account_controller.dart';
import './widgets/menu_item_widget.dart';

class AccountScreen extends GetWidget<AccountController> {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.cyan_A700,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    _buildUserCard(),
                    SizedBox(height: 20.h),
                    _buildMenuCard(),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
            _buildBottomNavigationBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    // Verifica se pode voltar (se há uma rota anterior na pilha)
    final canPop = Navigator.canPop(context);
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 16.h),
      child: Row(
        children: [
          // Só mostra o botão de voltar se houver uma rota anterior
          if (canPop) ...[
            GestureDetector(
              onTap: () => Get.back(),
              child: Icon(
                Icons.arrow_back,
                color: appTheme.white_A700,
                size: 28.h,
              ),
            ),
            SizedBox(width: 16.h),
          ],
          Text(
            'Conta',
            style: TextStyleHelper.instance.body18RegularOpenSans.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 20.fSize,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.h),
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: appTheme.white_A700,
        borderRadius: BorderRadius.circular(16.h),
      ),
      child: Row(
        children: [
          Container(
            width: 50.h,
            height: 50.h,
            decoration: BoxDecoration(
              color: appTheme.cyan_A700,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person,
              color: appTheme.white_A700,
              size: 30.h,
            ),
          ),
          SizedBox(width: 16.h),
          Text(
            'Usuário',
            style: TextStyleHelper.instance.body18RegularOpenSans.copyWith(
              color: appTheme.cyan_A700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.h),
      decoration: BoxDecoration(
        color: appTheme.white_A700,
        borderRadius: BorderRadius.circular(16.h),
      ),
      child: Column(
        children: [
          MenuItemWidget(
            icon: Icons.person,
            title: 'Perfil',
            onTap: controller.onProfileTap,
          ),
          Divider(
            height: 1.h,
            thickness: 1.h,
            color: appTheme.grey200,
            indent: 20.h,
            endIndent: 20.h,
          ),
          MenuItemWidget(
            icon: Icons.layers,
            title: 'Seus Decks',
            onTap: controller.onDecksTap,
          ),
          Divider(
            height: 1.h,
            thickness: 1.h,
            color: appTheme.grey200,
            indent: 20.h,
            endIndent: 20.h,
          ),
          MenuItemWidget(
            icon: Icons.workspace_premium,
            title: 'Associação',
            onTap: controller.onAssociationsTap,
          ),
          Divider(
            height: 1.h,
            thickness: 1.h,
            color: appTheme.grey200,
            indent: 20.h,
            endIndent: 20.h,
          ),
          MenuItemWidget(
            icon: Icons.settings,
            title: 'Configurações',
            onTap: controller.onSettingsTap,
          ),
          Divider(
            height: 1.h,
            thickness: 1.h,
            color: appTheme.grey200,
            indent: 20.h,
            endIndent: 20.h,
          ),
          MenuItemWidget(
            icon: Icons.delete_forever,
            title: 'Excluir Conta',
            onTap: controller.showDeleteAccountConfirmationDialog,
            textColor: Colors.red[700],
            iconColor: Colors.red[700],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: appTheme.white_A700,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 10.h,
            offset: Offset(0, -2.h),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 0),
          _buildNavItem(Icons.psychology, 1),
          _buildNavItem(Icons.person, 2),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    return GestureDetector(
      onTap: () => controller.onBottomNavTap(index),
      child: Obx(() => Icon(
            icon,
            size: 32.h,
            color: controller.selectedIndex.value == index
                ? appTheme.cyan_A700
                : appTheme.greyCustom,
          )),
    );
  }
}