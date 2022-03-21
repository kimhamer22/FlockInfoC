import 'package:fic_flutter/db_handle.dart';

class Helpers {
  VersionHandler vh = VersionHandler();
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

  getDBVersion() async {
    return await vh.version();
  }

  getLanguages() async {
    return await lh.languages();
  }

  getMainPageSections() async {
    return await sh.mainPageButtons();
  }

  getHamMenuSections() async {
    return await sh.hamMenuButtons();
  }
}
