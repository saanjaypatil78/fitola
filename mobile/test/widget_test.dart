import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitola/widgets/stat_column.dart';

void main() {
  testWidgets('StatColumn renders value and label', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: StatColumn(
            value: '42',
            label: 'Workouts',
          ),
        ),
      ),
    );

    expect(find.text('42'), findsOneWidget);
    expect(find.text('Workouts'), findsOneWidget);
  });
}
