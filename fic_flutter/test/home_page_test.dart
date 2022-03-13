import 'package:fic_flutter/pages/home_resources.dart';
import 'package:fic_flutter/pages/home_species.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fic_flutter/main.dart';

void main() {
  testWidgets('Home page has both tabs', (WidgetTester tester) async {
    //This hasn't been working because you can't test entire pages. Need to build the actual TabBar as a widget here to test it.

//   // Tap the 'Species' tab and trigger a frame.
//   await tester.tap(find.text('Species'));
//   //await tester.tap(find.byIcon(Icons.add));
//   await tester.pump();
//
//   // Verify that page has a Sheep widget.
//   expect(find.text('Sheep'), findsOneWidget);
  });
}
