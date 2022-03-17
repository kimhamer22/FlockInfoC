import 'dart:io';

import 'package:fic_flutter/db_handle.dart';
import 'package:fic_flutter/widgets/alert_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:fic_flutter/widgets/breadcrumb.dart';

import 'package:flowder/flowder.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

import '../helpers.dart';

class HamMenu extends StatefulWidget {
  const HamMenu({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HamMenu();
}

class _HamMenu extends State<HamMenu> {
  final double fontSize = 20;
  late Future allSpeciesFuture;
  late Future mainPageSections;
  final String tileRoute = '/simple_text';
  late final String path;
  late DownloaderUtils downloaderUtils;
  late ProgressDialog pd;

  @override
  void initState() {
    super.initState();
    allSpeciesFuture = Helpers().getSpecies();
    mainPageSections = Helpers().getMainPageSections();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    _setPath();
    if (!mounted) return;
  }

  Future<String> _setPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // _valuableProgress(context, progress) async {
  //   if (!pd.isOpen()) {
  //     pd.show(
  //       max: 100,
  //       msg: 'File Downloading...',
  //       progressType: ProgressType.valuable,
  //     );
  //   }
  //   pd.update(value: progress.ceil());
  // }

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
              BreadcrumbBar.homePressed(context);
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
                    var route = '/species';
                    list.add(ListTile(
                        title: title,
                        onTap: () {
                          Navigator.pushNamed(context, route,
                              arguments: data[i].id);
                          BreadcrumbBar.add(route, context, data[i].id);
                        }));
                  }
                  return ExpansionTile(
                    leading: SizedBox(
                      height: 25,
                      width: 25,
                      child: Image.asset(
                        'assets/images/barn_icon.png',
                      ),
                    ),
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
          FutureBuilder(
              future: mainPageSections,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var tiles = <ListTile>[];
                  var data = snapshot.data as List;
                  for (var i = 0; i < data.length; i++) {
                    var id = data[i].id;
                    var title = data[i].translationSection;
                    tiles.add(ListTile(
                      leading: const Icon(Icons.info),
                      title: Text(
                        title,
                        style: TextStyle(fontSize: fontSize),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, tileRoute, arguments: id);
                        BreadcrumbBar.add(tileRoute, context, id);
                      },
                    ));
                  }

                  return Column(
                    children: tiles,
                  );
                } else {
                  return Container();
                }
              }),
          ListTile(
            leading: const Icon(Icons.article),
            title: Text(
              'Acknowledgements',
              style: TextStyle(fontSize: fontSize),
            ),
            onTap: () {
              Navigator.pushNamed(context, tileRoute, arguments: 27);
              BreadcrumbBar.add(tileRoute, context, 27);
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
              BreadcrumbBar.add(tileRoute, context, 28);
            },
          ),
          ListTile(
            leading: const Icon(Icons.refresh),
            title: Text(
              'Update data',
              style: TextStyle(fontSize: fontSize),
            ),
            onTap: () async {
              try {
                // const String filename = 'flock-control.zip';
                final path = await _setPath();
                final String filepath = '$path/database.zip';
                //pd = ProgressDialog(context: context);
                downloaderUtils = DownloaderUtils(
                  progressCallback: (current, total) {
                    //final progress = (current / total) * 100;
                    //_valuableProgress(context, progress);
                  },
                  file: File(filepath),
                  progress: ProgressImplementation(),
                  onDone: () {
                    // Remove previous DB

                    // Unzip database
                    _setPath().then((dbDir) {
                      var dbPath = join(dbDir, "flock-control.sqlite");
                      DatabaseImporter.delete(dbPath).then((oldFile) {
                        final zipFile = File(filepath);
                        final destinationDir = Directory(path);
                        ZipFile.extractToDirectory(
                                zipFile: zipFile,
                                destinationDir: destinationDir)
                            .then((value) {
                          zipFile.delete();
                          DatabaseImporter.update(dbPath);
                          BreadcrumbBar.homePressed(context);
                          showAlertDialog(context);
                        });
                      });
                    });
                  },
                  deleteOnCancel: true,
                );

                const url =
                    'http://flockinfo.mvls.gla.ac.uk/static/downloads/database.zip';
                await Flowder.download(url, downloaderUtils);
              } catch (e) {
                BreadcrumbBar.homePressed(context);
              }
            },
          )
        ],
      ),
    );
  }
}
