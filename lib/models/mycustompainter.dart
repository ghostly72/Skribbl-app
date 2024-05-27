import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:skribbl/models/touchpoints.dart';

class mycustompainter extends CustomPainter {
  final List<touchpoints> pointslist;
  mycustompainter({required this.pointslist});

  List<Offset> offsetpoints = [];

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    Paint background = Paint()..color = Colors.white;
    Rect rect = Rect.fromLTRB(0, 0, size.width, size.height);
    canvas.drawRect(rect, background);
    canvas.clipRect(rect);

    for (int i = 0; i < pointslist.length - 1; i++) {
      if (pointslist[i] != null && pointslist[i + 1] != null) {
        canvas.drawLine(pointslist[i].points, pointslist[i + 1].points,
            pointslist[i].paint);
      } else if (pointslist[i] != null && pointslist[i + 1] == null) {
        offsetpoints.clear();
        offsetpoints.add(pointslist[i].points);
        offsetpoints.add(Offset(
            pointslist[i].points.dx + 0.1, pointslist[i].points.dy + 0.1));

        canvas.drawPoints(
            ui.PointMode.points, offsetpoints, pointslist[i].paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
