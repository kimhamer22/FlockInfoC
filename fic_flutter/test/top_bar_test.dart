import 'package:fic_flutter/widgets/ham_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fic_flutter/widgets/top_bar.dart';
import 'package:mockito/mockito.dart';

void main() {
  testWidgets('Ham Menu Loads', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: TopBar(page: 'Page')));

    final hamFinder = find.byIcon(Icons.menu);
    expect(hamFinder, findsOneWidget);
  });

  testWidgets('Sheep Logo Loads', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: TopBar(page: 'Page')));

    final logoFinder = find.byType(Image);
    expect(logoFinder, findsOneWidget);
  });

  testWidgets('Page Has Title', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: TopBar(page: 'Page')));

    final titleFinder = find.text('Page');
    expect(titleFinder, findsOneWidget);
  });
}
