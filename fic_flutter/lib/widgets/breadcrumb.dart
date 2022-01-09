import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fic_flutter/main.dart';

List<String> breadcrumb = [HomePage.route];

class BreadCrumb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 10.0),
        height: 40.0,
        width: MediaQuery.of(context).size.width,
        color: const Color.fromARGB(255, 227, 226, 226),
        child: Row(
            children: breadcrumb.map((e) => BreadcrumbItem(name: e)).toList()));
  }
}

class BreadcrumbItem extends StatefulWidget {
  final String name;
  BreadcrumbItem({
    required this.name,
  });

  @override
  _BreadcrumbItemState createState() => _BreadcrumbItemState();
}

class _BreadcrumbItemState extends State<BreadcrumbItem> {
  bool onIt = false;
  Color color = Colors.green;
  String init_text = '';
  String main_text = '';
  TextDecoration decoration = TextDecoration.underline;

  @override
  Widget build(BuildContext context) {
    if (widget.name == '/') {
      init_text = '';
      main_text = 'Home';
    } else {
      init_text = '/';
      main_text = widget.name.substring(1);
    }
    if (onIt) {
      decoration = TextDecoration.none;
      color = Colors.black45;
    }

    return Row(children: [
      Text(
        init_text,
      ),
      GestureDetector(
        onTap: () {
          if (breadcrumb.last != breadcrumb) {
            setState(() {
              Navigator.pop(context);
              breadcrumb.removeLast();
            });
          }
        },
        child: MouseRegion(
          opaque: true,
          onEnter: (value) {
            setState(() {
              onIt = true;
              color = Colors.green;
            });
          },
          onExit: (value) {
            setState(() {
              onIt = false;
              color = Colors.black45;
            });
          },
          child: Text(main_text,
              style: TextStyle(
                color: color,
                decoration: decoration,
              )),
        ),
      ),
    ]);
  }
}
