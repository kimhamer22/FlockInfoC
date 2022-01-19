import 'package:fic_flutter/widgets/breadcrumb.dart';
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
  late int sectionID; // TODO: Pass this when navigating (6 - Vaccination)
  SectionHandler sh = SectionHandler();
  late Future section;
  late Future relevantCats;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      var id = ModalRoute.of(context)!.settings.arguments as int;
      sectionID = id;
    }).whenComplete(() {
      section = Helpers().getSection(sectionID);
      relevantCats = Helpers().getRelevantSections(sectionID);
      setState(() {});
    }).then;
    super.initState();
  }

  final String title = "Vaccination";
  final String description =
      """Vaccines are essential for controlling some causes of abortion.

  Vaccines are only effective if:
  - stored at the correct temperature
  - given at the correct time
  - given to the correct animals
  - administered correctly
  - used within the stated time from opening (usually 2-8hrs) and before the use by date

  Product information leaflets will show specific details for each vaccine.
  """;
  final List<Heading> _headings = [
    Heading(
      headerValue: 'How to get it right',
      expandedValue: '...',
    ),
    Heading(
      headerValue: "How to check it's right",
      expandedValue: '...',
    ),
    Heading(
      headerValue: 'Benefits of getting it right',
      expandedValue: '...',
    ),
    Heading(
      headerValue: 'How it can go wrong',
      expandedValue: '...',
    ),
    Heading(
      headerValue: 'Effects of getting it wrong',
      expandedValue: '...',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    ExpansionPanelList(
                      expansionCallback: (int index, bool isExpanded) {
                        setState(() {
                          _headings[index].isExpanded = !isExpanded;
                        });
                      },
                      children:
                          _headings.map<ExpansionPanel>((Heading heading) {
                        return ExpansionPanel(
                          headerBuilder:
                              (BuildContext context, bool isExpanded) {
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
                    ),
                    FutureBuilder(
                        future: relevantCats,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var list = [];
                            var data = snapshot.data as List;
                            list.add(
                              const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(
                                    'Relevant Factors',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                            );
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
