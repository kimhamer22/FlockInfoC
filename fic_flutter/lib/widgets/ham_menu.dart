import 'package:flutter/material.dart';

class HamMenu extends StatelessWidget {
  const HamMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text(
              'Home',
              style: TextStyle(fontSize: 24),
            ),
            onTap: () {
              //Navigator.pop(context);
              Navigator.popUntil(context, ModalRoute.withName('/'));
            },
          ),
          ListTile(
            title: const Text(
              'Sheep',
              style: TextStyle(fontSize: 24),
            ),
            onTap: () {},
          )
        ],
      ),
    );
  }
}
