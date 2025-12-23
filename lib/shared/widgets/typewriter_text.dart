import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class TypewriterText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration charDuration;
  final bool showCursor;
  final VoidCallback? onComplete;

  const TypewriterText({
    super.key,
    required this.text,
    this.style,
    this.charDuration = const Duration(milliseconds: 30),
    this.showCursor = true,
    this.onComplete,
  });

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _charAnimation;
  bool _isComplete = false;

  @override
  void initState() {
    super.initState();
    _initAnimation();
  }

  void _initAnimation() {
    final totalDuration = widget.charDuration * widget.text.length;

    _controller = AnimationController(
      duration: totalDuration,
      vsync: this,
    );

    _charAnimation = IntTween(
      begin: 0,
      end: widget.text.length,
    ).animate(_controller);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && !_isComplete) {
        _isComplete = true;
        widget.onComplete?.call();
      }
    });

    _controller.forward();
  }

  @override
  void didUpdateWidget(TypewriterText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != oldWidget.text) {
      _controller.dispose();
      _isComplete = false;
      _initAnimation();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = widget.style ?? AppTypography.terminalText;

    return AnimatedBuilder(
      animation: _charAnimation,
      builder: (context, child) {
        final visibleText = widget.text.substring(0, _charAnimation.value);
        final showCursor = widget.showCursor && !_isComplete;

        return Text.rich(
          TextSpan(
            children: [
              TextSpan(text: visibleText, style: effectiveStyle),
              if (showCursor)
                TextSpan(
                  text: '▋',
                  style: effectiveStyle.copyWith(
                    color: AppColors.accentCyan,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
