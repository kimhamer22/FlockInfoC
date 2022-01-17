import 'package:fic_flutter/db_handle.dart';

class Helpers {
  getSection(int id) async {
    SectionHandler sh = SectionHandler();
    return await sh.section(id);
  }
}
