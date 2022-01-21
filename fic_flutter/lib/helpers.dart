import 'package:fic_flutter/db_handle.dart';

class Helpers {
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
}
