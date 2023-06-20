import 'package:flutter/material.dart';
import 'ps_colors.dart';
import 'ps_config.dart';

ThemeData themeData(ThemeData baseTheme) {
  //final baseTheme = ThemeData.light();

  if (baseTheme.brightness == Brightness.dark) {
    PsColors.loadColor2(false);

    // Dark Theme
    return baseTheme.copyWith(
      primaryColor: PsColors.mainColor,
      primaryColorDark: PsColors.mainDarkColor,
      primaryColorLight: PsColors.mainLightColor,
      textTheme: TextTheme(
        displayLarge: TextStyle(
            color: PsColors.textPrimaryColor,
            fontFamily: PsConfig.ps_default_font_family),
        displayMedium: TextStyle(
            color: PsColors.textPrimaryColor,
            fontFamily: PsConfig.ps_default_font_family),
        displaySmall: TextStyle(
            color: PsColors.textPrimaryColor,
            fontFamily: PsConfig.ps_default_font_family),
        headlineMedium: TextStyle(
          color: PsColors.textPrimaryColor,
          fontFamily: PsConfig.ps_default_font_family,
        ),
        headlineSmall: TextStyle(
            color: PsColors.textPrimaryColor,
            fontFamily: PsConfig.ps_default_font_family,
            fontWeight: FontWeight.bold),
        titleLarge: TextStyle(
            color: PsColors.textPrimaryColor,
            fontFamily: PsConfig.ps_default_font_family),
        titleMedium: TextStyle(
            color: PsColors.textPrimaryColor,
            fontFamily: PsConfig.ps_default_font_family,
            fontWeight: FontWeight.bold),
        titleSmall: TextStyle(
            color: PsColors.textPrimaryColor,
            fontFamily: PsConfig.ps_default_font_family,
            fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(
          color: PsColors.textPrimaryColor,
          fontFamily: PsConfig.ps_default_font_family,
        ),
        bodyMedium: TextStyle(
            color: PsColors.textPrimaryColor,
            fontFamily: PsConfig.ps_default_font_family,
            fontWeight: FontWeight.bold),
        labelLarge: TextStyle(
            color: PsColors.textPrimaryColor,
            fontFamily: PsConfig.ps_default_font_family),
        bodySmall: TextStyle(
            color: PsColors.textPrimaryLightColor,
            fontFamily: PsConfig.ps_default_font_family),
        labelSmall: TextStyle(
            color: PsColors.textPrimaryColor,
            fontFamily: PsConfig.ps_default_font_family),
      ),
      iconTheme: IconThemeData(color: PsColors.iconColor),
      appBarTheme: AppBarTheme(color: PsColors.coreBackgroundColor),
    );
  } else {
    PsColors.loadColor2(true);
    // White Theme
    return baseTheme.copyWith(
        primaryColor: PsColors.mainColor,
        primaryColorDark: PsColors.mainDarkColor,
        primaryColorLight: PsColors.mainLightColor,
        textTheme: TextTheme(
          displayLarge: TextStyle(
              color: PsColors.textPrimaryColor,
              fontFamily: PsConfig.ps_default_font_family),
          displayMedium: TextStyle(
              color: PsColors.textPrimaryColor,
              fontFamily: PsConfig.ps_default_font_family),
          displaySmall: TextStyle(
              color: PsColors.textPrimaryColor,
              fontFamily: PsConfig.ps_default_font_family),
          headlineMedium: TextStyle(
            color: PsColors.textPrimaryColor,
            fontFamily: PsConfig.ps_default_font_family,
          ),
          headlineSmall: TextStyle(
              color: PsColors.textPrimaryColor,
              fontFamily: PsConfig.ps_default_font_family,
              fontWeight: FontWeight.bold),
          titleLarge: TextStyle(
              color: PsColors.textPrimaryColor,
              fontFamily: PsConfig.ps_default_font_family),
          titleMedium: TextStyle(
              color: PsColors.textPrimaryColor,
              fontFamily: PsConfig.ps_default_font_family,
              fontWeight: FontWeight.bold),
          titleSmall: TextStyle(
              color: PsColors.textPrimaryColor,
              fontFamily: PsConfig.ps_default_font_family,
              fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(
            color: PsColors.textPrimaryColor,
            fontFamily: PsConfig.ps_default_font_family,
          ),
          bodyMedium: TextStyle(
              color: PsColors.textPrimaryColor,
              fontFamily: PsConfig.ps_default_font_family,
              fontWeight: FontWeight.bold),
          labelLarge: TextStyle(
              color: PsColors.textPrimaryColor,
              fontFamily: PsConfig.ps_default_font_family),
          bodySmall: TextStyle(
              color: PsColors.textPrimaryLightColor,
              fontFamily: PsConfig.ps_default_font_family),
          labelSmall: TextStyle(
              color: PsColors.textPrimaryColor,
              fontFamily: PsConfig.ps_default_font_family),
        ),
        iconTheme: IconThemeData(color: PsColors.iconColor),
        appBarTheme: AppBarTheme(color: PsColors.coreBackgroundColor));
  }
}
