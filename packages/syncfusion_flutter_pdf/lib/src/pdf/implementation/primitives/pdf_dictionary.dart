import 'package:intl/intl.dart';

import '../../interfaces/pdf_interface.dart';
import '../io/enums.dart';
import '../io/pdf_constants.dart';
import '../io/pdf_cross_table.dart';
import '../io/pdf_parser.dart';
import '../primitives/pdf_array.dart';
import '../primitives/pdf_boolean.dart';
import '../primitives/pdf_name.dart';
import '../primitives/pdf_null.dart';
import '../primitives/pdf_number.dart';
import '../primitives/pdf_reference_holder.dart';
import '../primitives/pdf_stream.dart';
import '../primitives/pdf_string.dart';
import '../security/pdf_encryptor.dart';
import '../security/pdf_security.dart';

/// internal class
class PdfDictionary implements IPdfPrimitive, IPdfChangable {
  /// Constructor to create a [PdfDictionary] object.
  PdfDictionary([PdfDictionary? dictionary]) {
    items = <PdfName?, IPdfPrimitive?>{};
    copyDictionary(dictionary);
    _encrypt = true;
    decrypted = false;
  }

  //Constants
  /// internal field
  static const String prefix = '<<';

  /// internal field
  static const String suffix = '>>';

  //Fields
  /// internal field
  Map<PdfName?, IPdfPrimitive?>? items;

  /// internal property
  bool? isChanged;
  bool? _isSaving;
  int? _objectCollectionIndex;
  int? _position;
  PdfObjectStatus? _status;
  bool? _isSkip;

  /// internal field
  PdfCrossTable? crossTable;

  /// internal field
  bool archive = true;
  bool? _encrypt;

  /// internal field
  bool? decrypted;

  //Properties
  /// Get the PdfDictionary items.
  IPdfPrimitive? operator [](dynamic key) => returnValue(checkName(key));

  ///  Set the PdfDictionary items.
  operator []=(dynamic key, dynamic value) => addItems(key, value);

  /// internal property
  bool get isSkip {
    _isSkip ??= false;
    return _isSkip!;
  }

  set isSkip(bool value) {
    _isSkip = value;
  }

  /// internal method
  dynamic addItems(dynamic key, dynamic value) {
    if (key == null) {
      throw ArgumentError.value(key, 'key', 'value cannot be null');
    }
    if (value == null) {
      throw ArgumentError.value(value, 'value', 'value cannot be null');
    }
    items![checkName(key)] = value as IPdfPrimitive?;
    modify();
    return value;
  }

  /// Get the length of the item.
  int get count => items!.length;

  /// Get the values of the item.
  List<IPdfPrimitive?> get value => items!.values as List<IPdfPrimitive?>;

  /// internal property
  bool? get encrypt => _encrypt;

  set encrypt(bool? value) {
    _encrypt = value;
    modify();
  }

  //Implementation
  /// internal method
  void copyDictionary(PdfDictionary? dictionary) {
    if (dictionary != null) {
      dictionary.items!
          .forEach((PdfName? k, IPdfPrimitive? v) => addItems(k, v));
      freezeChanges(this);
    }
  }

  /// Check and return the valid name.
  PdfName? checkName(dynamic key) {
    if (key is PdfName) {
      return key;
    } else if (key is String) {
      return PdfName(key);
    } else {
      return null;
    }
  }

  /// Check key and return the value.
  IPdfPrimitive? returnValue(dynamic key) {
    if (items!.containsKey(key)) {
      return items![key];
    } else {
      return null;
    }
  }

  /// internal method
  bool containsKey(dynamic key) {
    if (key is String) {
      return items!.containsKey(PdfName(key));
    } else if (key is PdfName) {
      return items!.containsKey(key);
    }
    return false;
  }

  /// internal method
  void remove(dynamic key) {
    if (key == null) {
      throw ArgumentError.value(key, 'key', 'value cannot be null');
    }
    final PdfName name = key is PdfName ? key : PdfName(key);
    items!.remove(name);
    modify();
  }

  /// internal method
  void clear() {
    items!.clear();
    modify();
  }

  /// internal method
  void modify() {
    changed = true;
  }

  /// internal method
  void setProperty(dynamic key, dynamic value) {
    if (value == null) {
      if (key is String) {
        items!.remove(PdfName(key));
      } else if (key is PdfName) {
        items!.remove(key);
      }
    } else {
      if (value is IPdfWrapper) {
        value = IPdfWrapper.getElement(value);
      }
      this[key] = value;
    }
    modify();
  }

  /// internal method
  void setName(dynamic key, String? name) {
    if (key is String) {
      key = PdfName(key);
    }
    if (items!.containsKey(key)) {
      this[key] = PdfName(name);
      modify();
    } else {
      this[key] = PdfName(name);
    }
  }

  /// internal method
  void setArray(String key, List<IPdfPrimitive> list) {
    PdfArray? pdfArray = this[key] as PdfArray?;
    if (pdfArray != null) {
      pdfArray.clear();
      modify();
    } else {
      pdfArray = PdfArray();
      this[key] = pdfArray;
    }
    for (int i = 0; i < list.length; i++) {
      pdfArray.add(list.elementAt(i));
    }
  }

  /// internal method
  void setString(String key, String? str) {
    if (containsKey(key) && this[key] is PdfString) {
      final IPdfPrimitive? pdfString = this[key];
      if (pdfString != null && pdfString is PdfString) {
        pdfString.value = str;
        modify();
      }
    } else {
      this[key] = PdfString(str!);
    }
  }

  /// internal method
  void saveDictionary(IPdfWriter writer, bool enableEvents) {
    writer.write(prefix);
    if (enableEvents) {
      final SavePdfPrimitiveArgs args = SavePdfPrimitiveArgs(writer);
      onBeginSave(args);
    }
    if (count > 0) {
      final PdfEncryptor encryptor =
          PdfSecurityHelper.getHelper(writer.document!.security).encryptor;
      final bool state = encryptor.encrypt;
      if (!_encrypt!) {
        encryptor.encrypt = false;
      }
      _saveItems(writer);
      if (!_encrypt!) {
        encryptor.encrypt = state;
      }
    }
    writer.write(suffix);
    writer.write(PdfOperators.newLine);
    if (enableEvents) {
      final SavePdfPrimitiveArgs args = SavePdfPrimitiveArgs(writer);
      onEndSave(args);
    }
  }

  void _saveItems(IPdfWriter writer) {
    writer.write(PdfOperators.newLine);
    items!.forEach((PdfName? key, IPdfPrimitive? value) {
      key!.save(writer);
      writer.write(PdfOperators.whiteSpace);
      final PdfName name = key;
      if (name.name == 'Fields') {
        final IPdfPrimitive? fields = value;
        final List<PdfReferenceHolder> fieldCollection = <PdfReferenceHolder>[];
        if (fields is PdfArray) {
          for (int k = 0; k < fields.count; k++) {
            final PdfReferenceHolder fieldReference =
                fields.elements[k]! as PdfReferenceHolder;
            fieldCollection.add(fieldReference);
          }
          for (int i = 0; i < fields.count; i++) {
            if (fields.elements[i]! is PdfReferenceHolder) {
              final PdfReferenceHolder refHolder =
                  fields.elements[i]! as PdfReferenceHolder;
              final PdfDictionary? field =
                  refHolder.referenceObject as PdfDictionary?;
              if (field != null) {
                if (field.beginSave != null) {
                  final SavePdfPrimitiveArgs args =
                      SavePdfPrimitiveArgs(writer);
                  field.beginSave!(field, args);
                }
                if (!field.containsKey(PdfName(PdfDictionaryProperties.kids))) {
                  if (field.items!
                      .containsKey(PdfName(PdfDictionaryProperties.ft))) {
                    final IPdfPrimitive? value =
                        field.items![PdfName(PdfDictionaryProperties.ft)];
                    if (value != null &&
                        value is PdfName &&
                        value.name == 'Sig') {
                      for (int k = 0; k < fields.count; k++) {
                        if (k == i) {
                          continue;
                        }
                        final PdfReferenceHolder fieldRef =
                            fields.elements[k]! as PdfReferenceHolder;
                        final PdfDictionary field1 =
                            fieldRef.object! as PdfDictionary;
                        if (field1.items!.containsKey(
                                PdfName(PdfDictionaryProperties.t)) &&
                            field.items!.containsKey(
                                PdfName(PdfDictionaryProperties.t))) {
                          final PdfString parentSignatureName =
                              field1.items![PdfName(PdfDictionaryProperties.t)]!
                                  as PdfString;
                          final PdfString childName =
                              field.items![PdfName(PdfDictionaryProperties.t)]!
                                  as PdfString;
                          if (parentSignatureName.value == childName.value) {
                            fields.remove(refHolder);
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
          value = fields;
        }
      }
      value!.save(writer);
      writer.write(PdfOperators.newLine);
    });
  }

  /// internal method
  IPdfPrimitive? getValue(String key, String parentKey) {
    PdfDictionary? dictionary = this;
    IPdfPrimitive? element = PdfCrossTable.dereference(dictionary[key]);
    while (element == null) {
      dictionary =
          PdfCrossTable.dereference(dictionary![parentKey]) as PdfDictionary?;
      if (dictionary == null) {
        break;
      }
      element = PdfCrossTable.dereference(dictionary[key]);
    }
    return element;
  }

  /// internal method
  int getInt(String propertyName) {
    final IPdfPrimitive? primitive =
        PdfCrossTable.dereference(this[propertyName]);
    return (primitive != null && primitive is PdfNumber)
        ? primitive.value!.toInt()
        : 0;
  }

  /// internal method
  PdfString? getString(String propertyName) {
    final IPdfPrimitive? primitive =
        PdfCrossTable.dereference(this[propertyName]);
    return (primitive != null && primitive is PdfString) ? primitive : null;
  }

  /// internal method
  bool checkChanges() {
    bool result = false;
    final List<PdfName?> keys = items!.keys.toList();
    for (int i = 0; i < keys.length; i++) {
      final IPdfPrimitive? primitive = items![keys[i]];
      if (primitive is IPdfChangable &&
          (primitive! as IPdfChangable).changed!) {
        result = true;
        break;
      }
    }
    return result;
  }

  /// internal method
  void setNumber(String key, num? value) {
    final PdfNumber? pdfNumber = this[key] as PdfNumber?;
    if (pdfNumber != null) {
      pdfNumber.value = value;
      modify();
    } else {
      this[key] = PdfNumber(value!);
    }
  }

  /// internal method
  void setBoolean(String key, bool? value) {
    final PdfBoolean? pdfBoolean = this[key] as PdfBoolean?;
    if (pdfBoolean != null) {
      pdfBoolean.value = value;
      modify();
    } else {
      this[key] = PdfBoolean(value);
    }
  }

  /// internal method
  void setDateTime(String key, DateTime dateTime) {
    final DateFormat dateFormat = DateFormat('yyyyMMddHHmmss');
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
    final IPdfPrimitive? primitive = this[key];
    if (primitive != null && primitive is PdfString) {
      primitive.value =
          "D:${dateFormat.format(dateTime)}+$offsetHours'$offsetMinutes'";
      modify();
    } else {
      this[key] = PdfString(
          "D:${dateFormat.format(dateTime)}+$offsetHours'$offsetMinutes'");
    }
  }

  /// Gets the date time from Pdf standard date format.
  DateTime getDateTime(PdfString dateTimeStringValue) {
    const String prefixD = 'D:';
    final PdfString dateTimeString = PdfString(dateTimeStringValue.value!);
    String value = dateTimeString.value!;
    while (value.startsWith(RegExp('[:-D-(-)]'))) {
      dateTimeString.value = value.replaceFirst(value[0], '');
      value = dateTimeString.value!;
    }
    while (value[value.length - 1].contains(RegExp('[:-D-(-)]'))) {
      dateTimeString.value =
          value.replaceRange(value.length - 1, value.length, '');
    }
    if (dateTimeString.value!.startsWith('191')) {
      dateTimeString.value = dateTimeString.value!.replaceFirst('191', '20');
    }
    final bool containPrefixD = dateTimeString.value!.contains(prefixD);
    const String dateTimeFormat = 'yyyyMMddHHmmss';
    dateTimeString.value =
        dateTimeString.value!.padRight(dateTimeFormat.length, '0');
    String localTime = ''.padRight(dateTimeFormat.length);
    if (dateTimeString.value!.isEmpty) {
      return DateTime.now();
    }
    if (dateTimeString.value!.length >= localTime.length) {
      localTime = containPrefixD
          ? dateTimeString.value!.substring(prefixD.length, localTime.length)
          : dateTimeString.value!.substring(0, localTime.length);
    }
    final String dateWithT =
        '${localTime.substring(0, 8)}T${localTime.substring(8)}';
    try {
      final DateTime dateTime = DateTime.parse(dateWithT);
      return dateTime;
    } catch (e) {
      return DateTime.now();
    }
  }

  //IPdfChangable members
  @override
  bool? get changed {
    isChanged ??= false;
    if (!isChanged!) {
      isChanged = checkChanges();
    }
    return isChanged;
  }

  @override
  set changed(bool? value) {
    isChanged = value;
  }

  @override
  void freezeChanges(dynamic freezer) {
    if (freezer is PdfParser || freezer is PdfDictionary) {
      isChanged = false;
    }
  }

  //IPdfPrimitive members
  @override
  IPdfPrimitive? clonedObject;

  @override
  bool? get isSaving {
    _isSaving ??= false;
    return _isSaving;
  }

  @override
  set isSaving(bool? value) {
    _isSaving = value;
  }

  @override
  int? get objectCollectionIndex {
    _objectCollectionIndex ??= 0;
    return _objectCollectionIndex;
  }

  @override
  set objectCollectionIndex(int? value) {
    _objectCollectionIndex = value;
  }

  @override
  int? get position {
    _position ??= -1;
    return _position;
  }

  @override
  set position(int? value) {
    _position = value;
  }

  @override
  PdfObjectStatus? get status {
    _status ??= PdfObjectStatus.none;
    return _status;
  }

  @override
  set status(PdfObjectStatus? value) {
    _status = value;
  }

  @override
  void save(IPdfWriter? writer) {
    saveDictionary(writer!, true);
  }

  @override
  void dispose() {
    if (items != null && items!.isNotEmpty) {
      final List<IPdfPrimitive?> primitives = items!.keys.toList();
      for (int i = 0; i < primitives.length; i++) {
        final PdfName? key = primitives[i] as PdfName?;
        items![key!]!.dispose();
      }
      items!.clear();
      items = null;
    }
    if (_status != null) {
      _status = null;
    }
  }

  //Events
  /// internal field
  SavePdfPrimitiveCallback? beginSave;

  /// internal field
  List<SavePdfPrimitiveCallback>? beginSaveList;

  /// internal field
  SavePdfPrimitiveCallback? endSave;

  /// internal method
  void onBeginSave(SavePdfPrimitiveArgs args) {
    if (beginSave != null) {
      beginSave!(this, args);
    }
    if (beginSaveList != null) {
      for (int i = 0; i < beginSaveList!.length; i++) {
        beginSaveList![i](this, args);
      }
    }
  }

  /// internal method
  void onEndSave(SavePdfPrimitiveArgs args) {
    if (endSave != null) {
      endSave!(this, args);
    }
  }

  @override
  IPdfPrimitive? cloneObject(PdfCrossTable crossTable) {
    if (this is! PdfStream) {
      if (clonedObject != null &&
          (clonedObject is PdfDictionary == true) &&
          (clonedObject! as PdfDictionary).crossTable == crossTable) {
        return clonedObject;
      } else {
        clonedObject = null;
      }
    }
    final PdfDictionary newDict = PdfDictionary();
    items!.forEach((PdfName? key, IPdfPrimitive? value) {
      final PdfName? name = key;
      final IPdfPrimitive obj = value!;
      final IPdfPrimitive? newObj = obj.cloneObject(crossTable);
      if (newObj is! PdfNull) {
        newDict[name] = newObj;
      }
    });
    newDict.archive = archive;
    newDict.status = _status;
    newDict.freezeChanges(this);
    newDict.crossTable = crossTable;

    if (this is! PdfStream) {
      clonedObject = newDict;
    }
    return newDict;
  }
}

/// internal class
class SavePdfPrimitiveArgs {
  /// internal constructor
  SavePdfPrimitiveArgs(IPdfWriter? writer) {
    if (writer == null) {
      throw ArgumentError.notNull('writer');
    } else {
      _writer = writer;
    }
  }

  IPdfWriter? _writer;

  /// internal property
  IPdfWriter? get writer => _writer;
}

/// internal type definition
typedef SavePdfPrimitiveCallback = void Function(
    Object sender, SavePdfPrimitiveArgs? args);
