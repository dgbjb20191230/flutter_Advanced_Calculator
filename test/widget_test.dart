// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:flutterjisuanqqi20250421/main.dart';
import 'package:flutterjisuanqqi20250421/viewmodels/calculator_viewmodel.dart';
import 'package:flutterjisuanqqi20250421/views/calculator_view.dart';

void main() {
  testWidgets('Calculator app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app title is displayed
    expect(find.text('高级计算器'), findsOneWidget);

    // Verify that the initial display shows 0
    expect(find.text('0', skipOffstage: false), findsWidgets);

    // This is just a basic smoke test to ensure the app builds
    // More detailed widget tests would be added for specific calculator functionality
  });
}
