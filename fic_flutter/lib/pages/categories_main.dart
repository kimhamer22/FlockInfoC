import 'package:fic_flutter/widgets/breadcrumb.dart';
import 'package:fic_flutter/widgets/top_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import '../widgets/navigation_button.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  bool controlClicked = false;
  bool causesClicked = false;

  //final String title = "Controlling Abortion";
  final List<Category> _categories = [
    Category(name: "Vaccination", subCategories: [
      const NavigationButton(title: "Vaccination", route: '/infopage'),
      const NavigationButton(title: "Schmallenberg Virus", route: '/'),
      const NavigationButton(title: "Toxoplasma Gondii", route: '/'),
      const NavigationButton(title: "Bluetongue Virus", route: '/'),
    ]),
    Category(name: "Body Condition Scoring", subCategories: []),
    Category(name: "Reduce Stress", subCategories: []),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(page: "Controlling Abortion"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
          child: Column(children: [
            breadcrumbBar(),
            const DefaultTabController(
              length: 2,
              child: Material(
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
                    Tab(text: "Control"),
                    Tab(text: "Causes"),
                  ],
                ),
              ),
            ),
            ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  _categories[index].isExpanded = !isExpanded;
                });
              },
              children: _categories.map<ExpansionPanel>((Category category) {
                return ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return ListTile(
                      title: Text(category.name),
                    );
                  },
                  body: Column(children: [
                    for (NavigationButton nb in category.subCategories) nb
                  ]),
                  isExpanded: category.isExpanded,
                  canTapOnHeader: true,
                );
              }).toList(),
            ),
          ]),
        ),
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
