import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class CardItemWidget extends StatelessWidget {
  final int cardNumber;
  final String question;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const CardItemWidget({
    Key? key,
    required this.cardNumber,
    required this.question,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.h),
      decoration: BoxDecoration(
        color: appTheme.white_A700,
        border: Border(
          bottom: BorderSide(
            color: appTheme.greyCustom.withAlpha(51),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Card number
          Container(
            width: 32.h,
            alignment: Alignment.centerLeft,
            child: Text(
              '$cardNumber',
              style: TextStyleHelper.instance.body15RegularOpenSans.copyWith(
                fontWeight: FontWeight.w600,
                color: appTheme.cyan_A700,
              ),
            ),
          ),
          SizedBox(width: 12.h),
          // Card icon
          Icon(
            Icons.credit_card,
            color: appTheme.cyan_A700,
            size: 24.h,
          ),
          SizedBox(width: 12.h),
          // Question text
          Expanded(
            child: Text(
              question,
              style: TextStyleHelper.instance.body15RegularOpenSans.copyWith(
                color: appTheme.cyan_A700,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 12.h),
          // Delete button
          GestureDetector(
            onTap: onDelete,
            child: Icon(
              Icons.close,
              color: Colors.red,
              size: 24.h,
            ),
          ),
          SizedBox(width: 16.h),
          // Edit button
          GestureDetector(
            onTap: onEdit,
            child: Icon(
              Icons.edit,
              color: appTheme.cyan_A700,
              size: 24.h,
            ),
          ),
        ],
      ),
    );
  }
}
