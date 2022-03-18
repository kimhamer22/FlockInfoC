import 'package:flutter/material.dart';
import '../helpers.dart';
import '../widgets/navigation_button.dart';

class HomeResources extends StatefulWidget {
  const HomeResources({Key? key}) : super(key: key);

  @override
  State<HomeResources> createState() => _HomeResources();
}

class _HomeResources extends State<HomeResources> {
  final String simpleRoute = '/simple_text';
  late Future sections;

  @override
  void initState() {
    sections = Helpers().getMainPageSections();
    super.initState();
  }

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
              title: 'Sheep Loss Prevention', route: '/species', id: 20),
          FutureBuilder(
              future: sections,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var buttons = <NavigationButton>[];
                  var data = snapshot.data as List;
                  for (var i = 0; i < data.length; i++) {
                    var id = data[i].id;
                    var title = data[i].translationSection;
                    buttons.add(NavigationButton(
                      route: '/simple_text',
                      title: title,
                      id: id,
                    ));
                  }

                  return Column(
                    children: buttons,
                  );
                } else {
                  return Container();
                }
              }),
        ]),
      ),
    );
  }
}
