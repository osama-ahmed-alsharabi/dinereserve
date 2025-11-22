import 'package:dinereserve/core/helpers/text_responsive_helper.dart';
import 'package:flutter/widgets.dart';

class AppTextStyle {
  final BuildContext context;

  AppTextStyle(this.context);

  TextStyle get text10Regular => TextStyle(
    fontSize: TextResponsiveHelper.responsiveText(
      fontSize: 10,
      context: context,
    ),
    fontWeight: FontWeight.w400,
  );

  TextStyle get text12Regular => TextStyle(
    fontSize: TextResponsiveHelper.responsiveText(
      fontSize: 12,
      context: context,
    ),
    fontWeight: FontWeight.w400,
  );

  TextStyle get text14Regular => TextStyle(
    fontSize: TextResponsiveHelper.responsiveText(
      fontSize: 14,
      context: context,
    ),
    fontWeight: FontWeight.w400,
  );

  TextStyle get text14Bold => TextStyle(
    fontSize: TextResponsiveHelper.responsiveText(
      fontSize: 14,
      context: context,
    ),
    fontWeight: FontWeight.bold,
  );

  TextStyle get text16Regular => TextStyle(
    fontSize: TextResponsiveHelper.responsiveText(
      fontSize: 16,
      context: context,
    ),
    fontWeight: FontWeight.w400,
  );

  TextStyle get text16Bold => TextStyle(
    fontSize: TextResponsiveHelper.responsiveText(
      fontSize: 16,
      context: context,
    ),
    fontWeight: FontWeight.bold,
  );

  TextStyle get text18SemiBold => TextStyle(
    fontSize: TextResponsiveHelper.responsiveText(
      fontSize: 18,
      context: context,
    ),
    fontWeight: FontWeight.w600,
  );

  TextStyle get text20Bold => TextStyle(
    fontSize: TextResponsiveHelper.responsiveText(
      fontSize: 20,
      context: context,
    ),
    fontWeight: FontWeight.bold,
  );

  TextStyle get text20Mediam => TextStyle(
    fontSize: TextResponsiveHelper.responsiveText(
      fontSize: 20,
      context: context,
    ),
    fontWeight: FontWeight.w500,
  );

  TextStyle get text24Bold => TextStyle(
    fontSize: TextResponsiveHelper.responsiveText(
      fontSize: 24,
      context: context,
    ),
    fontWeight: FontWeight.bold,
  );

  TextStyle get text28Bold => TextStyle(
    fontSize: TextResponsiveHelper.responsiveText(
      fontSize: 28,
      context: context,
    ),
    fontWeight: FontWeight.bold,
  );
}

extension AppTextStyleExtension on BuildContext {
  AppTextStyle get textStyle => AppTextStyle(this);
}
