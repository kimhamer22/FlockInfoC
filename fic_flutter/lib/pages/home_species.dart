import 'package:flutter/material.dart';
import '../widgets/navigation_button.dart';
import '../db_handle.dart';

class HomeSpecies extends StatefulWidget {
  const HomeSpecies({Key? key}) : super(key: key);

  @override
  State<HomeSpecies> createState() => _HomeSpecies();
}

class _HomeSpecies extends State<HomeSpecies> {
  late Future allSpeciesFuture;
  SectionHandler sh = SectionHandler();

  _getAllSpecies() async {
    return await sh.animalCategories();
  }

  @override
  void initState() {
    super.initState();
    allSpeciesFuture = _getAllSpecies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0x80DBF9D3),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: Center(
          child: FutureBuilder(
            future: allSpeciesFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var list = <NavigationButton>[];
                var data = snapshot.data as List;
                for (var i = 0; i < data.length; i++) {
                  var title = data[i].translationSection;
                  list.add(NavigationButton(
                      title: title,
                      route: '/' + title.toString().toLowerCase()));
                }
                return Column(
                  children: list,
                );
              } else {
                return const Text('Awaiting data...');
              }
            },
          ),
        ),
      ),
    );
  }
}
