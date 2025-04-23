import 'package:flutter_test/flutter_test.dart';
import 'package:flutterjisuanqqi20250421/models/calculator_model.dart';
import 'package:flutterjisuanqqi20250421/services/calculator_service.dart';
import 'package:flutterjisuanqqi20250421/viewmodels/calculator_viewmodel.dart';

void main() {
  group('CalculatorModel Tests', () {
    late CalculatorModel model;
    
    setUp(() {
      model = CalculatorModel();
    });
    
    test('Initial state is correct', () {
      expect(model.currentInput, '0');
      expect(model.operation, '');
      expect(model.firstOperand, null);
      expect(model.secondOperand, null);
      expect(model.shouldReplaceInput, false);
      expect(model.history, []);
    });
    
    test('clearAll resets all values', () {
      model.currentInput = '123';
      model.operation = '+';
      model.firstOperand = 123;
      model.secondOperand = 456;
      model.shouldReplaceInput = true;
      
      model.clearAll();
      
      expect(model.currentInput, '0');
      expect(model.operation, '');
      expect(model.firstOperand, null);
      expect(model.secondOperand, null);
      expect(model.shouldReplaceInput, false);
    });
    
    test('clearEntry only resets current input', () {
      model.currentInput = '123';
      model.operation = '+';
      model.firstOperand = 123;
      model.shouldReplaceInput = true;
      
      model.clearEntry();
      
      expect(model.currentInput, '0');
      expect(model.operation, '+');
      expect(model.firstOperand, 123);
      expect(model.shouldReplaceInput, false);
    });
    
    test('Memory operations work correctly', () {
      model.currentInput = '42';
      
      // Store in memory
      model.storeInMemory();
      expect(model.memory, '42');
      
      // Change current input
      model.currentInput = '100';
      
      // Recall from memory
      model.recallMemory();
      expect(model.currentInput, '42');
      
      // Add to memory
      model.currentInput = '8';
      model.addToMemory();
      expect(model.memory, '50');
      
      // Subtract from memory
      model.currentInput = '20';
      model.subtractFromMemory();
      expect(model.memory, '30');
      
      // Clear memory
      model.clearMemory();
      expect(model.memory, '');
    });
  });
  
  group('CalculatorService Tests', () {
    late CalculatorService service;
    
    setUp(() {
      service = CalculatorService();
    });
    
    test('Basic calculations work correctly', () async {
      expect(await service.calculate(5, 3, '+'), 8);
      expect(await service.calculate(5, 3, '-'), 2);
      expect(await service.calculate(5, 3, '×'), 15);
      expect(await service.calculate(6, 3, '÷'), 2);
      expect(await service.calculate(5, 3, '%'), 2);
      expect(await service.calculate(2, 3, 'x^y'), 8);
    });
    
    test('Division by zero throws error', () async {
      expect(() async => await service.calculate(5, 0, '÷'), throwsA(anything));
    });
    
    test('Scientific calculations work correctly', () async {
      expect(await service.scientificCalculation(9, 'sqrt'), 3);
      expect(await service.scientificCalculation(0, 'sin'), 0);
      expect(await service.scientificCalculation(0, 'cos'), 1);
      expect(await service.scientificCalculation(1, 'tan'), 1.5574077246549023); // tan(1)
      expect(await service.scientificCalculation(100, 'log'), 2);
      expect(await service.scientificCalculation(1, 'ln'), 0);
      expect(await service.scientificCalculation(2, '1/x'), 0.5);
      expect(await service.scientificCalculation(0, 'e^x'), 1);
      expect(await service.scientificCalculation(5, 'n!'), 120);
      expect(await service.scientificCalculation(5, '+/-'), -5);
    });
    
    test('formatNumber removes unnecessary decimal zeros', () {
      expect(service.formatNumber(5.0), '5');
      expect(service.formatNumber(5.5), '5.5');
    });
  });
  
  group('CalculatorViewModel Tests', () {
    late CalculatorViewModel viewModel;
    
    setUp(() {
      viewModel = CalculatorViewModel();
    });
    
    test('Initial state is correct', () {
      expect(viewModel.currentInput, '0');
      expect(viewModel.operation, '');
      expect(viewModel.history, []);
    });
    
    test('inputDigit works correctly', () {
      viewModel.inputDigit('1');
      expect(viewModel.currentInput, '1');
      
      viewModel.inputDigit('2');
      expect(viewModel.currentInput, '12');
      
      viewModel.inputDigit('.');
      expect(viewModel.currentInput, '12.');
      
      viewModel.inputDigit('5');
      expect(viewModel.currentInput, '12.5');
      
      // Should not allow multiple decimal points
      viewModel.inputDigit('.');
      expect(viewModel.currentInput, '12.5');
    });
    
    test('inputZeros works correctly', () {
      viewModel.inputDigit('1');
      viewModel.inputZeros(2);
      expect(viewModel.currentInput, '100');
      
      viewModel.clearAll();
      expect(viewModel.currentInput, '0');
      
      viewModel.inputZeros(3);
      expect(viewModel.currentInput, '0');
    });
    
    test('setOperation works correctly', () {
      viewModel.inputDigit('5');
      viewModel.setOperation('+');
      
      expect(viewModel.operation, '+');
    });
  });
}
