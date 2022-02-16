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
  }

  static add(String route, BuildContext context, int id) async {
    bread_routes.add(route);
    Section? section = await Helpers().getSection(id);

    breads.add(BreadCrumbItem(
      content: Text(section?.translationSection ?? 'Loading'),
      textColor: Colors.green,
      onTap: () {
        BreadCrumbItem last_breadcrumb = BreadCrumbItem(content: Text('Home'));
        if ((bread_routes.any((e) => e == route)) && (bread_routes != ['/'])) {
          while (bread_routes.any((e) => e == route)) {
            last_breadcrumb = breads.last;
            breads.removeLast();
            bread_routes.removeLast();
          }
          Navigator.popUntil(context, ModalRoute.withName(route));
        } else {
          print("No breadcrumb found");
        }
        //Breadcrumbs should include page you're on
        breads.add(last_breadcrumb);
        bread_routes.add(route);
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
            height: 50.0,
            width: MediaQuery.of(context).size.width,
            color: const Color.fromARGB(255, 227, 226, 226),
            child: BreadCrumb.builder(
              itemCount: breads.length,
              builder: (index) {
                return breads[index];
              },
              divider: Icon(Icons.chevron_right),
            )));
  }
}
