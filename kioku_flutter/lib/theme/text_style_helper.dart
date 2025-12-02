import 'package:flutter/material.dart';
import '../core/app_export.dart';

/// A helper class for managing text styles in the application
class TextStyleHelper {
  static TextStyleHelper? _instance;

  TextStyleHelper._();

  static TextStyleHelper get instance {
    _instance ??= TextStyleHelper._();
    return _instance!;
  }

  // Title Styles
  // Medium text styles for titles and subtitles

  TextStyle get title20RegularRoboto => TextStyle(
        fontSize: 20.fSize,
        fontWeight: FontWeight.w400,
        fontFamily: 'Roboto',
      );

  TextStyle get title20BoldOpenSans => TextStyle(
        fontSize: 20.fSize,
        fontWeight: FontWeight.w700,
        fontFamily: 'Open Sans',
        color: appTheme.cyan_900,
      );

  // Body Styles
  // Standard text styles for body content

  TextStyle get body15RegularOpenSans => TextStyle(
        fontSize: 15.fSize,
        fontWeight: FontWeight.w400,
        fontFamily: 'Open Sans',
        color: appTheme.cyan_900,
      );

  TextStyle get body14LightOpenSans => TextStyle(
        fontSize: 14.fSize,
        fontWeight: FontWeight.w300,
        fontFamily: 'Open Sans',
        color: appTheme.cyan_900,
      );

  TextStyle get body18RegularOpenSans => TextStyle(
        fontSize: 18.fSize,
        fontWeight: FontWeight.w400,
        fontFamily: 'Open Sans',
        color: appTheme.white_A700,
      );

  // Other Styles
  // Miscellaneous text styles without specified font size

  TextStyle get textStyle5 => TextStyle();
}
