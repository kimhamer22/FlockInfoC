import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fic_flutter/main.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';

List<BreadCrumbItem> breads = [
  BreadCrumbItem(
    content: Text("Home"),
    textColor: Colors.green,
    onTap: () {},
  )
];

class breadcrumbBar extends StatelessWidget {
  static void homePressed() {
    breads = [
      BreadCrumbItem(
        content: Text("Home"),
        textColor: Colors.green,
        onTap: () {},
      )
    ];
  }

  static void add(String route) {
    breads.add(BreadCrumbItem(
      content: Text(route.substring(1)),
      textColor: Colors.green,
      onTap: () {
        if (breads.isNotEmpty) {
          breads.removeLast();
        } else {
          print("Empty breads");
        }
      },
    ));
  }

  static void remove(String route) {
    breads.removeLast();
  }

  @override
  Widget build(BuildContext context) {
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
            )));
  }
}
