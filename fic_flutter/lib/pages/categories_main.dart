import 'package:fic_flutter/widgets/breadcrumb.dart';
import 'package:fic_flutter/widgets/expandable_cats.dart';
import 'package:fic_flutter/widgets/top_bar.dart';
import 'package:flutter/material.dart';
import '../db_handle.dart';
import '../widgets/navigation_button.dart';
import '../helpers.dart';

class CategoryPage extends StatefulWidget {
  final int sectionID;
  const CategoryPage({Key? key, required this.sectionID}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  bool controlClicked = false;
  bool causesClicked = false;

  SectionHandler sh = SectionHandler();
  late Future categories;
  late Future section;

  _getAllCategories() async {
    return await sh.childSections(widget.sectionID);
  }

  @override
  void initState() {
    super.initState();
    categories = _getAllCategories();
    section = Helpers().getSection(widget.sectionID);
  }

  //final String title = "Controlling Abortion";
  // final List<Category> _categories = [
  //   Category(name: "Vaccination", subCategories: [
  //     const NavigationButton(title: "Vaccination", route: '/infopage'),
  //     const NavigationButton(title: "Schmallenberg Virus", route: '/'),
  //     const NavigationButton(title: "Toxoplasma Gondii", route: '/'),
  //     const NavigationButton(title: "Bluetongue Virus", route: '/'),
  //   ]),
  //   Category(name: "Body Condition Scoring", subCategories: []),
  //   Category(name: "Reduce Stress", subCategories: []),
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: FutureBuilder(
            future: section,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var sectionObj = snapshot.data as Section;
                var title = sectionObj.translationSection ?? 'Loading...';
                return TopBar(page: title);
              } else {
                return const TopBar(page: "Loading...");
              }
            }),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
        child: Column(children: [
          BreadCrumb(),
          FutureBuilder(
              future: categories,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var catsList = <ExpandableCats>[];
                  var tabsList = <Tab>[];
                  var data = snapshot.data as List;
                  for (var i = 0; i < data.length; i++) {
                    var id = data[i].id;
                    var title = data[i].translationSection;
                    catsList.add(ExpandableCats(
                      parentID: id,
                    ));
                    tabsList.add(Tab(
                      text: title,
                    ));
                  }
                  return DefaultTabController(
                    length: data.length,
                    child: Expanded(
                      child: Column(
                        children: <Widget>[
                          Container(
                            constraints: const BoxConstraints(maxHeight: 150.0),
                            child: Material(
                              child: TabBar(
                                labelColor: Colors.black,
                                labelStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                                indicator: const BoxDecoration(
                                  color: Color(0x80DBF9D3),
                                ),
                                tabs: tabsList,
                              ),
                            ),
                          ),
                          Expanded(child: TabBarView(children: catsList))
                        ],
                      ),
                    ),
                  );
                } else {
                  return const Text('Loading...');
                }
              }),
        ]),
      ),
    );
  }
}

class Category {
  Category({
    required this.subCategories,
    required this.name,
    this.isExpanded = false,
  });

  String name;
  List<NavigationButton> subCategories;
  bool isExpanded;
}
