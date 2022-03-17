import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fic_flutter/widgets/ham_menu.dart';

void main() {
  testWidgets('Ham menu generates correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HamMenu()));

    final tileHomeFinder = find.text('Home');
    final speciesTileFinder = find.text('Species');
    final ackTileFinder = find.text('Acknowledgements');
    final contactTileFinder = find.text('Update data');

    expect(tileHomeFinder, findsOneWidget);
    expect(speciesTileFinder, findsOneWidget);
    expect(ackTileFinder, findsOneWidget);
    expect(contactTileFinder, findsOneWidget);
  });
}
