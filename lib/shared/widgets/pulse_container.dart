import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class PulseContainer extends StatefulWidget {
  final Widget child;
  final Color glowColor;
  final bool isActive;
  final Duration duration;
  final double minOpacity;
  final double maxOpacity;
  final double blurRadius;

  const PulseContainer({
    super.key,
    required this.child,
    this.glowColor = AppColors.accentCyan,
    this.isActive = true,
    this.duration = const Duration(milliseconds: 2000),
    this.minOpacity = 0.15,
    this.maxOpacity = 0.3,
    this.blurRadius = 8.0,
  });

  @override
  State<PulseContainer> createState() => _PulseContainerState();
}

class _PulseContainerState extends State<PulseContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: widget.minOpacity,
      end: widget.maxOpacity,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.isActive) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(PulseContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
        _controller.reset();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isActive) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: widget.glowColor.withValues(alpha: _animation.value),
                blurRadius: widget.blurRadius,
                spreadRadius: -2,
              ),
            ],
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
