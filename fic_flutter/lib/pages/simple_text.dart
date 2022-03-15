import 'package:fic_flutter/helpers.dart';
import 'package:fic_flutter/widgets/ham_menu.dart';
import 'package:flutter/material.dart';
import 'package:fic_flutter/widgets/top_bar.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

import '../db_handle.dart';

class SimpleText extends StatefulWidget {
  const SimpleText({Key? key}) : super(key: key);

  @override
  State<SimpleText> createState() => _SimpleText();
}

class _SimpleText extends State<SimpleText> {
  late int sectionID;
  late Future section;
  final String errorMessage = 'Could not load page';

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      var id = ModalRoute.of(context)!.settings.arguments as int;
      sectionID = id;
    }).whenComplete(() {
      section = Helpers().getSection(sectionID);
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
                  var description = sectionObj.translationData ?? errorMessage;
                  return SelectableLinkify(
                      onOpen: (link) async {
                        if (await canLaunch(link.url)) {
                          await launch(link.url);
                        } else {
                          throw 'Could not launch $link';
                        }
                      },
                      text: description);
                } else {
                  return Text(errorMessage);
                }
              },
            ),
          ),
        ),
      );
    } catch (LateInitializationError) {
      return const Text('ERROR');
    }
  }
}
