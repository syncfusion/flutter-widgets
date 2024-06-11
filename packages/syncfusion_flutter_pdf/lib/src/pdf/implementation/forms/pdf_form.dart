import 'dart:collection';
import 'dart:convert';

import 'package:xml/xml.dart';

import '../../interfaces/pdf_interface.dart';
import '../annotations/pdf_annotation_collection.dart';
import '../graphics/pdf_resources.dart';
import '../io/pdf_constants.dart';
import '../io/pdf_cross_table.dart';
import '../io/pdf_reader.dart';
import '../pages/pdf_page.dart';
import '../pdf_document/pdf_catalog.dart';
import '../pdf_document/pdf_document.dart';
import '../primitives/pdf_array.dart';
import '../primitives/pdf_boolean.dart';
import '../primitives/pdf_dictionary.dart';
import '../primitives/pdf_name.dart';
import '../primitives/pdf_null.dart';
import '../primitives/pdf_number.dart';
import '../primitives/pdf_reference.dart';
import '../primitives/pdf_reference_holder.dart';
import '../primitives/pdf_string.dart';
import 'enum.dart';
import 'pdf_check_box_field.dart';
import 'pdf_combo_box_field.dart';
import 'pdf_field.dart';
import 'pdf_form_field_collection.dart';
import 'pdf_list_box_field.dart';
import 'pdf_radio_button_list_field.dart';
import 'pdf_signature_field.dart';
import 'pdf_xfdf_document.dart';

/// Represents interactive form of the PDF document.
class PdfForm implements IPdfWrapper {
  //Constructors
  /// Initializes a new instance of the [PdfForm] class.
  PdfForm() : super() {
    _helper = PdfFormHelper(this);
    _helper._fields = PdfFormFieldCollectionHelper.getCollection();
    PdfFormFieldCollectionHelper.getHelper(_helper._fields!).form = this;
    _helper.dictionary!
        .setProperty(PdfDictionaryProperties.fields, _helper._fields);
    if (!_helper.isLoadedForm) {
      _helper.dictionary!.beginSave = _helper.beginSave;
    }
    _helper.setAppearanceDictionary = true;
  }

  PdfForm._internal(PdfCrossTable? crossTable,
      [PdfDictionary? formDictionary]) {
    _helper = PdfFormHelper(this);
    _helper.isLoadedForm = true;
    _helper.crossTable = crossTable;
    _helper.dictionary!.setBoolean(
        PdfDictionaryProperties.needAppearances, _helper.needAppearances);
    PdfDocumentHelper.getHelper(_helper.crossTable!.document!)
        .catalog
        .beginSaveList ??= <SavePdfPrimitiveCallback>[];
    PdfDocumentHelper.getHelper(_helper.crossTable!.document!)
        .catalog
        .beginSaveList!
        .add(_helper.beginSave);
    PdfDocumentHelper.getHelper(_helper.crossTable!.document!).catalog.modify();
    if (PdfDocumentHelper.getHelper(_helper.crossTable!.document!)
        .catalog
        .containsKey(PdfDictionaryProperties.perms)) {
      _checkPerms(
          PdfDocumentHelper.getHelper(_helper.crossTable!.document!).catalog);
    }
    if (formDictionary != null) {
      _initialize(formDictionary, crossTable!);
    }
  }

  //Fields
  late PdfFormHelper _helper;
  bool _readOnly = false;

  /// Gets or sets a value indicating whether field auto naming.
  ///
  /// The default value is true.
  bool fieldAutoNaming = true;

  /// Gets or sets the ExportEmptyFields property, enabling this will export
  /// the empty acroform fields.
  ///
  /// The default value is false.
  bool exportEmptyFields = false;

  //Properties

  /// Gets the fields collection.
  PdfFormFieldCollection get fields {
    if (_helper.isLoadedForm) {
      _helper._fields ??= PdfFormFieldCollectionHelper.getCollection(this);
    }
    return _helper._fields!;
  }

  /// Gets or sets a value indicating whether the form is read only.
  ///
  /// The default value is false.
  bool get readOnly => _readOnly;
  set readOnly(bool value) {
    _readOnly = value;
    if (_helper.isLoadedForm) {
      for (int i = 0; i < fields.count; i++) {
        fields[i].readOnly = value;
      }
    }
  }

  //Public methods.
  /// Specifies whether to set the default appearance for the form or not.
  void setDefaultAppearance(bool value) {
    _helper.needAppearances = value;
    _helper.setAppearanceDictionary = !value;
    _helper._isDefaultAppearance = value;
  }

  /// Flatten all the fields available in the form.
  ///
  /// The flatten will add at the time of saving the current document.
  void flattenAllFields() {
    _helper.flatten = true;
  }

  /// Imports form value from base 64 string to the file with the specific [DataFormat].
  void importDataFromBase64String(String base64String, DataFormat dataFormat,
      [bool continueImportOnError = false]) {
    importData(base64.decode(base64String).toList(), dataFormat,
        continueImportOnError);
  }

  /// Imports form value to the file with the specific [DataFormat].
  void importData(List<int> inputBytes, DataFormat dataFormat,
      [bool continueImportOnError = false]) {
    if (dataFormat == DataFormat.fdf) {
      _importDataFDF(inputBytes, continueImportOnError);
    } else if (dataFormat == DataFormat.json) {
      _importDataJSON(inputBytes, continueImportOnError);
    } else if (dataFormat == DataFormat.xfdf) {
      _importDataXFDF(inputBytes);
    } else if (dataFormat == DataFormat.xml) {
      _importDataXml(inputBytes, continueImportOnError);
    }
  }

  /// Export the form data to a file with the specific [DataFormat] and form name.
  List<int> exportData(DataFormat dataFormat, [String formName = '']) {
    List<int>? data;
    if (dataFormat == DataFormat.fdf) {
      data = _exportDataFDF(formName);
    } else if (dataFormat == DataFormat.xfdf) {
      data = _exportDataXFDF(formName);
    } else if (dataFormat == DataFormat.json) {
      data = _exportDataJSON();
    } else if (dataFormat == DataFormat.xml) {
      data = _exportDataXML();
    }
    return data!;
  }

  /// Imports XFDF Data from the given data.
  void _importDataXFDF(List<int> bytes) {
    final String data = utf8.decode(bytes);
    final XmlDocument xmlDoc = XmlDocument.parse(data);
    PdfField formField;
    for (final XmlNode node in xmlDoc.rootElement.firstElementChild!.children) {
      if (node is XmlElement) {
        final String fieldName = node.attributes.first.value;
        final int index = PdfFormFieldCollectionHelper.getHelper(fields)
            .getFieldIndex(fieldName);
        if (index >= 0 && index < fields.count) {
          formField = fields[index];
          String? fieldInnerValue;
          final List<String> fieldInnerValues = <String>[];
          if (node.childElements.length > 1) {
            for (int i = 0; i < node.childElements.length; i++) {
              fieldInnerValues.add(node.childElements.elementAt(i).innerText);
            }
          } else {
            fieldInnerValue = node.firstElementChild!.innerText;
          }
          if (fieldInnerValues.isNotEmpty) {
            PdfFieldHelper.getHelper(formField)
                .importFieldValue(fieldInnerValues);
          } else if (fieldInnerValue != null) {
            PdfFieldHelper.getHelper(formField)
                .importFieldValue(fieldInnerValue);
          }
        }
      }
    }
  }

  //Implementation

  void _initialize(PdfDictionary formDictionary, PdfCrossTable crossTable) {
    _helper.dictionary = formDictionary;
    //Get terminal fields.
    _createFields();
    //Gets NeedAppearance
    if (_helper.dictionary!
        .containsKey(PdfDictionaryProperties.needAppearances)) {
      final PdfBoolean needAppearance = crossTable.getObject(
              _helper.dictionary![PdfDictionaryProperties.needAppearances])!
          as PdfBoolean;
      _helper.needAppearances = needAppearance.value;
      _helper.setAppearanceDictionary = true;
    } else {
      _helper.setAppearanceDictionary = false;
    }
    //Gets resource dictionary
    if (_helper.dictionary!.containsKey(PdfDictionaryProperties.dr)) {
      final IPdfPrimitive? resourceDictionary = PdfCrossTable.dereference(
          _helper.dictionary![PdfDictionaryProperties.dr]);
      if (resourceDictionary != null && resourceDictionary is PdfDictionary) {
        _helper.resources = PdfResources(resourceDictionary);
      }
    }
  }

  //Retrieves the terminal fields.
  void _createFields() {
    PdfArray? fields;
    if (_helper.dictionary!.containsKey(PdfDictionaryProperties.fields)) {
      final IPdfPrimitive? obj = _helper.crossTable!
          .getObject(_helper.dictionary![PdfDictionaryProperties.fields]);
      if (obj != null) {
        fields = obj as PdfArray;
      }
    }
    int count = 0;
    final Queue<_NodeInfo> nodes = Queue<_NodeInfo>();
    while (true && fields != null) {
      for (; count < fields!.count; ++count) {
        final IPdfPrimitive? fieldDictionary =
            _helper.crossTable!.getObject(fields[count]);
        PdfArray? fieldKids;
        if (fieldDictionary != null &&
            fieldDictionary is PdfDictionary &&
            fieldDictionary.containsKey(PdfDictionaryProperties.kids)) {
          final IPdfPrimitive? fieldKid = _helper.crossTable!
              .getObject(fieldDictionary[PdfDictionaryProperties.kids]);
          if (fieldKid != null && fieldKid is PdfArray) {
            fieldKids = fieldKid;
            for (int i = 0; i < fieldKids.count; i++) {
              final IPdfPrimitive? kidsDict =
                  PdfCrossTable.dereference(fieldKids[i]);
              if (kidsDict != null &&
                  kidsDict is PdfDictionary &&
                  !kidsDict.containsKey(PdfDictionaryProperties.parent)) {
                kidsDict[PdfDictionaryProperties.parent] =
                    PdfReferenceHolder(fieldDictionary);
              }
            }
          }
        }
        if (fieldKids == null) {
          if (fieldDictionary != null) {
            if (!_helper.terminalFields.contains(fieldDictionary)) {
              _helper.terminalFields.add(fieldDictionary as PdfDictionary);
            }
          }
        } else {
          if (!(fieldDictionary! as PdfDictionary)
                  .containsKey(PdfDictionaryProperties.ft) ||
              _isNode(fieldKids)) {
            nodes.addFirst(_NodeInfo(fields, count));
            _helper.formHasKids = true;
            count = -1;
            fields = fieldKids;
          } else {
            _helper.terminalFields.add(fieldDictionary as PdfDictionary);
          }
        }
      }
      if (nodes.isEmpty) {
        break;
      }
      final _NodeInfo nInfo = nodes.elementAt(0);
      nodes.removeFirst();
      fields = nInfo._fields;
      count = nInfo._count + 1;
    }
  }

  //Determines whether the specified kids is node.
  bool _isNode(PdfArray kids) {
    bool isNode = false;
    if (kids.count >= 1) {
      final PdfDictionary dictionary =
          _helper.crossTable!.getObject(kids[0])! as PdfDictionary;
      if (dictionary.containsKey(PdfDictionaryProperties.subtype)) {
        final PdfName name = _helper.crossTable!
            .getObject(dictionary[PdfDictionaryProperties.subtype])! as PdfName;
        if (name.name != PdfDictionaryProperties.widget) {
          isNode = true;
        }
      }
    }
    return isNode;
  }

  void _checkPerms(PdfCatalog catalog) {
    IPdfPrimitive? permission = catalog[PdfDictionaryProperties.perms];
    if (permission is PdfReferenceHolder) {
      permission =
          (catalog[PdfDictionaryProperties.perms]! as PdfReferenceHolder)
              .object;
    }
    if (permission != null &&
        permission is PdfDictionary &&
        permission.containsKey('UR3')) {
      _helper.isUR3 = true;
    }
  }

  /// Imports form value from FDF file.
  void _importDataFDF(List<int> inputBytes, bool continueImportOnError) {
    final PdfReader reader = PdfReader(inputBytes);
    reader.position = 0;
    String? token = reader.getNextToken();
    if (token != null && token.startsWith('%')) {
      token = reader.getNextToken();
      if (token != null && !token.startsWith('FDF-')) {
        throw ArgumentError(
            'The source is not a valid FDF file because it does not start with"%FDF-"');
      }
    }
    final Map<String, List<String>> table = <String, List<String>>{};
    String? fieldName = '';
    token = reader.getNextToken();
    while (token != null && token.isNotEmpty) {
      if (token.toUpperCase() == 'T') {
        final List<String?> out = _getFieldName(reader, token);
        fieldName = out[0];
        token = out[1];
      }
      if (token != null && token.toUpperCase() == 'V') {
        _getFieldValue(reader, token, fieldName!, table);
      }
      token = reader.getNextToken();
    }
    PdfField? field;
    table.forEach((String k, List<String> v) {
      try {
        final int index =
            PdfFormFieldCollectionHelper.getHelper(fields).getFieldIndex(k);
        if (index == -1) {
          throw ArgumentError('Incorrect field name.');
        }
        field = fields[index];
        if (field != null) {
          PdfFieldHelper.getHelper(field!).importFieldValue(v);
        }
      } catch (e) {
        if (!continueImportOnError) {
          rethrow;
        }
      }
    });
  }

  /// Export the form data in FDF file format.
  List<int> _exportDataFDF(String formName) {
    List<int> bytes = <int>[];
    final PdfString headerString = PdfString('%FDF-1.2\n')
      ..encode = ForceEncoding.ascii;
    bytes.addAll(headerString.value!.codeUnits);
    int count = 1;
    for (int i = 0; i < fields.count; i++) {
      final PdfField field = fields[i];
      final PdfFieldHelper helper = PdfFieldHelper.getHelper(field);
      helper.exportEmptyField = exportEmptyFields;
      if (field.canExport && helper.isLoadedField) {
        final Map<String, dynamic> out = helper.exportField(bytes, count);
        bytes = out['bytes'] as List<int>;
        count = out['objectID'] as int;
      }
    }
    final PdfString formNameEncodedString = PdfString(formName)
      ..encode = ForceEncoding.ascii;
    final StringBuffer buffer = StringBuffer();
    buffer.write(
        '$count 0 obj<</F <${PdfString.bytesToHex(formNameEncodedString.value!.codeUnits)}>  /Fields [');
    for (int i = 0; i < fields.count; i++) {
      final PdfField field = fields[i];
      final PdfFieldHelper helper = PdfFieldHelper.getHelper(field);
      if (helper.isLoadedField && field.canExport && helper.objID != 0) {
        buffer.write('${helper.objID} 0 R ');
      }
    }
    buffer.write(']>>endobj\n');
    buffer.write('${count + 1} 0 obj<</Version /1.4 /FDF $count 0 R>>endobj\n');
    buffer.write('trailer\n<</Root ${count + 1} 0 R>>\n');
    final PdfString fdfString = PdfString(buffer.toString())
      ..encode = ForceEncoding.ascii;
    bytes.addAll(fdfString.value!.codeUnits);
    return bytes;
  }

  List<String?> _getFieldName(PdfReader reader, String? token) {
    String? fieldname = '';
    token = reader.getNextToken();
    if (token != null && token.isNotEmpty) {
      if (token == '<') {
        token = reader.getNextToken();
        if (token != null && token.isNotEmpty && token != '>') {
          final PdfString str = PdfString('');
          final List<int> buffer = str.hexToBytes(token);
          token = PdfString.byteToString(buffer);
          fieldname = token;
        }
      } else {
        token = reader.getNextToken();
        if (token != null && token.isNotEmpty) {
          String? str = ' ';
          while (str != ')') {
            str = reader.getNextToken();
            if (str != null && str.isNotEmpty && str != ')') {
              token = '${token!} $str';
            }
          }
          fieldname = token;
          token = str;
        }
      }
    }
    return <String?>[fieldname, token];
  }

  void _getFieldValue(PdfReader reader, String? token, String fieldName,
      Map<String, List<String>> table) {
    token = reader.getNextToken();
    if (token != null && token.isNotEmpty) {
      if (token == '[') {
        token = reader.getNextToken();
        if (token != null && token.isNotEmpty) {
          final List<String> fieldValues = <String>[];
          while (token != ']') {
            token =
                _fieldValue(reader, token, true, table, fieldName, fieldValues);
          }
          if (!table.containsKey(fieldName) && fieldValues.isNotEmpty) {
            table[fieldName] = fieldValues;
          }
        }
      } else {
        _fieldValue(reader, token, false, table, fieldName, null);
      }
    }
  }

  String? _fieldValue(
      PdfReader reader,
      String? token,
      bool isMultiSelect,
      Map<String, List<String>> table,
      String fieldName,
      List<String>? fieldValues) {
    if (token == '<') {
      token = reader.getNextToken();
      if (token != null && token.isNotEmpty && token != '>') {
        final PdfString str = PdfString('');
        final List<int> buffer = str.hexToBytes(token);
        token = PdfString.byteToString(buffer);
        if (isMultiSelect && fieldValues != null) {
          fieldValues.add(token);
        } else if (!table.containsKey(fieldName)) {
          table[fieldName] = <String>[token];
        }
      }
    } else {
      if (isMultiSelect && fieldValues != null) {
        while (token != '>' && token != ')' && token != ']') {
          if (token != null &&
              token.isNotEmpty &&
              (token == '/' || token != ')')) {
            token = reader.getNextToken();
            if (token != null &&
                token.isNotEmpty &&
                token != '>' &&
                token != ')') {
              String? str = ' ';
              while (str != ')' && str != '>') {
                str = reader.getNextToken();
                if (str != null &&
                    str.isNotEmpty &&
                    str != '>' &&
                    str != ')' &&
                    str != '/') {
                  token = '${token!} $str';
                }
                fieldValues.add(token!);
              }
            }
          }
          token = reader.getNextToken();
        }
      } else {
        while (token != '>' && token != ')') {
          if (token != null &&
              token.isNotEmpty &&
              (token == '/' || token != ')')) {
            token = reader.getNextToken();
            if (token != null &&
                token.isNotEmpty &&
                token != '>' &&
                token != ')') {
              String? str = ' ';
              while (str != ')' && str != '>') {
                str = reader.getNextToken();
                if (str != null &&
                    str.isNotEmpty &&
                    str != '>' &&
                    str != ')' &&
                    str != '/') {
                  token = '${token!} $str';
                }
              }
              if (!table.containsKey(fieldName)) {
                table[fieldName] = <String>[token!];
              }
            }
          }
          token = reader.getNextToken();
        }
      }
    }
    return token;
  }

  List<int> _exportDataXFDF(String formName) {
    final XFdfDocument xfdf = XFdfDocument(formName);
    for (int i = 0; i < fields.count; i++) {
      final PdfField field = fields[i];
      final PdfFieldHelper helper = PdfFieldHelper.getHelper(field);
      if (field.canExport) {
        helper.exportEmptyField = exportEmptyFields;
        final IPdfPrimitive? name = PdfFieldHelper.getValue(helper.dictionary!,
            helper.crossTable, PdfDictionaryProperties.ft, true);
        if (name != null && name is PdfName) {
          switch (name.name) {
            case 'Tx':
              final IPdfPrimitive? fieldValue = PdfFieldHelper.getValue(
                  helper.dictionary!,
                  helper.crossTable,
                  PdfDictionaryProperties.v,
                  true);
              if (fieldValue is PdfString) {
                xfdf.setFields(field.name!, fieldValue.value!);
              } else if (exportEmptyFields) {
                xfdf.setFields(field.name!, '');
              }
              break;
            case 'Ch':
              if (field is PdfListBoxField) {
                final IPdfPrimitive? primitive = PdfFieldHelper.getValue(
                    helper.dictionary!,
                    helper.crossTable,
                    PdfDictionaryProperties.v,
                    true);
                if (primitive is PdfArray) {
                  xfdf.setFields(field.name!, primitive);
                } else if (primitive is PdfString) {
                  xfdf.setFields(field.name!, primitive.value!);
                } else if (exportEmptyFields) {
                  xfdf.setFields(field.name!, '');
                }
              } else {
                final IPdfPrimitive? listField = PdfFieldHelper.getValue(
                    helper.dictionary!,
                    helper.crossTable,
                    PdfDictionaryProperties.v,
                    true);
                if (listField is PdfName) {
                  xfdf.setFields(field.name!, listField.name!);
                } else {
                  final IPdfPrimitive? comboValue = PdfFieldHelper.getValue(
                      helper.dictionary!,
                      helper.crossTable,
                      PdfDictionaryProperties.v,
                      true);
                  if (comboValue is PdfString) {
                    xfdf.setFields(field.name!, comboValue.value!);
                  } else if (exportEmptyFields) {
                    xfdf.setFields(field.name!, '');
                  }
                }
              }
              break;
            case 'Btn':
              final IPdfPrimitive? buttonFieldPrimitive =
                  PdfFieldHelper.getValue(helper.dictionary!, helper.crossTable,
                      PdfDictionaryProperties.v, true);
              if (buttonFieldPrimitive != null) {
                final String? value =
                    helper.getExportValue(field, buttonFieldPrimitive);
                if (value != null && value.isNotEmpty) {
                  xfdf.setFields(field.name!, value);
                } else if (field is PdfRadioButtonListField ||
                    field is PdfCheckBoxField) {
                  if (exportEmptyFields) {
                    xfdf.setFields(field.name!, '');
                  } else {
                    xfdf.setFields(field.name!, PdfDictionaryProperties.off);
                  }
                }
              } else {
                if (field is PdfRadioButtonListField) {
                  xfdf.setFields(
                      field.name!, helper.getAppearanceStateValue(field));
                } else {
                  final PdfDictionary holder = helper.getWidgetAnnotation(
                    helper.dictionary!,
                    helper.crossTable,
                  );
                  final IPdfPrimitive? holderName =
                      holder[PdfDictionaryProperties.usageApplication];
                  if (holderName is PdfName) {
                    xfdf.setFields(field.name!, holderName.name!);
                  } else if (exportEmptyFields) {
                    xfdf.setFields(field.name!, '');
                  }
                }
              }
              break;
          }
        }
      }
    }
    return xfdf.save();
  }

  void _importDataJSON(List<int> bytes, bool continueImportOnError) {
    String? fieldKey, fieldValue;
    final Map<String, String> table = <String, String>{};
    final PdfReader reader = PdfReader(bytes);
    String? token = reader.getNextJsonToken();
    reader.position = 0;
    while (token != null && token.isNotEmpty) {
      if (token != '{' && token != '}' && token != '"' && token != ',') {
        fieldKey = token;
        do {
          token = reader.getNextJsonToken();
        } while (token != ':');
        do {
          token = reader.getNextJsonToken();
        } while (token != '"');
        token = reader.getNextJsonToken();
        if (token != '"') {
          fieldValue = token;
        }
      }
      if (fieldKey != null && fieldValue != null) {
        table[PdfFormHelper.decodeXMLConversion(fieldKey)] =
            PdfFormHelper.decodeXMLConversion(fieldValue);
        fieldKey = fieldValue = null;
      }
      token = reader.getNextJsonToken();
    }
    PdfField? field;
    table.forEach((String k, String v) {
      try {
        final int index =
            PdfFormFieldCollectionHelper.getHelper(fields).getFieldIndex(k);
        if (index == -1) {
          throw ArgumentError('Incorrect field name.');
        }
        field = fields[index];
        if (field != null) {
          PdfFieldHelper.getHelper(field!).importFieldValue(v);
        }
      } catch (e) {
        if (!continueImportOnError) {
          rethrow;
        }
      }
    });
  }

  List<int> _exportDataJSON() {
    final List<int> bytes = <int>[];
    final Map<String, String> table = <String, String>{};
    for (int i = 0; i < fields.count; i++) {
      final PdfField field = fields[i];
      final PdfFieldHelper helper = PdfFieldHelper.getHelper(field);
      if (helper.isLoadedField && field.canExport) {
        final IPdfPrimitive? name = PdfFieldHelper.getValue(helper.dictionary!,
            helper.crossTable, PdfDictionaryProperties.ft, true);
        if (name != null && name is PdfName) {
          switch (name.name) {
            case 'Tx':
              final IPdfPrimitive? textField = PdfFieldHelper.getValue(
                  helper.dictionary!,
                  helper.crossTable,
                  PdfDictionaryProperties.v,
                  true);
              if (textField != null && textField is PdfString) {
                table[field.name!] = textField.value!;
              }
              break;
            case 'Ch':
              if (field is PdfListBoxField || field is PdfComboBoxField) {
                final IPdfPrimitive? listValue = PdfFieldHelper.getValue(
                    helper.dictionary!,
                    helper.crossTable,
                    PdfDictionaryProperties.v,
                    true);
                if (listValue != null) {
                  final String? value = helper.getExportValue(field, listValue);
                  if (value != null && value.isNotEmpty) {
                    table[field.name!] = value;
                  }
                }
              }
              break;
            case 'Btn':
              final IPdfPrimitive? buttonFieldPrimitive =
                  PdfFieldHelper.getValue(helper.dictionary!, helper.crossTable,
                      PdfDictionaryProperties.v, true);
              if (buttonFieldPrimitive != null) {
                final String? value =
                    helper.getExportValue(field, buttonFieldPrimitive);
                if (value != null && value.isNotEmpty) {
                  table[field.name!] = value;
                } else if (field is PdfRadioButtonListField ||
                    field is PdfCheckBoxField) {
                  table[field.name!] = 'Off';
                }
              } else {
                if (field is PdfRadioButtonListField) {
                  table[field.name!] = helper.getAppearanceStateValue(field);
                } else {
                  final PdfDictionary holder = helper.getWidgetAnnotation(
                      helper.dictionary!, helper.crossTable);
                  final IPdfPrimitive? holderName =
                      holder[PdfDictionaryProperties.usageApplication];
                  if (holderName != null && holderName is PdfName) {
                    table[field.name!] = holderName.name!;
                  }
                }
              }
              break;
          }
        }
      }
    }
    bytes.addAll(utf8.encode('{'));
    String json;
    int j = 0;
    table.forEach((String k, String v) {
      json = '"${_replaceJsonDelimiters(k)}":"${_replaceJsonDelimiters(v)}"';
      bytes.addAll(utf8.encode(j > 0 ? ',$json' : json));
      j++;
    });
    bytes.addAll(utf8.encode('}'));
    return bytes;
  }

  String _replaceJsonDelimiters(String value) {
    // ignore: unnecessary_string_escapes
    return value.contains(RegExp('[":,{}]|[\[]|]'))
        ? value
            .replaceAll(',', '_x002C_')
            .replaceAll('"', '_x0022_')
            .replaceAll(':', '_x003A_')
            .replaceAll('{', '_x007B_')
            .replaceAll('}', '_x007D_')
            .replaceAll('[', '_x005B_')
            .replaceAll(']', '_x005D_')
        : value;
  }

  /// Imports XML Data from the given data.
  void _importDataXml(List<int> bytes, bool continueImportOnError) {
    final String data = utf8.decode(bytes);
    final XmlDocument document = XmlDocument.parse(data);
    if (document.rootElement.name.local != 'Fields') {
      ArgumentError.value('The XML form data stream is not valid');
    } else {
      _importXmlData(document.rootElement.children, continueImportOnError);
    }
  }

  void _importXmlData(List<XmlNode> children, bool continueImportOnError) {
    for (final XmlNode childNode in children) {
      if (childNode is XmlElement) {
        if (childNode.innerText.isNotEmpty) {
          String fieldName = childNode.name.local.replaceAll('_x0020_', ' ');
          fieldName = fieldName
              .replaceAll('_x0023_', '#')
              .replaceAll('_x002C_', ',')
              .replaceAll('_x005C_', r'\')
              .replaceAll('_x0022_', '"')
              .replaceAll('_x003A_', ':')
              .replaceAll('_x005D_', ']')
              .replaceAll('_x005D_', ']')
              .replaceAll('_x007B_', '{')
              .replaceAll('_x007D_', '}')
              .replaceAll('_x0024_', r'$');
          try {
            final int index = PdfFormFieldCollectionHelper.getHelper(fields)
                .getFieldIndex(fieldName);
            if (index == -1) {
              throw ArgumentError('Incorrect field name.');
            }
            final PdfField formField = fields[index];
            PdfFieldHelper.getHelper(formField)
                .importFieldValue(childNode.innerText);
          } catch (e) {
            if (!continueImportOnError) {
              rethrow;
            }
          }
        }
        if (childNode.children.isNotEmpty) {
          _importXmlData(childNode.children, continueImportOnError);
        }
      }
    }
  }

  List<int> _exportDataXML() {
    final XmlBuilder builder = XmlBuilder();
    final List<XmlElement> elements = <XmlElement>[];
    builder.processing('xml', 'version="1.0" encoding="utf-8"');
    for (int i = 0; i < fields.count; i++) {
      final PdfField field = fields[i];
      if (field.canExport) {
        PdfFieldHelper.getHelper(field).exportEmptyField = exportEmptyFields;
        final XmlElement? element =
            PdfFieldHelper.getHelper(field).exportFieldForXml();
        if (element != null) {
          elements.add(element);
        }
      }
    }
    builder.element('Fields', nest: elements);
    return utf8.encode(builder.buildDocument().toXmlString(pretty: true));
  }
}

/// [PdfForm] helper
class PdfFormHelper {
  /// internal constructor
  PdfFormHelper(this.form);

  /// internal field
  late PdfForm form;

  /// internal field
  PdfDictionary? dictionary = PdfDictionary();

  /// internal field
  bool? needAppearances = false;

  /// internal field
  bool setAppearanceDictionary = false;

  /// internal field
  final List<String?> fieldNames = <String?>[];

  /// internal field
  PdfCrossTable? crossTable;

  /// internal field
  final List<PdfDictionary> terminalFields = <PdfDictionary>[];

  /// internal field
  bool formHasKids = false;

  /// internal field
  bool isLoadedForm = false;

  /// internal field
  Map<String?, List<PdfDictionary>>? widgetDictionary;

  /// internal field
  bool isUR3 = false;

  /// internal field
  // ignore: prefer_final_fields
  List<SignatureFlags> signatureFlags = <SignatureFlags>[SignatureFlags.none];
  PdfResources? _resource;

  /// internal field
  bool flatten = false;
  bool _isDefaultAppearance = false;
  PdfFormFieldCollection? _fields;

  /// internal property
  IPdfPrimitive? get element => dictionary;
  set element(IPdfPrimitive? value) {
    throw ArgumentError("Primitive element can't be set");
  }

  /// internal method
  static PdfFormHelper getHelper(PdfForm form) {
    return form._helper;
  }

  /// internal method
  static PdfForm internal(PdfCrossTable? crossTable,
      [PdfDictionary? formDictionary]) {
    return PdfForm._internal(crossTable, formDictionary);
  }

  /// internal method
  PdfResources get resources {
    if (_resource == null) {
      _resource = PdfResources();
      dictionary!.setProperty(PdfDictionaryProperties.dr, _resource);
    }
    return _resource!;
  }

  set resources(PdfResources value) {
    _resource = value;
    if (isLoadedForm) {
      dictionary!.setProperty(PdfDictionaryProperties.dr, value);
    }
  }

  /// internal method
  //Raises before stream saves.
  void beginSave(Object sender, SavePdfPrimitiveArgs? ars) {
    if (!isLoadedForm) {
      if (signatureFlags.length > 1 ||
          (signatureFlags.isNotEmpty &&
              !signatureFlags.contains(SignatureFlags.none))) {
        _setSignatureFlags(signatureFlags);
        needAppearances = false;
      }
      _checkFlatten();
      if (form.fields.count > 0 && setAppearanceDictionary) {
        dictionary!.setBoolean(
            PdfDictionaryProperties.needAppearances, needAppearances);
      }
    } else {
      int i = 0;
      if (signatureFlags.length > 1 ||
          (signatureFlags.isNotEmpty &&
              !signatureFlags.contains(SignatureFlags.none))) {
        _setSignatureFlags(signatureFlags);
        dictionary!.changed = true;
        if (!_isDefaultAppearance) {
          needAppearances = false;
        }
        if (dictionary!.containsKey(PdfDictionaryProperties.needAppearances)) {
          dictionary!.setBoolean(
              PdfDictionaryProperties.needAppearances, needAppearances);
        }
      }
      while (i < form.fields.count) {
        final PdfField field = form.fields[i];
        if (field is PdfSignatureField) {
          needAppearances = false;
        }
        final PdfFieldHelper helper = PdfFieldHelper.getHelper(field);
        if (helper.isLoadedField) {
          final PdfDictionary dic = helper.dictionary!;
          bool isSigned = false;
          if (field is PdfSignatureField) {
            if (dic.containsKey(PdfDictionaryProperties.v)) {
              final IPdfPrimitive? value =
                  PdfCrossTable.dereference(dic[PdfDictionaryProperties.v]);
              if (value != null) {
                isSigned = true;
              }
            }
          }
          bool isNeedAppearance = false;
          if (!dic.containsKey(PdfDictionaryProperties.ap) &&
              _isDefaultAppearance &&
              !needAppearances! &&
              !helper.changed) {
            isNeedAppearance = true;
          }
          if (helper.flags.length > 1) {
            helper.changed = true;
            helper.setFlags(helper.flags);
          }
          int fieldFlag = 0;
          if (dic.containsKey(PdfDictionaryProperties.f)) {
            final IPdfPrimitive? flag =
                PdfCrossTable.dereference(dic[PdfDictionaryProperties.f]);
            if (flag != null && flag is PdfNumber) {
              fieldFlag = flag.value!.toInt();
            }
          }
          PdfArray? kids;
          if (helper.dictionary!.containsKey(PdfDictionaryProperties.kids)) {
            kids = PdfCrossTable.dereference(
                helper.dictionary![PdfDictionaryProperties.kids]) as PdfArray?;
          }
          if (helper.flattenField && fieldFlag != 6) {
            if (field.page != null || kids != null) {
              helper.draw();
            }
            form.fields.remove(field);
            final int? index = crossTable!.items!.lookFor(helper.dictionary!);
            if (index != -1) {
              crossTable!.items!.objectCollection!.removeAt(index!);
            }
            --i;
          } else if (helper.changed ||
              isNeedAppearance ||
              (setAppearanceDictionary && !isSigned)) {
            helper.beginSave();
          }
        } else {
          if (helper.flattenField) {
            form.fields.remove(field);
            helper.draw();
            --i;
          } else {
            helper.save();
          }
        }
        ++i;
      }
      if (_isDefaultAppearance) {
        dictionary!.setBoolean(
            PdfDictionaryProperties.needAppearances, _isDefaultAppearance);
      } else if (!_isDefaultAppearance &&
          dictionary!.containsKey(PdfDictionaryProperties.needAppearances)) {
        dictionary!.setBoolean(
            PdfDictionaryProperties.needAppearances, _isDefaultAppearance);
      }
      dictionary!.remove('XFA');
    }
  }

  void _addFieldResourcesToPage(PdfField field) {
    final PdfResources formResources =
        PdfFormHelper.getHelper(field.form!).resources;
    if (formResources.containsKey(PdfDictionaryProperties.font)) {
      IPdfPrimitive? fieldFontResource =
          formResources[PdfDictionaryProperties.font];
      if (fieldFontResource is PdfReferenceHolder) {
        fieldFontResource = fieldFontResource.object as PdfDictionary?;
      }
      if (fieldFontResource != null && fieldFontResource is PdfDictionary) {
        // ignore: avoid_function_literals_in_foreach_calls
        fieldFontResource.items!.keys.forEach((PdfName? key) {
          final PdfResources pageResources =
              PdfPageHelper.getHelper(field.page!).getResources()!;
          IPdfPrimitive? pageFontResource =
              pageResources[PdfDictionaryProperties.font];
          if (pageFontResource is PdfDictionary) {
          } else if (pageFontResource is PdfReferenceHolder) {
            pageFontResource = pageFontResource.object as PdfDictionary?;
          }
          if (pageFontResource == null ||
              (pageFontResource is PdfDictionary &&
                  !pageFontResource.containsKey(key))) {
            final PdfReferenceHolder? fieldFontReference = (fieldFontResource!
                as PdfDictionary)[key] as PdfReferenceHolder?;
            if (pageFontResource == null) {
              final PdfDictionary fontDictionary = PdfDictionary();
              fontDictionary.items![key] = fieldFontReference;
              pageResources[PdfDictionaryProperties.font] = fontDictionary;
            } else {
              (pageFontResource as PdfDictionary).items![key] =
                  fieldFontReference;
            }
          }
        });
      }
    }
  }

  void _checkFlatten() {
    int i = 0;
    while (i < _fields!.count) {
      final PdfField field = _fields![i];
      final PdfFieldHelper helper = PdfFieldHelper.getHelper(field);
      if (helper.flattenField) {
        int? fieldFlag = 0;
        final PdfDictionary fieldDictionary = helper.dictionary!;
        if (fieldDictionary.containsKey(PdfDictionaryProperties.f)) {
          fieldFlag = (fieldDictionary[PdfDictionaryProperties.f]! as PdfNumber)
              .value as int?;
        }
        if (fieldFlag != 6) {
          _addFieldResourcesToPage(field);
          helper.draw();
          _fields!.remove(field);
          deleteFromPages(field);
          deleteAnnotation(field);
          --i;
        }
      } else if (helper.isLoadedField) {
        helper.beginSave();
      } else {
        helper.save();
      }
      ++i;
    }
  }

  /// internal method
  void deleteFromPages(PdfField field) {
    final PdfFieldHelper helper = PdfFieldHelper.getHelper(field);
    final PdfDictionary dic = helper.dictionary!;
    final PdfName kidsName = PdfName(PdfDictionaryProperties.kids);
    final PdfName annotsName = PdfName(PdfDictionaryProperties.annots);
    final PdfName pName = PdfName(PdfDictionaryProperties.p);
    final bool isLoaded = helper.isLoadedField;
    if (dic.items != null) {
      if (dic.containsKey(kidsName)) {
        final PdfArray array = dic[kidsName]! as PdfArray;
        for (int i = 0; i < array.count; ++i) {
          final PdfReferenceHolder holder = array[i]! as PdfReferenceHolder;
          final PdfDictionary? widget = holder.object as PdfDictionary?;
          PdfDictionary? page;
          if (!isLoaded) {
            final PdfReferenceHolder pageRef =
                widget![pName]! as PdfReferenceHolder;
            page = pageRef.object as PdfDictionary?;
          } else {
            PdfReference? pageRef;
            if (widget!.containsKey(pName) &&
                widget[PdfDictionaryProperties.p] is! PdfNull) {
              pageRef = crossTable!.getReference(widget[pName]);
            } else if (dic.containsKey(pName) &&
                dic[PdfDictionaryProperties.p] is! PdfNull) {
              pageRef = crossTable!.getReference(dic[pName]);
            } else if (field.page != null) {
              pageRef = crossTable!.getReference(
                  PdfPageHelper.getHelper(field.page!).dictionary);
            }
            page = crossTable!.getObject(pageRef) as PdfDictionary?;
          }
          if (page != null && page.containsKey(annotsName)) {
            PdfArray? annots;
            if (isLoaded) {
              annots = crossTable!.getObject(page[annotsName]) as PdfArray?;
              for (int i = 0; i < annots!.count; i++) {
                final IPdfPrimitive? obj = annots.elements[i];
                if (obj != null &&
                    obj is PdfReferenceHolder &&
                    obj.object is PdfDictionary &&
                    obj.object == holder.object) {
                  annots.remove(obj);
                  break;
                }
              }
              annots.changed = true;
              page.setProperty(annotsName, annots);
            } else {
              if (page[PdfDictionaryProperties.annots] is PdfReferenceHolder) {
                final PdfReferenceHolder annotReference =
                    page[PdfDictionaryProperties.annots]! as PdfReferenceHolder;
                annots = annotReference.object as PdfArray?;
                for (int i = 0; i < annots!.count; i++) {
                  final IPdfPrimitive? obj = annots.elements[i];
                  if (obj != null &&
                      obj is PdfReferenceHolder &&
                      obj.object is PdfDictionary &&
                      obj.object == holder.object) {
                    annots.remove(obj);
                    break;
                  }
                }
                annots.changed = true;
                page.setProperty(PdfDictionaryProperties.annots, annots);
              } else if (page[PdfDictionaryProperties.annots] is PdfArray) {
                if (helper.page != null) {
                  final PdfAnnotationCollection annotCollection =
                      helper.page!.annotations;
                  if (annotCollection.count > 0) {
                    final int index =
                        PdfAnnotationCollectionHelper.getHelper(annotCollection)
                            .annotations
                            .indexOf(holder);
                    if (index >= 0 && index < annotCollection.count) {
                      annotCollection.remove(annotCollection[index]);
                    }
                  }
                }
              }
            }
          } else if (isLoaded) {
            helper.requiredReference = holder;
            if (field.page != null &&
                PdfPageHelper.getHelper(field.page!)
                    .dictionary!
                    .containsKey(annotsName)) {
              final PdfArray annots = crossTable!.getObject(
                  PdfPageHelper.getHelper(field.page!)
                      .dictionary![annotsName])! as PdfArray;
              for (int i = 0; i < annots.count; i++) {
                final IPdfPrimitive? obj = annots.elements[i];
                if (obj != null &&
                    obj is PdfReferenceHolder &&
                    obj.object is PdfDictionary &&
                    obj.object == widget) {
                  annots.remove(obj);
                  break;
                }
              }
              annots.changed = true;
            }
            if (crossTable!.items != null &&
                crossTable!.items!.contains(widget)) {
              crossTable!.items!.objectCollection!
                  .removeAt(crossTable!.items!.lookFor(widget)!);
            }
            helper.requiredReference = null;
          }
        }
      } else {
        PdfDictionary? page;
        if (!isLoaded) {
          final PdfReferenceHolder pageRef = dic.containsKey(pName)
              ? (dic[pName] as PdfReferenceHolder?)!
              : PdfReferenceHolder(
                  PdfPageHelper.getHelper(field.page!).dictionary);
          page = pageRef.object as PdfDictionary?;
        } else {
          PdfReference? pageRef;
          if (dic.containsKey(pName) &&
              dic[PdfDictionaryProperties.p] is! PdfNull) {
            pageRef = crossTable!.getReference(dic[pName]);
          } else if (field.page != null) {
            pageRef = crossTable!
                .getReference(PdfPageHelper.getHelper(field.page!).dictionary);
          }
          page = crossTable!.getObject(pageRef) as PdfDictionary?;
        }
        if (page != null && page.containsKey(PdfDictionaryProperties.annots)) {
          final IPdfPrimitive? annots = isLoaded
              ? crossTable!.getObject(page[annotsName])
              : page[PdfDictionaryProperties.annots];
          if (annots != null && annots is PdfArray) {
            for (int i = 0; i < annots.count; i++) {
              final IPdfPrimitive? obj = annots.elements[i];
              if (obj != null &&
                  obj is PdfReferenceHolder &&
                  obj.object is PdfDictionary &&
                  obj.object == dic) {
                annots.remove(obj);
                break;
              }
            }
            annots.changed = true;
            page.setProperty(PdfDictionaryProperties.annots, annots);
          }
        } else if (isLoaded &&
            field.page != null &&
            PdfPageHelper.getHelper(field.page!)
                .dictionary!
                .containsKey(annotsName)) {
          final PdfArray annots = crossTable!.getObject(
                  PdfPageHelper.getHelper(field.page!).dictionary![annotsName])!
              as PdfArray;
          for (int i = 0; i < annots.count; i++) {
            final IPdfPrimitive? obj = annots.elements[i];
            if (obj != null &&
                obj is PdfReferenceHolder &&
                obj.object is PdfDictionary &&
                obj.object == dic) {
              annots.remove(obj);
              break;
            }
          }
          annots.changed = true;
        }
      }
    }
  }

  void _setSignatureFlags(List<SignatureFlags> value) {
    int n = 0;
    for (final SignatureFlags element in value) {
      n |= element.index;
    }
    dictionary!.setNumber(PdfDictionaryProperties.sigFlags, n);
  }

  /// internal method
  void deleteAnnotation(PdfField field) {
    final PdfFieldHelper helper = PdfFieldHelper.getHelper(field);
    final PdfDictionary dic = helper.dictionary!;
    if (dic.items != null) {
      if (dic.containsKey(PdfDictionaryProperties.kids)) {
        PdfArray? array;
        array = !helper.isLoadedField
            ? dic[PdfDictionaryProperties.kids] as PdfArray?
            : crossTable!.getObject(dic[PdfDictionaryProperties.kids])
                as PdfArray?;
        array!.clear();
        dic.setProperty(PdfDictionaryProperties.kids, array);
      }
    }
  }

  /// internal method
  String? getCorrectName(String? name) {
    String? correctName = name;
    if (fieldNames.contains(name)) {
      final int firstIndex = fieldNames.indexOf(name);
      final int lastIndex = fieldNames.lastIndexOf(name);
      if (firstIndex != lastIndex) {
        correctName = PdfResources.globallyUniqueIdentifier;
        fieldNames.removeAt(lastIndex);
        fieldNames.add(correctName);
      }
    }
    return correctName;
  }

  /// internal method
  //Removes field and kids annotation from dictionaries.
  void removeFromDictionaries(PdfField field,
      [bool removeFieldFromAcroForm = false]) {
    final PdfFieldHelper helper = PdfFieldHelper.getHelper(field);
    if ((_fields != null && _fields!.count > 0) || removeFieldFromAcroForm) {
      final PdfName fieldsDict = PdfName(PdfDictionaryProperties.fields);
      final PdfArray fields =
          crossTable!.getObject(dictionary![fieldsDict])! as PdfArray;
      for (int i = 0; i < fields.elements.length; i++) {
        final IPdfPrimitive? obj = fields.elements[i];
        if (obj != null &&
            obj is PdfReferenceHolder &&
            obj.object is PdfDictionary &&
            obj.object == helper.dictionary) {
          fields.remove(obj);
          break;
        }
      }
      helper.dictionary!.isSkip = true;
      fields.changed = true;
      if (!formHasKids ||
          !helper.dictionary!.items!
              .containsKey(PdfName(PdfDictionaryProperties.parent))) {
        for (int i = 0; i < fields.count; i++) {
          final IPdfPrimitive? fieldDictionary =
              PdfCrossTable.dereference(crossTable!.getObject(fields[i]));
          final PdfName kidsName = PdfName(PdfDictionaryProperties.kids);
          if (fieldDictionary != null &&
              fieldDictionary is PdfDictionary &&
              fieldDictionary.containsKey(kidsName)) {
            final PdfArray kids =
                crossTable!.getObject(fieldDictionary[kidsName])! as PdfArray;
            for (int i = 0; i < kids.count; i++) {
              final IPdfPrimitive? obj = kids[i];
              if (obj != null &&
                  obj is PdfReferenceHolder &&
                  obj.object == helper.dictionary) {
                kids.remove(obj);
                break;
              }
            }
          }
        }
      } else {
        if (helper.dictionary!.items!
            .containsKey(PdfName(PdfDictionaryProperties.parent))) {
          final PdfDictionary dic =
              (helper.dictionary![PdfDictionaryProperties.parent]!
                      as PdfReferenceHolder)
                  .object! as PdfDictionary;
          final PdfArray kids =
              dic.items![PdfName(PdfDictionaryProperties.kids)]! as PdfArray;
          for (int k = 0; k < kids.count; k++) {
            final PdfReferenceHolder kidsReference =
                kids[k]! as PdfReferenceHolder;
            if (kidsReference.object == helper.dictionary) {
              kids.remove(kidsReference);
              dic.modify();
              break;
            }
          }
        }
      }
      dictionary!.setProperty(fieldsDict, fields);
    }
    if (helper.isLoadedField && !removeFieldFromAcroForm) {
      deleteFromPages(field);
      deleteAnnotation(field);
    }
  }

  /// internal method
  static String decodeXMLConversion(String value) {
    String newString = value;
    while (newString.contains('_x')) {
      final int index = newString.indexOf('_x');
      final String tempString = newString.substring(index);
      if (tempString.length >= 7 && tempString[6] == '_') {
        newString = newString.replaceRange(index, index + 2, '--');
        final int? charCode =
            int.tryParse(value.substring(index + 2, index + 6), radix: 16);
        if (charCode != null && charCode >= 0) {
          value = value.replaceRange(
              index, index + 7, String.fromCharCode(charCode));
          newString = newString.replaceRange(index, index + 7, '-');
        }
      } else {
        break;
      }
    }
    return value;
  }
}

class _NodeInfo {
  //Constructor
  _NodeInfo(PdfArray? fields, int count) {
    _fields = fields;
    _count = count;
  }

  //Fields
  PdfArray? _fields;
  late int _count;
}
