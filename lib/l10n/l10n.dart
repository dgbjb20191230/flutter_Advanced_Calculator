import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en', ''),
    Locale('zh', ''),
  ];

  Map<String, String> _localizedStrings = {};

  Future<bool> load() async {
    // 这里应该加载本地化字符串，但为了简单起见，我们直接硬编码
    if (locale.languageCode == 'zh') {
      _localizedStrings = {
        'appTitle': '高级计算器',
        'radianMode': '弧度制',
        'degreeMode': '角度制',
        'history': '历史记录',
        'clearHistory': '清空历史',
        'noHistory': '暂无历史记录',
        'settings': '设置',
        'soundFeedback': '声音反馈',
        'vibrationFeedback': '震动反馈',
        'historyLimit': '历史记录数量',
        'lightTheme': '亮色主题',
        'darkTheme': '暗色主题',
        'followSystem': '跟随系统',
        'copyright': '© 2025 高级计算器应用'
      };
    } else {
      _localizedStrings = {
        'appTitle': 'Advanced Calculator',
        'radianMode': 'Radian',
        'degreeMode': 'Degree',
        'history': 'History',
        'clearHistory': 'Clear History',
        'noHistory': 'No history yet',
        'settings': 'Settings',
        'soundFeedback': 'Sound Feedback',
        'vibrationFeedback': 'Vibration Feedback',
        'historyLimit': 'History Limit',
        'lightTheme': 'Light Theme',
        'darkTheme': 'Dark Theme',
        'followSystem': 'Follow System',
        'copyright': '© 2025 Advanced Calculator App'
      };
    }
    return true;
  }

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  String get appTitle => translate('appTitle');
  String get radianMode => translate('radianMode');
  String get degreeMode => translate('degreeMode');
  String get history => translate('history');
  String get clearHistory => translate('clearHistory');
  String get noHistory => translate('noHistory');
  String get settings => translate('settings');
  String get soundFeedback => translate('soundFeedback');
  String get vibrationFeedback => translate('vibrationFeedback');
  String get historyLimit => translate('historyLimit');
  String get lightTheme => translate('lightTheme');
  String get darkTheme => translate('darkTheme');
  String get followSystem => translate('followSystem');
  String get copyright => translate('copyright');
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'zh'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
