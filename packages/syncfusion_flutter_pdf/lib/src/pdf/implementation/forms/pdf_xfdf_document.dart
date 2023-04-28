import 'dart:convert';

import 'package:xml/xml.dart';

import '../../interfaces/pdf_interface.dart';
import '../io/pdf_constants.dart';
import '../primitives/pdf_array.dart';
import '../primitives/pdf_string.dart';

/// internal class
class XFdfDocument {
  /// internal constructor
  XFdfDocument(String filename) {
    _pdfFilePath = filename;
  }

  //Fields
  String? _pdfFilePath;
  final Map<Object, Object> _table = <Object, Object>{};

  //Implementation
  /// internal method
  void setFields(Object fieldName, Object fieldvalue) {
    _table[fieldName] = fieldvalue;
  }

  /// internal method
  List<int> save() {
    List<int> xmlData;
    final XmlBuilder builder = XmlBuilder();
    builder.processing('xml', 'version="1.0" encoding="utf-8"');
    builder.element(PdfDictionaryProperties.xfdf.toLowerCase(), nest: () {
      builder.attribute('xmlns', 'http://ns.adobe.com/xfdf/');
      builder.attribute('xml:space', 'preserve');
      builder.element(PdfDictionaryProperties.fields.toLowerCase(),
          nest: _writeFormData());
      builder.element('f', nest: () {
        // ignore: unnecessary_null_checks
        builder.attribute('href', _pdfFilePath!);
      });
    });
    xmlData = utf8.encode(builder.buildDocument().toXmlString(pretty: true));
    return xmlData;
  }

  List<XmlElement> _writeFormData() {
    final List<XmlElement> elements = <XmlElement>[];
    _table.forEach((Object key, Object value) {
      final XmlElement xmlElement =
          XmlElement(XmlName(PdfDictionaryProperties.field.toLowerCase()));
      xmlElement.attributes.add(XmlAttribute(
          XmlName(PdfDictionaryProperties.name.toLowerCase()), key.toString()));
      if (value is PdfArray) {
        for (final IPdfPrimitive? str in value.elements) {
          if (str is PdfString) {
            xmlElement.children.add(XmlElement(
                XmlName(PdfDictionaryProperties.value.toLowerCase()),
                <XmlAttribute>[],
                <XmlNode>[XmlText(str.value.toString())]));
          }
        }
      } else {
        xmlElement.children.add(XmlElement(
            XmlName(PdfDictionaryProperties.value.toLowerCase()),
            <XmlAttribute>[],
            <XmlNode>[XmlText(value.toString())]));
      }
      elements.add(xmlElement);
    });
    return elements;
  }
}
