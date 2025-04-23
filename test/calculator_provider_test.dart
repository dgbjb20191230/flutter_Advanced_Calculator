import 'package:flutter_test/flutter_test.dart';
import 'package:flutterjisuanqqi20250421/providers/calculator_provider.dart';
import 'package:flutterjisuanqqi20250421/providers/settings_provider.dart';

void main() {
  group('CalculatorProvider Tests', () {
    late CalculatorProvider calculatorProvider;
    late SettingsProvider settingsProvider;
    
    setUp(() {
      settingsProvider = SettingsProvider();
      calculatorProvider = CalculatorProvider(settingsProvider);
    });
    
    test('Initial state is correct', () {
      expect(calculatorProvider.currentInput, '0');
      expect(calculatorProvider.expression, '');
      expect(calculatorProvider.history, []);
      expect(calculatorProvider.hasMemoryValue, false);
    });
    
    test('inputDigit works correctly', () {
      calculatorProvider.inputDigit('1');
      expect(calculatorProvider.currentInput, '1');
      
      calculatorProvider.inputDigit('2');
      expect(calculatorProvider.currentInput, '12');
      
      calculatorProvider.inputDigit('.');
      expect(calculatorProvider.currentInput, '12.');
      
      calculatorProvider.inputDigit('5');
      expect(calculatorProvider.currentInput, '12.5');
      
      // Should not allow multiple decimal points
      calculatorProvider.inputDigit('.');
      expect(calculatorProvider.currentInput, '12.5');
    });
    
    test('clearAll resets all values', () {
      calculatorProvider.inputDigit('1');
      calculatorProvider.inputDigit('2');
      calculatorProvider.setOperation('+');
      
      calculatorProvider.clearAll();
      
      expect(calculatorProvider.currentInput, '0');
      expect(calculatorProvider.expression, '');
    });
    
    test('clearEntry only resets current input', () {
      calculatorProvider.inputDigit('1');
      calculatorProvider.inputDigit('2');
      calculatorProvider.setOperation('+');
      calculatorProvider.inputDigit('3');
      
      calculatorProvider.clearEntry();
      
      expect(calculatorProvider.currentInput, '0');
      expect(calculatorProvider.expression, '12 + ');
    });
    
    test('Memory operations work correctly', () {
      calculatorProvider.inputDigit('4');
      calculatorProvider.inputDigit('2');
      
      // Store in memory
      calculatorProvider.memoryStore();
      expect(calculatorProvider.hasMemoryValue, true);
      
      // Change current input
      calculatorProvider.clearEntry();
      calculatorProvider.inputDigit('1');
      calculatorProvider.inputDigit('0');
      expect(calculatorProvider.currentInput, '10');
      
      // Recall from memory
      calculatorProvider.memoryRecall();
      expect(calculatorProvider.currentInput, '42');
      
      // Clear memory
      calculatorProvider.memoryClear();
      expect(calculatorProvider.hasMemoryValue, false);
    });
    
    test('Percentage operation works correctly', () {
      calculatorProvider.inputDigit('5');
      calculatorProvider.inputDigit('0');
      
      calculatorProvider.percentage();
      
      expect(calculatorProvider.currentInput, '0.5');
    });
    
    test('History operations work correctly', () {
      // Add some history items
      calculatorProvider.inputDigit('5');
      calculatorProvider.setOperation('+');
      calculatorProvider.inputDigit('3');
      calculatorProvider.calculateResult();
      
      expect(calculatorProvider.history.length, 1);
      
      // Clear history
      calculatorProvider.clearHistory();
      expect(calculatorProvider.history.length, 0);
    });
  });
}
