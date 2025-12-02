import 'package:flutter/material.dart';

import '../core/app_export.dart';

/**
 * A customizable button component that supports outlined styling with configurable
 * text, colors, dimensions, and spacing properties.
 * 
 * @param text - The button text content
 * @param onPressed - Callback function when button is tapped
 * @param textColor - Color of the button text
 * @param borderColor - Color of the button border
 * @param backgroundColor - Background color of the button
 * @param width - Width of the button
 * @param height - Height of the button
 * @param padding - Internal padding of the button
 * @param margin - External margin around the button
 * @param borderRadius - Corner radius of the button
 * @param fontSize - Font size of the button text
 * @param fontWeight - Font weight of the button text
 * @param fontFamily - Font family of the button text
 */
class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.textColor,
    this.borderColor,
    this.backgroundColor,
    required this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius,
    this.fontSize,
    this.fontWeight,
    this.fontFamily,
  }) : super(key: key);

  /// The text to display on the button
  final String text;

  /// Callback function when button is pressed
  final VoidCallback? onPressed;

  /// Color of the button text
  final Color? textColor;

  /// Color of the button border
  final Color? borderColor;

  /// Background color of the button
  final Color? backgroundColor;

  /// Width of the button
  final double width;

  /// Height of the button
  final double? height;

  /// Internal padding of the button
  final EdgeInsets? padding;

  /// External margin around the button
  final EdgeInsets? margin;

  /// Corner radius of the button
  final double? borderRadius;

  /// Font size of the button text
  final double? fontSize;

  /// Font weight of the button text
  final FontWeight? fontWeight;

  /// Font family of the button text
  final String? fontFamily;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height ?? 37.h,
      margin: margin ?? EdgeInsets.only(top: 14.h),
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor ?? appTheme.transparentCustom,
          padding: padding ??
              EdgeInsets.symmetric(
                horizontal: 12.h,
                vertical: 8.h,
              ),
          side: BorderSide(
            color: borderColor ?? Color(0xFF005F6B),
            width: 1.h,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 8.h),
          ),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          text,
          style: TextStyleHelper.instance.textStyle5
              .copyWith(color: textColor ?? Color(0xFF005F6B), height: 1.4),
        ),
      ),
    );
  }
}
