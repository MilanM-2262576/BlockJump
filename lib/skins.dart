import 'package:flutter/material.dart';
import 'dart:math';

class Skin {
  final String name;
  final Color color;
  final IconData icon;
  final String face;

  const Skin({required this.name, required this.color, required this.icon, required this.face});
}

const List<Skin> availableSkins = [
  Skin(name: "Classic", color: Colors.cyanAccent, icon: Icons.hexagon, face: "smile"),
  Skin(name: "Green Square", color: Colors.greenAccent, icon: Icons.crop_square, face: "neutral"),
  Skin(name: "Yellow Triangle", color: Colors.yellowAccent, icon: Icons.change_history, face: "wink"),

];

class SkinPreview extends StatelessWidget {
  final Skin skin;
  final double size;

  const SkinPreview({super.key, required this.skin, this.size = 48});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: SkinPainter(skin),
    );
  }
}

class SkinPainter extends CustomPainter {
  final Skin skin;

  SkinPainter(this.skin);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()..color = skin.color;

    // Vorm
    if (skin.icon == Icons.hexagon) {
      final path = Path();
      const sides = 6;
      final radius = size.width / 2.2;
      for (int i = 0; i < sides; i++) {
        final angle = (i * 2 * 3.14159 / sides) - 3.14159 / 2;
        final x = center.dx + radius * cos(angle);
        final y = center.dy + radius * sin(angle);
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
      canvas.drawPath(path, paint);
    } else if (skin.icon == Icons.crop_square) {
      final rect = Rect.fromCenter(center: center, width: size.width * 0.8, height: size.height * 0.8);
      canvas.drawRect(rect, paint);
    } else if (skin.icon == Icons.change_history) {
      final path = Path();
      final double r = size.width * 0.50;
      for (int i = 0; i < 3; i++) {
        final angle = (i * 2 * pi / 3) - pi / 2;
        final x = center.dx + r * cos(angle);
        final y = center.dy + r * sin(angle);
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
      canvas.drawPath(path, paint);
    }
     else {
      // fallback: cirkel
      canvas.drawCircle(center, size.width * 0.4, paint);
    }

    // Gezichtje
    final facePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    switch (skin.face) {
      case "smile":
        canvas.drawArc(
          Rect.fromCenter(center: center.translate(0, 6), width: size.width * 0.35, height: size.height * 0.18),
          0.1, 3.04, false, facePaint);
        canvas.drawCircle(center.translate(-size.width * 0.13, -size.height * 0.08), 2.5, facePaint..style = PaintingStyle.fill);
        canvas.drawCircle(center.translate(size.width * 0.13, -size.height * 0.08), 2.5, facePaint);
        break;
      case "wink":
        canvas.drawArc(
          Rect.fromCenter(center: center.translate(0, 6), width: size.width * 0.35, height: size.height * 0.18),
          0.1, 3.04, false, facePaint);
        canvas.drawLine(
          center.translate(-size.width * 0.13, -size.height * 0.08),
          center.translate(-size.width * 0.07, -size.height * 0.08),
          facePaint);
        canvas.drawCircle(center.translate(size.width * 0.13, -size.height * 0.08), 2.5, facePaint);
        break;
      case "neutral":
        canvas.drawLine(
          center.translate(-size.width * 0.09, size.height * 0.13),
          center.translate(size.width * 0.09, size.height * 0.13),
          facePaint);
        canvas.drawCircle(center.translate(-size.width * 0.13, -size.height * 0.08), 2.5, facePaint);
        canvas.drawCircle(center.translate(size.width * 0.13, -size.height * 0.08), 2.5, facePaint);
        break;
      default:
        // fallback: smile
        canvas.drawArc(
          Rect.fromCenter(center: center.translate(0, 6), width: size.width * 0.35, height: size.height * 0.18),
          0.1, 3.04, false, facePaint);
        canvas.drawCircle(center.translate(-size.width * 0.13, -size.height * 0.08), 2.5, facePaint);
        canvas.drawCircle(center.translate(size.width * 0.13, -size.height * 0.08), 2.5, facePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}