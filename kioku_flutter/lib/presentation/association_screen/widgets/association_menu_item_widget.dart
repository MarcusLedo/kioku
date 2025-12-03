import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class AssociationMenuItemWidget extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const AssociationMenuItemWidget({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 18.h),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyleHelper.instance.body18RegularOpenSans.copyWith(
                  color: appTheme.cyan_A700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
