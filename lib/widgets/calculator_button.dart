import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../providers/theme_provider.dart';
import 'package:flutter/services.dart';

class CalculatorButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double fontSize;
  final bool isActive;
  final bool isScientific;
  final Widget? child;
  
  const CalculatorButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.fontSize = 20,
    this.isActive = false,
    this.isScientific = false,
    this.child,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);
    
    final bgColor = isScientific
        ? (isActive ? Colors.green.shade200 : Colors.green.shade50)
        : (backgroundColor ?? (themeProvider.isDarkMode ? Colors.grey.shade800 : Colors.white));
    final txtColor = textColor ?? 
        (themeProvider.isDarkMode ? Colors.white : Colors.black);
    
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Material(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            onTap: () {
              // 触觉反馈
              if (settingsProvider.isVibrationEnabled) {
                HapticFeedback.lightImpact();
              }
              
              // 声音反馈
              if (settingsProvider.isSoundEnabled) {
                SystemSound.play(SystemSoundType.click);
              }
              
              onPressed();
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: child ?? Text(
                  text,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: txtColor,
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
