import 'package:flutter/material.dart';
import '../widgets/navigation_button.dart';
import '../widgets/top_bar.dart';
import '../widgets/breadcrumb.dart';
import '../db_handle.dart';

class Sheep extends StatefulWidget {
  const Sheep({Key? key}) : super(key: key);

  @override
  State<Sheep> createState() => _Sheep();
}

class _Sheep extends State<Sheep> {
  late Future allCategories;
  SectionHandler sh = SectionHandler();

  @override
  void initState() {
    super.initState();
    allCategories = _getAllCategories();
  }

  _getAllCategories() async {
    return await sh.childSections(1); // 1 = Sheep
  }

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
              FutureBuilder(
                  future: allCategories,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var list = <NavigationButton>[];
                      var data = snapshot.data as List;
                      print(data);
                      for (var i = 0; i < data.length; i++) {
                        var title = data[i].translationSection;
                        list.add(NavigationButton(
                            title: title, route: '/categorypage'));
                      }
                      return Column(
                        children: list,
                      );
                    } else {
                      return const Text('Awaiting data...');
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
