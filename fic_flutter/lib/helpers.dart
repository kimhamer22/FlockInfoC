import 'package:fic_flutter/db_handle.dart';

class Helpers {
  VersionHandler vh = VersionHandler();
  SectionHandler sh = SectionHandler();
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
}
