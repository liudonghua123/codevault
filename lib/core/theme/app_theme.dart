import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static TextStyle get codeTextStyle => GoogleFonts.jetBrainsMono(
    fontSize: 14,
    height: 1.5,
  );

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.darkPrimary,
      surface: AppColors.darkBackground,
      onSurface: AppColors.darkForeground,
    ),
    scaffoldBackgroundColor: AppColors.darkBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkSidebarBg,
      foregroundColor: AppColors.darkForeground,
      elevation: 0,
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: AppColors.darkSidebarBg,
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.darkBorder,
      thickness: 1,
    ),
    textTheme: TextTheme(
      bodyMedium: GoogleFonts.inter(
        color: AppColors.darkForeground,
        fontSize: 14,
      ),
    ),
    iconTheme: const IconThemeData(
      color: AppColors.darkForeground,
      size: 20,
    ),
  );

  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: AppColors.lightPrimary,
      surface: AppColors.lightBackground,
      onSurface: AppColors.lightForeground,
    ),
    scaffoldBackgroundColor: AppColors.lightBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightSidebarBg,
      foregroundColor: AppColors.lightForeground,
      elevation: 0,
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: AppColors.lightSidebarBg,
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.lightBorder,
      thickness: 1,
    ),
    textTheme: TextTheme(
      bodyMedium: GoogleFonts.inter(
        color: AppColors.lightForeground,
        fontSize: 14,
      ),
    ),
    iconTheme: const IconThemeData(
      color: AppColors.lightForeground,
      size: 20,
    ),
  );
}