import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../controller/profile_controller.dart';

class PersonalInfoCardWidget extends GetWidget<ProfileController> {
  const PersonalInfoCardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.h),
      padding: EdgeInsets.all(20.h),
      decoration: BoxDecoration(
        color: appTheme.white_A700,
        borderRadius: BorderRadius.circular(16.h),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informação Pessoal',
            style: TextStyleHelper.instance.body14LightOpenSans.copyWith(
              color: appTheme.greyCustom,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 20.h),
          Obx(() => _buildInfoRow('Nome', controller.userName.value, false)),
          SizedBox(height: 16.h),
          Obx(() => _buildInfoRow('E-mail', controller.userEmail.value, false)),
          SizedBox(height: 16.h),
          Obx(() => _buildInfoRow('Streak Atual', '${controller.currentStreak.value} dias', false)),
          SizedBox(height: 16.h),
          Obx(() => _buildInfoRow('Maior Streak', '${controller.longestStreak.value} dias', false)),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, bool isLink) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyleHelper.instance.body14LightOpenSans.copyWith(
            color: appTheme.greyCustom,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Text(
              value,
              style: TextStyleHelper.instance.body18RegularOpenSans.copyWith(
                color: appTheme.cyan_A700,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (isLink) ...[
              GestureDetector(
                onTap: () {},
                child: Text(
                  '<link to shared decks>',
                  style:
                      TextStyleHelper.instance.body14LightOpenSans.copyWith(
                    color: appTheme.cyan_A700,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}