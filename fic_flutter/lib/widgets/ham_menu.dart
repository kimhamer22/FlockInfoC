import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fic_flutter/widgets/breadcrumb.dart';
import 'package:fic_flutter/db_handle.dart';

import 'package:flowder/flowder.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:http/http.dart' as http;

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
  late final String path;
  late DownloaderUtils downloaderUtils;
  late ProgressDialog pd;
  late bool upToDateDB;

  @override
  void initState() {
    super.initState();
    allSpeciesFuture = Helpers().getSpecies();
    initPlatformState();

    // TODO: Update when we have endpoint
    // fetchWebDBVersion().then((response) {
    //   var websiteDBVersion = response.body as int;
    //   var appDBVersion = getAppDBVersion();
    //   upToDateDB = (appDBVersion == websiteDBVersion);
    // });
    upToDateDB = false;
  }

  Future<http.Response> fetchWebDBVersion() {
    return http.get(Uri.parse('http://flockinfo.mvls.gla.ac.uk:8000/version'));
  }

  getAppDBVersion() async {
    SectionHandler sh = SectionHandler();
    return await sh.animalCategories(); // TODO: Change to DB version
  }

  Future<void> initPlatformState() async {
    _setPath();
    if (!mounted) return;
  }

  void _setPath() async {
    path = (await getApplicationDocumentsDirectory()).path;
  }

  _valuableProgress(context, progress) async {
    if (!pd.isOpen()) {
      pd.show(
        max: 100,
        msg: 'File Downloading...',
        progressType: ProgressType.valuable,
      );
    }
    pd.update(value: progress.ceil());
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
              breadcrumbBar.homePressed(context);
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
                          breadcrumbBar.add(route, context, data[i].id);
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
              breadcrumbBar.add(tileRoute, context, 25);
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
              breadcrumbBar.add(tileRoute, context, 26);
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
              breadcrumbBar.add(tileRoute, context, 27);
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
              breadcrumbBar.add(tileRoute, context, 28);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.refresh,
              color: upToDateDB ? Colors.black45 : Colors.red,
            ),
            title: Text(
              'Update data',
              style: TextStyle(fontSize: fontSize),
            ),
            onTap: () async {
              try {
                // const String filename = 'flock-control.zip';
                const String filename = '20MB.zip';
                final String filepath = '$path/$filename';
                pd = ProgressDialog(context: context);
                downloaderUtils = DownloaderUtils(
                  progressCallback: (current, total) {
                    final progress = (current / total) * 100;
                    _valuableProgress(context, progress);
                  },
                  file: File(filepath),
                  progress: ProgressImplementation(),
                  onDone: () {
                    final zipFile = File(filepath);
                    final destinationDir = Directory(path);
                    ZipFile.extractToDirectory(
                        zipFile: zipFile, destinationDir: destinationDir);

                    breadcrumbBar.homePressed(context);
                  },
                  deleteOnCancel: true,
                );

                // TODO - Change URL to server's zipped DB
                // Local Django project's static folder
                //const url = 'http://10.0.2.2:8000/static/database/$filename';
                // Random dummy zip from online
                const url = 'http://ipv4.download.thinkbroadband.com/20MB.zip';
                await Flowder.download(url, downloaderUtils);
              } catch (e) {
                print(e);
              }
              // TODO - Update database
            },
          )
        ],
      ),
    );
  }
}
