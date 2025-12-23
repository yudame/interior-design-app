import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../shared/widgets/pulse_container.dart';
import '../../../data/models/style_preset.dart';

class StylePresetCard extends StatelessWidget {
  final StylePreset preset;
  final bool isSelected;
  final VoidCallback? onTap;

  const StylePresetCard({
    super.key,
    required this.preset,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 100,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.backgroundTertiary
              : AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? AppColors.accentCyan
                : AppColors.gridLine,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              preset.icon,
              size: 28,
              color: isSelected
                  ? AppColors.accentCyan
                  : AppColors.textSecondary,
            ),
            const SizedBox(height: 8),
            Text(
              preset.displayName.split(' ').first.toUpperCase(),
              style: TextStyle(
                fontFamily: AppTypography.fontFamilyMono,
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? AppColors.accentCyan
                    : AppColors.textSecondary,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              preset.id,
              style: TextStyle(
                fontFamily: AppTypography.fontFamilyMono,
                fontSize: 8,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );

    if (isSelected) {
      return PulseContainer(
        glowColor: AppColors.accentCyan,
        child: card,
      );
    }

    return card;
  }
}
