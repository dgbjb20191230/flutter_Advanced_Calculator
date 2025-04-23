import 'package:flutter/material.dart';

class HistoryView extends StatelessWidget {
  final List<String> history;
  
  const HistoryView({Key? key, required this.history}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('计算历史'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: history.isEmpty
          ? const Center(
              child: Text(
                '暂无计算历史',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                // 显示最新的历史记录在顶部
                final historyItem = history[history.length - 1 - index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      historyItem,
                      style: const TextStyle(fontSize: 18),
                      textAlign: TextAlign.right,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
