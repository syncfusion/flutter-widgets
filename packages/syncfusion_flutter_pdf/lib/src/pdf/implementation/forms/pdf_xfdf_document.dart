part of pdf;

class _XFdfDocument {
  //Constructor
  _XFdfDocument(String filename) {
    _pdfFilePath = filename;
  }

  //Fields
  String? _pdfFilePath;
  final Map<Object, Object> _table = <Object, Object>{};

  //Implementation
  void _setFields(Object fieldName, Object fieldvalue) {
    _table[fieldName] = fieldvalue;
  }

  List<int> _save() {
    List<int> xmlData;
    final XmlBuilder builder = XmlBuilder();
    builder.processing('xml', 'version="1.0" encoding="utf-8"');
    builder.element(_DictionaryProperties.xfdf.toLowerCase(), nest: () {
      builder.attribute('xmlns', 'http://ns.adobe.com/xfdf/');
      builder.attribute('xml:space', 'preserve');
      builder.element(_DictionaryProperties.fields.toLowerCase(),
          nest: _writeFormData());
      builder.element('f', nest: () {
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
          XmlElement(XmlName(_DictionaryProperties.field.toLowerCase()));
      xmlElement.attributes.add(XmlAttribute(
          XmlName(_DictionaryProperties.name.toLowerCase()), key.toString()));
      if (value is _PdfArray) {
        for (final _IPdfPrimitive? str in value._elements) {
          if (str is _PdfString) {
            xmlElement.children.add(XmlElement(
                XmlName(_DictionaryProperties.value.toLowerCase()),
                <XmlAttribute>[],
                <XmlNode>[XmlText(str.value.toString())]));
          }
        }
      } else {
        xmlElement.children.add(XmlElement(
            XmlName(_DictionaryProperties.value.toLowerCase()),
            <XmlAttribute>[],
            <XmlNode>[XmlText(value.toString())]));
      }
      elements.add(xmlElement);
    });
    return elements;
  }
}
