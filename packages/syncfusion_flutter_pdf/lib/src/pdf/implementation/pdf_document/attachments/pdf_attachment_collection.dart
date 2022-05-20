import 'dart:convert';

import '../../../interfaces/pdf_interface.dart';
import '../../general/pdf_collection.dart';
import '../../io/pdf_constants.dart';
import '../../io/pdf_cross_table.dart';
import '../../io/pdf_main_object_collection.dart';
import '../../primitives/pdf_array.dart';
import '../../primitives/pdf_dictionary.dart';
import '../../primitives/pdf_name.dart';
import '../../primitives/pdf_reference.dart';
import '../../primitives/pdf_reference_holder.dart';
import '../../primitives/pdf_stream.dart';
import '../../primitives/pdf_string.dart';
import '../enums.dart';
import '../pdf_document.dart';
import 'pdf_attachment.dart';

/// Represents a collection of the attachment objects.
class PdfAttachmentCollection extends PdfObjectCollection
    implements IPdfWrapper {
  //Constructors.
  /// Initializes a new instance of the [PdfAttachmentCollection] class.
  PdfAttachmentCollection() : super() {
    _helper = PdfAttachmentCollectionHelper(this);
  }

  PdfAttachmentCollection._(
      PdfDictionary dictionary, PdfCrossTable? crossTable) {
    _helper = PdfAttachmentCollectionHelper._(this, dictionary, crossTable);
  }

  //Fields
  late PdfAttachmentCollectionHelper _helper;

  //Properties
  /// Gets the attachment by index from  the collection. Read-Only.
  PdfAttachment operator [](int index) => _helper.getValue(index);

  //Public methods.
  /// Add [PdfAttachment] in the specified attachment collection.
  ///
  /// Returns position of the inserted attachment.
  int add(PdfAttachment attachment) {
    return _helper.add(attachment);
  }

  /// Removes the specified attachment from the collection.
  void remove(PdfAttachment attachment) {
    _helper._doRemove(attachment: attachment);
  }

  /// Removes attachment at the specified index.
  void removeAt(int index) {
    _helper._doRemove(index: index);
  }

  /// Search and find the index of the attachment.
  int indexOf(PdfAttachment attachment) {
    return _helper.indexOf(attachment);
  }

  /// Determines whether the attachment collection contains the specified attachment.
  ///
  /// Returns true if the attachment is present.
  bool contains(PdfAttachment attachment) {
    return _helper.contains(attachment);
  }

  /// Remove all the attachments from the collection.
  void clear() {
    _helper._doClear();
  }
}

/// [PdfAttachmentCollection] helper
class PdfAttachmentCollectionHelper extends PdfObjectCollectionHelper {
  /// internal constructor
  PdfAttachmentCollectionHelper(this.base) : super(base) {
    dictionary = PdfDictionary();
    dictionary.setProperty(PdfDictionaryProperties.names, _array);
  }
  PdfAttachmentCollectionHelper._(this.base, this.dictionary, this.crossTable)
      : super(base) {
    _initializeAttachmentCollection();
  }

  /// internal field
  late PdfAttachmentCollection base;

  /// internal field
  late PdfDictionary dictionary;

  /// internal field
  PdfArray? _array = PdfArray();

  /// internal field
  int _count = 0;

  /// internal field
  final Map<String, PdfReferenceHolder> _dic = <String, PdfReferenceHolder>{};

  /// internal field
  PdfCrossTable? crossTable;

  /// internal method
  static PdfAttachmentCollectionHelper getHelper(PdfAttachmentCollection base) {
    return base._helper;
  }

  /// internal method
  static PdfAttachmentCollection load(
      PdfDictionary attachmentDictionary, PdfCrossTable? crossTable) {
    return PdfAttachmentCollection._(attachmentDictionary, crossTable);
  }

  /// internal property
  IPdfPrimitive get element => dictionary;
  // ignore: unused_element
  set element(IPdfPrimitive? value) {
    throw ArgumentError("Primitive element can't be set");
  }

  /// internal method
  // ignore: prefer_final_fields
  bool conformance = false;

  /// internal method
  PdfAttachment getValue(int index) {
    if (index < 0 || index >= base.count) {
      throw RangeError('index');
    }
    return list[index] as PdfAttachment;
  }

  /// Add [PdfAttachment] in the specified attachment collection.
  ///
  /// Returns position of the inserted attachment.
  int add(PdfAttachment attachment) {
    if (conformance) {
      throw ArgumentError(
          'Attachment is not allowed for this conformance level.');
    }
    final int position = _doAdd(attachment);
    dictionary.modify();
    return position;
  }

  /// Search and find the index of the attachment.
  int indexOf(PdfAttachment attachment) {
    return list.indexOf(attachment);
  }

  /// Determines whether the attachment collection contains the specified attachment.
  ///
  /// Returns true if the attachment is present.
  bool contains(PdfAttachment attachment) {
    return list.contains(attachment);
  }

  void _initializeAttachmentCollection() {
    IPdfPrimitive? embedDictionary =
        dictionary[PdfDictionaryProperties.embeddedFiles];
    if (embedDictionary is PdfReferenceHolder) {
      embedDictionary = embedDictionary.object;
    }
    if (embedDictionary is PdfDictionary) {
      final IPdfPrimitive? obj = embedDictionary[PdfDictionaryProperties.names];
      final IPdfPrimitive? kid = embedDictionary[PdfDictionaryProperties.kids];
      if (obj is! PdfArray && kid != null && kid is PdfArray) {
        final PdfArray kids = kid;
        if (kids.count != 0) {
          for (int l = 0; l < kids.count; l++) {
            if (kids[l] is PdfReferenceHolder || kids[l] is PdfDictionary) {
              embedDictionary = kids[l] is PdfDictionary
                  ? kids[l]! as PdfDictionary
                  : (kids[l]! as PdfReferenceHolder).object != null &&
                          (kids[l]! as PdfReferenceHolder).object
                              is PdfDictionary
                      ? (kids[l]! as PdfReferenceHolder).object
                      : null;
              if (embedDictionary != null && embedDictionary is PdfDictionary) {
                _array =
                    embedDictionary[PdfDictionaryProperties.names] as PdfArray?;
                if (_array != null) {
                  _attachmentInformation(_array!);
                }
              }
            }
          }
        }
      } else if (obj is PdfArray) {
        _array = obj;
        _attachmentInformation(_array!);
      }
    }
  }

  //Internal method to get attachement information.
  void _attachmentInformation(PdfArray array) {
    if (array.count != 0) {
      int k = 1;
      for (int i = 0; i < (array.count ~/ 2); i++) {
        if (array[k] is PdfReferenceHolder || array[k] is PdfDictionary) {
          IPdfPrimitive? streamDictionary = array[k];
          if (array[k] is PdfReferenceHolder) {
            streamDictionary = (array[k]! as PdfReferenceHolder).object;
          }
          if (streamDictionary is PdfDictionary) {
            PdfStream? stream = PdfStream();
            PdfDictionary? attachmentStream;
            if (streamDictionary.containsKey(PdfDictionaryProperties.ef)) {
              if (streamDictionary[PdfDictionaryProperties.ef]
                  is PdfDictionary) {
                attachmentStream = streamDictionary[PdfDictionaryProperties.ef]
                    as PdfDictionary?;
              } else if (streamDictionary[PdfDictionaryProperties.ef]
                  is PdfReferenceHolder) {
                final PdfReferenceHolder streamHolder =
                    streamDictionary[PdfDictionaryProperties.ef]!
                        as PdfReferenceHolder;
                attachmentStream = streamHolder.object as PdfDictionary?;
              }
              final PdfReferenceHolder? holder1 =
                  attachmentStream![PdfDictionaryProperties.f]
                      as PdfReferenceHolder?;
              if (holder1 != null) {
                final IPdfPrimitive? reference = holder1.reference;
                if (holder1.object != null && holder1.object is PdfStream) {
                  stream = holder1.object as PdfStream?;
                  if (stream != null &&
                      crossTable!.encryptor != null &&
                      crossTable!.encryptor!.encryptAttachmentOnly! &&
                      reference != null &&
                      reference is PdfReference) {
                    stream.decrypt(crossTable!.encryptor!, reference.objNum);
                  }
                }
              }
            }
            PdfAttachment attachment;
            if (stream != null) {
              stream.decompress();
              if (streamDictionary.containsKey('F')) {
                attachment = PdfAttachment(
                    (streamDictionary['F']! as PdfString).value!,
                    stream.dataStream!);
                final IPdfPrimitive fileStream = stream;
                if (fileStream is PdfDictionary) {
                  final IPdfPrimitive? subtype = PdfCrossTable.dereference(
                      fileStream[PdfDictionaryProperties.subtype]);
                  if (subtype is PdfName) {
                    attachment.mimeType = subtype.name!
                        .replaceAll('#23', '#')
                        .replaceAll('#20', ' ')
                        .replaceAll('#2F', '/');
                  }
                }
                if (fileStream is PdfDictionary &&
                    fileStream.containsKey(PdfDictionaryProperties.params)) {
                  final IPdfPrimitive? mParams = PdfCrossTable.dereference(
                          fileStream[PdfDictionaryProperties.params])
                      as PdfDictionary?;
                  if (mParams is PdfDictionary) {
                    final IPdfPrimitive? creationDate =
                        PdfCrossTable.dereference(
                            mParams[PdfDictionaryProperties.creationDate]);
                    final IPdfPrimitive? modifiedDate =
                        PdfCrossTable.dereference(
                            mParams[PdfDictionaryProperties.modificationDate]);
                    if (creationDate is PdfString) {
                      attachment.creationDate =
                          mParams.getDateTime(creationDate);
                    }
                    if (modifiedDate is PdfString) {
                      attachment.modificationDate =
                          mParams.getDateTime(modifiedDate);
                    }
                  }
                }
                if (streamDictionary
                    .containsKey(PdfDictionaryProperties.afRelationship)) {
                  final IPdfPrimitive? relationShip = PdfCrossTable.dereference(
                      streamDictionary[PdfDictionaryProperties.afRelationship]);
                  if (relationShip is PdfName) {
                    attachment.relationship =
                        _obtainRelationShip(relationShip.name);
                  }
                }
                if (streamDictionary.containsKey('Desc')) {
                  attachment.description =
                      (streamDictionary['Desc']! as PdfString).value!;
                }
              } else {
                attachment = PdfAttachment(
                    (streamDictionary['Desc']! as PdfString).value!,
                    stream.dataStream!);
              }
            } else {
              if (streamDictionary.containsKey('Desc')) {
                attachment = PdfAttachment(
                    (streamDictionary['Desc']! as PdfString).value!, <int>[]);
              } else {
                attachment = PdfAttachment(
                    (streamDictionary['F']! as PdfString).value!, <int>[]);
              }
            }
            list.add(attachment);
          }
        }
        k = k + 2;
      }
    }
  }

  //Obtain Attachement relation ship
  PdfAttachmentRelationship _obtainRelationShip(String? relation) {
    PdfAttachmentRelationship relationShip =
        PdfAttachmentRelationship.unspecified;
    switch (relation) {
      case 'Alternative':
        relationShip = PdfAttachmentRelationship.alternative;
        break;
      case 'Data':
        relationShip = PdfAttachmentRelationship.data;
        break;
      case 'Source':
        relationShip = PdfAttachmentRelationship.source;
        break;
      case 'Supplement':
        relationShip = PdfAttachmentRelationship.supplement;
        break;
      case 'Unspecified':
        relationShip = PdfAttachmentRelationship.unspecified;
        break;
      default:
        break;
    }
    return relationShip;
  }

  //Adds the attachment.
  int _doAdd(PdfAttachment attachment) {
    final String fileName = attachment.fileName;
    final String converted = utf8.encode(fileName).length != fileName.length
        ? 'Attachment ${_count++}'
        : fileName;
    if (_dic.isEmpty && _array!.count > 0) {
      for (int i = 0; i < _array!.count; i += 2) {
        if (!_dic.containsKey((_array![i]! as PdfString).value)) {
          _dic[(_array![i]! as PdfString).value!] =
              _array![i + 1]! as PdfReferenceHolder;
        } else {
          final String value = '${(_array![i]! as PdfString).value!}_copy';
          _dic[value] = _array![i + 1]! as PdfReferenceHolder;
        }
      }
    }
    !_dic.containsKey(converted)
        ? _dic[converted] = PdfReferenceHolder(attachment)
        : _dic['${converted}_copy'] = PdfReferenceHolder(attachment);
    final List<String?> orderList = _dic.keys.toList();
    orderList.sort();
    _array!.clear();
    for (final String? key in orderList) {
      _array!.add(PdfString(key!));
      _array!.add(_dic[key]!);
    }
    list.add(attachment);
    return list.length - 1;
  }

  //Removes the attachment.
  void _doRemove({PdfAttachment? attachment, int? index}) {
    if (attachment != null) {
      index = list.indexOf(attachment);
    }
    _array!.removeAt(2 * index!);
    IPdfPrimitive? attachmentDictionay =
        PdfCrossTable.dereference(_array![2 * index]);
    if (attachmentDictionay is PdfDictionary) {
      _removeAttachementObjects(attachmentDictionay);
      attachmentDictionay = null;
    }
    _array!.removeAt(2 * index);
    list.removeAt(index);
  }

  //Removing attachment dictionary and stream from main object collection.
  void _removeAttachementObjects(PdfDictionary attachmentDictionary) {
    PdfMainObjectCollection? objectCollection;
    if (crossTable != null && crossTable!.document != null) {
      objectCollection =
          PdfDocumentHelper.getHelper(crossTable!.document!).objects;
    }
    if (objectCollection != null) {
      if (attachmentDictionary.containsKey(PdfDictionaryProperties.ef)) {
        final IPdfPrimitive? embedded = PdfCrossTable.dereference(
            attachmentDictionary[PdfDictionaryProperties.ef]);
        if (embedded is PdfDictionary) {
          if (embedded.containsKey(PdfDictionaryProperties.f)) {
            final IPdfPrimitive? stream =
                PdfCrossTable.dereference(embedded[PdfDictionaryProperties.f]);
            if (stream != null) {
              if (objectCollection.contains(stream)) {
                final int index = objectCollection.lookFor(stream)!;
                if (objectCollection.objectCollection!.length > index) {
                  objectCollection.objectCollection!.removeAt(index);
                }
              }
            }
          }
        }
      }
      if (objectCollection.contains(attachmentDictionary)) {
        final int index = objectCollection.lookFor(attachmentDictionary)!;
        if (objectCollection.objectCollection!.length > index) {
          objectCollection.objectCollection!.removeAt(index);
        }
      }
      if (_dic.isNotEmpty) {
        _dic.clear();
      }
    }
  }

  //Clears the collection.
  void _doClear() {
    list.clear();
    if (crossTable != null) {
      final PdfMainObjectCollection coll =
          PdfDocumentHelper.getHelper(crossTable!.document!).objects;
      if (coll.count > 0) {
        for (int i = 1; i < _array!.count; i = i + 2) {
          if (_array![i] is PdfReferenceHolder) {
            final IPdfPrimitive? dic = PdfCrossTable.dereference(_array![i]);
            if (dic is PdfDictionary) {
              _removeAttachementObjects(dic);
            }
          }
        }
      }
    }
    _array!.clear();
  }
}
