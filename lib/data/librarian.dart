import 'bible_data.dart';

class Librarian {
  static String? getParatextFromOsis(String osisBook) {
    return BibleData.osisToParatext[osisBook];
  }
}
