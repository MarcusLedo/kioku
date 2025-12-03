import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class MenuItemWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? textColor;
  final Color? iconColor;

  const MenuItemWidget({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.textColor,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 16.h),
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor ?? appTheme.cyan_A700,
              size: 24.h,
            ),
            SizedBox(width: 16.h),
            Text(
              title,
              style: TextStyleHelper.instance.body15RegularOpenSans.copyWith(
                color: textColor ?? appTheme.cyan_A700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
