import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../models/apimodel.dart';
import '../utils/colors.dart';
import '../utils/planthealththeme.dart';

class PlantHealth extends StatelessWidget {
  final Conditions? temp, humid;

  PlantHealth({this.temp, this.humid});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 18),
      child: Container(
        decoration: BoxDecoration(
          color: FitnessAppTheme.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8.0),
            bottomLeft: Radius.circular(8.0),
            bottomRight: Radius.circular(8.0),
            topRight: Radius.circular(68.0),
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: FitnessAppTheme.grey.withOpacity(0.2),
              offset: Offset(1.1, 1.1),
              blurRadius: 10.0,
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: Row(
                children: [
                  _buildConditionCard(temp),
                  SizedBox(width: 10),
                  _buildConditionCard(humid),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8),
              child: Container(
                height: 2,
                decoration: BoxDecoration(
                  color: FitnessAppTheme.background,
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 45, right: 24, top: 8, bottom: 16),
              child: Row(
                children: <Widget>[
                  _buildTemperatureInfo(),
                  _buildHumidityInfo(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConditionCard(Conditions? condition) {
    if (condition == null) return Container(); // Return an empty container if condition is null

    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: FitnessAppTheme.white,
                borderRadius: BorderRadius.all(Radius.circular(100.0)),
                border: Border.all(
                  width: 4,
                  color: FitnessAppTheme.nearlyDarkBlue.withOpacity(0.2),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "${condition.value}°C",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: FitnessAppTheme.fontName,
                      fontWeight: FontWeight.normal,
                      fontSize: 24,
                      letterSpacing: 0.0,
                      color: FitnessAppTheme.nearlyDarkBlue,
                    ),
                  ),
                  Text(
                    condition.subText!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: FitnessAppTheme.fontName,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      letterSpacing: 0.0,
                      color: FitnessAppTheme.grey.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: CustomPaint(
              painter: CurvePainter(
                colors: [
                  Color(int.parse(condition.color.toString())),
                  HexColor("#8A98E8"),
                  HexColor("#8A98E8"),
                ],
                angle: double.parse(condition.value) * 3.6,
              ),
              child: SizedBox(
                width: 108,
                height: 108,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemperatureInfo() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center ,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Temperature',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: FitnessAppTheme.fontName,
              fontWeight: FontWeight.w500,
              fontSize: 16,
              letterSpacing: -0.2,
              color: FitnessAppTheme.darkText,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Container(
              height: 4,
              width: 70,
              decoration: BoxDecoration(
                color: HexColor('#87A0E5').withOpacity(0.2),
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    width: double.parse(temp!.value),
                    height: 4,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Color(int.parse(temp!.color as String)),
                        Color(int.parse(temp!.color as String)).withOpacity(0.5),
                      ]),
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              "${temp!.value}°C",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: FitnessAppTheme.fontName,
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: FitnessAppTheme.grey.withOpacity(0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHumidityInfo() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Humidity',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: FitnessAppTheme.fontName,
              fontWeight: FontWeight.w500,
              fontSize: 16,
              letterSpacing: -0.2,
              color: FitnessAppTheme.darkText,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Container(
              height: 4,
              width: 70,
              decoration: BoxDecoration(
                color: HexColor('#F56E98').withOpacity(0.2),
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    width: double.parse(humid!.value) / 2,
                    height: 4,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Color(int.parse(humid!.color as String)).withOpacity(0.1),
                        Color(int.parse(humid!.color as String)),
                      ]),
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              humid!.value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: FitnessAppTheme.fontName,
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: FitnessAppTheme.grey.withOpacity(0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  final double angle;
  final List<Color> colors;

  CurvePainter({required this.colors, this.angle = 140});

  @override
  void paint(Canvas canvas, Size size) {
    List<Color> colorsList = colors.isNotEmpty ? colors : [Colors.white, Colors.white];

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.4)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;

    final shadowPaintCenter = Offset(size.width / 2, size.height / 2);
    final shadowPaintRadius = math.min(size.width / 2, size.height / 2) - (14 / 2);

    canvas.drawArc(
      Rect.fromCircle(center: shadowPaintCenter, radius: shadowPaintRadius),
      degreeToRadians(278),
      degreeToRadians(360 - (365 - angle)),
      false,
      shadowPaint,
    );

    shadowPaint.color = Colors.grey.withOpacity(0.3);
    shadowPaint.strokeWidth = 16;
    canvas.drawArc(
      Rect.fromCircle(center: shadowPaintCenter, radius: shadowPaintRadius),
      degreeToRadians(278),
      degreeToRadians(360 - (365 - angle)),
      false,
      shadowPaint,
    );

    shadowPaint.color = Colors.grey.withOpacity(0.2 );
    shadowPaint.strokeWidth = 20;
    canvas.drawArc(
      Rect.fromCircle(center: shadowPaintCenter, radius: shadowPaintRadius),
      degreeToRadians(278),
      degreeToRadians(360 - (365 - angle)),
      false,
      shadowPaint,
    );

    shadowPaint.color = Colors.grey.withOpacity(0.1);
    shadowPaint.strokeWidth = 22;
    canvas.drawArc(
      Rect.fromCircle(center: shadowPaintCenter, radius: shadowPaintRadius),
      degreeToRadians(278),
      degreeToRadians(360 - (365 - angle)),
      false,
      shadowPaint,
    );

    final rect = Rect.fromLTWH(0.0, 0.0, size.width, size.width);
    final gradient = SweepGradient(
      startAngle: degreeToRadians(268),
      endAngle: degreeToRadians(270.0 + 360),
      tileMode: TileMode.repeated,
      colors: colorsList,
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2) - (14 / 2);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      degreeToRadians(278),
      degreeToRadians(360 - (365 - angle)),
      false,
      paint,
    );

    final gradient1 = SweepGradient(
      tileMode: TileMode.repeated,
      colors: [Colors.white, Colors.white],
    );

    var cPaint = Paint()
      ..shader = gradient1.createShader(rect)
      ..color = Colors.white
      ..strokeWidth = 14 / 2;

    canvas.save();
    final centerToCircle = size.width / 2;
    canvas.translate(centerToCircle, centerToCircle);
    canvas.rotate(degreeToRadians(angle + 2));
    canvas.translate(0.0, -centerToCircle + 14 / 2);
    canvas.drawCircle(Offset(0, 0), 14 / 5, cPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  double degreeToRadians(double degree) {
    return (math.pi / 180) * degree;
  }
}