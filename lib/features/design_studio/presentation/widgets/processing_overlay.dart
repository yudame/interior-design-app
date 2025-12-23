import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class ProcessingOverlay extends StatefulWidget {
  final VoidCallback? onComplete;
  final Future<void> Function()? processTask;

  const ProcessingOverlay({
    super.key,
    this.onComplete,
    this.processTask,
  });

  static Future<void> show(
    BuildContext context, {
    Future<void> Function()? processTask,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: AppColors.backgroundPrimary.withValues(alpha: 0.95),
      builder: (context) => ProcessingOverlay(
        processTask: processTask,
        onComplete: () => Navigator.of(context).pop(),
      ),
    );
  }

  @override
  State<ProcessingOverlay> createState() => _ProcessingOverlayState();
}

class _ProcessingOverlayState extends State<ProcessingOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  bool _taskCompleted = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _startProcessTask();
  }

  Future<void> _startProcessTask() async {
    if (widget.processTask != null) {
      try {
        await widget.processTask!();
      } finally {
        _taskCompleted = true;
        _onComplete();
      }
    } else {
      _taskCompleted = true;
      _onComplete();
    }
  }

  void _onComplete() {
    if (_taskCompleted && mounted) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          widget.onComplete?.call();
        }
      });
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(32),
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 40),
          decoration: BoxDecoration(
            color: AppColors.backgroundSecondary,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.gridLine),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated progress indicator
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.accentCyan.withValues(
                          alpha: 0.3 + (_pulseController.value * 0.4),
                        ),
                        width: 3,
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(12),
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.accentCyan,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // Title
              Text(
                'Generating Design',
                style: AppTypography.terminalText.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),

              // Subtitle
              Text(
                'This may take a moment...',
                style: AppTypography.dataLabel.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
