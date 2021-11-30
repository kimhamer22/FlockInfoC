import 'package:fic_flutter/navigation_button.dart';
import 'package:flutter/material.dart';
import 'package:fic_flutter/top_bar.dart';

class Sheep extends StatefulWidget {
  const Sheep({Key? key}) : super(key: key);

  @override
  State<Sheep> createState() => _Sheep();
}

class _Sheep extends State<Sheep> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopBar(page: 'Sheep'),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
          child: Column(
            children: const [
              NavigationButton(
                  title: 'Controlling Abortion', route: '/infopage'),
              NavigationButton(title: 'Neonatal Survival', route: '/infopage'),
              NavigationButton(
                  title: 'Additional Resources', route: '/infopage'),
            ],
          ),
        ),
      ),
    );
  }
}
