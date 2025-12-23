import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTypography {
  AppTypography._();

  static const String fontFamilyMono = 'JetBrainsMono';
  static const String fontFamilyBody = 'Inter';

  static TextTheme get textTheme => const TextTheme(
        // Display styles - Inter
        displayLarge: TextStyle(
          fontFamily: fontFamilyBody,
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          letterSpacing: -0.5,
        ),
        displayMedium: TextStyle(
          fontFamily: fontFamilyBody,
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          letterSpacing: -0.5,
        ),
        displaySmall: TextStyle(
          fontFamily: fontFamilyBody,
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),

        // Headline styles - Inter
        headlineLarge: TextStyle(
          fontFamily: fontFamilyBody,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        headlineMedium: TextStyle(
          fontFamily: fontFamilyBody,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        headlineSmall: TextStyle(
          fontFamily: fontFamilyBody,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),

        // Title styles - Inter
        titleLarge: TextStyle(
          fontFamily: fontFamilyBody,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleMedium: TextStyle(
          fontFamily: fontFamilyBody,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleSmall: TextStyle(
          fontFamily: fontFamilyBody,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),

        // Body styles - Inter
        bodyLarge: TextStyle(
          fontFamily: fontFamilyBody,
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: AppColors.textPrimary,
        ),
        bodyMedium: TextStyle(
          fontFamily: fontFamilyBody,
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: AppColors.textSecondary,
        ),
        bodySmall: TextStyle(
          fontFamily: fontFamilyBody,
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: AppColors.textMuted,
        ),

        // Label styles - JetBrains Mono (technical/data)
        labelLarge: TextStyle(
          fontFamily: fontFamilyMono,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textAccent,
          letterSpacing: 0.5,
        ),
        labelMedium: TextStyle(
          fontFamily: fontFamilyMono,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.textAccent,
          letterSpacing: 0.5,
        ),
        labelSmall: TextStyle(
          fontFamily: fontFamilyMono,
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: AppColors.textMuted,
          letterSpacing: 0.5,
        ),
      );

  // Terminal/code text styles
  static const TextStyle terminalText = TextStyle(
    fontFamily: fontFamilyMono,
    fontSize: 13,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    letterSpacing: 0.3,
    height: 1.5,
  );

  static const TextStyle terminalPrompt = TextStyle(
    fontFamily: fontFamilyMono,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.accentCyan,
    letterSpacing: 0.3,
  );

  static const TextStyle dataLabel = TextStyle(
    fontFamily: fontFamilyMono,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
    letterSpacing: 1.0,
  );

  static const TextStyle dataValue = TextStyle(
    fontFamily: fontFamilyMono,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
  );
}
