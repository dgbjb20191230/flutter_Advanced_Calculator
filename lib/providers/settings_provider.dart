import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  bool _isRadianMode = false;
  bool _isSoundEnabled = true;
  bool _isVibrationEnabled = true;
  int _historyLimit = 20;
  
  SettingsProvider() {
    _loadSettings();
  }
  
  bool get isRadianMode => _isRadianMode;
  bool get isSoundEnabled => _isSoundEnabled;
  bool get isVibrationEnabled => _isVibrationEnabled;
  int get historyLimit => _historyLimit;
  
  // 切换角度/弧度模式
  void toggleAngleMode() {
    _isRadianMode = !_isRadianMode;
    _saveSettings();
    notifyListeners();
  }
  
  // 切换声音
  void toggleSound() {
    _isSoundEnabled = !_isSoundEnabled;
    _saveSettings();
    notifyListeners();
  }
  
  // 切换震动
  void toggleVibration() {
    _isVibrationEnabled = !_isVibrationEnabled;
    _saveSettings();
    notifyListeners();
  }
  
  // 设置历史记录数量限制
  void setHistoryLimit(int limit) {
    _historyLimit = limit;
    _saveSettings();
    notifyListeners();
  }
  
  // 加载设置
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isRadianMode = prefs.getBool('isRadianMode') ?? false;
    _isSoundEnabled = prefs.getBool('isSoundEnabled') ?? true;
    _isVibrationEnabled = prefs.getBool('isVibrationEnabled') ?? true;
    _historyLimit = prefs.getInt('historyLimit') ?? 20;
    notifyListeners();
  }
  
  // 保存设置
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isRadianMode', _isRadianMode);
    await prefs.setBool('isSoundEnabled', _isSoundEnabled);
    await prefs.setBool('isVibrationEnabled', _isVibrationEnabled);
    await prefs.setInt('historyLimit', _historyLimit);
  }
}
