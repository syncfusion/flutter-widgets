import '../../interfaces/pdf_interface.dart';
import '../annotations/pdf_annotation.dart';
import '../general/pdf_collection.dart';
import '../graphics/pdf_resources.dart';
import '../io/pdf_constants.dart';
import '../io/pdf_cross_table.dart';
import '../primitives/pdf_array.dart';
import '../primitives/pdf_dictionary.dart';
import '../primitives/pdf_name.dart';
import '../primitives/pdf_number.dart';
import '../primitives/pdf_reference_holder.dart';
import 'enum.dart';
import 'pdf_button_field.dart';
import 'pdf_check_box_field.dart';
import 'pdf_combo_box_field.dart';
import 'pdf_field.dart';
import 'pdf_field_item.dart';
import 'pdf_field_item_collection.dart';
import 'pdf_form.dart';
import 'pdf_list_box_field.dart';
import 'pdf_radio_button_list_field.dart';
import 'pdf_signature_field.dart';
import 'pdf_text_box_field.dart';

/// Represents a collection of form fields.
class PdfFormFieldCollection extends PdfObjectCollection
    implements IPdfWrapper {
  //Constructor
  /// Initializes a new instance of the [PdfFormFieldCollection] class.
  PdfFormFieldCollection._([PdfForm? form]) : super() {
    _helper = PdfFormFieldCollectionHelper(this, form);
  }

  //Fields
  late PdfFormFieldCollectionHelper _helper;

  //Properties
  /// Gets the [PdfField] at the specified index.
  PdfField operator [](int index) {
    if ((count < 0) || (index >= count)) {
      throw RangeError('index');
    }
    return _helper.list[index] as PdfField;
  }

  //Public methods
  /// Adds the specified field to the collection.
  int add(PdfField field) {
    return _helper._doAdd(field);
  }

  /// Adds a list of fields to the collection.
  void addAll(List<PdfField> fields) {
    if (fields.isEmpty) {
      throw ArgumentError("fields can't be empty");
    }
    // ignore: avoid_function_literals_in_foreach_calls
    fields.forEach((PdfField element) => add(element));
  }

  /// Removes the specified field in the collection.
  void remove(PdfField field) {
    _helper._doRemove(field);
  }

  /// Removes field at the specified position.
  void removeAt(int index) {
    _helper._doRemoveAt(index);
  }

  /// Gets the index of the specific field.
  int indexOf(PdfField field) {
    return PdfObjectCollectionHelper.getHelper(this).list.indexOf(field);
  }

  /// Determines whether field is contained within the collection.
  bool contains(PdfField field) {
    return PdfObjectCollectionHelper.getHelper(this).list.contains(field);
  }

  /// Clears the form field collection.
  void clear() {
    _helper._doClear();
  }
}

/// [PdfFormFieldCollection] helper
class PdfFormFieldCollectionHelper extends PdfObjectCollectionHelper {
  /// internal constructor
  PdfFormFieldCollectionHelper(this.formFieldCollection, PdfForm? form)
      : super(formFieldCollection) {
    if (form != null) {
      this.form = form;
      final PdfFormHelper formHelper = PdfFormHelper.getHelper(form);
      for (int i = 0; i < formHelper.terminalFields.length; ++i) {
        final PdfField? field = _getField(index: i);
        if (field != null) {
          _doAdd(field);
          if (removeTerminalField) {
            formHelper.terminalFields.removeAt(i);
            i--;
          }
        }
      }
    }
  }

  /// internal field
  late PdfFormFieldCollection formFieldCollection;

  /// internal field
  final PdfArray array = PdfArray();

  /// internal field
  PdfForm? form;

  /// internal field
  bool isAction = false;

  /// internal field
  bool removeTerminalField = false;

  /// internal field
  // ignore: prefer_final_fields
  final List<String?> addedFieldNames = <String?>[];

  /// internal method
  static PdfFormFieldCollectionHelper getHelper(
      PdfFormFieldCollection collection) {
    return collection._helper;
  }

  /// internal method
  static PdfFormFieldCollection getCollection([PdfForm? form]) {
    return PdfFormFieldCollection._(form);
  }

  /// internal method
  IPdfPrimitive get element => array;
  // ignore: unused_element
  set element(IPdfPrimitive? value) {
    throw ArgumentError("Primitive element can't be set");
  }

  /// internal method
  void createFormFieldsFromWidgets(int startFormFieldIndex) {
    for (int i = startFormFieldIndex;
        i < PdfFormHelper.getHelper(form!).terminalFields.length;
        ++i) {
      final PdfField? field = _getField(index: i);
      if (field != null) {
        _doAdd(field);
      }
    }
    if (PdfFormHelper.getHelper(form!).widgetDictionary != null &&
        PdfFormHelper.getHelper(form!).widgetDictionary!.isNotEmpty) {
      final Map<String?, List<PdfDictionary>> widgetDictionary =
          PdfFormHelper.getHelper(form!).widgetDictionary!;
      for (final List<PdfDictionary> dictValue in widgetDictionary.values) {
        if (dictValue.isNotEmpty) {
          final PdfField? field = _getField(dictionary: dictValue[0]);
          if (field != null) {
            PdfFormHelper.getHelper(form!)
                .terminalFields
                .add(PdfFieldHelper.getHelper(field).dictionary!);
            _doAdd(field);
          }
        }
      }
    }
  }

  int _doAdd(PdfField field) {
    final bool isLoaded =
        form != null && PdfFormHelper.getHelper(form!).isLoadedForm;
    removeTerminalField = false;
    if (!isAction) {
      PdfFieldHelper.getHelper(field).setForm(form);
      String? name = field.name;
      PdfArray? array;
      bool skipField = false;
      if (isLoaded) {
        array = PdfFormHelper.getHelper(form!)
                .dictionary!
                .containsKey(PdfDictionaryProperties.fields)
            ? PdfFormHelper.getHelper(form!).crossTable!.getObject(
                PdfFormHelper.getHelper(form!)
                    .dictionary![PdfDictionaryProperties.fields]) as PdfArray?
            : PdfArray();
        if (PdfFieldHelper.getHelper(field)
            .dictionary!
            .items!
            .containsKey(PdfName(PdfDictionaryProperties.parent))) {
          skipField = true;
        }
      } else {
        if (name == null || name.isEmpty) {
          name = PdfResources.globallyUniqueIdentifier;
        }
        PdfFormHelper.getHelper(form!).fieldNames.add(name);
      }
      if (!isLoaded || !PdfFieldHelper.getHelper(field).isLoadedField) {
        if (form!.fieldAutoNaming && !skipField) {
          if (!isLoaded) {
            PdfFieldHelper.getHelper(field)
                .applyName(PdfFormHelper.getHelper(form!).getCorrectName(name));
          } else {
            PdfFieldHelper.getHelper(field).applyName(getCorrectName(name));
            array!.add(PdfReferenceHolder(field));
            PdfFormHelper.getHelper(form!)
                .dictionary!
                .setProperty(PdfDictionaryProperties.fields, array);
          }
        } else if (isLoaded && !addedFieldNames.contains(name) && !skipField) {
          array!.add(PdfReferenceHolder(field));
          PdfFormHelper.getHelper(form!)
              .dictionary!
              .setProperty(PdfDictionaryProperties.fields, array);
        } else if (isLoaded && (!addedFieldNames.contains(name) && skipField) ||
            (form!.fieldAutoNaming && skipField)) {
          addedFieldNames.add(field.name);
        } else if (formFieldCollection.count > 0 && !isLoaded) {
          final int index = _addFieldItem(field, isLoaded);
          if (index >= 0) {
            removeTerminalField = true;
            return index;
          }
        }
      }
    }
    if (isLoaded) {
      if (!addedFieldNames.contains(field.name)) {
        addedFieldNames.add(field.name);
      } else if (PdfFieldHelper.getHelper(field).isLoadedField) {
        final int index = _addFieldItem(field, isLoaded);
        if (index >= 0) {
          removeTerminalField = true;
          return index;
        }
      }
    }
    if (field is! PdfRadioButtonListField &&
        PdfFieldHelper.getHelper(field).page != null) {
      PdfFieldHelper.getHelper(field)
          .page!
          .annotations
          .add(PdfFieldHelper.getHelper(field).widget!);
    }
    array.add(PdfReferenceHolder(field));
    list.add(field);
    PdfFieldHelper.getHelper(field).annotationIndex = list.length - 1;
    return list.length - 1;
  }

  int _addFieldItem(PdfField field, bool isLoaded) {
    for (int i = 0; i < formFieldCollection.count; i++) {
      if (list[i] is PdfField) {
        final PdfField oldField = list[i] as PdfField;
        if (oldField.name == field.name) {
          if ((field is PdfTextBoxField && oldField is PdfTextBoxField) ||
              (field is PdfCheckBoxField && oldField is PdfCheckBoxField)) {
            final PdfFieldHelper fieldHelper = PdfFieldHelper.getHelper(field);
            final PdfFieldHelper oldFieldHelper =
                PdfFieldHelper.getHelper(oldField);
            PdfDictionary? dic;
            PdfDictionary? oldFieldDic;
            if (isLoaded) {
              dic = _getWidgetAnnotation(fieldHelper.dictionary!);
              oldFieldDic = _getWidgetAnnotation(oldFieldHelper.dictionary!);
              PdfAnnotationHelper.getHelper(fieldHelper.widget!).dictionary =
                  dic;
              PdfAnnotationHelper.getHelper(oldFieldHelper.widget!).dictionary =
                  oldFieldDic;
            } else {
              dic =
                  PdfAnnotationHelper.getHelper(fieldHelper.widget!).dictionary;
              oldFieldDic =
                  PdfAnnotationHelper.getHelper(oldFieldHelper.widget!)
                      .dictionary;
            }
            dic!.remove(PdfDictionaryProperties.parent);
            if (isLoaded) {
              dic.setProperty(PdfDictionaryProperties.parent,
                  PdfReferenceHolder(oldFieldDic));
            }
            fieldHelper.widget!.parent = oldField;
            if (!isLoaded && fieldHelper.page != null) {
              fieldHelper.page!.annotations.add(fieldHelper.widget!);
            }
            final bool isOldFieldPresent =
                _checkCollection(oldFieldHelper.array, oldFieldDic!);
            bool isNewFieldPresent = false;
            if (isLoaded) {
              isNewFieldPresent = _checkCollection(oldFieldHelper.array, dic);
            }
            PdfReferenceHolder? oldFieldReferenceHolder;
            PdfReferenceHolder? newFieldReferenceHolder;
            if (!isOldFieldPresent) {
              oldFieldHelper.array.clear();
              oldFieldReferenceHolder = PdfReferenceHolder(oldFieldDic);
              oldFieldHelper.array.add(oldFieldReferenceHolder);
              oldFieldHelper.fieldItems ??= <PdfField>[];
              oldFieldHelper.fieldItems!.add(oldField);
            }
            if (!isNewFieldPresent) {
              newFieldReferenceHolder = PdfReferenceHolder(dic);
              oldFieldHelper.array.add(newFieldReferenceHolder);
              oldFieldHelper.fieldItems ??= <PdfField>[];
              oldFieldHelper.fieldItems!.add(field);
              oldFieldHelper.dictionary!.setProperty(
                  PdfDictionaryProperties.kids, oldFieldHelper.array);
            }
            if (isLoaded) {
              if (oldFieldReferenceHolder != null) {
                _addItem(oldField, oldFieldReferenceHolder, 0, true);
              }
              if (newFieldReferenceHolder != null) {
                _addItem(oldField, newFieldReferenceHolder,
                    oldFieldHelper.array.count - 1, false);
              }
              if (PdfFieldHelper.getHelper(field).isLoadedField) {
                PdfFormHelper.getHelper(form!)
                    .removeFromDictionaries(field, true);
              }
            }
            return formFieldCollection.count - 1;
          } else if (!isLoaded && field is PdfSignatureField) {
            final PdfSignatureField currentField = field;
            final PdfDictionary dictionary = PdfAnnotationHelper.getHelper(
                    PdfFieldHelper.getHelper(currentField).widget!)
                .dictionary!;
            if (dictionary.containsKey(PdfDictionaryProperties.parent)) {
              dictionary.remove(PdfDictionaryProperties.parent);
            }
            PdfFieldHelper.getHelper(currentField).widget!.parent = oldField;
            IPdfPrimitive? oldKids;
            IPdfPrimitive? newKids;
            if (PdfFieldHelper.getHelper(oldField)
                .dictionary!
                .containsKey(PdfDictionaryProperties.kids)) {
              oldKids = PdfFieldHelper.getHelper(oldField)
                  .dictionary!
                  .items![PdfName(PdfDictionaryProperties.kids)];
            }
            if (PdfFieldHelper.getHelper(field)
                .dictionary!
                .containsKey(PdfDictionaryProperties.kids)) {
              newKids = PdfFieldHelper.getHelper(field)
                  .dictionary!
                  .items![PdfName(PdfDictionaryProperties.kids)];
            }
            if (newKids != null && newKids is PdfArray) {
              if (oldKids == null || oldKids is! PdfArray) {
                oldKids = PdfArray();
              }
              for (int i = 0; i < newKids.count; i++) {
                final IPdfPrimitive? kidsReference = newKids[i];
                if (kidsReference != null &&
                    kidsReference is PdfReferenceHolder) {
                  oldKids.add(kidsReference);
                }
              }
            }
            PdfFieldHelper.getHelper(oldField)
                .dictionary!
                .setProperty(PdfDictionaryProperties.kids, oldKids);
            PdfSignatureFieldHelper.getHelper(currentField)
                .skipKidsCertificate = true;
            if (!field.page!.annotations
                .contains(PdfFieldHelper.getHelper(currentField).widget!)) {
              field.page!.annotations
                  .add(PdfFieldHelper.getHelper(currentField).widget!);
            }
            return formFieldCollection.count - 1;
          }
        }
      }
    }
    return -1;
  }

  PdfDictionary _getWidgetAnnotation(PdfDictionary dictionary) {
    if (dictionary.containsKey(PdfDictionaryProperties.kids)) {
      final IPdfPrimitive? array =
          PdfCrossTable.dereference(dictionary[PdfDictionaryProperties.kids]);
      if (array is PdfArray && array.count > 0) {
        final IPdfPrimitive? dic = PdfCrossTable.dereference(array[0]);
        if (dic is PdfDictionary) {
          return dic;
        }
      }
    }
    return dictionary;
  }

  void _addItem(PdfField field, PdfReferenceHolder referenceHolder, int index,
      bool initializeNew) {
    PdfFieldItemCollection? items;
    if (initializeNew) {
      items = PdfFieldItemCollectionHelper.load(field);
      if (field is PdfCheckBoxField) {
        PdfCheckBoxFieldHelper.getHelper(field).items = items;
      } else if (field is PdfTextBoxField) {
        PdfTextBoxFieldHelper.getHelper(field).items = items;
      }
    } else {
      if (field is PdfCheckBoxField) {
        items = field.items;
      } else if (field is PdfTextBoxField) {
        items = field.items;
      }
    }
    if (items != null) {
      final PdfDictionary? itemDictionary =
          PdfCrossTable.dereference(referenceHolder) as PdfDictionary?;
      PdfFieldItemCollectionHelper.getHelper(items)
          .add(PdfCheckBoxItemHelper.getItem(field, index, itemDictionary));
    }
  }

  bool _checkCollection(PdfArray array, PdfDictionary dictionary) {
    for (int i = 0; i < array.count; i++) {
      final IPdfPrimitive? obj = array.elements[i];
      if (obj != null &&
          obj is PdfReferenceHolder &&
          obj.object != null &&
          obj.object is PdfDictionary &&
          obj.object == dictionary) {
        return true;
      }
    }
    return false;
  }

  // Gets the field.
  PdfField? _getField({int? index, PdfDictionary? dictionary}) {
    index != null
        ? dictionary = PdfFormHelper.getHelper(form!).terminalFields[index]
        : ArgumentError.checkNotNull(
            dictionary, 'method cannot be initialized without parameters');
    final PdfCrossTable? crossTable = PdfFormHelper.getHelper(form!).crossTable;
    PdfField? field;
    final PdfName? name = PdfFieldHelper.getValue(
        dictionary!, crossTable, PdfDictionaryProperties.ft, true) as PdfName?;
    PdfFieldTypes type = PdfFieldTypes.none;
    if (name != null) {
      type = _getFieldType(name, dictionary, crossTable);
    }
    switch (type) {
      case PdfFieldTypes.comboBox:
        field = _createComboBox(dictionary, crossTable!);
        break;
      case PdfFieldTypes.listBox:
        field = _createListBox(dictionary, crossTable!);
        break;
      case PdfFieldTypes.textField:
        field = _createTextField(dictionary, crossTable!);
        break;
      case PdfFieldTypes.checkBox:
        field = _createCheckBox(dictionary, crossTable!);
        break;
      case PdfFieldTypes.radioButton:
        field = _createRadioButton(dictionary, crossTable!);
        break;
      case PdfFieldTypes.pushButton:
        field = _createPushButton(dictionary, crossTable!);
        break;
      case PdfFieldTypes.signatureField:
        field = _createSignatureField(dictionary, crossTable!);
        break;
      case PdfFieldTypes.none:
        break;
    }
    if (field != null) {
      PdfFieldHelper.getHelper(field).setForm(form);
      PdfFieldHelper.getHelper(field).beforeNameChanges = (String name) {
        if (addedFieldNames.contains(name)) {
          throw ArgumentError('Field with the same name already exist');
        }
      };
    }
    return field;
  }

  //Gets the type of the field.
  PdfFieldTypes _getFieldType(
      PdfName name, PdfDictionary dictionary, PdfCrossTable? crossTable) {
    final String str = name.name!;
    PdfFieldTypes type = PdfFieldTypes.none;
    final PdfNumber? number = PdfFieldHelper.getValue(
            dictionary, crossTable, PdfDictionaryProperties.fieldFlags, true)
        as PdfNumber?;
    int fieldFlags = 0;
    if (number != null) {
      fieldFlags = number.value!.toInt();
    }
    switch (str.toLowerCase()) {
      case 'ch':
        //check with FieldFlags.combo value.
        if ((fieldFlags & 1 << 17) != 0) {
          type = PdfFieldTypes.comboBox;
        } else {
          type = PdfFieldTypes.listBox;
        }
        break;
      case 'tx':
        type = PdfFieldTypes.textField;
        break;
      case 'btn':
        if ((fieldFlags & 1 << 15) != 0) {
          type = PdfFieldTypes.radioButton;
        } else if ((fieldFlags & 1 << 16) != 0) {
          type = PdfFieldTypes.pushButton;
        } else {
          type = PdfFieldTypes.checkBox;
        }
        break;
      case 'sig':
        type = PdfFieldTypes.signatureField;
        break;
    }
    return type;
  }

  //Creates the combo box.
  PdfField _createComboBox(PdfDictionary dictionary, PdfCrossTable crossTable) {
    final PdfField field =
        PdfComboBoxFieldHelper.loadComboBox(dictionary, crossTable);
    PdfFieldHelper.getHelper(field).setForm(form);
    return field;
  }

  //Creates the list box.
  PdfField _createListBox(PdfDictionary dictionary, PdfCrossTable crossTable) {
    final PdfField field =
        PdfListBoxFieldHelper.loadListBox(dictionary, crossTable);
    PdfFieldHelper.getHelper(field).setForm(form);
    return field;
  }

  //Creates the text field.
  PdfField _createTextField(
      PdfDictionary dictionary, PdfCrossTable crossTable) {
    final PdfField field =
        PdfTextBoxFieldHelper.loadTextBox(dictionary, crossTable);
    PdfFieldHelper.getHelper(field).setForm(form);
    return field;
  }

  PdfField _createCheckBox(PdfDictionary dictionary, PdfCrossTable crossTable) {
    final PdfField field =
        PdfCheckBoxFieldHelper.loadCheckBoxField(dictionary, crossTable);
    PdfFieldHelper.getHelper(field).setForm(form);
    return field;
  }

  PdfField _createRadioButton(
      PdfDictionary dictionary, PdfCrossTable crossTable) {
    final PdfField field =
        PdfRadioButtonListFieldHelper.loaded(dictionary, crossTable);
    PdfFieldHelper.getHelper(field).setForm(form);
    return field;
  }

  PdfField _createPushButton(
      PdfDictionary dictionary, PdfCrossTable crossTable) {
    final PdfField field =
        PdfButtonFieldHelper.loadButtonField(dictionary, crossTable);
    PdfFieldHelper.getHelper(field).setForm(form);
    return field;
  }

  PdfField _createSignatureField(
      PdfDictionary dictionary, PdfCrossTable crossTable) {
    final PdfField field =
        PdfSignatureFieldHelper.loadSignatureField(dictionary, crossTable);
    PdfFieldHelper.getHelper(field).setForm(form);
    return field;
  }

  /// Gets the new name of the field.
  String? getCorrectName(String? name) {
    final List<String?> tempList = <String?>[];
    for (int i = 0; i < formFieldCollection.count; i++) {
      final Object entry = list[i];
      if (entry is PdfField) {
        tempList.add(entry.name);
      }
    }
    String? correctName = name;
    int index = 0;
    while (tempList.contains(correctName)) {
      correctName = name! + index.toString();
      ++index;
    }
    tempList.clear();
    return correctName;
  }

  /// internal method
  int getFieldIndex(String name) {
    int i = -1;
    final List<String> fieldNames = <String>[];
    final List<String> indexedFieldNames = <String>[];
    for (int j = 0; j < formFieldCollection.count; j++) {
      if (PdfObjectCollectionHelper.getHelper(formFieldCollection).list[j]
          is PdfField) {
        final PdfField field =
            PdfObjectCollectionHelper.getHelper(formFieldCollection).list[j]
                as PdfField;
        fieldNames.add(field.name!);
        if (field.name != null) {
          indexedFieldNames.add(field.name!.split('[')[0]);
        }
      }
    }
    if (fieldNames.contains(name)) {
      i = fieldNames.indexOf(name);
    } else if (indexedFieldNames.contains(name)) {
      i = indexedFieldNames.indexOf(name);
    }
    return i;
  }

  /// internal method
  void removeContainingField(PdfReferenceHolder pageReferenceHolder) {
    for (int i = array.count - 1; i >= 0; --i) {
      final IPdfPrimitive? fieldDictionary =
          PdfCrossTable.dereference(array[i]);
      if (fieldDictionary != null && fieldDictionary is PdfDictionary) {
        if (fieldDictionary.containsKey(PdfDictionaryProperties.p)) {
          final IPdfPrimitive? holder =
              fieldDictionary[PdfDictionaryProperties.p];
          if (holder != null &&
              holder is PdfReferenceHolder &&
              holder.object == pageReferenceHolder.object) {
            _doRemoveAt(i);
          }
        } else if (fieldDictionary.containsKey(PdfDictionaryProperties.kids)) {
          final bool removed =
              _removeContainingFieldItems(fieldDictionary, pageReferenceHolder);
          if (removed) {
            _doRemoveAt(i);
          }
        }
      }
    }
  }

  void _removeFromDictionary(PdfField field) {
    if (PdfFieldHelper.getHelper(field).isLoadedField) {
      PdfFormHelper.getHelper(form!).removeFromDictionaries(field);
    }
    addedFieldNames.remove(field.name);
  }

  void _doRemove(PdfField field) {
    if (PdfFieldHelper.getHelper(field).isLoadedField ||
        (field.form != null &&
            PdfFormHelper.getHelper(field.form!).isLoadedForm)) {
      _removeFromDictionary(field);
    }
    PdfFieldHelper.getHelper(field).setForm(null);
    final int index = list.indexOf(field);
    array.removeAt(index);
    list.removeAt(index);
  }

  void _doRemoveAt(int index) {
    if (list[index] is PdfField &&
        PdfFieldHelper.getHelper(list[index] as PdfField).isLoadedField) {
      _removeFromDictionary(list[index] as PdfField);
    }
    array.removeAt(index);
    list.removeAt(index);
  }

  void _doClear() {
    if (formFieldCollection.count > 0) {
      for (int i = 0; i < formFieldCollection.count; i++) {
        if (list[i] is PdfField) {
          final PdfField field = list[i] as PdfField;
          if (PdfFieldHelper.getHelper(field).isLoadedField) {
            _removeFromDictionary(field);
          } else {
            PdfFormHelper.getHelper(form!).deleteFromPages(field);
            PdfFormHelper.getHelper(form!).deleteAnnotation(field);
            PdfFieldHelper.getHelper(field).page = null;
            if (PdfFieldHelper.getHelper(field).dictionary!.items != null) {
              PdfFieldHelper.getHelper(field).dictionary!.clear();
            }
            PdfFieldHelper.getHelper(field).setForm(null);
          }
        }
      }
    }
    addedFieldNames.clear();
    PdfFormHelper.getHelper(form!).terminalFields.clear();
    array.clear();
    list.clear();
  }

  bool _removeContainingFieldItems(
      PdfDictionary fieldDictionary, PdfReferenceHolder pageReferenceHolder) {
    bool isAllKidsRemoved = false;
    if (fieldDictionary.containsKey(PdfDictionaryProperties.kids)) {
      final IPdfPrimitive? array = PdfCrossTable.dereference(
          fieldDictionary[PdfDictionaryProperties.kids]);
      if (array != null && array is PdfArray) {
        for (int i = array.count - 1; i >= 0; --i) {
          IPdfPrimitive? holder;
          final IPdfPrimitive? kidObject = PdfCrossTable.dereference(array[i]);
          if (kidObject != null &&
              kidObject is PdfDictionary &&
              kidObject.containsKey(PdfDictionaryProperties.p))
            holder = kidObject[PdfDictionaryProperties.p];
          if (holder != null &&
              holder is PdfReferenceHolder &&
              holder.object == pageReferenceHolder.object) {
            (kidObject as PdfDictionary?)!.isSkip = true;
            array.removeAt(i);
            array.changed = true;
          }
        }
        if (array.count == 0) {
          isAllKidsRemoved = true;
        }
      }
    }
    return isAllKidsRemoved;
  }
}
