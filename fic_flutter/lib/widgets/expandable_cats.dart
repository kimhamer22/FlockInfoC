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
    var children = await sh.childSections(parentID);
    var factorsList = <Category>[];
    for (var child in children) {
      var relevantFactors = await sh.relevantSections(child.id);
      var factorsBtns = <NavigationButton>[];
      var childTitle = 'Tap to Read More';
      factorsBtns.add(NavigationButton(
          title: childTitle,
          route: '/infopage',
          colour: const Color(0xFF77CC7D), // Great work, team!
          id: child.id));
      for (var factor in relevantFactors) {
        var title = factor.translationSection ?? 'Loading...';
        factorsBtns.add(NavigationButton(
          title: title,
          route: '/infopage',
          id: factor.id,
        ));
      }
      var title = child.translationSection ?? 'Loading';
      factorsList
          .add(Category(subCategories: factorsBtns, name: title, id: child.id));
    }
    return factorsList;
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
              // var factorsList = <Category>[];
              // var data = snapshot.data as List;
              // for (var dataPoint in data) {
              //   factorsList.add(Category(
              //       subCategories: [],
              //       name: dataPoint.translationSection,
              //       id: dataPoint.id));
              // }
              return CustomPanelList(
                  categories: snapshot.data as List<Category>);
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
              title: Text(category.name,
                  style: const TextStyle(
                    fontSize: 18.0,
                  )),
            );
          },
          body: Column(children: <Widget>[
            Column(
              children: category.subCategories.sublist(0, 1),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(35.0, 10.0, 0.0, 10.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Relevant Factors:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
            Column(
                children: category.subCategories
                    .sublist(1, category.subCategories.length - 1)),
          ]),
          isExpanded: category.isExpanded,
          canTapOnHeader: true,
        );
      }).toList(),
    );
  }
}
