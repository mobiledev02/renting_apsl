import 'package:flutter/material.dart';

class Spinner extends StatelessWidget {
  Spinner({
    Key? key,
    this.progressColor,
    this.value,
    this.height = 50,
    this.width = 50,
  }) : super(key: key);
  final double? value;
  final Color? progressColor;
  double height;
  double width;

  @override
  Widget build(BuildContext context) {
    // By default circular progres indicator takes ascent color...
    return Center(
      child: SizedBox(
        height: height,
        width: width,
        child: CircularProgressIndicator(
          color: progressColor,
          value: value,
        ),
      ),
    );
  }
}
