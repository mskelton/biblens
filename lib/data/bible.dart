import 'package:flutter/services.dart';
import 'package:xml/xml.dart';

Future<XmlDocument> loadBible() async {
  var text = await rootBundle.loadString('assets/translations/ESV.xml');

  return XmlDocument.parse(text);
}
