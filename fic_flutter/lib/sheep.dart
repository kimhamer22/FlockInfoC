import 'package:fic_flutter/navigation_button.dart';
import 'package:flutter/material.dart';
import 'package:fic_flutter/top_bar.dart';
import 'package:fic_flutter/breadcrumb.dart';

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
            children: [
              BreadCrumb(),
              const NavigationButton(
                  title: 'Controlling Abortion', route: '/categorypage'),
              const NavigationButton(
                  title: 'Neonatal Survival', route: '/infopage'),
              const NavigationButton(
                  title: 'Additional Resources', route: '/infopage'),
            ],
          ),
        ),
      ),
    );
  }
}
