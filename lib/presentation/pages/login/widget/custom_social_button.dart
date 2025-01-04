import 'package:flutter/material.dart';

class CustomSocialButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final String iconPath;
  final VoidCallback onPressed;
  final double iconSize;
  const CustomSocialButton({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    required this.iconPath,
    required this.onPressed,
    required this.iconSize,
  });
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          textStyle: const TextStyle(fontSize: 18),
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          minimumSize: const Size(double.infinity, 50),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            iconPath,
            width: iconSize,
            height: iconSize,
          ),
          Text(text),
          SizedBox(width: 20),
        ],
      ),
    );
  }
}
