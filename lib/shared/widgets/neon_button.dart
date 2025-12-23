import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import 'pulse_container.dart';

class NeonButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isPulsing;
  final Color color;
  final IconData? icon;

  const NeonButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isPulsing = false,
    this.color = AppColors.accentCyan,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null && !isLoading;

    final button = Container(
      decoration: BoxDecoration(
        color: isEnabled ? color : AppColors.backgroundTertiary,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isEnabled ? color : AppColors.gridLine,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? onPressed : null,
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isEnabled
                            ? AppColors.backgroundPrimary
                            : AppColors.textMuted,
                      ),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (icon != null) ...[
                        Icon(
                          icon,
                          size: 18,
                          color: isEnabled
                              ? AppColors.backgroundPrimary
                              : AppColors.textMuted,
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        label.toUpperCase(),
                        style: TextStyle(
                          fontFamily: AppTypography.fontFamilyMono,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.0,
                          color: isEnabled
                              ? AppColors.backgroundPrimary
                              : AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );

    if (isPulsing && isEnabled) {
      return PulseContainer(
        glowColor: color,
        child: button,
      );
    }

    return button;
  }
}
