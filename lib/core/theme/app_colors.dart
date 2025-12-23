import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary backgrounds (deep slate)
  static const Color backgroundPrimary = Color(0xFF13161c);
  static const Color backgroundSecondary = Color(0xFF1a1f2a);
  static const Color backgroundTertiary = Color(0xFF242a38);

  // Accent colors
  static const Color accentCyan = Color(0xFF38bdf8);
  static const Color accentCyanDim = Color(0xFF1e6b8c);
  static const Color accentNeonBlue = Color(0xFF0ea5e9);
  static const Color accentPurple = Color(0xFF8b5cf6);
  static const Color accentPink = Color(0xFFec4899);

  // Grid and structure
  static const Color gridLine = Color(0xFF2a3142);
  static const Color gridLineFaint = Color(0xFF1f2635);
  static const Color borderActive = Color(0xFF38bdf8);

  // Text colors
  static const Color textPrimary = Color(0xFFe2e8f0);
  static const Color textSecondary = Color(0xFF94a3b8);
  static const Color textMuted = Color(0xFF64748b);
  static const Color textAccent = Color(0xFF38bdf8);

  // Status colors
  static const Color statusSuccess = Color(0xFF22c55e);
  static const Color statusWarning = Color(0xFFf59e0b);
  static const Color statusError = Color(0xFFef4444);
  static const Color statusProcessing = Color(0xFF38bdf8);

  // Gradients
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [backgroundPrimary, backgroundSecondary],
  );

  static LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentCyan, accentNeonBlue],
  );
}
