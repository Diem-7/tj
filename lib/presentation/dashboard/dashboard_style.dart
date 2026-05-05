import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardColors {
  static const backgroundTop = Color(0xff02040a);
  static const backgroundBottom = Color(0xff010205);
  static const panel = Color(0x770a1322);
  static const panelStrong = Color(0xaa0a1628);
  static const border = Color(0x771f3755);
  static const text = Color(0xffe2e8f0);
  static const mutedText = Color(0xff64748b);
  static const positive = Color(0xff338aff);
  static const negative = Color(0xffef4444);
  static const neutral = Color(0xff1e40af);
  static const violet = Color(0xff8b5cf6);
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
      borderRadius: BorderRadius.circular(8),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: strong ? DashboardColors.panelStrong : DashboardColors.panel,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: accentColor.withValues(alpha: strong ? 0.56 : 0.34),
            ),
            boxShadow: [
              BoxShadow(
                color: accentColor.withValues(alpha: strong ? 0.12 : 0.06),
                blurRadius: strong ? 18 : 12,
                offset: const Offset(0, 10),
              ),
              const BoxShadow(
                color: Color(0x55000000),
                blurRadius: 18,
                offset: Offset(0, 10),
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                accentColor.withValues(alpha: strong ? 0.18 : 0.08),
                const Color(0x00101d32),
                const Color(0x22111d31),
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
        color: color.withValues(alpha: 0.10),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.08),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Icon(icon, color: color, size: size * 0.48),
    );
  }
}

class EquitySparkline extends StatelessWidget {
  const EquitySparkline({
    required this.points,
    required this.color,
    this.fill = true,
    super.key,
  });

  final List<double> points;
  final Color color;
  final bool fill;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _EquitySparklinePainter(
        points: points,
        color: color,
        fill: fill,
      ),
      child: const SizedBox.expand(),
    );
  }
}

class _EquitySparklinePainter extends CustomPainter {
  const _EquitySparklinePainter({
    required this.points,
    required this.color,
    required this.fill,
  });

  final List<double> points;
  final Color color;
  final bool fill;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty || size.width <= 0 || size.height <= 0) {
      return;
    }

    final minValue = points.reduce((a, b) => a < b ? a : b);
    final maxValue = points.reduce((a, b) => a > b ? a : b);
    final range = maxValue - minValue < 1 ? 1.0 : maxValue - minValue;
    final step = points.length == 1 ? 0.0 : size.width / (points.length - 1);
    final path = Path();

    for (var index = 0; index < points.length; index++) {
      final x = points.length == 1 ? size.width : index * step;
      final y =
          size.height - ((points[index] - minValue) / range * size.height);
      if (index == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    if (fill) {
      final fillPath = Path.from(path)
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..close();
      canvas.drawPath(
        fillPath,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              color.withValues(alpha: 0.26),
              color.withValues(alpha: 0.02),
            ],
          ).createShader(Offset.zero & size),
      );
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_EquitySparklinePainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.color != color ||
        oldDelegate.fill != fill;
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

class AppTheme {
  static ThemeData get darkTheme {
    final baseTheme = ThemeData.dark();
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xff338aff),
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: DashboardColors.backgroundBottom,
      textTheme: GoogleFonts.interTextTheme(baseTheme.textTheme).apply(
        bodyColor: DashboardColors.text,
        displayColor: DashboardColors.text,
      ),
      cardTheme: CardThemeData(
        color: DashboardColors.panel,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: DashboardColors.border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: DashboardColors.panelStrong,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: DashboardColors.border),
        ),
      ),
      useMaterial3: true,
    );
  }
}
