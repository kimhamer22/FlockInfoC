// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:fic_flutter/main.dart';

void main() {
  testWidgets('Clicking Species shows Sheep button',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FlockControl());

    // Tap the 'Species' tab and trigger a frame.
    await tester.tap(find.text('Species'));
    //await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that page has a Sheep widget.
    expect(find.text('Sheep'), findsOneWidget);
  });
}
