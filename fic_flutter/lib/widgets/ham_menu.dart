import 'package:flutter/material.dart';
import 'package:fic_flutter/widgets/breadcrumb.dart';
import 'package:fic_flutter/main.dart';

class HamMenu extends StatelessWidget {
  final double fontSize = 20;
  const HamMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.home),
            title: Text(
              'Home',
              style: TextStyle(fontSize: fontSize),
            ),
            onTap: () {
              Navigator.popUntil(context, ModalRoute.withName('/'));
              breadcrumb.clear();
              breadcrumb.add(HomePage.route);
            },
          ),
          ExpansionTile(
            leading: const Icon(Icons.pets),
            title: Text(
              'Species',
              style: TextStyle(fontSize: fontSize),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: Text(
              'General Resources',
              style: TextStyle(fontSize: fontSize),
            ),
            onTap: () {
              Navigator.popUntil(context, ModalRoute.withName('/'));
            },
          ),
          ListTile(
            leading: const Icon(Icons.health_and_safety),
            title: Text(
              'Benefits of Reducing Losses',
              style: TextStyle(fontSize: fontSize),
            ),
            onTap: () {
              Navigator.popUntil(context, ModalRoute.withName('/'));
            },
          ),
          ListTile(
            leading: const Icon(Icons.article),
            title: Text(
              'Acknowledgments',
              style: TextStyle(fontSize: fontSize),
            ),
            onTap: () {
              Navigator.popUntil(context, ModalRoute.withName('/'));
            },
          ),
          ListTile(
            leading: const Icon(Icons.email),
            title: Text(
              'Contact Us',
              style: TextStyle(fontSize: fontSize),
            ),
            onTap: () {
              Navigator.popUntil(context, ModalRoute.withName('/'));
            },
          ),
        ],
      ),
    );
  }
}
