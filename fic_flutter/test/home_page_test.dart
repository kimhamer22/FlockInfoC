import 'package:fic_flutter/pages/home_resources.dart';
import 'package:fic_flutter/pages/home_species.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';

void main() {
  final TestWidgetsFlutterBinding binding =
      TestWidgetsFlutterBinding.ensureInitialized()
          as TestWidgetsFlutterBinding;

  testWidgets('Tabs labels correct', (WidgetTester tester) async {
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

    final tabBarFinder = find.byType(DefaultTabController);
    final homeTabFinder = find.text("Home");
    final speciesTabFinder = find.text("Species");

    expect(homeTabFinder, findsOneWidget);
    expect(speciesTabFinder, findsOneWidget);
    expect(tabBarFinder, findsOneWidget);
  });

  testWidgets('Tab Bar Exists', (WidgetTester tester) async {
    binding.window.physicalSizeTestValue = Size(800, 800);
    binding.window.devicePixelRatioTestValue = 1.0;
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

    final tabBarFinder = find.byType(DefaultTabController);

    expect(tabBarFinder, findsOneWidget);
  });

  testWidgets('Both Tabs Generated', (WidgetTester tester) async {
    binding.window.physicalSizeTestValue = Size(800, 800);
    binding.window.devicePixelRatioTestValue = 1.0;
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

    final tabFinder = find.byType(Tab);
    expect(tabFinder, findsWidgets);
  });
}
