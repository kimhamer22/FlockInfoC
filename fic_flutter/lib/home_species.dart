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
      backgroundColor: const Color(0xffDBF9D3),
      body: Center(
        child: Column(children: const [
          NavigationButton(title: "Sheep", route: '/infopage'),
          NavigationButton(
            title: "Cows",
            route: '/infopage',
          ),
        ]),
      ),
    );
  }
}
