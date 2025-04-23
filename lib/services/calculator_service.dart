import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';

class CalculatorService {
  // 使用异步方法进行基本计算
  Future<double> calculate(double a, double b, String operation) async {
    try {
      // 处理特殊情况
      if (a.isNaN || b.isNaN) {
        return double.nan;
      }

      double result;
      switch (operation) {
        case '+':
          result = a + b;
          break;
        case '-':
          result = a - b;
          break;
        case '×':
          result = a * b;
          break;
        case '÷':
          if (b == 0) {
            // 返回无穷大而不是抛出异常
            return a == 0 ? double.nan : (a < 0 ? double.negativeInfinity : double.infinity);
          }
          result = a / b;
          break;
        case '%':
          if (b == 0) {
            return double.nan;
          }
          result = a % b;
          break;
        case 'xʸ':
          // 处理特殊情况
          if (a == 0 && b == 0) {
            return 1; // 数学上 0^0 通常定义为 1
          }
          if (a == 0 && b < 0) {
            return double.infinity; // 除以零
          }
          if (a < 0 && b != b.floorToDouble()) {
            return double.nan; // 负数的非整数次方
          }
          result = pow(a, b).toDouble();
          break;
        case 'x√y':
          if (b < 0 && a.floorToDouble() == a && a % 2 != 0) {
            // 奇数次方根可以处理负数
            result = -pow(-b, 1 / a).toDouble();
          } else if (b <= 0) {
            return double.nan; // 底数必须大于0
          } else if (a <= 0) {
            return double.nan; // 开方指数必须大于0
          } else {
            result = pow(b, 1 / a).toDouble();
          }
          break;
        default:
          throw Exception('不支持的操作');
      }

      // 检查结果是否有效
      if (result.isNaN || result.isInfinite) {
        return result; // 直接返回特殊值
      }

      return result;
    } catch (e) {
      debugPrint('计算错误: $e');
      return double.nan;
    }
  }

  // 科学计算函数
  Future<double> scientificCalculation(
    double value,
    String operation, {
    bool isRadianMode = false,
  }) async {
    try {
      // 处理特殊情况
      if (value.isNaN) {
        return double.nan;
      }

      double result;
      switch (operation) {
        case 'sqrt':
          if (value < 0) {
            return double.nan; // 负数不能开平方根
          }
          result = sqrt(value);
          break;
        case 'sin':
          // 如果是角度模式，需要转换为弧度
          if (!isRadianMode) {
            value = value * pi / 180;
          }
          result = sin(value);
          break;
        case 'cos':
          if (!isRadianMode) {
            value = value * pi / 180;
          }
          result = cos(value);
          break;
        case 'tan':
          if (!isRadianMode) {
            value = value * pi / 180;
          }
          // 处理 tan 的特殊情况，如 90度、270度等
          double normalizedValue = value % (2 * pi);
          if (normalizedValue.abs() % pi == pi / 2) {
            return value.isNegative ? double.negativeInfinity : double.infinity;
          }
          result = tan(value);
          break;
        case 'log':
          if (value <= 0) {
            return double.nan; // 对数的底数必须大于0
          }
          result = log(value) / ln10;
          break;
        case 'ln':
          if (value <= 0) {
            return double.nan; // 自然对数的底数必须大于0
          }
          result = log(value);
          break;
        case '1/x':
          if (value == 0) {
            return double.infinity; // 除以零返回无穷大
          }
          result = 1 / value;
          break;
        case 'e^x':
          // 处理溢出情况
          if (value > 709) {
            return double.infinity;
          } else if (value < -709) {
            return 0;
          }
          result = exp(value);
          break;
        case 'n!':
          if (value < 0 || value != value.floor()) {
            return double.nan; // 阶乘只适用于非负整数
          }
          if (value > 170) {
            return double.infinity; // 防止计算过大的阶乘
          }
          result = _factorial(value.toInt()).toDouble();
          break;
        case '+/-':
          result = -value;
          break;
        case 'abs':
          result = value.abs();
          break;
        case 'percent':
          result = value / 100.0;
          break;
        default:
          return double.nan; // 不支持的操作
      }

      // 检查结果是否有效
      if (result.isNaN || result.isInfinite) {
        return result; // 直接返回特殊值
      }

      return result;
    } catch (e) {
      debugPrint('科学计算错误: $e');
      return double.nan;
    }
  }

  // 计算阶乘
  int _factorial(int n) {
    if (n <= 1) return 1;
    return n * _factorial(n - 1);
  }

  // 格式化数字，去除不必要的小数点和零 - 重构版
  String formatNumber(double number) {
    // 处理特殊情况
    if (number.isInfinite) return number.isNegative ? '-∞' : '∞';
    if (number.isNaN) return 'Error';

    // 处理整数
    if (number == number.truncate()) {
      // 如果是整数，直接返回整数形式
      return number.toInt().toString();
    }

    // 处理非常大的数字
    if (number.abs() >= 1e12) {
      return number.toStringAsExponential(6);
    }

    // 处理非常小的数字
    if (number.abs() < 1e-6 && number != 0) {
      return number.toStringAsExponential(6);
    }

    // 处理正常范围的数字
    // 首先确定需要保留的小数位数
    int precision;
    double absValue = number.abs();

    if (absValue >= 1e6) {
      precision = 2; // 大数字保留较少小数位
    } else if (absValue >= 1e3) {
      precision = 4; // 中等大小的数字
    } else if (absValue >= 1) {
      precision = 6; // 一般大小的数字
    } else if (absValue >= 1e-3) {
      precision = 8; // 小数
    } else {
      precision = 10; // 非常小的数字
    }

    // 格式化数字，保留指定的小数位数
    String formatted = number.toStringAsFixed(precision);

    // 去除末尾的零
    while (formatted.contains('.') && formatted.endsWith('0')) {
      formatted = formatted.substring(0, formatted.length - 1);
    }

    // 如果小数点后没有数字，删除小数点
    if (formatted.endsWith('.')) {
      formatted = formatted.substring(0, formatted.length - 1);
    }

    return formatted;
  }

  // 计算表达式 - 简化版
  Future<String> evaluateExpression(
    String expression, {
    bool isRadianMode = false,
  }) async {
    try {
      // 预处理表达式
      expression = expression.trim();

      // 替换数学符号
      expression = expression.replaceAll('×', '*');
      expression = expression.replaceAll('÷', '/');
      expression = expression.replaceAll('π', '$pi');

      // 处理科学计算函数
      expression = _processScientificFunctions(expression, isRadianMode);

      // 直接计算简单表达式
      if (_isSimpleExpression(expression)) {
        return _calculateSimpleExpression(expression);
      }

      // 如果是复杂表达式，则分解为简单表达式计算
      double result = _calculateBasicExpression(expression);
      return formatNumber(result);
    } catch (e) {
      debugPrint('Expression evaluation error: $e');
      throw Exception('表达式计算错误');
    }
  }

  // 判断是否为简单表达式
  bool _isSimpleExpression(String expression) {
    // 只包含数字和一个运算符
    return RegExp(r'^[0-9.]+[+\-*/][0-9.]+$').hasMatch(expression);
  }

  // 计算简单表达式
  String _calculateSimpleExpression(String expression) {
    if (expression.contains('+')) {
      List<String> parts = expression.split('+');
      double a = double.parse(parts[0]);
      double b = double.parse(parts[1]);
      return formatNumber(a + b);
    } else if (expression.contains('-')) {
      List<String> parts = expression.split('-');
      double a = double.parse(parts[0]);
      double b = double.parse(parts[1]);
      return formatNumber(a - b);
    } else if (expression.contains('*')) {
      List<String> parts = expression.split('*');
      double a = double.parse(parts[0]);
      double b = double.parse(parts[1]);
      return formatNumber(a * b);
    } else if (expression.contains('/')) {
      List<String> parts = expression.split('/');
      double a = double.parse(parts[0]);
      double b = double.parse(parts[1]);
      if (b == 0) {
        throw Exception('除数不能为零');
      }
      return formatNumber(a / b);
    }

    return expression; // 如果没有运算符，直接返回
  }

  // 计算基本表达式
  double _calculateBasicExpression(String expression) {
    // 处理加减法
    if (expression.contains('+')) {
      int index = expression.lastIndexOf('+');
      String leftPart = expression.substring(0, index);
      String rightPart = expression.substring(index + 1);

      double leftValue = _calculateBasicExpression(leftPart);
      double rightValue = _calculateBasicExpression(rightPart);

      return leftValue + rightValue;
    }

    if (expression.contains('-')) {
      int index = expression.lastIndexOf('-');
      String leftPart = expression.substring(0, index);
      String rightPart = expression.substring(index + 1);

      // 处理负数的情况
      if (leftPart.isEmpty) {
        return -_calculateBasicExpression(rightPart);
      }

      double leftValue = _calculateBasicExpression(leftPart);
      double rightValue = _calculateBasicExpression(rightPart);

      return leftValue - rightValue;
    }

    // 处理乘除法
    if (expression.contains('*')) {
      int index = expression.lastIndexOf('*');
      String leftPart = expression.substring(0, index);
      String rightPart = expression.substring(index + 1);

      double leftValue = _calculateBasicExpression(leftPart);
      double rightValue = _calculateBasicExpression(rightPart);

      return leftValue * rightValue;
    }

    if (expression.contains('/')) {
      int index = expression.lastIndexOf('/');
      String leftPart = expression.substring(0, index);
      String rightPart = expression.substring(index + 1);

      double leftValue = _calculateBasicExpression(leftPart);
      double rightValue = _calculateBasicExpression(rightPart);

      if (rightValue == 0) {
        throw Exception('除数不能为零');
      }

      return leftValue / rightValue;
    }

    // 如果没有运算符，尝试直接解析为数字
    try {
      return double.parse(expression);
    } catch (e) {
      throw Exception('无法解析表达式: $expression');
    }
  }

  // 处理科学计算函数
  String _processScientificFunctions(String expression, bool isRadianMode) {
    // 替换常量
    expression = expression.replaceAll('e', '$e');

    // 处理三角函数
    expression = expression.replaceAllMapped(RegExp(r'sin\(([^)]+)\)'), (
      match,
    ) {
      try {
        double value = double.parse(match.group(1)!);
        if (!isRadianMode) {
          value = value * pi / 180;
        }
        return '${sin(value)}';
      } catch (e) {
        return match.group(0)!;
      }
    });

    expression = expression.replaceAllMapped(RegExp(r'cos\(([^)]+)\)'), (
      match,
    ) {
      try {
        double value = double.parse(match.group(1)!);
        if (!isRadianMode) {
          value = value * pi / 180;
        }
        return '${cos(value)}';
      } catch (e) {
        return match.group(0)!;
      }
    });

    expression = expression.replaceAllMapped(RegExp(r'tan\(([^)]+)\)'), (
      match,
    ) {
      try {
        double value = double.parse(match.group(1)!);
        if (!isRadianMode) {
          value = value * pi / 180;
        }
        return '${tan(value)}';
      } catch (e) {
        return match.group(0)!;
      }
    });

    // 处理平方根
    expression = expression.replaceAllMapped(RegExp(r'sqrt\(([^)]+)\)'), (
      match,
    ) {
      try {
        double value = double.parse(match.group(1)!);
        return '${sqrt(value)}';
      } catch (e) {
        return match.group(0)!;
      }
    });

    return expression;
  }
}
