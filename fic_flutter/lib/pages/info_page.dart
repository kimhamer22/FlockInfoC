import 'package:fic_flutter/widgets/breadcrumb.dart';
import 'package:fic_flutter/widgets/navigation_button.dart';
import 'package:flutter/material.dart';
import 'package:fic_flutter/widgets/top_bar.dart';

import '../db_handle.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  final int id = 6; // TODO: Pass this when navigating
  SectionHandler sh = SectionHandler();
  late Future section;

  _getSection() async {
    return await sh.section(id);
  }

  @override
  void initState() {
    super.initState();
    section = _getSection();
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
      appBar: TopBar(page: title),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
          child: FutureBuilder(
              future: section,
              builder: (context, snapshot) {
                var sectionObject = snapshot.data;
                if (snapshot.hasData) {
                  var sectionNotNullObj = sectionObject as Section;
                  var description =
                      sectionNotNullObj.translationData ?? 'Could not load';
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
                    const Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Relevant Causes',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    const NavigationButton(
                        title: 'Schmallenberg Virus', route: "/infopage"),
                    const NavigationButton(
                        title: 'Toxoplasma Gondii', route: "/infopage"),
                    const NavigationButton(
                        title: 'Bluetongue Virus', route: "/infopage"),
                    const NavigationButton(title: '...', route: "/infopage"),
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
