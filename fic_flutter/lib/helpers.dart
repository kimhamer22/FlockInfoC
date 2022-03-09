import 'package:fic_flutter/db_handle.dart';

class Helpers {
  SectionHandler sh = SectionHandler();
  LanguageHandler lh = LanguageHandler();

  getSection(int id) async {
    return await sh.section(id);
  }

  getRelevantSections(int id) async {
    return await sh.relevantSections(id);
  }

  getChildren(int id) async {
    return await sh.childSections(id);
  }

  getSpecies() async {
    return await sh.animalCategories();
  }

  getLanguages() async {
    return await lh.languages();
  }
}
