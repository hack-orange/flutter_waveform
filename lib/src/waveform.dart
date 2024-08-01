import 'package:flutter/material.dart';

import 'painter.dart';

class WaveformWidget extends StatelessWidget {
  const WaveformWidget({super.key, required this.amplitudes,required this.height, required this.width});
  final List<double> amplitudes;
  final double height;
  final double width;
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: WaveformPainter(amplitudes: amplitudes),
      child: SizedBox(
        width: width,
        height: height,
      ),
    );
  }
}
