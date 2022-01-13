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
                    subCategories: [], name: dataPoint.translationSection));
              }
              return ExpansionPanelList(
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    print(factorsList[index].isExpanded);
                    factorsList[index].isExpanded = !isExpanded;
                    print("INDEX : $index ... $isExpanded");
                    print(factorsList[index].isExpanded);
                  });
                },
                children: factorsList.map<ExpansionPanel>((Category category) {
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
              );
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
    this.isExpanded = false,
  });

  String name;
  List<NavigationButton> subCategories;
  bool isExpanded;
}
