import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';
import 'calculator_button.dart';

class NumberPad extends StatelessWidget {
  final bool isLandscape;

  const NumberPad({Key? key, this.isLandscape = false}) : super(key: key);

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
      flex: 5,
      child: Column(
        children: [
          // 科学计算按钮行1
          Expanded(
            child: Row(
              children: [
                CalculatorButton(
                  text: '√',
                  isActive: calculatorProvider.activeFunctionKey == 'sqrt',
                  isScientific: true,
                  onPressed: () {
                    calculatorProvider.setActiveFunctionKey('sqrt');
                    calculatorProvider.performScientificOperation('sqrt');
                  },
                ),
                CalculatorButton(
                  text: '|x|',
                  isActive: calculatorProvider.activeFunctionKey == 'abs',
                  isScientific: true,
                  onPressed: () {
                    calculatorProvider.setActiveFunctionKey('abs');
                    calculatorProvider.performScientificOperation('abs');
                  },
                ),
                CalculatorButton(
                  text: 'xʸ',
                  isActive: calculatorProvider.activeFunctionKey == 'xʸ',
                  isScientific: true,
                  onPressed: () {
                    calculatorProvider.setActiveFunctionKey('xʸ');
                    calculatorProvider.performScientificOperation('xʸ');
                  },
                ),
                CalculatorButton(
                  text: 'n!',
                  isActive: calculatorProvider.activeFunctionKey == 'n!',
                  isScientific: true,
                  onPressed: () {
                    calculatorProvider.setActiveFunctionKey('n!');
                    calculatorProvider.performScientificOperation('n!');
                  },
                ),
                CalculatorButton(
                  text: 'x²',
                  isActive: calculatorProvider.activeFunctionKey == 'x²',
                  isScientific: true,
                  onPressed: () {
                    calculatorProvider.setActiveFunctionKey('x²');
                    calculatorProvider.performScientificOperation('x²');
                  },
                ),
              ],
            ),
          ),

          // 科学计算按钮行2
          Expanded(
            child: Row(
              children: [
                CalculatorButton(
                  text: 'sin',
                  isActive: calculatorProvider.activeFunctionKey == 'sin',
                  isScientific: true,
                  onPressed: () {
                    calculatorProvider.setActiveFunctionKey('sin');
                    calculatorProvider.performScientificOperation('sin');
                  },
                ),
                CalculatorButton(
                  text: 'cos',
                  isActive: calculatorProvider.activeFunctionKey == 'cos',
                  isScientific: true,
                  onPressed: () {
                    calculatorProvider.setActiveFunctionKey('cos');
                    calculatorProvider.performScientificOperation('cos');
                  },
                ),
                CalculatorButton(
                  text: 'tan',
                  isActive: calculatorProvider.activeFunctionKey == 'tan',
                  isScientific: true,
                  onPressed: () {
                    calculatorProvider.setActiveFunctionKey('tan');
                    calculatorProvider.performScientificOperation('tan');
                  },
                ),
                CalculatorButton(
                  text: 'log',
                  isActive: calculatorProvider.activeFunctionKey == 'log',
                  isScientific: true,
                  onPressed: () {
                    calculatorProvider.setActiveFunctionKey('log');
                    calculatorProvider.performScientificOperation('log');
                  },
                ),
                CalculatorButton(
                  text: 'ln',
                  isActive: calculatorProvider.activeFunctionKey == 'ln',
                  isScientific: true,
                  onPressed: () {
                    calculatorProvider.setActiveFunctionKey('ln');
                    calculatorProvider.performScientificOperation('ln');
                  },
                ),
              ],
            ),
          ),

          // 科学计算按钮行3
          Expanded(
            child: Row(
              children: [
                CalculatorButton(
                  text: '1/x',
                  isActive: calculatorProvider.activeFunctionKey == '1/x',
                  isScientific: true,
                  onPressed: () {
                    calculatorProvider.setActiveFunctionKey('1/x');
                    calculatorProvider.performScientificOperation('1/x');
                  },
                ),
                CalculatorButton(
                  text: 'e^x',
                  isActive: calculatorProvider.activeFunctionKey == 'e^x',
                  isScientific: true,
                  onPressed: () {
                    calculatorProvider.setActiveFunctionKey('e^x');
                    calculatorProvider.performScientificOperation('e^x');
                  },
                ),
                CalculatorButton(
                  text: '+/-',
                  isActive: calculatorProvider.activeFunctionKey == '+/-',
                  isScientific: true,
                  onPressed: () {
                    calculatorProvider.setActiveFunctionKey('+/-');
                    calculatorProvider.performScientificOperation('+/-');
                  },
                ),
                CalculatorButton(
                  text: '%',
                  isActive: calculatorProvider.activeFunctionKey == '%',
                  isScientific: true,
                  onPressed: () {
                    calculatorProvider.setActiveFunctionKey('%');
                    calculatorProvider.percentage();
                  },
                ),
                CalculatorButton(
                  text: 'AC',
                  onPressed: () => calculatorProvider.clearAll(),
                  backgroundColor: Colors.pink.shade100,
                  textColor: Colors.red,
                ),
              ],
            ),
          ),

          // 数字按钮行1 - 7,8,9,÷
          Expanded(
            child: Row(
              children: [
                CalculatorButton(
                  text: '7',
                  onPressed: () => calculatorProvider.inputDigit('7'),
                ),
                CalculatorButton(
                  text: '8',
                  onPressed: () => calculatorProvider.inputDigit('8'),
                ),
                CalculatorButton(
                  text: '9',
                  onPressed: () => calculatorProvider.inputDigit('9'),
                ),
                CalculatorButton(
                  text: '÷',
                  onPressed: () => calculatorProvider.setOperation('÷'),
                  backgroundColor: Colors.blue.shade100,
                ),
                CalculatorButton(
                  text: 'CE',
                  onPressed: () => calculatorProvider.clearEntry(),
                  backgroundColor: Colors.pink.shade100,
                  textColor: Colors.red,
                ),
              ],
            ),
          ),

          // 数字按钮行2 - 4,5,6,×
          Expanded(
            child: Row(
              children: [
                CalculatorButton(
                  text: '4',
                  onPressed: () => calculatorProvider.inputDigit('4'),
                ),
                CalculatorButton(
                  text: '5',
                  onPressed: () => calculatorProvider.inputDigit('5'),
                ),
                CalculatorButton(
                  text: '6',
                  onPressed: () => calculatorProvider.inputDigit('6'),
                ),
                CalculatorButton(
                  text: '×',
                  onPressed: () => calculatorProvider.setOperation('×'),
                  backgroundColor: Colors.blue.shade100,
                ),
                CalculatorButton(
                  text: '0',
                  onPressed: () => calculatorProvider.inputDigit('0'),
                ),
              ],
            ),
          ),

          // 数字按钮行3 - 1,2,3,-
          Expanded(
            child: Row(
              children: [
                CalculatorButton(
                  text: '1',
                  onPressed: () => calculatorProvider.inputDigit('1'),
                ),
                CalculatorButton(
                  text: '2',
                  onPressed: () => calculatorProvider.inputDigit('2'),
                ),
                CalculatorButton(
                  text: '3',
                  onPressed: () => calculatorProvider.inputDigit('3'),
                ),
                CalculatorButton(
                  text: '-',
                  onPressed: () => calculatorProvider.setOperation('-'),
                  backgroundColor: Colors.blue.shade100,
                ),
                CalculatorButton(
                  text: '.',
                  onPressed: () => calculatorProvider.inputDigit('.'),
                ),
              ],
            ),
          ),

          // 数字按钮行4 - 00,000,+,⌫,=
          Expanded(
            child: Row(
              children: [
                CalculatorButton(
                  text: '00',
                  onPressed:
                      () => {
                        calculatorProvider.inputDigit('0'),
                        calculatorProvider.inputDigit('0'),
                      },
                ),
                CalculatorButton(
                  text: '000',
                  onPressed:
                      () => {
                        calculatorProvider.inputDigit('0'),
                        calculatorProvider.inputDigit('0'),
                        calculatorProvider.inputDigit('0'),
                      },
                ),
                CalculatorButton(
                  text: '+',
                  onPressed: () => calculatorProvider.setOperation('+'),
                  backgroundColor: Colors.blue.shade100,
                ),
                CalculatorButton(
                  text: '⌫',
                  onPressed: () => calculatorProvider.backspace(),
                  backgroundColor: Colors.pink.shade100,
                ),
                CalculatorButton(
                  text: '=',
                  onPressed: () => calculatorProvider.calculateResult(),
                  backgroundColor: Colors.orange,
                  textColor: Colors.white,
                ),
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
        // 科学计算按钮行1
        Expanded(
          child: Row(
            children: [
              CalculatorButton(
                text: '√',
                onPressed:
                    () => calculatorProvider.performScientificOperation('sqrt'),
              ),
              CalculatorButton(
                text: '|x|',
                onPressed: () {
                  calculatorProvider.setActiveFunctionKey('|x|');
                  calculatorProvider.performScientificOperation('abs');
                },
              ),
              CalculatorButton(
                text: 'xʸ',
                onPressed: () {
                  calculatorProvider.setActiveFunctionKey('xʸ');
                  calculatorProvider.performScientificOperation('xʸ');
                },
              ),
              CalculatorButton(
                text: 'n!',
                onPressed: () {
                  calculatorProvider.setActiveFunctionKey('n!');
                  calculatorProvider.performScientificOperation('n!');
                },
              ),
              CalculatorButton(
                text: 'x²',
                onPressed:
                    () => calculatorProvider.performScientificOperation('x²'),
              ),
            ],
          ),
        ),

        // 科学计算按钮行2
        Expanded(
          child: Row(
            children: [
              CalculatorButton(
                text: 'sin',
                onPressed:
                    () => calculatorProvider.performScientificOperation('sin'),
              ),
              CalculatorButton(
                text: 'cos',
                onPressed:
                    () => calculatorProvider.performScientificOperation('cos'),
              ),
              CalculatorButton(
                text: 'tan',
                onPressed:
                    () => calculatorProvider.performScientificOperation('tan'),
              ),
              CalculatorButton(
                text: 'log',
                onPressed:
                    () => calculatorProvider.performScientificOperation('log'),
              ),
              CalculatorButton(
                text: 'ln',
                onPressed:
                    () => calculatorProvider.performScientificOperation('ln'),
              ),
            ],
          ),
        ),

        // 科学计算按钮行3
        Expanded(
          child: Row(
            children: [
              CalculatorButton(
                text: '1/x',
                onPressed:
                    () => calculatorProvider.performScientificOperation('1/x'),
              ),
              CalculatorButton(
                text: 'e^x',
                onPressed:
                    () => calculatorProvider.performScientificOperation('e^x'),
              ),
              CalculatorButton(
                text: '+/-',
                onPressed:
                    () => calculatorProvider.performScientificOperation('+/-'),
              ),
              CalculatorButton(
                text: '%',
                onPressed: () => calculatorProvider.percentage(),
              ),
              CalculatorButton(
                text: 'AC',
                onPressed: () => calculatorProvider.clearAll(),
                backgroundColor: Colors.pink.shade100,
                textColor: Colors.red,
              ),
            ],
          ),
        ),

        // 数字按钮行1 - 7,8,9,÷
        Expanded(
          child: Row(
            children: [
              CalculatorButton(
                text: '7',
                onPressed: () => calculatorProvider.inputDigit('7'),
              ),
              CalculatorButton(
                text: '8',
                onPressed: () => calculatorProvider.inputDigit('8'),
              ),
              CalculatorButton(
                text: '9',
                onPressed: () => calculatorProvider.inputDigit('9'),
              ),
              CalculatorButton(
                text: '÷',
                onPressed: () => calculatorProvider.setOperation('÷'),
                backgroundColor: Colors.blue.shade100,
              ),
              CalculatorButton(
                text: 'CE',
                onPressed: () => calculatorProvider.clearEntry(),
                backgroundColor: Colors.pink.shade100,
                textColor: Colors.red,
              ),
            ],
          ),
        ),

        // 数字按钮行2 - 4,5,6,×
        Expanded(
          child: Row(
            children: [
              CalculatorButton(
                text: '4',
                onPressed: () => calculatorProvider.inputDigit('4'),
              ),
              CalculatorButton(
                text: '5',
                onPressed: () => calculatorProvider.inputDigit('5'),
              ),
              CalculatorButton(
                text: '6',
                onPressed: () => calculatorProvider.inputDigit('6'),
              ),
              CalculatorButton(
                text: '×',
                onPressed: () => calculatorProvider.setOperation('×'),
                backgroundColor: Colors.blue.shade100,
              ),
              CalculatorButton(
                text: '0',
                onPressed: () => calculatorProvider.inputDigit('0'),
              ),
            ],
          ),
        ),

        // 数字按钮行3 - 1,2,3,-
        Expanded(
          child: Row(
            children: [
              CalculatorButton(
                text: '1',
                onPressed: () => calculatorProvider.inputDigit('1'),
              ),
              CalculatorButton(
                text: '2',
                onPressed: () => calculatorProvider.inputDigit('2'),
              ),
              CalculatorButton(
                text: '3',
                onPressed: () => calculatorProvider.inputDigit('3'),
              ),
              CalculatorButton(
                text: '-',
                onPressed: () => calculatorProvider.setOperation('-'),
                backgroundColor: Colors.blue.shade100,
              ),
              CalculatorButton(
                text: '.',
                onPressed: () => calculatorProvider.inputDigit('.'),
              ),
            ],
          ),
        ),

        // 数字按钮行4 - 00,000,+,⌫,=
        Expanded(
          child: Row(
            children: [
              CalculatorButton(
                text: '00',
                onPressed:
                    () => {
                      calculatorProvider.inputDigit('0'),
                      calculatorProvider.inputDigit('0'),
                    },
              ),
              CalculatorButton(
                text: '000',
                onPressed:
                    () => {
                      calculatorProvider.inputDigit('0'),
                      calculatorProvider.inputDigit('0'),
                      calculatorProvider.inputDigit('0'),
                    },
              ),
              CalculatorButton(
                text: '+',
                onPressed: () => calculatorProvider.setOperation('+'),
                backgroundColor: Colors.blue.shade100,
              ),
              CalculatorButton(
                text: '',
                onPressed: () => calculatorProvider.backspace(),
                backgroundColor: Colors.pink.shade100,
                // 用child自定义内容
                // ignore: prefer_const_constructors
                child: Icon(Icons.backspace_outlined, size: 28, color: Colors.black),
              ),
              CalculatorButton(
                text: '=',
                onPressed: () => calculatorProvider.calculateResult(),
                backgroundColor: Colors.orange,
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
