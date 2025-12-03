import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class AnswerButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isCorrect;
  final bool isRevealed;
  final bool isSelected;

  const AnswerButtonWidget({
    Key? key,
    required this.text,
    required this.onTap,
    this.isCorrect = false,
    this.isRevealed = false,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = appTheme.cyan_A700;
    
    if (isRevealed) {
      if (isCorrect) {
        backgroundColor = Colors.green;
      } else if (isSelected && !isCorrect) {
        backgroundColor = Colors.red;
      } else {
        backgroundColor = appTheme.cyan_A700.withOpacity(0.5);
      }
    } else if (isSelected) {
      backgroundColor = appTheme.cyan_900;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.h),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12.h),
          border: isSelected && !isRevealed
              ? Border.all(color: appTheme.white_A700, width: 2)
              : null,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyleHelper.instance.body18RegularOpenSans.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 16.h,
              color: appTheme.white_A700,
            ),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
