
import 'dart:math' as math;
import 'package:flutter/material.dart';

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key});

  @override
  State<AnimatedBackground> createState() =>
      _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: _BackgroundPainter(_controller.value),
              size: Size.infinite,
            );
          },
        ),
      ),
    );
  }
}

class _BackgroundPainter extends CustomPainter {
  final double progress;

  _BackgroundPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFF0B0B14),
    );

    final time = progress * 2 * math.pi;

    _drawGrid(canvas, size);

    _drawGlow(
      canvas,
      Offset(
        size.width * (0.75 + 0.08 * math.sin(time)),
        size.height * 0.30,
      ),
      const Color(0xFF8B5CF6),
      size.width * 0.45,
    );

    _drawGlow(
      canvas,
      Offset(
        size.width * 0.25,
        size.height * (0.75 + 0.08 * math.cos(time)),
      ),
      const Color(0xFF2563EB),
      size.width * 0.40,
    );

    _drawParticles(canvas, size, time);
  }

  void _drawGlow(
    Canvas canvas,
    Offset center,
    Color color,
    double radius,
  ) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          color.withValues(alpha: 0.32),
          color.withValues(alpha: 0.12),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(center: center, radius: radius),
      );

    canvas.drawCircle(center, radius, paint);
  }

  void _drawGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.035)
      ..strokeWidth = 0.7;

    const spacing = 55.0;

    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  void _drawParticles(
    Canvas canvas,
    Size size,
    double time,
  ) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.35);

    for (int i = 0; i < 45; i++) {
      final x = ((i * 137.5) + time * 8) % size.width;
      final y = ((i * 83.7) + time * 4) % size.height;

      canvas.drawCircle(
        Offset(x, y),
        i % 3 == 0 ? 1.5 : 0.8,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BackgroundPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
