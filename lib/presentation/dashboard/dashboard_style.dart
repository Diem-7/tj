import 'dart:ui';

import 'package:flutter/material.dart';

class DashboardColors {
  static const backgroundTop = Color(0xff071120);
  static const backgroundBottom = Color(0xff020713);
  static const panel = Color(0xcc0b1728);
  static const panelStrong = Color(0xe6101d32);
  static const border = Color(0xff1f4268);
  static const text = Color(0xfff4f8ff);
  static const mutedText = Color(0xff9aa8bd);
  static const positive = Color(0xff22e39a);
  static const negative = Color(0xffff4d57);
  static const neutral = Color(0xff4ea1ff);
  static const violet = Color(0xff8c5cff);
}

class CockpitPanel extends StatelessWidget {
  const CockpitPanel({
    required this.child,
    this.padding = const EdgeInsets.all(22),
    this.accent,
    this.strong = false,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? accent;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    final accentColor = accent ?? DashboardColors.neutral;

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: strong ? DashboardColors.panelStrong : DashboardColors.panel,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: DashboardColors.border),
            boxShadow: [
              BoxShadow(
                color: accentColor.withValues(alpha: strong ? 0.20 : 0.10),
                blurRadius: strong ? 32 : 22,
                offset: const Offset(0, 18),
              ),
              const BoxShadow(
                color: Color(0x66000000),
                blurRadius: 28,
                offset: Offset(0, 16),
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                accentColor.withValues(alpha: strong ? 0.18 : 0.08),
                const Color(0x00101d32),
                const Color(0x33111d31),
              ],
            ),
          ),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

class GlowIcon extends StatelessWidget {
  const GlowIcon({
    required this.icon,
    required this.color,
    this.size = 48,
    super.key,
  });

  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.18),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.22),
            blurRadius: 28,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Icon(icon, color: color, size: size * 0.48),
    );
  }
}

Color performanceColor(double value) {
  if (value > 0) {
    return DashboardColors.positive;
  }
  if (value < 0) {
    return DashboardColors.negative;
  }
  return DashboardColors.neutral;
}
