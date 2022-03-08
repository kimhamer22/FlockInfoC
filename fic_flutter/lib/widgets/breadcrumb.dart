import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fic_flutter/main.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';

import '../db_handle.dart';
import '../helpers.dart';

List<BreadCrumbItem> breads = [
  BreadCrumbItem(
    content: Text("Home"),
    textColor: Colors.black,
    onTap: () {},
  )
];
List<String> bread_routes = [];
List<int> bread_ids = [0];

class breadcrumbBar extends StatelessWidget {
  static void homePressed(BuildContext context) {
    Navigator.popUntil(context, ModalRoute.withName('/'));
    breads = [
      BreadCrumbItem(
        content: Text("Home"),
        textColor: Colors.green,
      )
    ];
    bread_routes = ['/'];
    bread_ids = [0];
  }

  static add(String route, BuildContext context, int id) async {
    Section? section = await Helpers().getSection(id);
    var title = section?.translationSection;
    bread_routes.add(route);
    bread_ids.add(id);
    print(bread_ids);
    //print('Adding route:' + route);

    breads.add(BreadCrumbItem(
      content: Text(title ?? 'Loading'),
      textColor: Colors.green,
      onTap: () async {
        //variables needed later on in the function
        //print("internal bread ids");
        //print(bread_ids);
        var page_name = title;
        BreadCrumbItem last_breadcrumb = BreadCrumbItem(content: Text('Home'));
        int current_id = bread_ids.last;
        int target_id = id;

        //clear bread routes when navigating to previous pages
        if ((bread_routes.any((e) => e == route)) && (bread_routes != ['/'])) {
          while (bread_routes.any((e) => e == route)) {
            last_breadcrumb = breads.last;
            breads.removeLast();
            bread_routes.removeLast();
            bread_ids.removeLast();
          }

          //try using popUntil to go back, issue arises when navigating between
          // 2 pages of same type as they have the same route
          Navigator.popUntil(context, ModalRoute.withName(route));

          //current page has the id of the last id in the list
          //use this to find what page we're currently on
          if (bread_ids != [0]) {
            Section? section = await Helpers().getSection(current_id);
            var current_title = section?.translationSection;
            //print(current_title);

            //check if previous popUntil nav worked, else iterate through all pages
            //in bread route until we are on the right page
            while (current_id != target_id) {
              print("trying to get to: " +
                  page_name! +
                  " id:" +
                  target_id.toString());
              print("from " + current_title! + " id:" + current_id.toString());
              if (bread_ids.contains(target_id)) {
                print(current_id);
                Navigator.pop(context);
                bread_ids.removeLast();
                print(bread_ids);
                current_id = bread_ids.last;
                print(bread_ids);
                Section? section = await Helpers().getSection(current_id);
                current_title = section?.translationSection;
              } else {
                print("page not found");
                break;
              }
            }
            //print("found page");
          } else {
            print("No breads left");
          }
        } else {
          print("No breadcrumb found");
        }
        //Breadcrumbs should include page you're on
        breads.add(last_breadcrumb);
        bread_routes.add(route);
        bread_ids.add(current_id);
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
        content: Text("Home"),
        textColor: Colors.green,
        onTap: () {
          breadcrumbBar.homePressed(context);
        },
      ));
    }
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
              divider: Icon(Icons.chevron_right),
              overflow: ScrollableOverflow(direction: Axis.horizontal),
            )));
  }
}
