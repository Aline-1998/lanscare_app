import 'package:flutter/material.dart';

import '../data_store.dart';

class LineChartWidget extends StatelessWidget {
  final List<HealthRecord> records;
  final String metricType; // 'Tekanan Darah', 'Gula Darah', 'Berat Badan'

  const LineChartWidget({
    super.key,
    required this.records,
    required this.metricType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: CustomPaint(
        size: Size.infinite,
        painter: _LineChartPainter(
          records: records.reversed.toList(), // Chronological order
          metricType: metricType,
        ),
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<HealthRecord> records;
  final String metricType;

  _LineChartPainter({required this.records, required this.metricType});

  @override
  void paint(Canvas canvas, Size size) {
    if (records.isEmpty) return;

    final paintLine = Paint()
      ..color = const Color(0xFF27A1A6)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final paintLineDiastolic = Paint()
      ..color = const Color(0xFF22B573)
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final paintDot = Paint()
      ..color = const Color(0xFF27A1A6)
      ..style = PaintingStyle.fill;

    final paintDotDiastolic = Paint()
      ..color = const Color(0xFF22B573)
      ..style = PaintingStyle.fill;

    final paintGrid = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 1.0;

    final textStyle = TextStyle(
      color: Colors.grey[600],
      fontSize: 10.0,
      fontWeight: FontWeight.w500,
    );

    // Determine min/max values to scale properly
    double minY = 0;
    double maxY = 150;

    if (metricType == 'Gula Darah') {
      minY = 50;
      maxY = 150;
    } else if (metricType == 'Berat Badan') {
      minY = 40;
      maxY = 80;
    } else {
      // Tekanan Darah (Systolic runs up to 160, Diastolic 60-100)
      minY = 40;
      maxY = 160;
    }

    final double width = size.width;
    final double height = size.height;

    // Y axes margins
    final double paddingLeft = 35.0;
    final double paddingRight = 10.0;
    final double paddingTop = 10.0;
    final double paddingBottom = 25.0;

    final double chartWidth = width - paddingLeft - paddingRight;
    final double chartHeight = height - paddingTop - paddingBottom;

    // Draw horizontal grid lines and Y labels
    final int gridLinesCount = 5;
    for (int i = 0; i < gridLinesCount; i++) {
      final double fraction = i / (gridLinesCount - 1);
      final double y = paddingTop + chartHeight * (1 - fraction);
      final double val = minY + (maxY - minY) * fraction;

      // Draw line
      canvas.drawLine(
        Offset(paddingLeft, y),
        Offset(width - paddingRight, y),
        paintGrid,
      );

      // Draw label
      final textSpan = TextSpan(text: val.toStringAsFixed(0), style: textStyle);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(
        canvas,
        Offset(paddingLeft - textPainter.width - 5, y - textPainter.height / 2),
      );
    }

    // Coordinates calculations
    final int pointsCount = records.length;
    final double xSegment =
        chartWidth / (pointsCount > 1 ? (pointsCount - 1) : 1);

    final List<Offset> points1 = [];
    final List<Offset> points2 = []; // Used for Diastolic in Tekanan Darah

    for (int i = 0; i < pointsCount; i++) {
      final record = records[i];
      final double x = paddingLeft + (i * xSegment);

      double yVal1 = 0;
      double yVal2 = 0;

      if (metricType == 'Gula Darah') {
        yVal1 = record.bloodSugar.toDouble();
      } else if (metricType == 'Berat Badan') {
        yVal1 = record.weight;
      } else {
        // Tekanan Darah
        yVal1 = double.tryParse(record.bpSystolic) ?? 120.0;
        yVal2 = double.tryParse(record.bpDiastolic) ?? 80.0;
      }

      // Clamp values
      yVal1 = yVal1.clamp(minY, maxY);
      yVal2 = yVal2.clamp(minY, maxY);

      final double yPercent1 = (yVal1 - minY) / (maxY - minY);
      final double y1 = paddingTop + chartHeight * (1 - yPercent1);
      points1.add(Offset(x, y1));

      if (metricType == 'Tekanan Darah') {
        final double yPercent2 = (yVal2 - minY) / (maxY - minY);
        final double y2 = paddingTop + chartHeight * (1 - yPercent2);
        points2.add(Offset(x, y2));
      }

      // Draw X label (Dates)
      final String dateLabel = '${record.date.day}/${record.date.month}';
      final textSpan = TextSpan(text: dateLabel, style: textStyle);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, height - paddingBottom + 5),
      );
    }

    // Draw lines & dots
    if (pointsCount > 0) {
      if (pointsCount == 1) {
        canvas.drawCircle(points1[0], 6.0, paintDot);
        if (metricType == 'Tekanan Darah') {
          canvas.drawCircle(points2[0], 6.0, paintDotDiastolic);
        }
      } else {
        // Line 1
        final path1 = Path()..moveTo(points1[0].dx, points1[0].dy);
        for (int i = 1; i < pointsCount; i++) {
          path1.lineTo(points1[i].dx, points1[i].dy);
        }
        canvas.drawPath(path1, paintLine);

        // Dots 1
        for (final pt in points1) {
          canvas.drawCircle(pt, 5.0, Paint()..color = Colors.white);
          canvas.drawCircle(pt, 4.0, paintDot);
        }

        if (metricType == 'Tekanan Darah') {
          // Line 2 (Diastolic)
          final path2 = Path()..moveTo(points2[0].dx, points2[0].dy);
          for (int i = 1; i < pointsCount; i++) {
            path2.lineTo(points2[i].dx, points2[i].dy);
          }
          canvas.drawPath(path2, paintLineDiastolic);

          // Dots 2
          for (final pt in points2) {
            canvas.drawCircle(pt, 5.0, Paint()..color = Colors.white);
            canvas.drawCircle(pt, 4.0, paintDotDiastolic);
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) {
    return oldDelegate.records != records ||
        oldDelegate.metricType != metricType;
  }
}

class BarChartWidget extends StatelessWidget {
  final List<String> labels;
  final List<double> values;
  final double maxValue;

  const BarChartWidget({
    super.key,
    required this.labels,
    required this.values,
    this.maxValue = 60.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: CustomPaint(
        size: Size.infinite,
        painter: _BarChartPainter(
          labels: labels,
          values: values,
          maxValue: maxValue,
        ),
      ),
    );
  }
}

class _BarChartPainter extends CustomPainter {
  final List<String> labels;
  final List<double> values;
  final double maxValue;

  _BarChartPainter({
    required this.labels,
    required this.values,
    required this.maxValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;

    final paintBar = Paint()
      ..color = const Color(0xFF27A1A6)
      ..style = PaintingStyle.fill;

    final paintGrid = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..strokeWidth = 1.0;

    final textStyle = TextStyle(
      color: Colors.grey[600],
      fontSize: 9.0,
      fontWeight: FontWeight.w500,
    );

    final double paddingLeft = 25.0;
    final double paddingRight = 5.0;
    final double paddingTop = 10.0;
    final double paddingBottom = 20.0;

    final double chartWidth = width - paddingLeft - paddingRight;
    final double chartHeight = height - paddingTop - paddingBottom;

    // Y Grid & labels (0, max/3, 2*max/3, max)
    final double step = maxValue / 3;
    final List<double> yValues = [0, step, step * 2, maxValue];
    for (int i = 0; i < yValues.length; i++) {
      final double fraction = i / (yValues.length - 1);
      final double y = paddingTop + chartHeight * (1 - fraction);

      canvas.drawLine(
        Offset(paddingLeft, y),
        Offset(width - paddingRight, y),
        paintGrid,
      );

      final textSpan = TextSpan(
        text: '${yValues[i].toStringAsFixed(0)}',
        style: textStyle,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(
        canvas,
        Offset(paddingLeft - textPainter.width - 5, y - textPainter.height / 2),
      );
    }

    if (labels.isEmpty) return;

    final double barSpacing = chartWidth / labels.length;
    final double barWidth = (barSpacing * 0.4).clamp(4.0, 30.0);

    for (int i = 0; i < labels.length; i++) {
      final double val = values[i];
      final double xCenter = paddingLeft + (i * barSpacing) + (barSpacing / 2);

      // Bar rectangle
      final double barHeightPercent = (val / maxValue).clamp(0.0, 1.0);
      final double barTop = paddingTop + chartHeight * (1 - barHeightPercent);
      final double barBottom = height - paddingBottom;

      final rect = RRect.fromRectAndCorners(
        Rect.fromLTRB(
          xCenter - barWidth / 2,
          barTop,
          xCenter + barWidth / 2,
          barBottom,
        ),
        topLeft: const Radius.circular(4.0),
        topRight: const Radius.circular(4.0),
      );

      canvas.drawRRect(rect, paintBar);

      // Label X
      final textSpan = TextSpan(text: labels[i], style: textStyle);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(
        canvas,
        Offset(xCenter - textPainter.width / 2, height - paddingBottom + 5),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BarChartPainter oldDelegate) {
    return oldDelegate.labels != labels ||
        oldDelegate.values != values ||
        oldDelegate.maxValue != maxValue;
  }
}
