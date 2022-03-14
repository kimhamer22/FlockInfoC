import 'package:fic_flutter/pages/home_resources.dart';
import 'package:fic_flutter/pages/home_species.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Home page has both tabs', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: DefaultTabController(
      length: 2,
      child: Column(children: <Widget>[
        Container(
          constraints: const BoxConstraints(maxHeight: 150.0),
          child: const Material(
            child: TabBar(
              labelColor: Colors.black,
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              indicator: BoxDecoration(
                color: Color(0x80DBF9D3),
              ),
              tabs: [
                Tab(text: "Home"),
                Tab(text: "Species"),
              ],
            ),
          ),
        ),
        const Expanded(
          child: TabBarView(
            children: <Widget>[
              HomeResources(),
              HomeSpecies(),
            ],
          ),
        ),
      ]),
    )));
    await tester.pumpAndSettle();

    final homeTabFinder = find.text("Home");
    final speciesTabFinder = find.text("Species");

    expect(homeTabFinder, findsOneWidget);
    expect(speciesTabFinder, findsOneWidget);
  });
}
