import 'package:flutter/material.dart';

class touchpoints {
  Paint paint;
  Offset points;
  touchpoints({required this.paint, required this.points});

  Map<String, dynamic> toJson() {
    return {
      'point': {
        "dx": '${points.dx}',
        "dy": '${points.dy}'
      } //$-> string interpollation to convert double value to string
    };
  }
}
