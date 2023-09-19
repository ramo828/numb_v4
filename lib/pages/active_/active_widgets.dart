import 'package:flutter/material.dart';

class RoundedProgressBar extends StatelessWidget {
  final double value;
  final double height;
  final Color backgroundColor;
  final Color progressColor;
  final double borderRadius;

  RoundedProgressBar({
    required this.value,
    this.height = 10.0,
    this.backgroundColor = Colors.grey,
    this.progressColor = Colors.blue,
    this.borderRadius = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Stack(
        children: [
          FractionallySizedBox(
            widthFactor: value,
            child: Container(
              decoration: BoxDecoration(
                color: progressColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(borderRadius),
                  bottomLeft: Radius.circular(borderRadius),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
