import 'package:fic_flutter/widgets/ham_menu.dart';
import 'package:fic_flutter/widgets/navigation_button.dart';
import 'package:fic_flutter/helpers.dart';
import 'package:flutter/material.dart';
import '../widgets/navigation_button.dart';
import '../widgets/top_bar.dart';
import '../widgets/breadcrumb.dart';
import '../db_handle.dart';

class SingleSpecies extends StatefulWidget {
  const SingleSpecies({Key? key}) : super(key: key);

  @override
  State<SingleSpecies> createState() => _SingleSpecies();
}

class _SingleSpecies extends State<SingleSpecies> {
  late int sectionID;
  late Future allCategories;
  late Future section;
  SectionHandler sh = SectionHandler();

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      var id = ModalRoute.of(context)!.settings.arguments as int;
      sectionID = id;
    }).whenComplete(() {
      allCategories = _getAllCategories(sectionID);
      section = Helpers().getSection(sectionID);
      setState(() {});
    }).then;
    super.initState();
  }

  _getAllCategories(int id) async {
    return await sh.childSections(id);
  }

  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            BreadcrumbBar.homePressed(context);
          },
          child: const Icon(Icons.home),
        ),
        drawer: const HamMenu(),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: FutureBuilder(
              future: section,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var sectionObj = snapshot.data as Section;
                  var title = sectionObj.translationSection ?? 'Loading...';
                  return TopBar(page: title);
                } else {
                  return const TopBar(page: "Loading...");
                }
              }),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: Column(
              children: [
                BreadcrumbBar(),
                FutureBuilder(
                    future: allCategories,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var list = <NavigationButton>[];
                        var data = snapshot.data as List;
                        for (var i = 0; i < data.length; i++) {
                          var title = data[i].translationSection;
                          list.add(NavigationButton(
                              title: title,
                              route: '/categorypage',
                              id: data[i].id));
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
    } catch (LateInitializationError) {
      return const Text('Loading...');
    }
  }
}
