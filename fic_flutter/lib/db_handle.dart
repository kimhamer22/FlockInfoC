import 'dart:async';

import 'package:flutter/widgets.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class AssociatedImage {
  final int id;
  final int section_id
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
  final String name
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
  final int? expandable_child;
  final int? is_tab;

  Section({
    required this.id,
    this.expandable_child = 0,
    this.is_tab = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'expandable_child': expandable_child,
      'is_tab': is_tab,
    };
  }

  @override
  String toString() {
    return 'Section{id: $id, name: $expandable_child, age: $is_tab}';
  }
}

class SectionParent {
  final int section_id;
  final ind parent_section_id;

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