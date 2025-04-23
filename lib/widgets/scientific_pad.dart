import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';
import 'calculator_button.dart';

class ScientificPad extends StatelessWidget {
  final bool isLandscape;

  const ScientificPad({Key? key, this.isLandscape = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final calculatorProvider = Provider.of<CalculatorProvider>(context);

    if (isLandscape) {
      return _buildLandscapeLayout(calculatorProvider);
    } else {
      return _buildPortraitLayout(calculatorProvider);
    }
  }

  Widget _buildPortraitLayout(CalculatorProvider calculatorProvider) {
    return Expanded(
      flex: 3,
      child: Column(
        children: [
          // 第一行 - 三角函数
          Expanded(
            child: Row(
              children: [
                CalculatorButton(
                  text: 'sin',
                  onPressed:
                      () =>
                          calculatorProvider.performScientificOperation('sin'),
                  backgroundColor: Colors.purple.shade100,
                ),
                CalculatorButton(
                  text: 'cos',
                  onPressed:
                      () =>
                          calculatorProvider.performScientificOperation('cos'),
                  backgroundColor: Colors.purple.shade100,
                ),
                CalculatorButton(
                  text: 'tan',
                  onPressed:
                      () =>
                          calculatorProvider.performScientificOperation('tan'),
                  backgroundColor: Colors.purple.shade100,
                ),
              ],
            ),
          ),

          // 第二行 - 常数和对数
          Expanded(
            child: Row(
              children: [
                CalculatorButton(
                  text: 'π',
                  onPressed: () => calculatorProvider.inputConstant('π'),
                  backgroundColor: Colors.green.shade100,
                ),
                CalculatorButton(
                  text: 'e',
                  onPressed: () => calculatorProvider.inputConstant('e'),
                  backgroundColor: Colors.green.shade100,
                ),
                CalculatorButton(
                  text: 'ln',
                  onPressed:
                      () => calculatorProvider.performScientificOperation('ln'),
                  backgroundColor: Colors.purple.shade100,
                ),
                CalculatorButton(
                  text: 'log',
                  onPressed:
                      () =>
                          calculatorProvider.performScientificOperation('log'),
                  backgroundColor: Colors.purple.shade100,
                ),
              ],
            ),
          ),

          // 第三行 - 幂运算
          Expanded(
            child: Row(
              children: [
                CalculatorButton(
                  text: 'x²',
                  onPressed:
                      () => calculatorProvider.performScientificOperation('x²'),
                  backgroundColor: Colors.teal.shade100,
                ),
                CalculatorButton(
                  text: 'x³',
                  onPressed:
                      () => calculatorProvider.performScientificOperation('x³'),
                  backgroundColor: Colors.teal.shade100,
                ),
                CalculatorButton(
                  text: 'xʸ',
                  onPressed: () => calculatorProvider.setOperation('xʸ'),
                  backgroundColor: Colors.teal.shade100,
                ),
                CalculatorButton(
                  text: '10^x',
                  onPressed:
                      () =>
                          calculatorProvider.performScientificOperation('10^x'),
                  backgroundColor: Colors.teal.shade100,
                ),
              ],
            ),
          ),

          // 第四行 - 开方和其他
          Expanded(
            child: Row(
              children: [
                CalculatorButton(
                  text: '√',
                  onPressed:
                      () =>
                          calculatorProvider.performScientificOperation('sqrt'),
                  backgroundColor: Colors.teal.shade100,
                ),
                CalculatorButton(
                  text: '∛',
                  onPressed:
                      () =>
                          calculatorProvider.performScientificOperation('cbrt'),
                  backgroundColor: Colors.teal.shade100,
                ),
                CalculatorButton(
                  text: 'x√y',
                  onPressed: () => calculatorProvider.setOperation('x√y'),
                  backgroundColor: Colors.teal.shade100,
                ),
                CalculatorButton(
                  text: 'e^x',
                  onPressed:
                      () =>
                          calculatorProvider.performScientificOperation('e^x'),
                  backgroundColor: Colors.teal.shade100,
                ),
              ],
            ),
          ),

          // 第五行 - 其他函数
          Expanded(
            child: Row(
              children: [
                CalculatorButton(
                  text: '|x|',
                  onPressed:
                      () =>
                          calculatorProvider.performScientificOperation('abs'),
                  backgroundColor: Colors.amber.shade100,
                ),
                CalculatorButton(
                  text: '1/x',
                  onPressed:
                      () =>
                          calculatorProvider.performScientificOperation('1/x'),
                  backgroundColor: Colors.amber.shade100,
                ),
                CalculatorButton(
                  text: 'n!',
                  onPressed:
                      () => calculatorProvider.performScientificOperation('n!'),
                  backgroundColor: Colors.amber.shade100,
                ),
                CalculatorButton(
                  text: '+/-',
                  onPressed:
                      () =>
                          calculatorProvider.performScientificOperation('+/-'),
                  backgroundColor: Colors.amber.shade100,
                ),
              ],
            ),
          ),

          // 第六行 - 括号
          Expanded(
            child: Row(
              children: [
                CalculatorButton(
                  text: '(',
                  onPressed: () => calculatorProvider.inputParenthesis('('),
                  backgroundColor: Colors.orange.shade100,
                ),
                CalculatorButton(
                  text: ')',
                  onPressed: () => calculatorProvider.inputParenthesis(')'),
                  backgroundColor: Colors.orange.shade100,
                ),
                // 留两个空位保持布局平衡
                Expanded(child: Container()),
                Expanded(child: Container()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLandscapeLayout(CalculatorProvider calculatorProvider) {
    return Column(
      children: [
        // 第一行 - 三角函数
        Expanded(
          child: Row(
            children: [
              CalculatorButton(
                text: 'sin',
                onPressed:
                    () => calculatorProvider.performScientificOperation('sin'),
                backgroundColor: Colors.purple.shade100,
              ),
              CalculatorButton(
                text: 'cos',
                onPressed:
                    () => calculatorProvider.performScientificOperation('cos'),
                backgroundColor: Colors.purple.shade100,
              ),
              CalculatorButton(
                text: 'tan',
                onPressed:
                    () => calculatorProvider.performScientificOperation('tan'),
                backgroundColor: Colors.purple.shade100,
              ),
            ],
          ),
        ),

        // 第二行 - 常数和对数
        Expanded(
          child: Row(
            children: [
              CalculatorButton(
                text: 'π',
                onPressed: () => calculatorProvider.inputConstant('π'),
                backgroundColor: Colors.green.shade100,
              ),
              CalculatorButton(
                text: 'e',
                onPressed: () => calculatorProvider.inputConstant('e'),
                backgroundColor: Colors.green.shade100,
              ),
              CalculatorButton(
                text: 'ln',
                onPressed:
                    () => calculatorProvider.performScientificOperation('ln'),
                backgroundColor: Colors.purple.shade100,
              ),
            ],
          ),
        ),

        // 第三行 - 幂运算
        Expanded(
          child: Row(
            children: [
              CalculatorButton(
                text: 'x²',
                onPressed:
                    () => calculatorProvider.performScientificOperation('x²'),
                backgroundColor: Colors.teal.shade100,
              ),
              CalculatorButton(
                text: 'x³',
                onPressed:
                    () => calculatorProvider.performScientificOperation('x³'),
                backgroundColor: Colors.teal.shade100,
              ),
              CalculatorButton(
                text: 'xʸ',
                onPressed: () => calculatorProvider.setOperation('xʸ'),
                backgroundColor: Colors.teal.shade100,
              ),
            ],
          ),
        ),

        // 第四行 - 开方
        Expanded(
          child: Row(
            children: [
              CalculatorButton(
                text: '√',
                onPressed:
                    () => calculatorProvider.performScientificOperation('sqrt'),
                backgroundColor: Colors.teal.shade100,
              ),
              CalculatorButton(
                text: '∛',
                onPressed:
                    () => calculatorProvider.performScientificOperation('cbrt'),
                backgroundColor: Colors.teal.shade100,
              ),
              CalculatorButton(
                text: 'x√y',
                onPressed: () => calculatorProvider.setOperation('x√y'),
                backgroundColor: Colors.teal.shade100,
              ),
            ],
          ),
        ),

        // 第五行 - 其他函数
        Expanded(
          child: Row(
            children: [
              CalculatorButton(
                text: '|x|',
                onPressed:
                    () => calculatorProvider.performScientificOperation('abs'),
                backgroundColor: Colors.amber.shade100,
              ),
              CalculatorButton(
                text: '1/x',
                onPressed:
                    () => calculatorProvider.performScientificOperation('1/x'),
                backgroundColor: Colors.amber.shade100,
              ),
              CalculatorButton(
                text: 'n!',
                onPressed:
                    () => calculatorProvider.performScientificOperation('n!'),
                backgroundColor: Colors.amber.shade100,
              ),
            ],
          ),
        ),

        // 第六行 - 括号和指数
        Expanded(
          child: Row(
            children: [
              CalculatorButton(
                text: '(',
                onPressed: () => calculatorProvider.inputParenthesis('('),
                backgroundColor: Colors.orange.shade100,
              ),
              CalculatorButton(
                text: ')',
                onPressed: () => calculatorProvider.inputParenthesis(')'),
                backgroundColor: Colors.orange.shade100,
              ),
              CalculatorButton(
                text: 'e^x',
                onPressed:
                    () => calculatorProvider.performScientificOperation('e^x'),
                backgroundColor: Colors.teal.shade100,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
