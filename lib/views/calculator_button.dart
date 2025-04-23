import 'package:flutter/material.dart';

class CalculatorButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final IconData? icon; // 添加图标属性

  const CalculatorButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
    this.fontSize = 24,
    this.icon, // 可选的图标
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Material(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          elevation: 2, // 添加一点阴影效果
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: icon != null
                    ? Icon(
                        icon,
                        color: textColor,
                        size: fontSize * 1.2,
                      )
                    : Text(
                        text,
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
