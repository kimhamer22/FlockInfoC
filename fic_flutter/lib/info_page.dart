import 'package:flutter/material.dart';
import 'package:fic_flutter/top_bar.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
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
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: SingleChildScrollView(
          child: Column(children: [
            const Text(
              'Description:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Padding(padding: EdgeInsets.all(10), child: Text(description)),
            ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  _headings[index].isExpanded = !isExpanded;
                });
              },
              children: _headings.map<ExpansionPanel>((Heading heading) {
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
            ),
          ]),
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
