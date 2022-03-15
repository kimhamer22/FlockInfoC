import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fic_flutter/widgets/navigation_button.dart';

void main() {
  testWidgets('Button has a title', (WidgetTester tester) async {
    await tester.pumpWidget(
        MaterialApp(home: NavigationButton(title: 'Home Test', route: '/')));

    final titleFinder = find.text('Home Test');
    expect(titleFinder, findsOneWidget);
  });
}
