import 'package:flutter/material.dart';

class LansCareLogo extends StatelessWidget {
  final double size;
  const LansCareLogo({super.key, this.size = 100.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: const Color(0xFF0F5A5C), width: size * 0.04),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Heart outline and details inside
          CustomPaint(
            size: Size(size * 0.8, size * 0.8),
            painter: _LogoPainter(),
          ),
        ],
      ),
    );
  }
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    // Draw stylized heart
    final heartPath = Path();
    heartPath.moveTo(width * 0.5, height * 0.75);
    // Left curve
    heartPath.cubicTo(
      width * 0.1,
      height * 0.5,
      width * 0.05,
      height * 0.2,
      width * 0.5,
      height * 0.2,
    );
    // Right curve
    heartPath.cubicTo(
      width * 0.95,
      height * 0.2,
      width * 0.9,
      height * 0.5,
      width * 0.5,
      height * 0.75,
    );

    // Draw heart outline
    final outlinePaint = Paint()
      ..color = const Color(0xFF0F5A5C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = width * 0.05
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(heartPath, outlinePaint);

    // Draw elderly couple silhouette simplified
    // Grandfather (left)
    final gfCenter = Offset(width * 0.38, height * 0.45);
    final gfRadius = width * 0.13;
    final gfPaint = Paint()
      ..color = const Color(0xFF0F5A5C)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(gfCenter, gfRadius, gfPaint);

    // Draw grandfather's glasses
    final glassesPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = width * 0.02;
    canvas.drawCircle(
      Offset(width * 0.33, height * 0.44),
      width * 0.04,
      glassesPaint,
    );
    canvas.drawCircle(
      Offset(width * 0.43, height * 0.44),
      width * 0.04,
      glassesPaint,
    );
    canvas.drawLine(
      Offset(width * 0.37, height * 0.44),
      Offset(width * 0.39, height * 0.44),
      glassesPaint,
    );

    // Grandmother (right)
    final gmCenter = Offset(width * 0.62, height * 0.45);
    final gmRadius = width * 0.13;
    canvas.drawCircle(gmCenter, gmRadius, gfPaint);

    // Draw grandmother's hair bun at top
    canvas.drawCircle(
      Offset(width * 0.62, height * 0.30),
      width * 0.05,
      gfPaint,
    );
    // Draw grandmother's glasses
    canvas.drawCircle(
      Offset(Offset(width * 0.57, height * 0.45).dx, height * 0.44),
      width * 0.04,
      glassesPaint,
    );
    canvas.drawCircle(
      Offset(Offset(width * 0.67, height * 0.45).dx, height * 0.44),
      width * 0.04,
      glassesPaint,
    );
    canvas.drawLine(
      Offset(width * 0.61, height * 0.44),
      Offset(width * 0.63, height * 0.44),
      glassesPaint,
    );

    // Friendly smiles
    final smilePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = width * 0.02;

    final smilePath1 = Path()
      ..addArc(
        Rect.fromCircle(
          center: Offset(width * 0.38, height * 0.49),
          radius: width * 0.04,
        ),
        0.1,
        2.9,
      );
    canvas.drawPath(smilePath1, smilePaint);

    final smilePath2 = Path()
      ..addArc(
        Rect.fromCircle(
          center: Offset(width * 0.62, height * 0.49),
          radius: width * 0.04,
        ),
        0.1,
        2.9,
      );
    canvas.drawPath(smilePath2, smilePaint);

    // Draw green medical cross in the bottom right corner of the heart
    final crossCenter = Offset(width * 0.8, height * 0.75);

    // Draw green circle background for the cross
    canvas.drawCircle(crossCenter, width * 0.14, Paint()..color = Colors.white);
    canvas.drawCircle(
      crossCenter,
      width * 0.12,
      Paint()..color = const Color(0xFF22B573),
    );

    // Draw white plus sign
    final plusPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = width * 0.05
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(crossCenter.dx - width * 0.06, crossCenter.dy),
      Offset(crossCenter.dx + width * 0.06, crossCenter.dy),
      plusPaint,
    );
    canvas.drawLine(
      Offset(crossCenter.dx, crossCenter.dy - width * 0.06),
      Offset(crossCenter.dx, crossCenter.dy + width * 0.06),
      plusPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
