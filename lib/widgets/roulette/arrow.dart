import 'package:flutter/material.dart';

class Arrow extends StatelessWidget {
  const Arrow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20,
      height: 36,
      child: CustomPaint(painter: _ArrowPainter()),
    );
  }
}

class _ArrowPainter extends CustomPainter {
  final _fillPaint = Paint()
    ..color = Colors.redAccent
    ..style = PaintingStyle.fill;

  final _strokePaint = Paint()
    ..color = Colors.black // Color for the border line
    ..style = PaintingStyle.stroke // Use stroke style for the border line
    ..strokeWidth = 2.5; // Set the thickness of the border line

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..lineTo(0, 0)
      ..relativeLineTo(size.width / 2, size.height)
      ..relativeLineTo(size.width / 2, -size.height)
      ..close();

    canvas.drawPath(
        path, _fillPaint); // Draw with the Paint object to fill the interior
    canvas.drawPath(path,
        _strokePaint); // Draw with the Paint object to draw the border line
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
