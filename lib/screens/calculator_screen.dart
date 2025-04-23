import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/display_panel.dart';
import '../widgets/number_pad.dart';
import '../widgets/memory_panel.dart';
import '../providers/calculator_provider.dart';
import '../providers/settings_provider.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final calculatorProvider = Provider.of<CalculatorProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('高级计算器'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 显示区域
            DisplayPanel(),

            // 角度/弧度切换
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        settingsProvider.toggleAngleMode();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        elevation: 0,
                        side: BorderSide(color: Colors.grey.shade200),
                      ),
                      child: Text(
                        settingsProvider.isRadianMode ? '弧度制' : '角度制',
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 查看历史记录按钮
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _showHistoryPanel(context, calculatorProvider);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade50,
                        foregroundColor: Colors.blue.shade700,
                        elevation: 0,
                      ),
                      child: const Text('查看历史记录'),
                    ),
                  ),
                ],
              ),
            ),

            // 按钮区域
            Expanded(
              child:
                  isLandscape && !isSmallScreen
                      ? _buildLandscapeLayout(context)
                      : _buildPortraitLayout(context),
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

  Widget _buildPortraitLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // 内存操作按钮行
          MemoryPanel(),

          // 数字与基本运算区
          NumberPad(),
        ],
      ),
    );
  }

  Widget _buildLandscapeLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          // 右侧数字按钮
          Expanded(
            flex: 1,
            child: Column(
              children: [
                MemoryPanel(isCompact: true),
                Expanded(child: NumberPad(isLandscape: true)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showHistoryPanel(
    BuildContext context,
    CalculatorProvider calculatorProvider,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '计算历史',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      calculatorProvider.clearHistory();
                      Navigator.pop(context);
                    },
                    child: const Text('清空历史'),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child:
                    calculatorProvider.history.isEmpty
                        ? const Center(child: Text('暂无历史记录'))
                        : ListView.builder(
                          itemCount: calculatorProvider.history.length,
                          itemBuilder: (context, index) {
                            // 显示最新的历史记录在顶部
                            final historyItem =
                                calculatorProvider.history[calculatorProvider
                                        .history
                                        .length -
                                    1 -
                                    index];
                            return ListTile(
                              title: Text(
                                historyItem,
                                textAlign: TextAlign.right,
                                style: const TextStyle(fontSize: 18),
                              ),
                              onTap: () {
                                // 点击历史记录项，将结果填入当前输入
                                final parts = historyItem.split(' = ');
                                if (parts.length == 2) {
                                  calculatorProvider.setInput(parts[1]);
                                  Navigator.pop(context);
                                }
                              },
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  calculatorProvider.removeHistoryItem(
                                    calculatorProvider.history.length -
                                        1 -
                                        index,
                                  );
                                },
                              ),
                            );
                          },
                        ),
              ),
            ],
          ),
        );
      },
    );
  }
}
