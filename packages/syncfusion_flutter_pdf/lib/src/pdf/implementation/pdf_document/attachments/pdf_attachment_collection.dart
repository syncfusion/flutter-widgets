part of pdf;

/// Represents a collection of the attachment objects.
class PdfAttachmentCollection extends PdfObjectCollection
    implements _IPdfWrapper {
  //Constructors.
  /// Initializes a new instance of the [PdfAttachmentCollection] class.
  PdfAttachmentCollection() : super() {
    _dictionary.setProperty(_DictionaryProperties.names, _array);
  }

  PdfAttachmentCollection._(
      _PdfDictionary attachmentDictionary, _PdfCrossTable crossTable) {
    _dictionary = attachmentDictionary;
    _crossTable = crossTable;
    _initializeAttachmentCollection();
  }

  //Fields
  _PdfDictionary _dictionary = _PdfDictionary();
  _PdfArray _array = _PdfArray();
  // ignore: prefer_final_fields
  bool _conformance = false;
  int _count = 0;
  final Map<String, _PdfReferenceHolder> _dic = {};
  _PdfCrossTable _crossTable;

  //Properties
  /// Gets the attachment by index from  the collection. Read-Only.
  PdfAttachment operator [](int index) {
    return _list[index] is PdfAttachment ? _list[index] : null;
  }

  //Public methods.
  /// Add [PdfAttachment] in the specified attachment collection.
  ///
  /// Returns position of the inserted attachment.
  int add(PdfAttachment attachment) {
    ArgumentError.checkNotNull(attachment, 'attachment');
    if (_conformance) {
      throw ArgumentError(
          'Attachment is not allowed for this conformance level.');
    }
    final int position = _doAdd(attachment);
    _dictionary.modify();
    return position;
  }

  /// Removes the specified attachment from the collection.
  void remove(PdfAttachment attachment) {
    ArgumentError.checkNotNull(attachment, 'attachment');
    _doRemove(attachment: attachment);
  }

  /// Removes attachment at the specified index.
  void removeAt(int index) {
    _doRemove(index: index);
  }

  /// Search and find the index of the attachment.
  int indexOf(PdfAttachment attachment) {
    ArgumentError.checkNotNull(attachment, 'attachment');
    return _list.indexOf(attachment);
  }

  /// Determines whether the attachment collection contains the specified attachment.
  ///
  /// Returns true if the attachment is present.
  bool contains(PdfAttachment attachment) {
    ArgumentError.checkNotNull(attachment, 'attachment');
    return _list.contains(attachment);
  }

  /// Remove all the attachments from the collection.
  void clear() {
    _doClear();
  }

  //Implementations.
  //Adds the attachment.
  int _doAdd(PdfAttachment attachment) {
    final String fileName = attachment.fileName;
    final String converted = utf8.encode(fileName).length != fileName.length
        ? 'Attachment ${_count++}'
        : fileName;
    if (_dic.isEmpty && _array.count > 0) {
      for (int i = 0; i < _array.count; i += 2) {
        if (!_dic.containsKey((_array[i] as _PdfString).value)) {
          _dic[(_array[i] as _PdfString).value] =
              _array[i + 1] as _PdfReferenceHolder;
        } else {
          final String value = (_array[i] as _PdfString).value + '_copy';
          _dic[value] = _array[i + 1] as _PdfReferenceHolder;
        }
      }
    }
    !_dic.containsKey(converted)
        ? _dic[converted] = _PdfReferenceHolder(attachment)
        : _dic[converted + '_copy'] = _PdfReferenceHolder(attachment);
    final List<String> orderList = _dic.keys.toList();
    orderList.sort();
    _array._clear();
    for (final key in orderList) {
      _array._add(_PdfString(key));
      _array._add(_dic[key]);
    }
    _list.add(attachment);
    return _list.length - 1;
  }

  //Removes the attachment.
  void _doRemove({PdfAttachment attachment, int index}) {
    if (attachment != null) {
      index = _list.indexOf(attachment);
    }
    _array._removeAt(2 * index);
    _IPdfPrimitive attachmentDictionay =
        _PdfCrossTable._dereference(_array[2 * index]);
    if (attachmentDictionay is _PdfDictionary) {
      _removeAttachementObjects(attachmentDictionay);
      attachmentDictionay = null;
    }
    _array._removeAt(2 * index);
    _list.removeAt(index);
  }

  //Removing attachment dictionary and stream from main object collection.
  void _removeAttachementObjects(_PdfDictionary attachmentDictionary) {
    _PdfMainObjectCollection _objectCollection;
    if (_crossTable != null && _crossTable._document != null) {
      _objectCollection = _crossTable._document._objects;
    }
    if (_objectCollection != null) {
      if (attachmentDictionary != null) {
        if (attachmentDictionary.containsKey(_DictionaryProperties.ef)) {
          final _IPdfPrimitive embedded = _PdfCrossTable._dereference(
              attachmentDictionary[_DictionaryProperties.ef]);
          if (embedded is _PdfDictionary) {
            if (embedded.containsKey(_DictionaryProperties.f)) {
              final _IPdfPrimitive stream = _PdfCrossTable._dereference(
                  embedded[_DictionaryProperties.f]);
              if (stream != null) {
                if (_objectCollection.contains(stream)) {
                  final int index = _objectCollection._lookFor(stream);
                  if (_objectCollection._objectCollection.length > index) {
                    _objectCollection._objectCollection.removeAt(index);
                  }
                }
              }
            }
          }
        }
        if (_objectCollection.contains(attachmentDictionary)) {
          final int index = _objectCollection._lookFor(attachmentDictionary);
          if (_objectCollection._objectCollection.length > index) {
            _objectCollection._objectCollection.removeAt(index);
          }
        }
      }
      if (_dic.isNotEmpty) {
        _dic.clear();
      }
    }
  }

  //Clears the collection.
  void _doClear() {
    _list.clear();
    if (_crossTable != null) {
      final _PdfMainObjectCollection coll = _crossTable._document._objects;
      if (coll != null) {
        for (int i = 1; i < _array.count; i = i + 2) {
          if (_array[i] is _PdfReferenceHolder) {
            final _IPdfPrimitive dic = _PdfCrossTable._dereference(_array[i]);
            if (dic is _PdfDictionary) {
              _removeAttachementObjects(dic);
            }
          }
        }
      }
    }
    _array._clear();
  }

  void _initializeAttachmentCollection() {
    _IPdfPrimitive embedDictionary =
        _dictionary[_DictionaryProperties.embeddedFiles];
    if (embedDictionary is _PdfReferenceHolder) {
      embedDictionary = (embedDictionary as _PdfReferenceHolder).object;
    }
    if (embedDictionary is _PdfDictionary) {
      final _IPdfPrimitive obj =
          (embedDictionary as _PdfDictionary)[_DictionaryProperties.names];
      final _IPdfPrimitive kid =
          (embedDictionary as _PdfDictionary)[_DictionaryProperties.kids];
      if (!(obj is _PdfArray) && kid is _PdfArray) {
        final _PdfArray kids = kid;
        if (kids != null) {
          if (kids.count != 0) {
            for (int l = 0; l < kids.count; l++) {
              if (kids[l] is _PdfReferenceHolder || kids[l] is _PdfDictionary) {
                embedDictionary = kids[l] is _PdfDictionary
                    ? kids[l] as _PdfDictionary
                    : (kids[l] as _PdfReferenceHolder).object != null &&
                            (kids[l] as _PdfReferenceHolder).object
                                is _PdfDictionary
                        ? (kids[l] as _PdfReferenceHolder).object
                        : null;
                if (embedDictionary != null &&
                    embedDictionary is _PdfDictionary) {
                  _array =
                      embedDictionary[_DictionaryProperties.names] as _PdfArray;
                  if (_array != null) {
                    _attachmentInformation(_array);
                  }
                }
              }
            }
          }
        }
      } else if (obj is _PdfArray) {
        _array = obj;
        _attachmentInformation(_array);
      }
    }
  }

  //Internal method to get attachement information.
  void _attachmentInformation(_PdfArray _array) {
    if (_array.count != 0) {
      int k = 1;
      for (int i = 0; i < (_array.count ~/ 2); i++) {
        if (_array[k] is _PdfReferenceHolder || _array[k] is _PdfDictionary) {
          _IPdfPrimitive streamDictionary = _array[k];
          if (_array[k] is _PdfReferenceHolder) {
            streamDictionary = (_array[k] as _PdfReferenceHolder).object;
          }
          if (streamDictionary is _PdfDictionary) {
            _PdfStream stream = _PdfStream();
            _PdfDictionary attachmentStream;
            if (streamDictionary.containsKey(_DictionaryProperties.ef)) {
              if (streamDictionary[_DictionaryProperties.ef]
                  is _PdfDictionary) {
                attachmentStream = streamDictionary[_DictionaryProperties.ef]
                    as _PdfDictionary;
              } else if (streamDictionary[_DictionaryProperties.ef]
                  is _PdfReferenceHolder) {
                final _PdfReferenceHolder streamHolder =
                    streamDictionary[_DictionaryProperties.ef]
                        as _PdfReferenceHolder;
                attachmentStream = streamHolder.object as _PdfDictionary;
              }
              final _PdfReferenceHolder holder1 =
                  attachmentStream[_DictionaryProperties.f]
                      as _PdfReferenceHolder;
              if (holder1 != null) {
                if (holder1.object != null && holder1.object is _PdfStream) {
                  stream = holder1.object;
                }
              }
            }
            PdfAttachment attachment;
            if (stream != null) {
              stream._decompress();
              if (streamDictionary.containsKey('F')) {
                attachment = PdfAttachment(
                    (streamDictionary['F'] as _PdfString).value,
                    stream._dataStream);
                final _IPdfPrimitive fileStream = stream;
                if (fileStream is _PdfDictionary) {
                  final _IPdfPrimitive subtype = _PdfCrossTable._dereference(
                      fileStream[_DictionaryProperties.subtype]);
                  if (subtype is _PdfName) {
                    attachment.mimeType = subtype._name
                        .replaceAll('#23', '#')
                        .replaceAll('#20', ' ')
                        .replaceAll('#2F', '/');
                  }
                }
                if (fileStream is _PdfDictionary &&
                    fileStream.containsKey(_DictionaryProperties.params)) {
                  final _IPdfPrimitive mParams = _PdfCrossTable._dereference(
                          fileStream[_DictionaryProperties.params])
                      as _PdfDictionary;
                  if (mParams is _PdfDictionary) {
                    final _IPdfPrimitive creationDate =
                        _PdfCrossTable._dereference(
                            mParams[_DictionaryProperties.creationDate]);
                    final _IPdfPrimitive modifiedDate =
                        _PdfCrossTable._dereference(
                            mParams[_DictionaryProperties.modificationDate]);
                    if (creationDate is _PdfString) {
                      attachment.creationDate =
                          mParams._getDateTime(creationDate);
                    }
                    if (modifiedDate is _PdfString) {
                      attachment.modificationDate =
                          mParams._getDateTime(modifiedDate);
                    }
                  }
                }
                if (streamDictionary
                    .containsKey(_DictionaryProperties.afRelationship)) {
                  final _IPdfPrimitive relationShip =
                      _PdfCrossTable._dereference(streamDictionary[
                          _DictionaryProperties.afRelationship]);
                  if (relationShip is _PdfName) {
                    attachment.relationship =
                        _obtainRelationShip(relationShip._name);
                  }
                }
                if (streamDictionary.containsKey('Desc')) {
                  attachment.description =
                      (streamDictionary['Desc'] as _PdfString).value;
                }
              } else {
                attachment = PdfAttachment(
                    (streamDictionary['Desc'] as _PdfString).value,
                    stream._dataStream);
              }
            } else {
              if (streamDictionary.containsKey('Desc')) {
                attachment = PdfAttachment(
                    (streamDictionary['Desc'] as _PdfString).value, []);
              } else {
                attachment = PdfAttachment(
                    (streamDictionary['F'] as _PdfString).value, []);
              }
            }
            _list.add(attachment);
          }
        }
        k = k + 2;
      }
    }
  }

  //Obtain Attachement relation ship
  PdfAttachmentRelationship _obtainRelationShip(String relation) {
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

  //Overrides
  @override
  _IPdfPrimitive get _element => _dictionary;

  @override
  set _element(_IPdfPrimitive value) {
    throw ArgumentError('primitive element can\'t be set');
  }
}
