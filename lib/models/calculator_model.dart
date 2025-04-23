class CalculatorModel {
  String currentInput = '0';
  String expression = '';
  String operation = '';
  String memory = '';
  double? firstOperand;
  double? secondOperand;
  bool shouldReplaceInput = false;
  List<String> history = [];

  void addToHistory(String calculation) {
    history.add(calculation);
    if (history.length > 100) {
      history.removeAt(0);
    }
  }

  void clearAll() {
    currentInput = '0';
    expression = '';
    operation = '';
    firstOperand = null;
    secondOperand = null;
    shouldReplaceInput = false;
  }

  void clearEntry() {
    currentInput = '0';
    shouldReplaceInput = false;
  }

  void clearMemory() {
    memory = '';
  }

  void storeInMemory() {
    try {
      // Format the number before storing to ensure consistency
      double value = double.parse(currentInput);
      memory = value.toString();
      // Remove trailing .0 if it's a whole number
      if (memory.endsWith('.0')) {
        memory = memory.substring(0, memory.length - 2);
      }
    } catch (e) {
      // If parsing fails, store as is
      memory = currentInput;
    }
  }

  void recallMemory() {
    if (memory.isNotEmpty) {
      currentInput = memory;
      shouldReplaceInput = true;
    }
  }

  void addToMemory() {
    try {
      double currentValue = double.parse(currentInput);

      if (memory.isNotEmpty) {
        try {
          double memoryValue = double.parse(memory);
          double result = memoryValue + currentValue;
          memory = result.toString();
          if (memory.endsWith('.0')) {
            memory = memory.substring(0, memory.length - 2);
          }
        } catch (e) {
          // If memory can't be parsed, just store current value
          memory = currentInput;
        }
      } else {
        // If memory is empty, store current value
        memory = currentInput;
      }
    } catch (e) {
      // If current input can't be parsed, don't change memory
    }
  }

  void subtractFromMemory() {
    try {
      double currentValue = double.parse(currentInput);

      if (memory.isNotEmpty) {
        try {
          double memoryValue = double.parse(memory);
          double result = memoryValue - currentValue;
          memory = result.toString();
          if (memory.endsWith('.0')) {
            memory = memory.substring(0, memory.length - 2);
          }
        } catch (e) {
          // If memory can't be parsed, store negative of current value
          memory = '-$currentInput';
        }
      } else {
        // If memory is empty, store negative of current value
        memory = '-$currentInput';
      }
    } catch (e) {
      // If current input can't be parsed, don't change memory
    }
  }
}
