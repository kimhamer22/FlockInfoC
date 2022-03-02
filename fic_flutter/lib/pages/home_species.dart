import 'package:fic_flutter/helpers.dart';
import 'package:flutter/material.dart';
import '../widgets/navigation_button.dart';

class HomeSpecies extends StatefulWidget {
  const HomeSpecies({Key? key}) : super(key: key);

  @override
  State<HomeSpecies> createState() => _HomeSpecies();
}

class _HomeSpecies extends State<HomeSpecies> {
  late Future allSpeciesFuture;

  @override
  void initState() {
    super.initState();
    allSpeciesFuture = Helpers().getSpecies();
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
                  var route = '/species';
                  list.add(NavigationButton(
                    title: title,
                    route: route,
                    id: data[i].id,
                  ));
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
