import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Striped Background')),
        body: StripedBackground(
          color: Colors.orangeAccent.shade200, // ストライプの色を指定します
          stripeWidth: 10, // ストライプの幅を指定します
          spacing: 5, // ストライプ間のスペースを指定します
          angle: 135, // ストライプの角度を指定します（度数法で指定）
        ),
        // ここに他のウィジェットを追加します
      ),
    );
  }
}

class StripedBackground extends StatelessWidget {
  final Color color;
  final double stripeWidth;
  final double spacing;
  final double angle;

  StripedBackground({
    required this.color,
    this.stripeWidth = 10.0,
    this.spacing = 10.0,
    this.angle = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // 背景色を指定します（必要に応じて変更してください）
      child: CustomPaint(
        size: Size(double.infinity, double.infinity),
        painter: _StripedBackgroundPainter(color, stripeWidth, spacing, angle),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Text('aaaaaaaaaaaaaaaa'),
        ),
      ),
    );
  }
}

class _StripedBackgroundPainter extends CustomPainter {
  final Color color;
  final double stripeWidth;
  final double spacing;
  final double angle;

  _StripedBackgroundPainter(
      this.color, this.stripeWidth, this.spacing, this.angle);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = stripeWidth;

    final double diagonalLength =
        math.sqrt(size.width * size.width + size.height * size.height);
    double x = -diagonalLength * math.sin(math.pi / 180 * angle);

    while (x < size.width * 2) {
      final start = Offset(x, 0);
      final end = Offset(
          x + size.height * math.tan(math.pi / 180 * angle), size.height);
      canvas.drawLine(start, end, paint);
      x += (stripeWidth + spacing) / math.sin(math.pi / 180 * angle);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
