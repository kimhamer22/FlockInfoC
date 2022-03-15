import 'package:fic_flutter/pages/general_resources.dart';
import 'package:fic_flutter/pages/home_species.dart';
import 'package:fic_flutter/pages/categories_main.dart';
import 'package:fic_flutter/pages/single_species.dart';
import 'package:fic_flutter/pages/simple_text.dart';
import 'package:fic_flutter/widgets/breadcrumb.dart';
import 'package:fic_flutter/widgets/ham_menu.dart';
import 'package:flutter/material.dart';
import 'package:fic_flutter/widgets/top_bar.dart';
import 'package:fic_flutter/pages/home_resources.dart';
import 'package:fic_flutter/pages/info_page.dart';

//import 'db_handle.dart';

void main() async {
  // Avoid errors caused by flutter upgrade.
  // Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();

  // DATABASE EXAMPLES
  // SectionHandler sh = SectionHandler();
  // MainPageHandler mph = MainPageHandler();
  //
  // var relevants = await sh.relevantSections(5); // 7 - BCS
  // print(relevants);
  //
  // var section = await sh.section(1);
  // print("Calling section(1): \n RESULT: ");
  // print(section);
  //
  // var children = await sh.childSections(1);
  // print("Calling childSections(1): \n RESULT: ");
  // print(children);
  //
  // var animals = await sh.animalCategories();
  // print("Calling animalCategories(): \n RESULT: ");
  // print(animals);

  // var relevant = await sh.relevantSections(4);
  // print("Calling relevantSections(): \n RESULT: ");
  // print(relevant);
  // runApp(const FlockControl());
  //
  // var mainPage = await mph.mainPage();
  // print("Calling mainPage(): \n RESULT: ");
  // print(mainPage);
  // runApp(const FlockControl());
  //
  // var mainPageButtons = await sh.mainPageButtons();
  // print("Calling mainPageButtons(): \n RESULT: ");
  // print(mainPageButtons);

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
        '/species': (context) => const SingleSpecies(),
        '/categorypage': (context) => const CategoryPage(3),
        '/generalresources': (context) => const GeneralResources(),
        '/simple_text': (context) => const SimpleText(),
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
  static const String route = '/';
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopBar(page: 'Home'),
      drawer: const HamMenu(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          BreadcrumbBar.homePressed(context);
        },
        child: const Icon(Icons.home),
      ),
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
        ),
      ),
    );
  }
}
