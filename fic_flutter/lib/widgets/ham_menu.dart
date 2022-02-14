import 'dart:io';

import 'package:flowder/flowder.dart';
import 'package:flutter/material.dart';
import 'package:fic_flutter/widgets/breadcrumb.dart';
import 'package:fic_flutter/main.dart';

import '../helpers.dart';

class HamMenu extends StatefulWidget {
  const HamMenu({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HamMenu();
}

class _HamMenu extends State<HamMenu> {
  final double fontSize = 20;
  late Future allSpeciesFuture;
  final String tileRoute = '/simple_text';

  final downloaderUtils = DownloaderUtils(
    progressCallback: (current, total) {
      final progress = (current / total) * 100;
      print('Downloading: $progress');
    },
    file: File('../assets/database/200MB.zip'),
    progress: ProgressImplementation(),
    onDone: () {
      print('Download done');
    },
    deleteOnCancel: true,
  );

  @override
  void initState() {
    super.initState();
    allSpeciesFuture = Helpers().getSpecies();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.home),
            title: Text(
              'Home',
              style: TextStyle(fontSize: fontSize),
            ),
            onTap: () {
              Navigator.popUntil(context, ModalRoute.withName('/'));
              breadcrumb.clear();
              breadcrumb.add(HomePage.route);
            },
          ),
          FutureBuilder(
              future: allSpeciesFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var list = <ListTile>[];
                  var data = snapshot.data as List;
                  for (var i = 0; i < data.length; i++) {
                    var title = Text(data[i].translationSection);
                    var route = '/' + title.data.toString().toLowerCase();
                    list.add(ListTile(
                        title: title,
                        onTap: () {
                          Navigator.pushNamed(context, route);
                          breadcrumb.add(route);
                        }));
                  }
                  return ExpansionTile(
                    leading: const Icon(Icons.pets),
                    title: Text(
                      'Species',
                      style: TextStyle(fontSize: fontSize),
                    ),
                    children: list,
                  );
                } else {
                  return ListTile(
                    leading: const Icon(Icons.pets),
                    title:
                        Text('Species', style: TextStyle(fontSize: fontSize)),
                  );
                }
              }),
          ListTile(
            leading: const Icon(Icons.info),
            title: Text(
              'General Resources',
              style: TextStyle(fontSize: fontSize),
            ),
            onTap: () {
              // 25 - General Resources
              Navigator.pushNamed(context, tileRoute, arguments: 25);
            },
          ),
          ListTile(
            leading: const Icon(Icons.health_and_safety),
            title: Text(
              'Benefits of Reducing Losses',
              style: TextStyle(fontSize: fontSize),
            ),
            onTap: () {
              Navigator.pushNamed(context, tileRoute, arguments: 26);
            },
          ),
          ListTile(
            leading: const Icon(Icons.article),
            title: Text(
              'Acknowledgements',
              style: TextStyle(fontSize: fontSize),
            ),
            onTap: () {
              Navigator.pushNamed(context, tileRoute, arguments: 27);
            },
          ),
          ListTile(
            leading: const Icon(Icons.email),
            title: Text(
              'Contact Us',
              style: TextStyle(fontSize: fontSize),
            ),
            onTap: () {
              Navigator.pushNamed(context, tileRoute, arguments: 28);
            },
          ),
          ListTile(
            leading: const Icon(Icons.refresh),
            title: Text(
              'Update data',
              style: TextStyle(fontSize: fontSize),
            ),
            onTap: () async {
              // TODO - Pull database
              // TODO - Change URL to server's zipped DB
              const url = 'http://ipv4.download.thinkbroadband.com/200MB.zip';
              final core = await Flowder.download(url, downloaderUtils);
              core.download(url, downloaderUtils);
              // TODO - Unzip database
              // TODO - Update database
              Navigator.popUntil(context, ModalRoute.withName('/'));
              breadcrumb.clear();
              breadcrumb.add(HomePage.route);
            },
          )
        ],
      ),
    );
  }
}
