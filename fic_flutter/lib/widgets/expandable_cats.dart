import 'package:flutter/material.dart';
import 'navigation_button.dart';
import '../db_handle.dart';

class ExpandableCats extends StatefulWidget {
  final int parentID;
  const ExpandableCats({Key? key, required this.parentID}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ExpandableCats();
}

class _ExpandableCats extends State<ExpandableCats> {
  late Future allFactors;
  late int parentID;
  SectionHandler sh = SectionHandler();

  _getAllFactors(int parentID) async {
    return await sh.childSections(parentID);
  }

  @override
  void initState() {
    super.initState();
    parentID = widget.parentID;
    allFactors = _getAllFactors(parentID);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder(
          future: allFactors,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var factorsList = <Category>[];
              var data = snapshot.data as List;
              for (var dataPoint in data) {
                factorsList.add(Category(
                    subCategories: [],
                    name: dataPoint.translationSection,
                    id: dataPoint.id));
              }
              return CustomPanelList(categories: factorsList);
            } else {
              return const Text('Loading...');
            }
          }),
    );
  }
}

class Category {
  Category({
    required this.subCategories,
    required this.name,
    required this.id,
    this.isExpanded = false,
  });

  String name;
  int id;
  List<NavigationButton> subCategories;
  bool isExpanded;
}

class CustomPanelList extends StatefulWidget {
  List<Category> categories;

  CustomPanelList({Key? key, required this.categories}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CustomPanelList();
}

class _CustomPanelList extends State<CustomPanelList> {
  late List<Category> categories;

  @override
  void initState() {
    super.initState();
    categories = widget.categories;
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          //print(factorsList[index].isExpanded);
          categories[index].isExpanded = !isExpanded;
          //print("INDEX : $index ... $isExpanded");
          //print(factorsList[index].isExpanded);
        });
      },
      children: categories.map<ExpansionPanel>((Category category) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(category.name),
            );
          },
          body: RelevantFactors(
            id: category.id,
          ),
          isExpanded: category.isExpanded,
          canTapOnHeader: true,
        );
      }).toList(),
    );
  }
}

class RelevantFactors extends StatefulWidget {
  final int id;
  const RelevantFactors({Key? key, required this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RelevantFactorsState();
}

class _RelevantFactorsState extends State<RelevantFactors> {
  late int id;
  late Future children;
  SectionHandler sh = SectionHandler();

  // TODO: Change to actual relevant factors
  _getRelevantFactors() async {
    return await sh.animalCategories();
  }

  @override
  void initState() {
    super.initState();
    children = _getRelevantFactors();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: children,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var list = <NavigationButton>[];
            var data = snapshot.data as List;
            for (var dataPoint in data) {
              list.add(NavigationButton(
                  title: dataPoint.translationSection, route: '/infopage'));
            }
            return Column(children: list);
          } else {
            return const Text('Loading...');
          }
        });
  }
}
