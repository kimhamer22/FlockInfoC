import 'package:fic_flutter/home_species.dart';
import 'package:flutter/material.dart';
import 'package:fic_flutter/top_bar.dart';
import 'package:fic_flutter/home_resources.dart';
import 'package:fic_flutter/info_page.dart';

void main() {
  runApp(const FlockControl());
}

class FlockControl extends StatelessWidget {
  const FlockControl({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flock Control',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(title: 'Home'),
        '/infopage': (context) => const InfoPage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopBar(page: 'Home'),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: DefaultTabController(
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
                    Tab(text: "Resources"),
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
        ),
      ),
    );
  }
}
