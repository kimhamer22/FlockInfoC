import 'package:flutter/material.dart';
import 'navigation_button.dart';

class HomeSpecies extends StatefulWidget {
  const HomeSpecies({Key? key}) : super(key: key);

  @override
  State<HomeSpecies> createState() => _HomeSpecies();
}

class _HomeSpecies extends State<HomeSpecies> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: const [
        NavigationButton(title: "Hello"),
        NavigationButton(title: "Goodbye"),
      ]),
    );
  }
}
