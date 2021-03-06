import 'package:fic_flutter/widgets/breadcrumb.dart';
import 'package:fic_flutter/widgets/ham_menu.dart';
import 'package:fic_flutter/widgets/expandable_cats.dart';
import 'package:fic_flutter/widgets/top_bar.dart';
import 'package:flutter/material.dart';
import '../db_handle.dart';
import '../widgets/navigation_button.dart';
import '../helpers.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage(int id, {Key? key}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late Future categories;
  late Future section;
  late int sectionID;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      var id = ModalRoute.of(context)!.settings.arguments as int;
      sectionID = id;
    }).whenComplete(() {
      categories = Helpers().getChildren(sectionID);
      section = Helpers().getSection(sectionID);
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
        drawer: const HamMenu(),
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
            BreadcrumbBar(),
            FutureBuilder(
                future: categories,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var list = <NavigationButton>[];
                    var data = snapshot.data as List;
                    for (var i = 0; i < data.length; i++) {
                      if (data[i].type != 3) {
                        var title = data[i].translationSection;
                        list.add(NavigationButton(
                            title: title,
                            route: '/simple_text',
                            id: data[i].id));
                      }
                    }
                    return Column(
                      children: list,
                    );
                  } else {
                    return const Text('Awaiting data...');
                  }
                }),
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
                      if (data[i].type == 3) {
                        // 3 - Tab
                        catsList.add(ExpandableCats(
                          parentID: id,
                        ));
                        tabsList.add(Tab(
                          text: title,
                        ));
                      }
                    }
                    return DefaultTabController(
                      length: tabsList.length,
                      child: Expanded(
                        child: Column(
                          children: <Widget>[
                            Container(
                              constraints:
                                  const BoxConstraints(maxHeight: 150.0),
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
    } catch (LateInitializationError) {
      return const Text('ERROR');
    }
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
