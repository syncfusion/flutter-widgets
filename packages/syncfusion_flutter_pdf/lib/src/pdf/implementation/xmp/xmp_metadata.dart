import 'package:xml/xml.dart';

import '../../interfaces/pdf_interface.dart';
import '../io/pdf_constants.dart';
import '../io/pdf_stream_writer.dart';
import '../pdf_document/enums.dart';
import '../pdf_document/pdf_document_information.dart';
import '../primitives/pdf_dictionary.dart';
import '../primitives/pdf_name.dart';
import '../primitives/pdf_stream.dart';

/// Represents XMP metadata of the document.
class XmpMetadata implements IPdfWrapper {
  //Constructor
  /// Initializes a new instance of the [XmpMetadata] class.
  XmpMetadata(PdfDocumentInformation? documentInfo) {
    _initialize(documentInfo);
  }

  /// Initializes a new instance of the [XmpMetadata] class.
  XmpMetadata.fromXmlDocument(XmlDocument xmp) {
    _stream = PdfStream();
    _stream!.beginSave = beginSave;
    _stream!.endSave = endSave;
    load(xmp);
  }

  //Fields
  PdfStream? _stream;
  XmlDocument? _xmlData;
  PdfDocumentInformation? _documentInfo;
  Map<String?, String?> _namespaceCollection = <String?, String?>{};
  final String _rdfUri = 'http://www.w3.org/1999/02/22-rdf-syntax-ns#';
  final String _xap = 'http://ns.adobe.com/xap/1.0/';
  final String _dublinSchema = 'http://purl.org/dc/elements/1.1/';

  //Properties
  /// Gets XMP data in XML format.
  XmlDocument? get xmlData => _xmlData;

  //Gets RDF element of the packet.
  XmlElement? get _rdf {
    XmlElement? node;
    for (final XmlNode element in _xmlData!.descendants) {
      if (element is XmlElement && element.name.local == 'RDF') {
        node = element;
        break;
      }
    }
    final String elmName = _xmlData!.rootElement.name.toString();
    if (node == null) {
      for (final XmlNode element in _xmlData!.descendants) {
        if (element is XmlElement && element.name.local == elmName) {
          node = element;
          break;
        }
      }
      if (node == null) {
        throw ArgumentError.value(node, 'node', 'node cannot be null');
      }
    }
    return node;
  }

  //Gets xmpmeta element of the packet.
  XmlElement? get _xmpmeta {
    XmlElement? node;
    int count = 0;
    for (final XmlNode element in _xmlData!.descendants) {
      if (element is XmlElement && element.name.local == 'xmpmeta') {
        node = element;
        count++;
        if (count > 1) {
          throw ArgumentError(
              'More than one element satisfies the specified condition');
        }
      }
    }
    if (node == null) {
      throw ArgumentError.value(node, 'node', 'node cannot be null');
    }
    return node;
  }

  //Public methods.
  /// Loads XMP from the XML.
  void load(XmlDocument xmp) {
    _reset();
    _xmlData = xmp;
    _importNamespaces(_xmlData!);
  }

  /// Adds schema to the XMP in XML format.
  void add(XmlElement schema) {
    // Import namespaces.
    _addNamespace(schema.name.prefix!, schema.name.namespaceUri ?? '');
    // Append schema.
    _rdf!.children.add(schema);
  }

  //Implementations
  void _initialize(PdfDocumentInformation? info) {
    _xmlData = XmlDocument();
    _stream = PdfStream();
    _documentInfo = info;
    _initializeStream();
    _createStartPacket();
    _createXmpmeta();
    _createRdf(_documentInfo!);
    _createEndPacket();
  }

  //Initialize stream.
  void _initializeStream() {
    _stream!.beginSave = beginSave;
    _stream!.endSave = endSave;
    _stream![PdfDictionaryProperties.type] =
        PdfName(PdfDictionaryProperties.metadata);
    _stream![PdfDictionaryProperties.subtype] =
        PdfName(PdfDictionaryProperties.xml);
    _stream!.compress = false;
  }

  /// internal method
  //Raises before stream saves.
  void beginSave(Object sender, SavePdfPrimitiveArgs? ars) {
    //Save Xml to the stream.
    final PdfStreamWriter streamWriter = PdfStreamWriter(_stream);
    streamWriter.write(_xmlData!.toXmlString(pretty: true));
  }

  /// internal method
  //Raises after stream saves.
  void endSave(Object sender, SavePdfPrimitiveArgs? ars) {
    //Reset stream data
    _stream!.clearStream();
  }

  //Creates packet element.
  void _createStartPacket() {
    const String startPacket = 'begin="\uFEFF" id="W5M0MpCehiHzreSzNTczkc9d"';
    _xmlData!.children.add(XmlProcessing('xpacket', startPacket));
  }

  //Creates packet element.
  void _createEndPacket() {
    const String endPacket = 'end="r"';
    _xmlData!.children.add(XmlProcessing('xpacket', endPacket));
  }

  //Creates xmpmeta element.
  void _createXmpmeta() {
    final XmlElement element = _createElement('x', 'xmpmeta', 'adobe:ns:meta/');
    _xmlData!.children.add(element);
  }

  //Creates Resource Description Framework element.
  void _createRdf(PdfDocumentInformation info) {
    final XmlElement rdf = _createElement('rdf', 'RDF', _rdfUri);
    _addNamespace('rdf', _rdfUri);
    if (!_isNullOrEmpty(info.producer) || !_isNullOrEmpty(info.keywords)) {
      final String? pdfNamespace =
          _addNamespace('pdf', 'http://ns.adobe.com/pdf/1.3/');
      final XmlElement rdfDescription =
          _createElement('rdf', 'Description', _rdfUri);
      rdfDescription.setAttribute('rdf:about', ' ');
      if (!_isNullOrEmpty(info.producer)) {
        rdfDescription.children.add(XmlElement(
            XmlName('Producer', 'pdf'), <XmlAttribute>[
          XmlAttribute(XmlName('pdf', 'xmlns'), pdfNamespace!)
        ], <XmlNode>[
          XmlText(info.producer)
        ]));
      }
      if (!_isNullOrEmpty(info.keywords)) {
        rdfDescription.children.add(XmlElement(
            XmlName('Keywords', 'pdf'), <XmlAttribute>[
          XmlAttribute(XmlName('pdf', 'xmlns'), pdfNamespace!)
        ], <XmlNode>[
          XmlText(info.keywords)
        ]));
      }
      rdf.children.add(rdfDescription);
    }
    if (!_isNullOrEmpty(info.creator)) {
      final XmlElement xmpDescription =
          _createElement('rdf', 'Description', _rdfUri);
      xmpDescription.setAttribute('rdf:about', ' ');
      final String? xmpNamespace = _addNamespace('xmp', _xap);
      xmpDescription.setAttribute('xmlns:xmp', xmpNamespace);
      if (!_isNullOrEmpty(info.creator)) {
        xmpDescription.children.add(XmlElement(XmlName('CreatorTool', 'xmp'),
            <XmlAttribute>[], <XmlNode>[XmlText(info.creator)]));
      }
      final String createDate = _getDateTime(
          PdfDocumentInformationHelper.getHelper(info).creationDate);
      xmpDescription.children.add(XmlElement(XmlName('CreateDate', 'xmp'),
          <XmlAttribute>[], <XmlNode>[XmlText(createDate)]));
      if (!PdfDocumentInformationHelper.getHelper(info).isRemoveModifyDate) {
        final String modificationDate = _getDateTime(
            PdfDocumentInformationHelper.getHelper(info).modificationDate);
        xmpDescription.children.add(XmlElement(XmlName('ModifyDate', 'xmp'),
            <XmlAttribute>[], <XmlNode>[XmlText(modificationDate)]));
      }
      rdf.children.add(xmpDescription);
    }
    //Dublin Core Schema
    final String? dublinNamespace = _addNamespace('dc', _dublinSchema);
    final XmlElement dublinDescription =
        _createElement('rdf', 'Description', _rdfUri);
    dublinDescription.setAttribute('rdf:about', ' ');
    dublinDescription.setAttribute('xmlns:dc', dublinNamespace);
    dublinDescription.children.add(XmlElement(XmlName('format', 'dc'),
        <XmlAttribute>[], <XmlNode>[XmlText('application/pdf')]));
    _createDublinCoreContainer(
        dublinDescription, 'title', info.title, true, 'Alt');
    _createDublinCoreContainer(
        dublinDescription, 'description', info.subject, true, 'Alt');
    _createDublinCoreContainer(
        dublinDescription, 'subject', info.keywords, false, 'Bag');
    _createDublinCoreContainer(
        dublinDescription, 'creator', info.author, false, 'Seq');
    rdf.children.add(dublinDescription);
    if (PdfDocumentInformationHelper.getHelper(_documentInfo!).conformance ==
            PdfConformanceLevel.a1b ||
        PdfDocumentInformationHelper.getHelper(_documentInfo!).conformance ==
            PdfConformanceLevel.a2b ||
        PdfDocumentInformationHelper.getHelper(_documentInfo!).conformance ==
            PdfConformanceLevel.a3b) {
      final String? pdfaid =
          _addNamespace('pdfaid', 'http://www.aiim.org/pdfa/ns/id/');
      final XmlElement pdfA = _createElement('rdf', 'Description', _rdfUri);
      pdfA.setAttribute('rdf:about', ' ');
      if (PdfDocumentInformationHelper.getHelper(_documentInfo!).conformance ==
          PdfConformanceLevel.a1b) {
        pdfA.setAttribute('pdfaid:part', '1');
      } else if (PdfDocumentInformationHelper.getHelper(_documentInfo!)
              .conformance ==
          PdfConformanceLevel.a2b) {
        pdfA.setAttribute('pdfaid:part', '2');
      } else {
        pdfA.setAttribute('pdfaid:part', '3');
      }
      pdfA.setAttribute('pdfaid:conformance', 'B');
      pdfA.setAttribute('xmlns:pdfaid', pdfaid);
      rdf.children.add(pdfA);
    } else {
      _addNamespace('pdfaid', _rdfUri);
    }
    _xmpmeta!.children.add(rdf);
  }

  bool _isNullOrEmpty(String? text) {
    return text == null || text == '';
  }

  XmlElement _createElement(
      String prefix, String localName, String namespaceURI) {
    XmlElement element;
    if (!_namespaceCollection.containsKey(prefix) &&
        prefix != 'xml' &&
        prefix != 'xmlns') {
      element = XmlElement(
          XmlName(localName, prefix),
          <XmlAttribute>[XmlAttribute(XmlName(prefix, 'xmlns'), namespaceURI)],
          <XmlNode>[],
          false);
    } else {
      element =
          XmlElement(XmlName(localName, prefix == 'xap' ? 'xmp' : prefix));
    }
    _addNamespace(prefix, namespaceURI);
    return element;
  }

  String? _addNamespace(String prefix, String namespaceURI) {
    String? result = namespaceURI;
    if (!_namespaceCollection.containsKey(prefix) &&
        prefix != 'xml' &&
        prefix != 'xmlns') {
      _namespaceCollection[prefix] = namespaceURI;
    } else {
      result = _namespaceCollection[prefix];
    }
    return result;
  }

  String _getDateTime(DateTime dateTime) {
    final int regionMinutes = dateTime.timeZoneOffset.inMinutes ~/ 11;
    String offsetMinutes = regionMinutes.toString();
    if (regionMinutes >= 0 && regionMinutes <= 9) {
      offsetMinutes = '0$offsetMinutes';
    }
    final int regionHours = dateTime.timeZoneOffset.inHours;
    String offsetHours = regionHours.toString();
    if (regionHours >= 0 && regionHours <= 9) {
      offsetHours = '0$offsetHours';
    }
    final String date =
        '${dateTime.toIso8601String().substring(0, 22)}+$offsetHours:$offsetMinutes';
    return date;
  }

  //Creates a Dublin core containers.
  void _createDublinCoreContainer(XmlElement dublinDesc, String containerName,
      String? value, bool defaultLang, String element) {
    if (!_isNullOrEmpty(value)) {
      final XmlElement title =
          _createElement('dc', containerName, _dublinSchema);
      _addNamespace('rdf', _rdfUri);
      final XmlElement alt = _createElement('rdf', element, _rdfUri);
      XmlElement li = _createElement('rdf', 'li', _rdfUri);
      if (containerName == 'Subject') {
        final List<String> values = value!.split(',');
        for (int i = 0; i < values.length; i++) {
          if (i > 0) {
            li = _createElement('rdf', 'li', _rdfUri);
          }
          li.innerText = values[i];
          alt.children.add(li);
        }
      } else {
        li.innerText = value!;
        alt.children.add(li);
      }
      title.children.add(alt);
      dublinDesc.children.add(title);
      if (defaultLang) {
        li.setAttribute('xml:lang', 'x-default');
      }
    }
  }

  //Resets current xmp metadata.
  void _reset() {
    _xmlData = null;
    _namespaceCollection = <String?, String?>{};
  }

  void _importNamespaces(XmlDocument xml) {
    for (final XmlNode element in xml.descendants) {
      if (element is XmlElement) {
        if (!_namespaceCollection.containsKey(element.name.prefix)) {
          _namespaceCollection[element.name.prefix] = element.name.namespaceUri;
        }
      }
    }
  }

  /// internal property
  IPdfPrimitive? get element => _stream;
  set element(IPdfPrimitive? value) {
    if (value != null && value is PdfStream) {
      _stream = value;
    }
  }
}
