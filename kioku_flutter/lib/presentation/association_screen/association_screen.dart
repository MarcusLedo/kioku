import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import './controller/association_controller.dart';
import './widgets/association_menu_item_widget.dart';

class AssociationScreen extends GetWidget<AssociationController> {
  const AssociationScreen({Key? key}) : super(key: key);

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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 16.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Icon(
              Icons.arrow_back,
              color: appTheme.white_A700,
              size: 28.h,
            ),
          ),
          SizedBox(width: 16.h),
          Text(
            'Associação',
            style: TextStyleHelper.instance.body18RegularOpenSans.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 20.fSize,
              color: appTheme.white_A700,
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
          AssociationMenuItemWidget(
            title: 'Pagamentos',
            onTap: () {},
          ),
          Divider(
            height: 1.h,
            thickness: 1.h,
            color: appTheme.grey200,
            indent: 20.h,
            endIndent: 20.h,
          ),
          AssociationMenuItemWidget(
            title: 'Cancelar Associação',
            onTap: () {},
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