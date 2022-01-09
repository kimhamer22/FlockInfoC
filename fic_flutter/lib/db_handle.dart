import 'dart:async';
import 'dart:typed_data';
import 'package:fic_flutter/enums/sections/section_type.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'exceptions/DatabaseRecordNotFound.dart';

final database = openDatabase('flock-controll.sqlite');

class AssociatedImage {
  final int id;
  final int section_id;
  final Uint8List image;

  AssociatedImage({
    required this.id,
    required this.section_id,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'section_id': section_id,
      'image': image,
    };
  }

}

class Language {
  final int id;
  final String name;
  final Uint8List icon;

  Language({
    required this.id,
    required this.name,
    required this.icon,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
    };
  }

}
class Section {
  final int id;
  final int? type;
  final String? translation_section;
  final String? translation_data;
  final String? parent;

  Section({
    required this.id,
    this.type = 2,

    // only used for retrieval not population
    this.translation_section = "",
    this.translation_data = "",
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
    return 'Section{ID: $id, TITLE: $translation_section, PARENT: $parent, DATA: $translation_data, TYPE: $type}';
  }
}

class SectionParent {
  final int section_id;
  final int parent_section_id;

  SectionParent({
    required this.section_id,
    required this.parent_section_id,
  });

  Map<String, dynamic> toMap() {
    return {
      'section_id': section_id,
      'parent_section_id': parent_section_id,
    };
  }

  @override
  String toString() {
    return 'Child - $section_id, parent - $parent_section_id';
  }
}


class TranslationsData {
  final int id;
  final int language_id;
  final int section_id;
  final String translation;

  TranslationsData({
    required this.id,
    required this.language_id,
    required this.section_id,
    required this.translation,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'language_id': language_id,
      'section_id': section_id,
      'translation': translation,
    };
  }

}

class TranslationsSection {
  final int id;
  final int language_id;
  final int section_id;
  final String translation;

  TranslationsSection({
    required this.id,
    required this.language_id,
    required this.section_id,
    required this.translation,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'language_id': language_id,
      'section_id': section_id,
      'translation': translation,
    };
  }

}

class DatabaseImporter
{
  static Future open() async {
    // Construct the path to the app's writable database file:
    var dbDir = await getDatabasesPath();
    var dbPath = join(dbDir, "db.sqlite");

    // Delete any existing database:
    // KEEP FOR DEVELOPMENT so database is updated
    // COMMENT OUT when on production
    await deleteDatabase(dbPath);

    var exists = await databaseExists(dbPath);

    if (!exists) {
      ByteData data = await rootBundle.load(
          "assets/database/flock-control.sqlite");
      List<int> bytes = data.buffer.asUint8List(
          data.offsetInBytes, data.lengthInBytes);
      await File(dbPath).writeAsBytes(bytes);
    }
    var db = openDatabase(dbPath, readOnly: true);

    return db;
  }
}


/// Handles all database operations related to sections
class SectionHandler
{
  late Database db;
  SectionHandler();

  /// Returns all animal categories (by filtering out section type 0)
  Future<List<Section>> animalCategories() async
  {
    final db = await DatabaseImporter.open();

    var query = """
        SELECT s.*, 
               ts.translation as translation_section
        FROM section as s
        JOIN translations_sections as ts ON s.id = ts.section_id
        WHERE s.type=""" + SectionType.speciesCategory.index.toString() + """ and
        ts.language_id = 1
    """;

    final List<Map<String, dynamic>> maps = await db.rawQuery(query);
    return List.generate(maps.length, (i) {
      return Section(
        id: maps[i]['id'],
        type: maps[i]['type'],
        translation_data: maps[i]['translation_data'],
        translation_section: maps[i]['translation_section'],
        parent: maps[i]['parent'],
      );
    });
  }


  /// Returns child sections provided parent section id
  Future<List<Section>> childSections(int parentId) async
  {
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
        WHERE sp.parent_section_id=""" + parentId.toString() + """ and
        ts.language_id = 1
    """;

    final List<Map<String, dynamic>> maps = await db.rawQuery(query);
    return List.generate(maps.length, (i) {
      return Section(
        id: maps[i]['id'],
        type: maps[i]['type'],
        translation_data: maps[i]['translation_data'],
        translation_section: maps[i]['translation_section'],
        parent: maps[i]['parent'],
      );
    });
  }

  /// Returns all the information about current section given its id
  /// Throws DatabaseRecordNotFound if record is not found
  Future<Section> section(int id) async {

    final db = await DatabaseImporter.open();

    // final List<Map<String, dynamic>> maps = await db.query('section');
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
        WHERE s.id =""" + id.toString() + """ and
        ts.language_id = 1
        LIMIT 1
    """;
    final List<Map<String, dynamic>> maps = await db.rawQuery(query);
    if (maps.length != 1)
    {
      throw DatabaseRecordNotFound("The section with this id does not exist!");
    }

    return Section(
      id: maps[0]['id'],
      type: maps[0]['type'],
      translation_data: maps[0]['translation_data'],
      translation_section: maps[0]['translation_section'],
      parent: maps[0]['parent'],
    );
  }

}


