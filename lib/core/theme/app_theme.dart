import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.backgroundPrimary,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.accentCyan,
          secondary: AppColors.accentPurple,
          surface: AppColors.backgroundSecondary,
          error: AppColors.statusError,
          onPrimary: AppColors.backgroundPrimary,
          onSecondary: AppColors.textPrimary,
          onSurface: AppColors.textPrimary,
          onError: AppColors.textPrimary,
        ),
        textTheme: AppTypography.textTheme,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.backgroundPrimary,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
        ),
        cardTheme: CardThemeData(
          color: AppColors.backgroundSecondary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(
              color: AppColors.gridLine,
              width: 1,
            ),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accentCyan,
            foregroundColor: AppColors.backgroundPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            textStyle: const TextStyle(
              fontFamily: AppTypography.fontFamilyMono,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.0,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.accentCyan,
            side: const BorderSide(color: AppColors.accentCyan),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            textStyle: const TextStyle(
              fontFamily: AppTypography.fontFamilyMono,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.0,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.backgroundTertiary,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: AppColors.gridLine),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: AppColors.gridLine),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(
              color: AppColors.accentCyan,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: AppColors.statusError),
          ),
          hintStyle: const TextStyle(
            fontFamily: AppTypography.fontFamilyMono,
            color: AppColors.textMuted,
          ),
          labelStyle: const TextStyle(
            fontFamily: AppTypography.fontFamilyMono,
            color: AppColors.textSecondary,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: AppColors.backgroundSecondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.gridLine,
          thickness: 1,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.textSecondary,
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: AppColors.accentCyan,
          linearTrackColor: AppColors.gridLine,
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.backgroundTertiary,
          contentTextStyle: const TextStyle(
            fontFamily: AppTypography.fontFamilyMono,
            color: AppColors.textPrimary,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: const BorderSide(color: AppColors.gridLine),
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
}
