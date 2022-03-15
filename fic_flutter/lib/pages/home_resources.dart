import 'package:flutter/material.dart';
import '../widgets/navigation_button.dart';

class HomeResources extends StatefulWidget {
  const HomeResources({Key? key}) : super(key: key);

  @override
  State<HomeResources> createState() => _HomeResources();
}

class _HomeResources extends State<HomeResources> {
  final String simpleRoute = '/simple_text';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0x80DBF9D3),
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 20, 30, 30),
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
          NavigationButton(
              title: 'Sheep loss prevention', route: '/species', id: 20),
          NavigationButton(
              title: 'General Resources', route: simpleRoute, id: 25),
          NavigationButton(
              title: 'Benefits of Reducing Losses', route: simpleRoute, id: 26),
        ]),
      ),
    );
  }
}
