import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';
import 'calculator_button.dart';

class MemoryPanel extends StatelessWidget {
  final bool isCompact;

  const MemoryPanel({Key? key, this.isCompact = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final calculatorProvider = Provider.of<CalculatorProvider>(context);

    if (isCompact) {
      return _buildCompactLayout(calculatorProvider);
    } else {
      return _buildFullLayout(calculatorProvider);
    }
  }

  Widget _buildFullLayout(CalculatorProvider calculatorProvider) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Material(
              color: Colors.pink.shade50,
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                onTap: () => calculatorProvider.memoryClear(),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'MC',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Material(
              color: Colors.pink.shade50,
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                onTap: () => calculatorProvider.memoryRecall(),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'MR',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Material(
              color: Colors.pink.shade50,
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                onTap: () => calculatorProvider.memoryStore(),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'MS',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Material(
              color: Colors.pink.shade50,
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                onTap: () => calculatorProvider.memoryAdd(),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'M+',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Material(
              color: Colors.pink.shade50,
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                onTap: () => calculatorProvider.memorySubtract(),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'M-',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompactLayout(CalculatorProvider calculatorProvider) {
    return Row(
      children: [
        Expanded(
          child: CalculatorButton(
            text: 'MC',
            onPressed: () => calculatorProvider.memoryClear(),
            backgroundColor: Colors.deepPurple.shade100,
            fontSize: 14,
          ),
        ),
        Expanded(
          child: CalculatorButton(
            text: 'MR',
            onPressed: () => calculatorProvider.memoryRecall(),
            backgroundColor: Colors.deepPurple.shade100,
            fontSize: 14,
          ),
        ),
        Expanded(
          child: CalculatorButton(
            text: 'MS',
            onPressed: () => calculatorProvider.memoryStore(),
            backgroundColor: Colors.deepPurple.shade100,
            fontSize: 14,
          ),
        ),
        Expanded(
          child: CalculatorButton(
            text: 'M+',
            onPressed: () => calculatorProvider.memoryAdd(),
            backgroundColor: Colors.deepPurple.shade100,
            fontSize: 14,
          ),
        ),
        Expanded(
          child: CalculatorButton(
            text: 'M-',
            onPressed: () => calculatorProvider.memorySubtract(),
            backgroundColor: Colors.deepPurple.shade100,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
