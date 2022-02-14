import 'package:fic_flutter/widgets/breadcrumb.dart';
import 'package:fic_flutter/widgets/ham_menu.dart';
import 'package:fic_flutter/widgets/navigation_button.dart';
import 'package:flutter/material.dart';
import 'package:fic_flutter/widgets/top_bar.dart';

import '../db_handle.dart';
import '../helpers.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  late int sectionID;
  late Future section;
  late Future relevantCats;
  late Future subheadings;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      var id = ModalRoute.of(context)!.settings.arguments as int;
      sectionID = id;
    }).whenComplete(() {
      section = Helpers().getSection(sectionID);
      subheadings = Helpers().getChildren(sectionID);
      relevantCats = Helpers().getRelevantSections(sectionID);
      setState(() {});
    }).then;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: FutureBuilder(
                future: section,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var sectionObj = snapshot.data as Section;
                    var description =
                        sectionObj.translationData ?? 'Could not load';
                    return Column(children: [
                      BreadCrumb(),
                      const Text(
                        'Description:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(description)),
                      FutureBuilder(
                          future: subheadings,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              var headings = <Heading>[];
                              for (var dataPoint in snapshot.data as List) {
                                headings.add(Heading(
                                    expandedValue: dataPoint.translationData,
                                    headerValue: dataPoint.translationSection));
                              }
                              return CustomTextPanel(headings: headings);
                            } else {
                              return const Padding(padding: EdgeInsets.zero);
                            }
                          }),
                      FutureBuilder(
                          future: relevantCats,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              var list = [];
                              var data = snapshot.data as List;
                              if (data.isNotEmpty) {
                                list.add(
                                  const Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        'Relevant Factors',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                );
                              }
                              for (var i = 0; i < data.length; i++) {
                                var title = data[i].translationSection;
                                list.add(NavigationButton(
                                  title: title,
                                  route: '/infopage',
                                  id: data[i].id,
                                ));
                              }
                              return Column(
                                children: List.from(list),
                              );
                            } else {
                              return const Text('No relevant sections found');
                            }
                          }),
                    ]);
                  } else {
                    return const Text('Loading...');
                  }
                }),
          ),
        ),
      );
    } catch (LateInitializationError) {
      return const Text('ERROR');
    }
  }
}

// stores ExpansionPanel state information
class Heading {
  Heading({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

class CustomTextPanel extends StatefulWidget {
  final List<Heading> headings;

  const CustomTextPanel({Key? key, required this.headings}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CustomTextPanel();
}

class _CustomTextPanel extends State<CustomTextPanel> {
  late List<Heading> headings;

  @override
  void initState() {
    super.initState();
    headings = widget.headings;
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          headings[index].isExpanded = !isExpanded;
        });
      },
      children: headings.map<ExpansionPanel>((Heading heading) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(heading.headerValue),
            );
          },
          body: ListTile(
            title: Text(heading.expandedValue),
          ),
          isExpanded: heading.isExpanded,
          canTapOnHeader: true,
        );
      }).toList(),
    );
  }
}
