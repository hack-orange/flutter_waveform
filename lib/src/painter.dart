import 'package:flutter/material.dart';

class WaveformPainter extends CustomPainter {
  final List<double> amplitudes;
  final double maxAmplitude;

  WaveformPainter({required this.amplitudes, this.maxAmplitude = 100.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final path = Path();
    final double widthStep = size.width / (amplitudes.length - 1);

    for (int i = 0; i < amplitudes.length - 1; i++) {
      final double x1 = i * widthStep;
      final double y1 = size.height / 2 - amplitudes[i] * (size.height / 2) / maxAmplitude;
      final double x2 = (i + 1) * widthStep;
      final double y2 = size.height / 2 - amplitudes[i + 1] * (size.height / 2) / maxAmplitude;

      if (i == 0) {
        path.moveTo(x1, y1);
      }

      // Use quadraticBezierTo for a smooth transition
      final double xc = (x1 + x2) / 2;
      final double yc = (y1 + y2) / 2;
      path.quadraticBezierTo(x1, y1, xc, yc);
    }

    // Draw the last segment
    final double lastX = (amplitudes.length - 1) * widthStep;
    final double lastY = size.height / 2 - amplitudes.last * (size.height / 2) / maxAmplitude;
    path.lineTo(lastX, lastY);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
