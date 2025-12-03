import 'package:flutter/material.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_image_view.dart';
import './controller/homepage_controller.dart';
import './widgets/streak_calendar_widget.dart';
import './widgets/deck_card_widget.dart';

class HomepageScreen extends GetWidget<HomepageController> {
  const HomepageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.cyan_A700,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildStreakSection(),
                    SizedBox(height: 24.h),
                    _buildDecksSection(),
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

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgVector,
                width: 40.h,
                height: 40.h,
                color: appTheme.white_A700,
              ),
              SizedBox(width: 12.h),
              Text(
                'Kioku',
                style: TextStyleHelper.instance.body18RegularOpenSans.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: controller.onSettingsTap,
            icon: Icon(
              Icons.settings,
              color: appTheme.white_A700,
              size: 28.h,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.h),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.local_fire_department,
                color: Colors.orange,
                size: 32.h,
              ),
              SizedBox(width: 8.h),
              Text(
                'Streak',
                style: TextStyleHelper.instance.body18RegularOpenSans.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          const StreakCalendarWidget(),
        ],
      ),
    );
  }

  Widget _buildDecksSection() {
    return Container(
      decoration: BoxDecoration(
        color: appTheme.cyan_900,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32.h),
          topRight: Radius.circular(32.h),
        ),
      ),
      padding: EdgeInsets.all(20.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Decks Recentes',
                style: TextStyleHelper.instance.body18RegularOpenSans.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: controller.onViewAllDecks,
                child: Text(
                  'Veja todos',
                  style:
                      TextStyleHelper.instance.body15RegularOpenSans.copyWith(
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Obx(() {
            if (controller.recentDecks.isEmpty) {
              return Container(
                padding: EdgeInsets.symmetric(vertical: 40.h),
                child: Center(
                  child: Text(
                    'Nenhum deck criado ainda',
                    style: TextStyleHelper.instance.body15RegularOpenSans.copyWith(
                      color: appTheme.greyCustom,
                    ),
                  ),
                ),
              );
            }
            
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: controller.recentDecks.map((deck) {
                  // Converte icon_name para IconData
                  IconData iconData = _getIconFromName(deck['icon_name'] as String? ?? 'book');
                  
                  return DeckCardWidget(
                    deckId: deck['id'] as String? ?? '',
                    title: deck['title'] as String? ?? 'Deck sem título',
                    totalCards: (deck['total_cards'] as int?) ?? 0,
                    studiedCards: (deck['last_study_correct_answers'] as int?) ?? 0,
                    icon: iconData,
                    isImported: (deck['is_imported'] as bool?) ?? false,
                    onTap: () => controller.onDeckTap(
                      deck['id'] as String? ?? '',
                      deck['title'] as String? ?? 'Deck',
                    ),
                  );
                }).toList(),
              ),
            );
          }),
          SizedBox(height: 80.h),
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

  IconData _getIconFromName(String iconName) {
    switch (iconName) {
      case 'psychology':
        return Icons.psychology;
      case 'school':
        return Icons.school;
      case 'book':
        return Icons.book;
      case 'lightbulb':
        return Icons.lightbulb;
      case 'science':
        return Icons.science;
      case 'calculate':
        return Icons.calculate;
      case 'language':
        return Icons.language;
      case 'history':
        return Icons.history;
      case 'public':
        return Icons.public;
      case 'code':
        return Icons.code;
      case 'medical_services':
        return Icons.medical_services;
      case 'business':
        return Icons.business;
      default:
        return Icons.book;
    }
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
