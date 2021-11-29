import 'package:flutter/material.dart';
import 'navigation_button.dart';

class HomeResources extends StatefulWidget {
  const HomeResources({Key? key}) : super(key: key);

  @override
  State<HomeResources> createState() => _HomeResources();
}

class _HomeResources extends State<HomeResources> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
          child: Image.asset('assets/images/word art (low res).png'),
        ),
        const Text(
          'Flock Information Centre',
          style: TextStyle(fontSize: 30),
        ),
        const Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            'Online resources to provide information to professionals in the farming industry',
            textAlign: TextAlign.center,
          ),
        ),
        const NavigationButton(title: 'General Resources', route: "/infopage"),
        const NavigationButton(
            title: 'Benefits of Reducing Losses', route: "/infopage"),
        const Icon(Icons.eleven_mp_sharp),
      ]),
    );
  }
}
