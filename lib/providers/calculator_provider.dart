import 'package:flutter/foundation.dart';
import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import '../models/calculator_model.dart';
import '../services/calculator_service.dart';
import 'settings_provider.dart';

class CalculatorProvider with ChangeNotifier {
  // 内存提示
  String? _memoryTip;
  String? get memoryTip => _memoryTip;
  void setMemoryTip(String? tip) {
    _memoryTip = tip;
    notifyListeners();
    if (tip != null && tip.isNotEmpty) {
      Future.delayed(const Duration(seconds: 2), () {
        if (_memoryTip == tip) {
          _memoryTip = null;
          notifyListeners();
        }
      });
    }
  }

  // 科学计算提示
  String? _scientificTip;
  String? get scientificTip => _scientificTip;

  // 设置科学计算提示
  void setScientificTip(String? tip) {
    _scientificTip = tip;
    notifyListeners();
    if (tip != null && tip.isNotEmpty) {
      Future.delayed(const Duration(seconds: 3), () {
        if (_scientificTip == tip) {
          _scientificTip = null;
          notifyListeners();
        }
      });
    }
  }

  // 激活的功能键
  String _activeFunctionKey = '';
  String get activeFunctionKey => _activeFunctionKey;
  void setActiveFunctionKey(String key) {
    _activeFunctionKey = key;
    notifyListeners();
  }
  void clearActiveFunctionKey() {
    _activeFunctionKey = '';
    notifyListeners();
  }

  // 模型和服务
  final CalculatorModel _model = CalculatorModel();
  final CalculatorService _service = CalculatorService();
  final SettingsProvider _settingsProvider;

  CalculatorProvider(this._settingsProvider);

  // Getters
  String get currentInput => _model.currentInput;
  String get expression => _model.expression;
  List<String> get history => _model.history;
  String get memory => _model.memory;
  bool get hasMemoryValue => _model.memory.isNotEmpty;

  // 输入数字
  void inputDigit(String digit) {
    _scientificTip = null;
    if (_model.shouldReplaceInput) {
      _model.currentInput = digit;
      _model.shouldReplaceInput = false;
    } else {
      if (_model.currentInput == '0' && digit != '.') {
        _model.currentInput = digit;
      } else {
        // 避免多个小数点
        if (digit == '.' && _model.currentInput.contains('.')) {
          return;
        }
        _model.currentInput += digit;
      }
    }
    notifyListeners();
  }

  // 输入多个零
  void inputZeros(int count) {
    String zeros = '0' * count;
    if (_model.currentInput == '0') {
      return; // 如果当前已经是0，不做任何操作
    } else if (_model.shouldReplaceInput) {
      _model.currentInput = zeros;
      _model.shouldReplaceInput = false;
    } else {
      _model.currentInput += zeros;
    }
    notifyListeners();
  }

  // 这个方法已被移除，使用下面的 setOperation 方法代替

  // 这个方法已被移除，使用下面的 calculateResult 方法代替

  // 输入常数
  void inputConstant(String constant) {
    double value;
    switch (constant) {
      case 'π':
        value = 3.14159265359;
        break;
      case 'e':
        value = 2.71828182846;
        break;
      default:
        return;
    }

    _model.currentInput = value.toString();
    _model.shouldReplaceInput = true;
    notifyListeners();
  }

  // 输入括号
  void inputParenthesis(String parenthesis) {
    if (parenthesis == '(') {
      if (_model.expression.isEmpty ||
          _model.expression.endsWith('(') ||
          _model.expression.endsWith('+') ||
          _model.expression.endsWith('-') ||
          _model.expression.endsWith('×') ||
          _model.expression.endsWith('÷')) {
        _model.expression += '(';
      } else {
        _model.expression += ' × (';
      }
    } else if (parenthesis == ')') {
      // 检查是否有未闭合的左括号
      int openCount = 0;
      int closeCount = 0;

      for (int i = 0; i < _model.expression.length; i++) {
        if (_model.expression[i] == '(') openCount++;
        if (_model.expression[i] == ')') closeCount++;
      }

      if (openCount > closeCount) {
        if (!_model.expression.endsWith(')') &&
            !_model.expression.endsWith('(')) {
          _model.expression += '${_model.currentInput})';
          _model.shouldReplaceInput = true;
        } else if (_model.expression.endsWith('(')) {
          _model.expression += '0)';
        } else {
          _model.expression += ')';
        }
      }
    }
    notifyListeners();
  }

  // 设置操作符 - 修复版
  void setOperation(String op) {
    try {
      // 特殊处理百分号操作
      if (op == '%') {
        percentage();
        return;
      }

      // 如果当前有错误，先清除
      if (_model.currentInput == 'Error') {
        clearAll();
        return;
      }

      // 如果已经有操作符，先计算前面的结果
      if (_model.operation.isNotEmpty) {
        // 如果用户连续输入操作符，先计算前面的结果
        _calculateWithOperation();

        // 设置新的操作符和第一个操作数
        try {
          _model.firstOperand = double.parse(_model.currentInput);
          _model.operation = op;
          _model.shouldReplaceInput = true;
        } catch (parseError) {
          debugPrint('Parse error: $parseError');
          _model.currentInput = 'Error';
          _model.shouldReplaceInput = true;
        }

        notifyListeners();
        return;
      }

      // 如果表达式不为空，则使用表达式模式
      if (_model.expression.isNotEmpty) {
        // 如果表达式不以操作符结尾，则添加当前输入
        if (!_model.expression.endsWith(' ') && !_model.shouldReplaceInput) {
          _model.expression += _model.currentInput;
        }

        // 添加操作符
        _model.expression += ' $op ';
        _model.shouldReplaceInput = true;
      } else {
        // 使用简单操作符模式
        try {
          _model.firstOperand = double.parse(_model.currentInput);
          _model.operation = op;
          _model.shouldReplaceInput = true;
        } catch (parseError) {
          debugPrint('Parse error: $parseError');
          _model.currentInput = 'Error';
          _model.shouldReplaceInput = true;
        }
      }
    } catch (e) {
      debugPrint('Operation error: $e');
      _model.currentInput = 'Error';
      _model.shouldReplaceInput = true;
    }
    notifyListeners();
  }

  // 计算结果 - 修复版
  Future<void> calculateResult() async {
    try {
      // 如果没有运算符也没有表达式，则仅显示当前输入
      if (_model.expression.isEmpty && _model.operation.isEmpty) {
        // 如果用户只输入了一个数字并按了等号，将其添加到历史记录中
        _model.addToHistory('${_model.currentInput} = ${_model.currentInput}');
        _model.shouldReplaceInput = true;
        notifyListeners();
        return;
      }

      // 使用简单操作符模式处理计算
      if (_model.operation.isNotEmpty) {
        // 如果有操作符，则计算结果
        _calculateWithOperation();
        // 这里不 return，继续往下走，保证 shouldReplaceInput 被正确设置
      }

      // 如果有表达式，则使用表达式计算
      if (_model.expression.isNotEmpty) {
        // 如果表达式不以操作符结尾，则添加当前输入
        if (!_model.expression.endsWith(' ') && !_model.shouldReplaceInput) {
          _model.expression += _model.currentInput;
        } else if (_model.expression.endsWith(' ')) {
          // 如果表达式以空格结尾，说明最后是一个操作符
          _model.expression += _model.currentInput;
        }

        // 计算表达式
        try {
          final result = await _service.evaluateExpression(
            _model.expression,
            isRadianMode: _settingsProvider.isRadianMode,
          );

          // 保存历史记录
          _model.addToHistory('${_model.expression} = $result');

          // 限制历史记录数量
          while (_model.history.length > _settingsProvider.historyLimit) {
            _model.history.removeAt(0);
          }

          // 更新当前输入和表达式
          _model.currentInput = result;
          _model.expression = '';
          _model.shouldReplaceInput = true;
        } catch (calcError) {
          debugPrint('Calculation error: $calcError');
          _model.currentInput = 'Error';
          _model.shouldReplaceInput = true;
        }
      } else {
        // 如果没有表达式和操作符，确保 shouldReplaceInput 被设置
        _model.shouldReplaceInput = true;
      }
    } catch (e) {
      debugPrint('Input parsing error: $e');
      _model.currentInput = 'Error';
      _model.shouldReplaceInput = true;
    }

    notifyListeners();
  }

  // 使用操作符计算 - 修复版
  void _calculateWithOperation() {
    try {
      // 如果没有操作符，直接返回
      if (_model.operation.isEmpty) return;

      // 如果没有第一个操作数，将当前输入设为第一个操作数
      if (_model.firstOperand == null) {
        try {
          _model.firstOperand = double.parse(_model.currentInput);
        } catch (e) {
          _model.currentInput = 'Error';
          _model.shouldReplaceInput = true;
          return;
        }
      }

      // 如果当前输入应该被替换，但用户没有输入新的数字，则使用第一个操作数作为第二个操作数
      if (_model.shouldReplaceInput &&
          _model.currentInput == _service.formatNumber(_model.firstOperand!)) {
        _model.secondOperand = _model.firstOperand;
      } else {
        // 否则尝试解析当前输入作为第二个操作数
        try {
          _model.secondOperand = double.parse(_model.currentInput);
        } catch (e) {
          // 如果无法解析，使用第一个操作数
          _model.secondOperand = _model.firstOperand;
        }
      }

      // 格式化计算表达式
      String calculation =
          '${_model.firstOperand} ${_model.operation} ${_model.secondOperand}';
      double result;

      // 根据操作符计算结果
      switch (_model.operation) {
        case '+':
          result = _model.firstOperand! + _model.secondOperand!;
          break;
        case '-':
          result = _model.firstOperand! - _model.secondOperand!;
          break;
        case '×': // 乘号
          result = _model.firstOperand! * _model.secondOperand!;
          break;
        case '÷': // 除号
          if (_model.secondOperand == 0) {
            throw Exception('除数不能为零');
          }
          result = _model.firstOperand! / _model.secondOperand!;
          break;
        case '%':
          result = _model.firstOperand! % _model.secondOperand!;
          break;
        case 'xʸ':
          result = pow(_model.firstOperand!, _model.secondOperand!).toDouble();
          break;
        case 'x√y':
          if (_model.secondOperand! <= 0) {
            throw Exception('底数必须大于0');
          }
          if (_model.firstOperand! <= 0) {
            throw Exception('开方指数必须大于0');
          }
          result =
              pow(_model.secondOperand!, 1 / _model.firstOperand!).toDouble();
          break;
        default:
          throw Exception('不支持的操作');
      }

      // 格式化结果并更新模型
      _model.currentInput = _service.formatNumber(result);
      _model.addToHistory('$calculation = ${_model.currentInput}');

      // 限制历史记录数量
      while (_model.history.length > _settingsProvider.historyLimit) {
        _model.history.removeAt(0);
      }

      // 重置操作符和设置第一个操作数为结果，以便连续计算
      _model.firstOperand = result;
      _model.operation = '';
      _model.shouldReplaceInput = true;
      notifyListeners(); // 保证每次计算后界面及时刷新
    } catch (e) {
      debugPrint('Operation calculation error: $e');
      _model.currentInput = 'Error';
      _model.shouldReplaceInput = true;
      notifyListeners();
    }
  }

  // 百分号操作
  void percentage() {
    try {
      double value = double.parse(_model.currentInput);
      double result = value / 100.0;
      _model.currentInput = _service.formatNumber(result);
      _model.addToHistory('$value% = ${_model.currentInput}');
      _model.shouldReplaceInput = true;
    } catch (e) {
      debugPrint('Percentage error: $e');
      _model.currentInput = 'Error';
      _model.shouldReplaceInput = true;
    }
    notifyListeners();
  }

  // 退格
  void backspace() {
    if (_model.currentInput.length > 1) {
      _model.currentInput = _model.currentInput.substring(
        0,
        _model.currentInput.length - 1,
      );
    } else {
      _model.currentInput = '0';
    }
    notifyListeners();
  }

  // 清除所有
  void clearAll() {
    _model.clearAll();
    _scientificTip = null;
    notifyListeners();
  }

  // 清除当前输入
  void clearEntry() {
    _model.clearEntry();
    notifyListeners();
  }

  // 内存操作
  void memoryStore() {
    _model.storeInMemory();
    setMemoryTip('已存储到内存');
  }

  void memoryRecall() {
    _model.recallMemory();
    setMemoryTip('已从内存读取');
  }

  void memoryClear() {
    _model.clearMemory();
    setMemoryTip('已清空内存');
  }

  void memoryAdd() {
    _model.addToMemory();
    setMemoryTip('已加到内存');
  }

  void memorySubtract() {
    _model.subtractFromMemory();
    setMemoryTip('已从内存减去');
  }

  // 历史记录操作
  void clearHistory() {
    _model.history.clear();
    notifyListeners();
  }

  void removeHistoryItem(int index) {
    if (index >= 0 && index < _model.history.length) {
      _model.history.removeAt(index);
      notifyListeners();
    }
  }

  // 设置输入值（用于从历史记录中回填）
  void setInput(String value) {
    _model.currentInput = value;
    _model.shouldReplaceInput = true;
    notifyListeners();
  }

  // 计算阶乘
  int _factorial(int n) {
    if (n <= 1) return 1;
    return n * _factorial(n - 1);
  }

  // 科学计算
  void performScientificOperation(String operation) {
    try {
      // 如果当前有错误，先清除
      if (_model.currentInput == 'Error') {
        clearAll();
        return;
      }

      // 解析当前输入值
      double value = double.tryParse(_model.currentInput) ?? 0;
      String formattedValue = _service.formatNumber(value);
      String originalExpression = '';
      double result;

      // 特殊处理正负号切换
      if (operation == '+/-') {
        _model.currentInput = _service.formatNumber(-value);
        _model.shouldReplaceInput = true;
        setScientificTip('变更符号: ${_model.currentInput}');
        notifyListeners();
        return;
      }

      // 特殊处理幂运算
      if (operation == 'x^y' || operation == 'xʸ') {
        _model.firstOperand = value;
        _model.operation = 'xʸ';
        _model.shouldReplaceInput = true;
        setScientificTip('幂运算: $formattedValue 的 y 次方');
        notifyListeners();
        return;
      }

      // 特殊处理开方
      if (operation == 'x√y') {
        _model.firstOperand = value;
        _model.operation = 'x√y';
        _model.shouldReplaceInput = true;
        setScientificTip('$formattedValue 次方根');
        notifyListeners();
        return;
      }

      // 根据操作类型计算结果
      switch (operation) {
        case 'sqrt':
          originalExpression = '√($formattedValue)';
          if (value < 0) {
            _model.currentInput = 'Error';
            _model.shouldReplaceInput = true;
            notifyListeners();
            return;
          }
          result = sqrt(value);
          break;

        case 'sin':
          originalExpression = 'sin($formattedValue)';
          result = sin(value * pi / 180); // 默认使用角度制
          break;

        case 'cos':
          originalExpression = 'cos($formattedValue)';
          result = cos(value * pi / 180); // 默认使用角度制
          break;

        case 'tan':
          originalExpression = 'tan($formattedValue)';
          // 检查是否是 90°、270° 等特殊角度
          double degrees = value % 360;
          if (degrees == 90 || degrees == 270 || degrees == -90 || degrees == -270) {
            _model.currentInput = 'Error';
            _model.shouldReplaceInput = true;
            notifyListeners();
            return;
          }
          result = tan(value * pi / 180); // 默认使用角度制
          break;

        case 'log':
          originalExpression = 'log($formattedValue)';
          if (value <= 0) {
            _model.currentInput = 'Error';
            _model.shouldReplaceInput = true;
            notifyListeners();
            return;
          }
          result = log(value) / ln10; // 常用对数
          break;

        case 'ln':
          originalExpression = 'ln($formattedValue)';
          if (value <= 0) {
            _model.currentInput = 'Error';
            _model.shouldReplaceInput = true;
            notifyListeners();
            return;
          }
          result = log(value); // 自然对数
          break;

        case '1/x':
          originalExpression = '1/$formattedValue';
          if (value == 0) {
            _model.currentInput = 'Error';
            _model.shouldReplaceInput = true;
            notifyListeners();
            return;
          }
          result = 1 / value;
          break;

        case 'e^x':
          originalExpression = 'e^$formattedValue';
          if (value > 709) {
            _model.currentInput = '∞'; // 无穷大
            _model.shouldReplaceInput = true;
            notifyListeners();
            return;
          }
          result = exp(value);
          break;

        case 'n!':
          originalExpression = '$formattedValue!';
          if (value < 0 || value != value.floor()) {
            _model.currentInput = 'Error';
            _model.shouldReplaceInput = true;
            notifyListeners();
            return;
          }
          if (value > 170) {
            _model.currentInput = '∞'; // 无穷大
            _model.shouldReplaceInput = true;
            notifyListeners();
            return;
          }
          result = _factorial(value.toInt()).toDouble();
          break;

        case 'abs':
          originalExpression = '|$formattedValue|';
          result = value.abs();
          break;

        case 'percent':
          originalExpression = '$formattedValue%';
          result = value / 100.0;
          break;

        case 'x²': // x的平方
          try {
            originalExpression = '$formattedValue²';
            debugPrint('Calculating square of $value');
            // 直接使用乘法而不是 pow 函数
            result = value * value;
            debugPrint('Square result: $result');
          } catch (e) {
            debugPrint('Error calculating square: $e');
            _model.currentInput = 'Error';
            _model.shouldReplaceInput = true;
            notifyListeners();
            return;
          }
          break;

        case 'x³': // x的立方
          try {
            originalExpression = '$formattedValue³';
            debugPrint('Calculating cube of $value');
            // 直接使用乘法而不是 pow 函数
            result = value * value * value;
            debugPrint('Cube result: $result');
          } catch (e) {
            debugPrint('Error calculating cube: $e');
            _model.currentInput = 'Error';
            _model.shouldReplaceInput = true;
            notifyListeners();
            return;
          }
          break;

        case '10^x': // 10的x次方
          originalExpression = '10^$formattedValue';
          if (value > 308) {
            _model.currentInput = '∞'; // 无穷大
            _model.shouldReplaceInput = true;
            notifyListeners();
            return;
          }
          result = pow(10, value).toDouble();
          break;

        default:
          _model.currentInput = 'Error';
          _model.shouldReplaceInput = true;
          notifyListeners();
          return;
      }

      // 格式化结果并更新模型
      _model.currentInput = _service.formatNumber(result);
      _model.addToHistory('$originalExpression = ${_model.currentInput}');
      _model.shouldReplaceInput = true;

      // 设置科学计算提示
      setScientificTip('$originalExpression = ${_model.currentInput}');

    } catch (e) {
      debugPrint('Scientific calculation error: $e');
      _model.currentInput = 'Error';
      _model.shouldReplaceInput = true;
    }

    notifyListeners();
  }
}
