import 'package:flutter/material.dart';
import 'package:pudez_street_playground/common/style/color.dart';

class MyTextButton extends StatelessWidget {
  const MyTextButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.backgroundColor = textPrimary,
    this.textColor = white,
  });

  final Function()? onPressed;
  final String text;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
