import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';

import '../db_handle.dart';
import '../helpers.dart';

List<BreadCrumbItem> breads = [
  BreadCrumbItem(
    content: const Text("Home"),
    textColor: Colors.black,
    onTap: () {},
  )
];
List<String> breadRoutes = ['/'];
List<int> breadIDs = [0];

class BreadcrumbBar extends StatelessWidget {
  const BreadcrumbBar({Key? key}) : super(key: key);

  static void homePressed(BuildContext context) {
    Navigator.popUntil(context, ModalRoute.withName('/'));
    breads = [
      BreadCrumbItem(
        content: const Text("Home"),
        textColor: Colors.green,
      )
    ];
    breadRoutes = ['/'];
    breadIDs = [0];
  }

  static add(String route, BuildContext context, int id) async {
    Section? section = await Helpers().getSection(id);
    var title = section?.translationSection;
    breadRoutes.add(route);
    breadIDs.add(id);
    print(breadIDs);
    print(breadRoutes);
    //print('Adding route:' + route);

    breads.add(BreadCrumbItem(
      content: Text(title ?? 'Loading'),
      textColor: Colors.green,
      onTap: () async {
        var pageName = title;
        BreadCrumbItem lastBreadcrumb =
            BreadCrumbItem(content: const Text('Home'));
        int currentID = breadIDs.last;
        int targetID = id;

        //current page has the id of the last id in the list
        //use this to find what page we're currently on
        if (breadIDs != [0]) {
          Section? section = await Helpers().getSection(currentID);
          var currentTitle = section?.translationSection;
          //print(currentTitle);

          //check if previous popUntil nav worked, else iterate through all pages
          //in bread route until we are on the right page
          while (currentID != targetID) {
            Navigator.pop(context);
            breads.removeLast();
            breadIDs.removeLast();
            breadRoutes.removeLast();
            currentID = breadIDs.last;
            Section? section = await Helpers().getSection(currentID);
            currentTitle = section?.translationSection;
          }
          //print("found page");
        } else {
          print("No breads left");
        }
      },
    ));
  }

  //static void remove(String route) {}

  @override
  Widget build(BuildContext context) {
    print("building breadcrumbs");
    if (breads == []) {
      print("empty breads");
      breads.add(BreadCrumbItem(
        content: const Text("Home"),
        textColor: Colors.green,
        onTap: () {
          BreadcrumbBar.homePressed(context);
        },
      ));
    }
    bool reverse = breads.length > 4;
    return SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.only(left: 10.0),
            height: 40.0,
            width: MediaQuery.of(context).size.width,
            color: const Color.fromARGB(255, 227, 226, 226),
            child: BreadCrumb.builder(
              itemCount: breads.length,
              builder: (index) {
                return breads[index];
              },
              divider: const Icon(Icons.chevron_right),
              overflow: ScrollableOverflow(
                  direction: Axis.horizontal, reverse: reverse),
            )));
  }
}
