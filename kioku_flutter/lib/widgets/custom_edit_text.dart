import 'package:flutter/material.dart';
import '../core/app_export.dart';

/**
 * CustomEditText - A reusable text input field component with consistent styling
 * 
 * Features:
 * - Consistent border styling with teal color (#005f6b)
 * - Rounded corners with 8px radius
 * - Built-in padding and responsive design
 * - Validation support for form handling
 * - Keyboard type customization
 * - Placeholder text support
 * - Date picker integration for date inputs
 * - Password visibility toggle for secure text input
 * 
 * @param controller - TextEditingController for managing text input
 * @param hintText - Placeholder text displayed when field is empty
 * @param validator - Function to validate input text
 * @param keyboardType - Type of keyboard to display
 * @param onTap - Callback function when field is tapped
 * @param readOnly - Whether the field is read-only
 * @param maxLines - Maximum number of lines for text input
 * @param obscureText - Whether to hide the text (for passwords)
 * @param suffixIcon - Optional icon widget to show at the end of the field
 */
class CustomEditText extends StatelessWidget {
  const CustomEditText({
    Key? key,
    this.controller,
    this.hintText,
    this.validator,
    this.keyboardType,
    this.onTap,
    this.readOnly,
    this.maxLines,
    this.obscureText,
    this.suffixIcon,
  }) : super(key: key);

  /// Controller for managing the text input
  final TextEditingController? controller;

  /// Placeholder text shown when the field is empty
  final String? hintText;

  /// Function to validate the input text
  final String? Function(String?)? validator;

  /// Type of keyboard to display for input
  final TextInputType? keyboardType;

  /// Callback function triggered when the field is tapped
  final VoidCallback? onTap;

  /// Whether the text field is read-only
  final bool? readOnly;

  /// Maximum number of lines for the text input
  final int? maxLines;

  /// Whether to hide the text (for password fields)
  final bool? obscureText;

  /// Optional suffix icon widget
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType ?? TextInputType.text,
      onTap: onTap,
      readOnly: readOnly ?? false,
      maxLines: maxLines ?? 1,
      obscureText: obscureText ?? false,
      decoration: InputDecoration(
        hintText: hintText ?? "",
        contentPadding: EdgeInsets.all(12.h),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.h),
          borderSide: BorderSide(
            color: appTheme.cyan_900,
            width: 1.h,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.h),
          borderSide: BorderSide(
            color: appTheme.cyan_900,
            width: 1.h,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.h),
          borderSide: BorderSide(
            color: appTheme.cyan_900,
            width: 1.h,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.h),
          borderSide: BorderSide(
            color: appTheme.redCustom,
            width: 1.h,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.h),
          borderSide: BorderSide(
            color: appTheme.redCustom,
            width: 1.h,
          ),
        ),
      ),
    );
  }
}
