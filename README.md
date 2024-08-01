# Waveform

A Flutter package to display a dynamic audio waveform that changes based on the audio amplitude. Ideal for visualizing audio input and providing real-time feedback in audio recording applications.

## Features

- Real-time waveform display based on audio amplitude
- Customizable appearance
- Smooth transitions between amplitude points
- Supports both silence detection and active audio display

## Getting started

### Prerequisites

Ensure you have the following:
- Flutter SDK
- Permissions for microphone access (for audio input)

### Installation

Add the following to your `pubspec.yaml`:
```yaml
dependencies:
  waveform: latest

```
```dart
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'dart:async';
import 'waveform_painter.dart';  // Ensure this path is correct

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Waveform Example')),
        body: WaveformWidget(),
      ),
    );
  }
}

class WaveformWidget extends StatefulWidget {
  @override
  _WaveformWidgetState createState() => _WaveformWidgetState();
}

class _WaveformWidgetState extends State<WaveformWidget> {
  final Record _record = Record();
  bool _isRecording = false;
  Timer? _timer;
  List<double> amplitudes = List.generate(100, (index) => 0.0);
  double _threshold = -40.0;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await Permission.microphone.request();
  }

  void _startRecording() async {
    if (await _record.hasPermission()) {
      await _record.start();
      setState(() {
        _isRecording = true;
      });
      _startAmplitudeDetection();
    }
  }

  void _stopRecording() async {
    await _record.stop();
    setState(() {
      _isRecording = false;
    });
    _timer?.cancel();
  }

  void _startAmplitudeDetection() {
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) async {
      final amplitude = await _record.getAmplitude();
      double value = (amplitude?.current ?? 0);
      if (value < _threshold) {
        value = 0;  // Silence is a straight line
      } else {
        value = amplitude!.current.abs();
      }

      setState(() {
        amplitudes.removeAt(0);
        amplitudes.add(value);
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _record.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        painter: WaveformPainter(amplitudes: amplitudes),
        child: Container(
          width: double.infinity,
          height: 200,
        ),
      ),
    );
  }
}


```