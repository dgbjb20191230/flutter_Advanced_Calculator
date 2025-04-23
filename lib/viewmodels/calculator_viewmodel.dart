import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import '../models/calculator_model.dart';
import '../services/calculator_service.dart';

class CalculatorViewModel with ChangeNotifier {
  final CalculatorModel _model = CalculatorModel();
  final CalculatorService _service = CalculatorService();

  String get currentInput => _model.currentInput;
  String get operation => _model.operation;
  List<String> get history => _model.history;
  String get memory => _model.memory;

  // 输入数字
  void inputDigit(String digit) {
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

  // 设置操作符
  void setOperation(String op) {
    try {
      // 如果已经有第一个操作数和操作符，并且当前输入不应该被替换
      // 那么这是连续操作，先计算前一个结果
      if (_model.firstOperand != null && !_model.shouldReplaceInput && _model.operation.isNotEmpty) {
        _performChainOperation(op);
        return;
      }

      // 确保当前输入可以被解析为数字
      _model.firstOperand = double.tryParse(_model.currentInput) ?? 0;
      _model.operation = op;
      _model.shouldReplaceInput = true;
      notifyListeners(); // 立即通知界面更新
    } catch (e) {
      debugPrint('Operation error: $e');
      _model.currentInput = 'Error';
      _model.shouldReplaceInput = true;
      notifyListeners();
    }
  }

  // 计算结果 - 重构版
  void calculateResult() {
    // 如果当前有错误，先清除
    if (_model.currentInput == 'Error') {
      clearAll();
      return;
    }

    // 如果没有操作符，可能是用户只输入了一个数字就按了等号
    // 这种情况下，我们将当前输入保持不变，并设置 shouldReplaceInput 为 true
    if (_model.operation.isEmpty) {
      _model.shouldReplaceInput = true;
      notifyListeners(); // 立即通知界面更新
      return;
    }

    try {
      // 获取操作数和操作符
      double secondOperand = double.tryParse(_model.currentInput) ?? 0;
      double firstOperand = _model.firstOperand ?? 0;
      String operation = _model.operation;

      // 格式化计算表达式
      String firstOperandStr = _service.formatNumber(firstOperand);
      String secondOperandStr = _service.formatNumber(secondOperand);
      String calculation = '$firstOperandStr $operation $secondOperandStr';

      // 直接计算结果
      double result;

      // 基本运算
      switch (operation) {
        case '+':
          result = firstOperand + secondOperand;
          break;

        case '-':
          result = firstOperand - secondOperand;
          break;

        case '×': // 乘号
          result = firstOperand * secondOperand;
          break;

        case '÷': // 除号
          if (secondOperand == 0) {
            _model.currentInput = 'Error';
            _model.shouldReplaceInput = true;
            _model.operation = '';
            notifyListeners();
            return;
          }
          result = firstOperand / secondOperand;
          break;

        case 'xʸ': // x的y次方
          // 处理特殊情况
          if (firstOperand == 0 && secondOperand == 0) {
            result = 1; // 数学上 0^0 通常定义为 1
          } else if (firstOperand == 0 && secondOperand < 0) {
            _model.currentInput = 'Error'; // 0的负数次方无意义
            _model.shouldReplaceInput = true;
            _model.operation = '';
            notifyListeners();
            return;
          } else if (firstOperand < 0 && secondOperand != secondOperand.floor()) {
            _model.currentInput = 'Error'; // 负数的非整数次方无意义
            _model.shouldReplaceInput = true;
            _model.operation = '';
            notifyListeners();
            return;
          } else {
            result = pow(firstOperand, secondOperand).toDouble();
          }
          break;

        case 'x√y': // x次方根y
          if (secondOperand < 0 && firstOperand.floor() == firstOperand && firstOperand % 2 != 0) {
            // 奇数次方根可以处理负数
            result = -pow(-secondOperand, 1 / firstOperand).toDouble();
          } else if (secondOperand <= 0) {
            _model.currentInput = 'Error'; // 负数或零的偶数次方根无意义
            _model.shouldReplaceInput = true;
            _model.operation = '';
            notifyListeners();
            return;
          } else if (firstOperand <= 0) {
            _model.currentInput = 'Error'; // 开方指数必须大于0
            _model.shouldReplaceInput = true;
            _model.operation = '';
            notifyListeners();
            return;
          } else {
            result = pow(secondOperand, 1 / firstOperand).toDouble();
          }
          break;

        default:
          _model.currentInput = 'Error';
          _model.shouldReplaceInput = true;
          _model.operation = '';
          notifyListeners();
          return;
      }

      // 检查结果是否有效
      if (result.isNaN || result.isInfinite) {
        _model.currentInput = result.isNaN ? 'Error' : (result.isNegative ? '-∞' : '∞');
        _model.shouldReplaceInput = true;
        _model.operation = '';
        notifyListeners();
        return;
      }

      // 格式化结果
      String formattedResult = _service.formatNumber(result);

      // 更新模型和历史记录
      _model.currentInput = formattedResult;
      _model.addToHistory('$calculation = $formattedResult');
      _model.firstOperand = result;
      _model.operation = '';
      _model.shouldReplaceInput = true;

      // 立即通知界面更新
      notifyListeners();
    } catch (e) {
      debugPrint('Calculation error: $e');
      _model.currentInput = 'Error';
      _model.shouldReplaceInput = true;
      _model.operation = '';
      _model.firstOperand = null;
      notifyListeners();
    }
  }





  // 处理连续操作，如 1+2+3 - 重构版
  void _performChainOperation(String nextOperation) {
    // 如果当前有错误，先清除
    if (_model.currentInput == 'Error') {
      clearAll();
      return;
    }

    try {
      // 获取当前输入作为第二个操作数
      double secondOperand = double.tryParse(_model.currentInput) ?? 0;
      double firstOperand = _model.firstOperand ?? 0;
      String operation = _model.operation;

      // 格式化计算表达式
      String firstOperandStr = _service.formatNumber(firstOperand);
      String secondOperandStr = _service.formatNumber(secondOperand);
      String calculation = '$firstOperandStr $operation $secondOperandStr';

      // 直接计算结果
      double result;

      // 基本运算
      switch (operation) {
        case '+':
          result = firstOperand + secondOperand;
          break;

        case '-':
          result = firstOperand - secondOperand;
          break;

        case '×': // 乘号
          result = firstOperand * secondOperand;
          break;

        case '÷': // 除号
          if (secondOperand == 0) {
            _model.currentInput = 'Error';
            _model.shouldReplaceInput = true;
            _model.operation = '';
            notifyListeners();
            return;
          }
          result = firstOperand / secondOperand;
          break;

        case 'xʸ': // x的y次方
          // 处理特殊情况
          if (firstOperand == 0 && secondOperand == 0) {
            result = 1; // 数学上 0^0 通常定义为 1
          } else if (firstOperand == 0 && secondOperand < 0) {
            _model.currentInput = 'Error'; // 0的负数次方无意义
            _model.shouldReplaceInput = true;
            _model.operation = '';
            notifyListeners();
            return;
          } else if (firstOperand < 0 && secondOperand != secondOperand.floor()) {
            _model.currentInput = 'Error'; // 负数的非整数次方无意义
            _model.shouldReplaceInput = true;
            _model.operation = '';
            notifyListeners();
            return;
          } else {
            result = pow(firstOperand, secondOperand).toDouble();
          }
          break;

        case 'x√y': // x次方根y
          if (secondOperand < 0 && firstOperand.floor() == firstOperand && firstOperand % 2 != 0) {
            // 奇数次方根可以处理负数
            result = -pow(-secondOperand, 1 / firstOperand).toDouble();
          } else if (secondOperand <= 0) {
            _model.currentInput = 'Error'; // 负数或零的偶数次方根无意义
            _model.shouldReplaceInput = true;
            _model.operation = '';
            notifyListeners();
            return;
          } else if (firstOperand <= 0) {
            _model.currentInput = 'Error'; // 开方指数必须大于0
            _model.shouldReplaceInput = true;
            _model.operation = '';
            notifyListeners();
            return;
          } else {
            result = pow(secondOperand, 1 / firstOperand).toDouble();
          }
          break;

        default:
          _model.currentInput = 'Error';
          _model.shouldReplaceInput = true;
          _model.operation = '';
          notifyListeners();
          return;
      }

      // 检查结果是否有效
      if (result.isNaN || result.isInfinite) {
        _model.currentInput = result.isNaN ? 'Error' : (result.isNegative ? '-∞' : '∞');
        _model.shouldReplaceInput = true;
        _model.operation = '';
        notifyListeners();
        return;
      }

      // 格式化结果
      String formattedResult = _service.formatNumber(result);

      // 更新模型和历史记录
      _model.currentInput = formattedResult;
      _model.addToHistory('$calculation = $formattedResult');
      _model.firstOperand = result;
      _model.operation = nextOperation;
      _model.shouldReplaceInput = true;

      // 立即通知界面更新
      notifyListeners();
    } catch (e) {
      debugPrint('Chain operation error: $e');
      _model.currentInput = 'Error';
      _model.shouldReplaceInput = true;
      _model.operation = '';
      _model.firstOperand = null;
      notifyListeners();
    }
  }



  // 科学计算 - 重构版
  void performScientificOperation(String op) {
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
      if (op == '+/-') {
        _model.currentInput = _service.formatNumber(-value);
        _model.shouldReplaceInput = true;
        notifyListeners();
        return;
      }

      // 特殊处理幂运算
      if (op == 'x^y' || op == 'xʸ') {
        _model.firstOperand = value;
        _model.operation = 'xʸ';
        _model.shouldReplaceInput = true;
        notifyListeners();
        return;
      }

      // 特殊处理开方
      if (op == 'x√y') {
        _model.firstOperand = value;
        _model.operation = 'x√y';
        _model.shouldReplaceInput = true;
        notifyListeners();
        return;
      }

      // 根据操作类型计算结果
      switch (op) {
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

    } catch (e) {
      debugPrint('Scientific calculation error: $e');
      _model.currentInput = 'Error';
      _model.shouldReplaceInput = true;
    }

    notifyListeners();
  }

  // 计算阶乘
  int _factorial(int n) {
    if (n <= 1) return 1;
    return n * _factorial(n - 1);
  }

  // 清除所有
  void clearAll() {
    _model.clearAll();
    notifyListeners();
  }

  // 清除当前输入
  void clearEntry() {
    _model.clearEntry();
    notifyListeners();
  }

  // 退格功能 - 删除最后一个字符
  void backspace() {
    // 如果应该替换输入，则清除当前输入
    if (_model.shouldReplaceInput) {
      _model.currentInput = '0';
      _model.shouldReplaceInput = false;
    } else {
      // 如果当前输入长度大于1，删除最后一个字符
      if (_model.currentInput.length > 1) {
        _model.currentInput = _model.currentInput.substring(0, _model.currentInput.length - 1);
      } else {
        // 如果只有一个字符，则设置为0
        _model.currentInput = '0';
      }
    }
    notifyListeners();
  }

  // 内存操作状态
  String _memoryStatus = '';
  String get memoryStatus => _memoryStatus;

  // 清除内存状态消息的计时器
  Timer? _memoryStatusTimer;

  // 设置临时内存状态消息
  void _setMemoryStatus(String status) {
    _memoryStatus = status;
    debugPrint('Memory status: $status'); // 打印状态信息以便调试

    // 取消之前的计时器（如果有）
    _memoryStatusTimer?.cancel();

    // 设置新的计时器，5秒后清除状态消息（增加到 5 秒）
    _memoryStatusTimer = Timer(const Duration(seconds: 5), () {
      _memoryStatus = '';
      notifyListeners();
    });

    // 立即通知界面更新，确保状态显示
    notifyListeners();
  }

  // 内存操作 - 增强版
  void memoryStore() {
    _model.storeInMemory();
    if (_model.memory.isNotEmpty) {
      _setMemoryStatus('已存储到内存: ${_model.memory}');
    } else {
      _setMemoryStatus('存储失败');
    }
  }

  void memoryRecall() {
    if (_model.memory.isEmpty) {
      _setMemoryStatus('内存为空');
    } else {
      _model.recallMemory();
      _setMemoryStatus('已从内存读取: ${_model.memory}');
    }
  }

  void memoryClear() {
    if (_model.memory.isNotEmpty) {
      String oldMemory = _model.memory;
      _model.clearMemory();
      _setMemoryStatus('内存已清除: $oldMemory');
    } else {
      _setMemoryStatus('内存已经为空');
    }
  }

  void memoryAdd() {
    String oldMemory = _model.memory.isEmpty ? '0' : _model.memory;
    _model.addToMemory();
    if (_model.memory != oldMemory) {
      _setMemoryStatus('已添加到内存: ${_model.memory}');
    } else {
      _setMemoryStatus('添加失败');
    }
  }

  void memorySubtract() {
    String oldMemory = _model.memory.isEmpty ? '0' : _model.memory;
    _model.subtractFromMemory();
    if (_model.memory != oldMemory) {
      _setMemoryStatus('已从内存减去: ${_model.memory}');
    } else {
      _setMemoryStatus('减去失败');
    }
  }

  // 显示历史记录
  List<String> getHistory() {
    return _model.history;
  }

  // 添加到历史记录
  void addToHistory(String calculation) {
    _model.addToHistory(calculation);
    notifyListeners();
  }
}
