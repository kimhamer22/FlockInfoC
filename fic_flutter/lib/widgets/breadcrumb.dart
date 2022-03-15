import 'package:fic_flutter/main.dart';
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
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomePage(title: 'Home')),
      (Route<dynamic> route) => false,
    );
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

    breads.add(BreadCrumbItem(
      content: Text(title ?? 'Loading'),
      textColor: Colors.green,
      onTap: () async {
        int currentID = breadIDs.last;
        int targetID = id;

        //current page has the id of the last id in the list
        //use this to find what page we're currently on
        if (breadIDs != [0]) {
          Section? section = await Helpers().getSection(currentID);
          var currentTitle = section?.translationSection;

          //iterate through all pages
          //in breads until we are on the right page
          // TODO: Fix bug that doesn't allow navigating to same (earlier) section
          while (currentID != targetID) {
            Navigator.pop(context);
            breads.removeLast();
            breadIDs.removeLast();
            breadRoutes.removeLast();
            currentID = breadIDs.last;
            Section? section = await Helpers().getSection(currentID);
            currentTitle = section?.translationSection;
          }
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
