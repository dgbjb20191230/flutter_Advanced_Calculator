import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;
  bool _followSystem = true;
  
  ThemeProvider() {
    _loadThemePreference();
  }
  
  bool get isDarkMode => _isDarkMode;
  bool get followSystem => _followSystem;
  
  // 切换主题
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _followSystem = false;
    _saveThemePreference();
    notifyListeners();
  }
  
  // 设置是否跟随系统
  void setFollowSystem(bool value) {
    _followSystem = value;
    _saveThemePreference();
    notifyListeners();
  }
  
  // 根据系统设置更新主题
  void updateThemeFromSystem(Brightness systemBrightness) {
    if (_followSystem) {
      _isDarkMode = systemBrightness == Brightness.dark;
      notifyListeners();
    }
  }
  
  // 加载主题设置
  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _followSystem = prefs.getBool('followSystem') ?? true;
    notifyListeners();
  }
  
  // 保存主题设置
  Future<void> _saveThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    await prefs.setBool('followSystem', _followSystem);
  }
}
