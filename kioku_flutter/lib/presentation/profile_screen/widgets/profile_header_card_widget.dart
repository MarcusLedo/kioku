import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_image_view.dart';
import '../controller/profile_controller.dart';

class ProfileHeaderCardWidget extends GetWidget<ProfileController> {
  const ProfileHeaderCardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.h),
      decoration: BoxDecoration(
        color: appTheme.white_A700,
        borderRadius: BorderRadius.circular(16.h),
      ),
      child: Column(
        children: [
          _buildBackgroundImage(),
          SizedBox(height: 40.h),
          _buildProfileSection(),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Container(
      height: 120.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.h),
          topRight: Radius.circular(16.h),
        ),
        image: const DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1506905925346-21bda4d32df4',
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Column(
      children: [
        Container(
          transform: Matrix4.translationValues(0, -50.h, 0),
          child: Container(
            width: 100.h,
            height: 100.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: appTheme.white_A700,
                width: 4.h,
              ),
            ),
            child: ClipOval(
              child: Obx(() {
                if (controller.avatarUrl.value.isNotEmpty) {
                  return CustomImageView(
                    imagePath: controller.avatarUrl.value,
                    fit: BoxFit.cover,
                  );
                }
                return Container(
                  color: appTheme.cyan_A700,
                  child: Icon(
                    Icons.person,
                    size: 50.h,
                    color: appTheme.white_A700,
                  ),
                );
              }),
            ),
          ),
        ),
        Transform.translate(
          offset: Offset(0, -30.h),
          child: Column(
            children: [
              Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        controller.userName.value,
                        style: TextStyleHelper.instance.body18RegularOpenSans.copyWith(
                          color: appTheme.cyan_A700,
                          fontWeight: FontWeight.w600,
                          fontSize: 18.fSize,
                        ),
                      ),
                      SizedBox(width: 8.h),
                      Icon(
                        Icons.workspace_premium,
                        color: appTheme.cyan_A700,
                        size: 24.h,
                      ),
                    ],
                  )),
              SizedBox(height: 16.h),
              ElevatedButton.icon(
                onPressed: controller.onEditProfile,
                icon: Icon(
                  Icons.edit,
                  size: 18.h,
                  color: appTheme.white_A700,
                ),
                label: Text(
                  'Edit Profile',
                  style:
                      TextStyleHelper.instance.body14LightOpenSans.copyWith(
                    color: appTheme.white_A700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: appTheme.cyan_A700,
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.h, vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.h),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}