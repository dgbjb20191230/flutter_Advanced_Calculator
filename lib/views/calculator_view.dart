import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/calculator_viewmodel.dart';
import 'calculator_button.dart';
import 'history_view.dart';

class CalculatorView extends StatelessWidget {
  const CalculatorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CalculatorViewModel>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('高级计算器'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 显示区域
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [

                  // 主显示区域
                  Container(
                    width: double.infinity,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.lightBlue.shade50,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.centerRight,
                    child: Text(
                      viewModel.currentInput,
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // 内存值和状态指示器
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 内存状态指示器
                        if (viewModel.memoryStatus.isNotEmpty)
                          Text(
                            viewModel.memoryStatus,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.red, // 使用红色文字
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        else
                          const SizedBox(), // 占位空间

                        // 内存值指示器
                        Text(
                          viewModel.memory.isNotEmpty ? 'M: ${viewModel.memory}' : '',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.pink.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 功能按钮
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // 弹出弧度制/角度制选择对话框
                        showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: const Text('角度制选择'),
                                content: const Text('此功能尚未实现'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('关闭'),
                                  ),
                                ],
                              ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                      ),
                      child: const Text('弧度制'),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // 历史记录按钮
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    HistoryView(history: viewModel.history),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                      ),
                      child: const Text('历史记录'),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // 按钮区域
            Expanded(
              child:
                  isLandscape && !isSmallScreen
                      ? _buildLandscapeLayout(viewModel)
                      : _buildPortraitLayout(viewModel),
            ),

            // 版权信息
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '© 2025 高级计算器应用',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPortraitLayout(CalculatorViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // 内存操作按钮行
          Expanded(
            child: Row(
              children: [
                CalculatorButton(
                  text: 'MC',
                  onPressed: () => viewModel.memoryClear(),
                  backgroundColor: Colors.pink.shade100,
                  icon: Icons.memory_outlined, // 内存图标
                ),
                CalculatorButton(
                  text: 'MR',
                  onPressed: () => viewModel.memoryRecall(),
                  backgroundColor: Colors.pink.shade100,
                  icon: Icons.restore_outlined, // 读取图标
                ),
                CalculatorButton(
                  text: 'MS',
                  onPressed: () => viewModel.memoryStore(),
                  backgroundColor: Colors.pink.shade100,
                  icon: Icons.save_outlined, // 保存图标
                ),
                CalculatorButton(
                  text: 'M+',
                  onPressed: () => viewModel.memoryAdd(),
                  backgroundColor: Colors.pink.shade100,
                  icon: Icons.add_circle_outline, // 添加图标
                ),
                CalculatorButton(
                  text: 'M-',
                  onPressed: () => viewModel.memorySubtract(),
                  backgroundColor: Colors.pink.shade100,
                  icon: Icons.remove_circle_outline, // 减去图标
                ),
              ],
            ),
          ),

          // 科学计算按钮行1
          Expanded(
            child: Row(
              children: [
                CalculatorButton(
                  text: '√',
                  onPressed: () => viewModel.performScientificOperation('sqrt'),
                  backgroundColor: Colors.blue.shade100,
                ),
                CalculatorButton(
                  text: '|x|',
                  onPressed: () => viewModel.performScientificOperation('abs'),
                  backgroundColor: Colors.blue.shade100,
                ),
                CalculatorButton(
                  text: 'x²',
                  onPressed: () => viewModel.performScientificOperation('x²'),
                  backgroundColor: Colors.blue.shade100,
                ),
                CalculatorButton(
                  text: 'x³',
                  onPressed: () => viewModel.performScientificOperation('x³'),
                  backgroundColor: Colors.blue.shade100,
                ),
                CalculatorButton(
                  text: 'n!',
                  onPressed: () => viewModel.performScientificOperation('n!'),
                  backgroundColor: Colors.blue.shade100,
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
                  onPressed: () => viewModel.performScientificOperation('sin'),
                  backgroundColor: Colors.blue.shade100,
                ),
                CalculatorButton(
                  text: 'cos',
                  onPressed: () => viewModel.performScientificOperation('cos'),
                  backgroundColor: Colors.blue.shade100,
                ),
                CalculatorButton(
                  text: 'tan',
                  onPressed: () => viewModel.performScientificOperation('tan'),
                  backgroundColor: Colors.blue.shade100,
                ),
                CalculatorButton(
                  text: 'log',
                  onPressed: () => viewModel.performScientificOperation('log'),
                  backgroundColor: Colors.blue.shade100,
                ),
                CalculatorButton(
                  text: 'ln',
                  onPressed: () => viewModel.performScientificOperation('ln'),
                  backgroundColor: Colors.blue.shade100,
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
                  onPressed: () => viewModel.performScientificOperation('1/x'),
                  backgroundColor: Colors.blue.shade100,
                ),
                CalculatorButton(
                  text: 'e^x',
                  onPressed: () => viewModel.performScientificOperation('e^x'),
                  backgroundColor: Colors.blue.shade100,
                ),
                CalculatorButton(
                  text: '10^x',
                  onPressed: () => viewModel.performScientificOperation('10^x'),
                  backgroundColor: Colors.blue.shade100,
                ),
                CalculatorButton(
                  text: 'x^y',
                  onPressed: () => viewModel.setOperation('xʸ'),
                  backgroundColor: Colors.blue.shade100,
                ),
                CalculatorButton(
                  text: 'x√y',
                  onPressed: () => viewModel.setOperation('x√y'),
                  backgroundColor: Colors.blue.shade100,
                ),
              ],
            ),
          ),

          // 科学计算按钮行4
          Expanded(
            child: Row(
              children: [
                CalculatorButton(
                  text: '+/-',
                  onPressed: () => viewModel.performScientificOperation('+/-'),
                  backgroundColor: Colors.blue.shade100,
                ),
                CalculatorButton(
                  text: '%',
                  onPressed: () => viewModel.performScientificOperation('percent'),
                  backgroundColor: Colors.blue.shade100,
                ),
                CalculatorButton(
                  text: 'CE',
                  onPressed: () => viewModel.clearEntry(),
                  backgroundColor: Colors.orange.shade300,
                  textColor: Colors.white,
                  icon: Icons.clear_outlined, // 使用清除当前图标
                ),
                CalculatorButton(
                  text: 'AC',
                  onPressed: () => viewModel.clearAll(),
                  backgroundColor: Colors.red.shade300,
                  textColor: Colors.white,
                  icon: Icons.delete_forever_outlined, // 使用清除图标
                ),
                CalculatorButton(
                  text: 'Backspace', // 文本不会显示，但需要保留以符合构造函数
                  onPressed: () => viewModel.backspace(),
                  backgroundColor: Colors.orange.shade300,
                  textColor: Colors.white,
                  icon: Icons.backspace_outlined, // 使用退格图标
                ),
              ],
            ),
          ),

          // 数字按钮行1
          Expanded(
            child: Row(
              children: [
                CalculatorButton(
                  text: '7',
                  onPressed: () => viewModel.inputDigit('7'),
                ),
                CalculatorButton(
                  text: '8',
                  onPressed: () => viewModel.inputDigit('8'),
                ),
                CalculatorButton(
                  text: '9',
                  onPressed: () => viewModel.inputDigit('9'),
                ),
                CalculatorButton(
                  text: '÷',
                  onPressed: () => viewModel.setOperation('÷'),
                  backgroundColor: Colors.blue.shade100,
                ),
                CalculatorButton(
                  text: 'CE',
                  onPressed: () => viewModel.clearEntry(),
                  backgroundColor: Colors.red.shade100,
                ),
              ],
            ),
          ),

          // 数字按钮行2
          Expanded(
            child: Row(
              children: [
                CalculatorButton(
                  text: '4',
                  onPressed: () => viewModel.inputDigit('4'),
                ),
                CalculatorButton(
                  text: '5',
                  onPressed: () => viewModel.inputDigit('5'),
                ),
                CalculatorButton(
                  text: '6',
                  onPressed: () => viewModel.inputDigit('6'),
                ),
                CalculatorButton(
                  text: '×',
                  onPressed: () => viewModel.setOperation('×'),
                  backgroundColor: Colors.blue.shade100,
                ),
                CalculatorButton(
                  text: '0',
                  onPressed: () => viewModel.inputDigit('0'),
                ),
              ],
            ),
          ),

          // 数字按钮行3
          Expanded(
            child: Row(
              children: [
                CalculatorButton(
                  text: '1',
                  onPressed: () => viewModel.inputDigit('1'),
                ),
                CalculatorButton(
                  text: '2',
                  onPressed: () => viewModel.inputDigit('2'),
                ),
                CalculatorButton(
                  text: '3',
                  onPressed: () => viewModel.inputDigit('3'),
                ),
                CalculatorButton(
                  text: '-',
                  onPressed: () => viewModel.setOperation('-'),
                  backgroundColor: Colors.blue.shade100,
                ),
                CalculatorButton(
                  text: '.',
                  onPressed: () => viewModel.inputDigit('.'),
                ),
              ],
            ),
          ),

          // 数字按钮行4
          Expanded(
            child: Row(
              children: [
                CalculatorButton(
                  text: '00',
                  onPressed: () => viewModel.inputZeros(2),
                ),
                CalculatorButton(
                  text: '000',
                  onPressed: () => viewModel.inputZeros(3),
                ),
                CalculatorButton(
                  text: '+',
                  onPressed: () => viewModel.setOperation('+'),
                  backgroundColor: Colors.blue.shade100,
                ),
                CalculatorButton(
                  text: '=',
                  onPressed: () => viewModel.calculateResult(),
                  backgroundColor: Colors.yellow,
                  textColor: Colors.black,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLandscapeLayout(CalculatorViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          // 左侧科学计算按钮
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      CalculatorButton(
                        text: 'sin',
                        onPressed:
                            () => viewModel.performScientificOperation('sin'),
                      ),
                      CalculatorButton(
                        text: 'cos',
                        onPressed:
                            () => viewModel.performScientificOperation('cos'),
                      ),
                      CalculatorButton(
                        text: 'tan',
                        onPressed:
                            () => viewModel.performScientificOperation('tan'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      CalculatorButton(
                        text: 'log',
                        onPressed:
                            () => viewModel.performScientificOperation('log'),
                      ),
                      CalculatorButton(
                        text: 'ln',
                        onPressed:
                            () => viewModel.performScientificOperation('ln'),
                      ),
                      CalculatorButton(
                        text: 'e^x',
                        onPressed:
                            () => viewModel.performScientificOperation('e^x'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      CalculatorButton(
                        text: '√',
                        onPressed:
                            () => viewModel.performScientificOperation('sqrt'),
                      ),
                      CalculatorButton(
                        text: '|x|',
                        onPressed:
                            () => viewModel.performScientificOperation('abs'),
                      ),
                      CalculatorButton(
                        text: 'x^y',
                        onPressed: () => viewModel.setOperation('x^y'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      CalculatorButton(
                        text: 'x√y',
                        onPressed: () => viewModel.setOperation('x√y'),
                      ),
                      CalculatorButton(
                        text: 'n!',
                        onPressed:
                            () => viewModel.performScientificOperation('n!'),
                      ),
                      CalculatorButton(
                        text: '+/-',
                        onPressed:
                            () => viewModel.performScientificOperation('+/-'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      CalculatorButton(
                        text: 'MC',
                        onPressed: () => viewModel.memoryClear(),
                        backgroundColor: Colors.pink.shade100,
                      ),
                      CalculatorButton(
                        text: 'MR',
                        onPressed: () => viewModel.memoryRecall(),
                        backgroundColor: Colors.pink.shade100,
                      ),
                      CalculatorButton(
                        text: 'MS',
                        onPressed: () => viewModel.memoryStore(),
                        backgroundColor: Colors.pink.shade100,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      CalculatorButton(
                        text: 'M+',
                        onPressed: () => viewModel.memoryAdd(),
                        backgroundColor: Colors.pink.shade100,
                      ),
                      CalculatorButton(
                        text: 'M-',
                        onPressed: () => viewModel.memorySubtract(),
                        backgroundColor: Colors.pink.shade100,
                      ),
                      CalculatorButton(
                        text: '1/x',
                        onPressed:
                            () => viewModel.performScientificOperation('1/x'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 右侧数字按钮
          Expanded(
            flex: 4,
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      CalculatorButton(
                        text: 'AC',
                        onPressed: () => viewModel.clearAll(),
                        backgroundColor: Colors.red.shade300,
                        textColor: Colors.white,
                      ),
                      CalculatorButton(
                        text: 'CE',
                        onPressed: () => viewModel.clearEntry(),
                        backgroundColor: Colors.red.shade100,
                      ),
                      CalculatorButton(
                        text: '%',
                        onPressed: () => viewModel.setOperation('%'),
                      ),
                      CalculatorButton(
                        text: '÷',
                        onPressed: () => viewModel.setOperation('÷'),
                        backgroundColor: Colors.blue.shade100,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      CalculatorButton(
                        text: '7',
                        onPressed: () => viewModel.inputDigit('7'),
                      ),
                      CalculatorButton(
                        text: '8',
                        onPressed: () => viewModel.inputDigit('8'),
                      ),
                      CalculatorButton(
                        text: '9',
                        onPressed: () => viewModel.inputDigit('9'),
                      ),
                      CalculatorButton(
                        text: '×',
                        onPressed: () => viewModel.setOperation('×'),
                        backgroundColor: Colors.blue.shade100,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      CalculatorButton(
                        text: '4',
                        onPressed: () => viewModel.inputDigit('4'),
                      ),
                      CalculatorButton(
                        text: '5',
                        onPressed: () => viewModel.inputDigit('5'),
                      ),
                      CalculatorButton(
                        text: '6',
                        onPressed: () => viewModel.inputDigit('6'),
                      ),
                      CalculatorButton(
                        text: '-',
                        onPressed: () => viewModel.setOperation('-'),
                        backgroundColor: Colors.blue.shade100,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      CalculatorButton(
                        text: '1',
                        onPressed: () => viewModel.inputDigit('1'),
                      ),
                      CalculatorButton(
                        text: '2',
                        onPressed: () => viewModel.inputDigit('2'),
                      ),
                      CalculatorButton(
                        text: '3',
                        onPressed: () => viewModel.inputDigit('3'),
                      ),
                      CalculatorButton(
                        text: '+',
                        onPressed: () => viewModel.setOperation('+'),
                        backgroundColor: Colors.blue.shade100,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      CalculatorButton(
                        text: '00',
                        onPressed: () => viewModel.inputZeros(2),
                      ),
                      CalculatorButton(
                        text: '0',
                        onPressed: () => viewModel.inputDigit('0'),
                      ),
                      CalculatorButton(
                        text: '.',
                        onPressed: () => viewModel.inputDigit('.'),
                      ),
                      CalculatorButton(
                        text: '=',
                        onPressed: () => viewModel.calculateResult(),
                        backgroundColor: Colors.yellow,
                        textColor: Colors.black,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
