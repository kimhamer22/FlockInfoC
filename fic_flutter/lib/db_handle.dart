import 'dart:async';
import 'dart:typed_data';
import 'package:fic_flutter/enums/sections/section_type.dart';
import 'package:fic_flutter/exceptions/multiple_records_found_expected_one.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:fic_flutter/globals.dart' as globals;

import 'exceptions/database_record_not_found.dart';

final database = openDatabase('flock-control.sqlite');

class AssociatedImage {
  final int id;
  final int sectionId;
  final Uint8List image;

  AssociatedImage({
    required this.id,
    required this.sectionId,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'section_id': sectionId,
      'image': image,
    };
  }
}

class Version {
  final int id;

  Version({required this.id});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
    };
  }
}

class Language {
  final int id;
  final String name;

  Language({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class Section {
  final int id;
  final int type;
  final String? translationSection;
  final String? translationData;
  final String? parent;

  Section({
    required this.id,
    this.type = 2,

    // only used for retrieval not population
    this.translationSection = "",
    this.translationData = "",
    this.parent = "",
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
    };
  }

  @override
  String toString() {
    String typeEnum = SectionType.values[type].toString();
    return 'Section{ID: $id, TITLE: $translationSection, PARENT: $parent, DATA: $translationData, TYPE: $type ($typeEnum)}';
  }
}

class SectionParent {
  final int sectionId;
  final int parentSectionId;

  SectionParent({
    required this.sectionId,
    required this.parentSectionId,
  });

  Map<String, dynamic> toMap() {
    return {
      'section_id': sectionId,
      'parent_section_id': parentSectionId,
    };
  }

  @override
  String toString() {
    return 'Child - $sectionId, parent - $parentSectionId';
  }
}

class TranslationsData {
  final int id;
  final int languageId;
  final int sectionId;
  final String translation;

  TranslationsData({
    required this.id,
    required this.languageId,
    required this.sectionId,
    required this.translation,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'language_id': languageId,
      'section_id': sectionId,
      'translation': translation,
    };
  }
}

class TranslationsSection {
  final int id;
  final int languageId;
  final int sectionId;
  final String translation;

  TranslationsSection({
    required this.id,
    required this.languageId,
    required this.sectionId,
    required this.translation,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'language_id': languageId,
      'section_id': sectionId,
      'translation': translation,
    };
  }
}

class MainPage {
  final String title;
  final String description;
  final String button1;
  final String button2;

  MainPage({
    required this.title,
    required this.description,
    required this.button1,
    required this.button2,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'button1': button1,
      'button2': button2,
    };
  }
}

class DatabaseImporter {
  static Future open() async {
    // Construct the path to the app's writable database file:
    var dbDir = await getDatabasesPath();
    var dbPath = join(dbDir, "flock-control.sqlite");

    // Delete any existing database:
    // KEEP FOR DEVELOPMENT so database is updated
    // COMMENT OUT when on production
    //await deleteDatabase(dbPath);

    var exists = await databaseExists(dbPath);

    if (!exists) {
      ByteData data =
          await rootBundle.load("assets/database/flock-control.sqlite");
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(dbPath).writeAsBytes(bytes);
    }
    var db = openDatabase(dbPath);

    return db;
  }

  static update(String? path) async {
    // Construct the path to the app's writable database file:
    var dbDir = await getDatabasesPath();
    var dbPath = path ?? join(dbDir, "flock-control.sqlite");

    openDatabase(dbPath);
  }

  static Future delete(String path) async {
    return await deleteDatabase(path);
  }
}

/// Handles operations for languages
class LanguageHandler {
  late Database db;
  LanguageHandler();

  Language languageGenerator(data) {
    return Language(id: data['id'], name: data['name']);
  }

  /// Returns all languages
  Future<List<Language>> languages() async {
    final db = await DatabaseImporter.open();

    var query = """
        SELECT *
        FROM language
    """;

    final List<Map<String, dynamic>> maps = await db.rawQuery(query);
    return List.generate(maps.length, (i) {
      return languageGenerator(maps[i]);
    });
  }
}

/// Handles all database operations related to sections
class SectionHandler {
  late Database db;
  SectionHandler();

  Section sectionGenerator(data) {
    return Section(
      id: data['id'],
      type: data['type'],
      translationData: data['translation_data'],
      translationSection: data['translation_section'],
      parent: data['parent'],
    );
  }

  /// Returns all animal categories (by filtering out section type 0)
  Future<List<Section>> animalCategories() async {
    final db = await DatabaseImporter.open();

    var query = """
        SELECT s.*, 
               ts.translation as translation_section
        FROM section as s
        JOIN translations_sections as ts ON s.id = ts.section_id
        WHERE s.type=""" +
        SectionType.speciesCategory.index.toString() +
        """ and
        ts.language_id = """ +
        globals.language.toString();

    final List<Map<String, dynamic>> maps = await db.rawQuery(query);
    return List.generate(maps.length, (i) {
      return sectionGenerator(maps[i]);
    });
  }

  /// Returns child sections provided parent section id
  Future<List<Section>> childSections(int parentId) async {
    final db = await DatabaseImporter.open();

    var query = """
        SELECT s.*, 
               td.translation as translation_data, 
               ts.translation as translation_section,
               pts.translation as parent
        FROM section as s
        JOIN translations_sections as ts ON s.id = ts.section_id
        LEFT JOIN translations_data as td ON s.id = td.section_id
        LEFT JOIN section_parent as sp ON s.id = sp.section_id
        LEFT JOIN translations_sections as pts ON sp.parent_section_id = pts.section_id
        WHERE sp.parent_section_id=""" +
        parentId.toString() +
        """ and
        ts.language_id = """ +
        globals.language.toString() +
        """ and
        (pts.language_id = """ +
        globals.language.toString() +
        """ or pts.language_id IS NULL)
        and (td.language_id IS NULL or td.language_id=""" +
        globals.language.toString() +""")""";

    final List<Map<String, dynamic>> maps = await db.rawQuery(query);
    return List.generate(maps.length, (i) {
      return sectionGenerator(maps[i]);
    });
  }

  /// Returns all the information about current section given its id
  /// Throws DatabaseRecordNotFound if record is not found
  /// Throws MultipleRecordsFoundExpectedOne (sanity check) if more than one record is returned
  Future<Section> section(int id) async {
    final db = await DatabaseImporter.open();

    var query = """
        SELECT s.*, 
               td.translation as translation_data, 
               ts.translation as translation_section,
               pts.translation as parent
        FROM section as s
        JOIN translations_sections as ts ON s.id = ts.section_id
        LEFT JOIN (
          SELECT tss.translation, tss.language_id
          FROM section_parent as spp
          JOIN translations_sections as tss on spp.parent_section_id = tss.section_id
          WHERE spp.section_id = """ + id.toString() + """ and
                tss.language_id= """+ globals.language.toString() + """
        ) as pts
        LEFT JOIN (
          SELECT tdd.translation
          FROM translations_data as tdd
          WHERE tdd.section_id = """ + id.toString() + """ and
                tdd.language_id= """+ globals.language.toString() + """
        ) as td
        WHERE s.id =""" +
        id.toString() +
        """ and
        ts.language_id = """ +
        globals.language.toString();
    final List<Map<String, dynamic>> maps = await db.rawQuery(query);

    if (maps.isEmpty) {
      throw DatabaseRecordNotFound("The section with this id does not exist!");
    }
    if (maps.length != 1) {
      throw MultipleRecordsFoundExpectedOne(
          "Only one record should be returned by the query");
    }

    return sectionGenerator(maps[0]);
  }

  ///generates the buttons for the homepage
  Future<List<Section>> mainPageButtons() async {
    final db = await DatabaseImporter.open();

    var query = """
        SELECT s.*, 
               ts.translation as translation_section
        FROM section as s
        JOIN translations_sections as ts ON s.id = ts.section_id
        WHERE s.type=""" +
        SectionType.homePage.index.toString() +
        """ and
        ts.language_id = """ +
        globals.language.toString();

    final List<Map<String, dynamic>> maps = await db.rawQuery(query);
    return List.generate(maps.length, (i) {
      return sectionGenerator(maps[i]);
    });
  }

  Future<List<Section>> hamMenuButtons() async {
    final db = await DatabaseImporter.open();

    var query = """
        SELECT s.*, 
               ts.translation as translation_section
        FROM section as s
        JOIN translations_sections as ts ON s.id = ts.section_id
        WHERE s.type=""" +
        SectionType.hamMenu.index.toString() +
        """ and
        ts.language_id = """ +
        globals.language.toString();

    final List<Map<String, dynamic>> maps = await db.rawQuery(query);
    return List.generate(maps.length, (i) {
      return sectionGenerator(maps[i]);
    });
  }

  Future<List<Section>> relevantSections(int id) async {
    final db = await DatabaseImporter.open();

    var query = """ 
      SELECT s.*, ts.translation as translation_section FROM relevant_sections as rs
      JOIN section as s ON rs.relevant_sections_id = s.id
      JOIN translations_sections as ts ON s.id = ts.section_id
      WHERE rs.section_id = """ +
        id.toString() +
        """
      UNION 
      SELECT s.*, ts.translation as translation_section FROM relevant_sections as rs
      JOIN section as s ON rs.section_id = s.id
      JOIN translations_sections as ts ON s.id = ts.section_id
      WHERE rs.relevant_sections_id = """ +
        id.toString() +
        """ and
        ts.language_id = """ +
        globals.language.toString();

    final List<Map<String, dynamic>> maps = await db.rawQuery(query);
    return List.generate(maps.length, (i) {
      return sectionGenerator(maps[i]);
    });
  }
}

/// Handles all database operations related to sections
class VersionHandler {
  late Database db;

  VersionHandler();

  Version versionGenerator(data) {
    return Version(
      id: data['version_number'],
    );
  }

  /// Returns all languages
  Future<Version> version() async {
    final db = await DatabaseImporter.open();

    var query = """
        SELECT *
        FROM version
        LIMIT 1
    """;

    final List<Map<String, dynamic>> maps = await db.rawQuery(query);
    return versionGenerator(maps[0]);
  }
}

/// A class for all database operations for the main page

class MainPageHandler {
  late Database db;
  MainPageHandler();

  Future<List> mainPage() async {
    // get a reference to the database
    final db = await DatabaseImporter.open();

    var query = """ 
    SELECT * FROM main_page
    
    """;
    final List<Map<String, dynamic>> maps = await db.rawQuery(query);

    if (maps.isEmpty) {
      throw DatabaseRecordNotFound("The main page is empty!");
    }

    return maps;
  }
}
