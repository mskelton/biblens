import 'package:flutter/material.dart';

class CameraBadge extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;

  const CameraBadge({
    super.key,
    required this.text,
    this.backgroundColor = Colors.teal,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: ShapeDecoration(
        color: backgroundColor,
        shape: const CircleBorder(),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
    );
  }
}
