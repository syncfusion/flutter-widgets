part of pdf;

/// Each instance of this class represents an bookmark node
/// in the bookmark tree.
///
/// ```dart
/// //Create a new document.
/// PdfDocument document = PdfDocument();
/// //Create document bookmarks.
/// PdfBookmark bookmark = document.bookmarks.add('Page 1')
///   ..destination = PdfDestination(document.pages.add(), Offset(20, 20))
///   ..textStyle = [PdfTextStyle.bold]
///   ..color = PdfColor(255, 0, 0);
/// //Save the document.
/// List<int> bytes = document.save();
/// //Dispose the document.
/// document.dispose();
/// ```
class PdfBookmark extends PdfBookmarkBase {
  //Constructor
  /// Initializes a new instance of the [PdfBookmark] class.
  PdfBookmark._internal(String title, PdfBookmarkBase parent,
      PdfBookmark? previous, PdfBookmark? next,
      {bool isExpanded = false,
      PdfColor? color,
      PdfDestination? destination,
      PdfNamedDestination? namedDestination,
      PdfAction? action,
      List<PdfTextStyle>? textStyle})
      : super._internal() {
    _parent = parent;
    _dictionary!
        .setProperty(_DictionaryProperties.parent, _PdfReferenceHolder(parent));
    _previous = previous;
    _next = next;
    this.title = title;
    this.isExpanded = isExpanded;
    if (color != null) {
      this.color = color;
    }
    if (destination != null) {
      this.destination = destination;
    }
    if (namedDestination != null) {
      this.namedDestination = namedDestination;
    }
    if (action != null) {
      this.action = action;
    }
    if (textStyle != null) {
      this.textStyle = textStyle;
    }
  }

  PdfBookmark._load(_PdfDictionary? dictionary, _PdfCrossTable crossTable)
      : super._load(dictionary, crossTable);

  //Fields
  /// Internal variable to store destination.
  PdfDestination? _destination;

  /// Internal variable to store named destination.
  PdfNamedDestination? _namedDestination;

  /// Internal variable to store text Style.
  List<PdfTextStyle> _textStyle = <PdfTextStyle>[PdfTextStyle.regular];

  /// Internal variable to store previous.
  PdfBookmark? _previousBookmark;

  /// Internal variable to store next.
  PdfBookmark? _nextBookmark;

  /// Internal variable to store parent.
  PdfBookmarkBase? _parent;

  /// Internal variable to store color.
  PdfColor _color = PdfColor(0, 0, 0);

  /// Internal variable to store action.
  PdfAction? _action;

  //Properties
  /// Gets or sets the outline destination page.
  ///
  /// ```dart
  /// //Create a new document.
  /// PdfDocument document = PdfDocument();
  /// //Create document bookmarks.
  /// PdfBookmark bookmark = document.bookmarks.add('Page 1')
  ///   //Set the destination page.
  ///   ..destination = PdfDestination(document.pages.add(), Offset(20, 20))
  ///   ..textStyle = [PdfTextStyle.bold]
  ///   ..color = PdfColor(255, 0, 0);
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfDestination? get destination {
    if (_isLoadedBookmark) {
      PdfDestination? destination;
      if (_obtainNamedDestination() == null) {
        destination = _obtainDestination();
      }
      return destination;
    } else {
      return _destination;
    }
  }

  set destination(PdfDestination? value) {
    if (value != null) {
      _destination = value;
      _dictionary!.setProperty(_DictionaryProperties.dest, value);
    }
  }

  /// Gets or sets the named destination in outline.
  ///
  /// ```dart
  /// //Create a new document.
  /// PdfDocument document = PdfDocument();
  /// //Create a named destination.
  /// PdfNamedDestination namedDestination = PdfNamedDestination('Page 1')
  ///   ..destination = PdfDestination(document.pages.add(), Offset(100, 300));
  /// //Add the named destination
  /// document.namedDestinationCollection.add(namedDestination);
  /// //Create document bookmarks.
  /// document.bookmarks.add('Page 1')
  ///   //Set the named destination.
  ///   ..namedDestination = namedDestination
  ///   ..color = PdfColor(255, 0, 0);
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfNamedDestination? get namedDestination {
    if (_isLoadedBookmark) {
      _namedDestination ??= _obtainNamedDestination();
      return _namedDestination;
    } else {
      return _namedDestination;
    }
  }

  set namedDestination(PdfNamedDestination? value) {
    if (value != null && _namedDestination != value) {
      _namedDestination = value;
      final _PdfDictionary dictionary = _PdfDictionary();
      dictionary.setProperty(
          _DictionaryProperties.d, _PdfString(_namedDestination!.title));
      dictionary.setProperty(
          _DictionaryProperties.s, _PdfName(_DictionaryProperties.goTo));
      _dictionary!.setProperty(
          _DictionaryProperties.a, _PdfReferenceHolder(dictionary));
    }
  }

  /// Gets or sets the outline title.
  ///
  /// ```dart
  /// //Create a new document.
  /// PdfDocument document = PdfDocument();
  /// //Create document bookmarks.
  /// document.bookmarks.add('Page 1')
  ///   ..destination = PdfDestination(document.pages.add(), Offset(20, 20))
  ///   ..textStyle = [PdfTextStyle.bold]
  ///   ..color = PdfColor(255, 0, 0)
  ///   //Set the bookmark title.
  ///   ..title = 'Bookmark';
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  String get title {
    if (_isLoadedBookmark) {
      return _obtainTitle();
    } else {
      final _PdfString? title =
          _dictionary![_DictionaryProperties.title] as _PdfString?;
      if (title != null && title.value != null) {
        return title.value!;
      } else {
        return '';
      }
    }
  }

  set title(String value) {
    _dictionary![_DictionaryProperties.title] = _PdfString(value);
  }

  /// Gets or sets the color of bookmark title.
  ///
  /// ```dart
  /// //Create a new document.
  /// PdfDocument document = PdfDocument();
  /// //Create document bookmarks.
  /// document.bookmarks.add('Page 1')
  ///   ..destination = PdfDestination(document.pages.add(), Offset(20, 20))
  ///   ..textStyle = [PdfTextStyle.bold]
  ///   ..color = PdfColor(255, 0, 0)
  ///   ..title = 'Bookmark';
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfColor get color {
    if (_isLoadedBookmark) {
      return _obtainColor();
    } else {
      return _color;
    }
  }

  set color(PdfColor value) {
    if (_isLoadedBookmark) {
      _assignColor(value);
    } else {
      if (_color != value) {
        _color = value;
        _updateColor();
      }
    }
  }

  /// Gets or sets the style of the outline title.
  ///
  /// ```dart
  /// //Create a new document.
  /// PdfDocument document = PdfDocument();
  /// //Create document bookmarks.
  /// document.bookmarks.add('Page 1')
  ///   ..destination = PdfDestination(document.pages.add(), Offset(20, 20))
  ///   ..textStyle = [PdfTextStyle.bold]
  ///   ..color = PdfColor(255, 0, 0)
  ///   ..title = 'Bookmark';
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  List<PdfTextStyle> get textStyle {
    if (_isLoadedBookmark) {
      return <PdfTextStyle>[_obtainTextStyle()];
    } else {
      return _textStyle;
    }
  }

  set textStyle(List<PdfTextStyle> value) {
    if (_isLoadedBookmark) {
      _assignTextStyle(value);
    } else {
      if (_textStyle != value) {
        _textStyle = value;
        _updateTextStyle();
      }
    }
  }

  /// Gets or sets the action for the outline.
  ///
  /// ```dart
  /// //Create a new document.
  /// PdfDocument document = PdfDocument();
  /// //Create document bookmarks.
  /// document.bookmarks.add('Page 1')
  ///   ..destination = PdfDestination(document.pages.add(), Offset(20, 20))
  ///   ..textStyle = [PdfTextStyle.bold]
  ///   ..color = PdfColor(255, 0, 0)
  ///   //Set the bookmark action.
  ///   ..action = PdfUriAction('http://www.google.com');
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfAction? get action => _action;
  set action(PdfAction? value) {
    if (value != null && _action != value) {
      _action = value;
      _dictionary!.setProperty(
          _DictionaryProperties.a, _PdfReferenceHolder(_action!._dictionary));
    }
  }

  /// Gets or sets whether to expand the node or not.
  ///
  /// ```dart
  /// //Create a new document.
  /// PdfDocument document = PdfDocument();
  /// //Create document bookmarks.
  /// PdfBookmark bookmark = document.bookmarks.add('Page 1')
  ///   ..destination = PdfDestination(document.pages.add(), Offset(20, 20))
  ///   ..textStyle = [PdfTextStyle.bold]
  ///   ..color = PdfColor(255, 0, 0);
  /// //Get if is expanded.
  /// bool expand = bookmark.isExpanded;
  /// //Save the document.
  /// List<int> bytes = document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  bool get isExpanded => super._isExpanded;
  set isExpanded(bool value) {
    super._isExpanded = value;
  }

  PdfBookmark? get _previous {
    if (_isLoadedBookmark) {
      return _obtainPrevious();
    } else {
      return _previousBookmark;
    }
  }

  set _previous(PdfBookmark? value) {
    if (_previousBookmark != value) {
      _previousBookmark = value;
      _dictionary!
          .setProperty(_DictionaryProperties.prev, _PdfReferenceHolder(value));
    }
  }

  /// Gets the next outline object.
  PdfBookmark? get _next {
    if (_isLoadedBookmark) {
      return _obtainNext();
    } else {
      return _nextBookmark;
    }
  }

  /// Sets the next outline object.
  set _next(PdfBookmark? value) {
    if (_nextBookmark != value) {
      _nextBookmark = value;
      _dictionary!
          .setProperty(_DictionaryProperties.next, _PdfReferenceHolder(value));
    }
  }

  //Implementations
  @override
  List<PdfBookmarkBase> get _list {
    final List<PdfBookmarkBase> list = super._list;
    if (_isLoadedBookmark) {
      if (list.isEmpty) {
        _reproduceTree();
      }
      return list;
    } else {
      return list;
    }
  }

  void _updateColor() {
    final _PdfArray? array =
        _dictionary![_DictionaryProperties.c] as _PdfArray?;
    if (array != null && _color.isEmpty) {
      _dictionary!.remove(_DictionaryProperties.c);
    } else {
      _dictionary![_DictionaryProperties.c] =
          _color._toArray(PdfColorSpace.rgb);
    }
  }

  /// Updates the outline text style.
  void _updateTextStyle() {
    if (_textStyle.length == 1 && _textStyle[0] == PdfTextStyle.regular) {
      _dictionary!.remove(_DictionaryProperties.f);
    } else {
      int value = 0;
      for (int i = 0; i < _textStyle.length; i++) {
        value |= _textStyle[i].index;
      }
      _dictionary![_DictionaryProperties.f] = _PdfNumber(value);
    }
  }

  void _setParent(PdfBookmarkBase parent) {
    _parent = parent;
  }

  String _obtainTitle() {
    String title = '';
    if (_dictionary!.containsKey(_DictionaryProperties.title)) {
      final _PdfString? str =
          _PdfCrossTable._dereference(_dictionary![_DictionaryProperties.title])
              as _PdfString?;
      if (str != null && str.value != null) {
        title = str.value!;
      }
    }
    return title;
  }

  PdfColor _obtainColor() {
    PdfColor color = PdfColor(0, 0, 0);
    if (_dictionary!.containsKey(_DictionaryProperties.c)) {
      final _PdfArray? colours =
          _PdfCrossTable._dereference(_dictionary![_DictionaryProperties.c])
              as _PdfArray?;
      if (colours != null && colours.count > 2) {
        double? red = 0;
        double green = 0;
        double blue = 0;
        _PdfNumber? colorValue =
            _PdfCrossTable._dereference(colours[0]) as _PdfNumber?;
        if (colorValue != null) {
          red = colorValue.value as double?;
        }
        colorValue = _PdfCrossTable._dereference(colours[1]) as _PdfNumber?;
        if (colorValue != null) {
          green = colorValue.value!.toDouble();
        }
        colorValue = _PdfCrossTable._dereference(colours[2]) as _PdfNumber?;
        if (colorValue != null) {
          blue = colorValue.value!.toDouble();
        }
        color = PdfColor(red!.toInt(), green.toInt(), blue.toInt());
      }
    }
    return color;
  }

  PdfTextStyle _obtainTextStyle() {
    PdfTextStyle style = PdfTextStyle.regular;
    if (_dictionary!.containsKey(_DictionaryProperties.f)) {
      final _PdfNumber? flag =
          _PdfCrossTable._dereference(_dictionary![_DictionaryProperties.f])
              as _PdfNumber?;
      int flagValue = 0;
      if (flag != null) {
        flagValue = flag.value!.toInt() - 1;
      }
      style = PdfTextStyle.values.elementAt(flagValue);
    }
    return style;
  }

  PdfBookmark? _obtainNext() {
    PdfBookmark? nextBookmark;
    int index = _parent!._list.indexOf(this);
    ++index;
    if (index < _parent!._list.length) {
      nextBookmark = _parent!._list[index] as PdfBookmark?;
    } else {
      if (_dictionary!.containsKey(_DictionaryProperties.next)) {
        final _PdfDictionary? next =
            _crossTable._getObject(_dictionary![_DictionaryProperties.next])
                as _PdfDictionary?;
        nextBookmark = PdfBookmark._load(next, _crossTable);
      }
    }
    return nextBookmark;
  }

  PdfBookmark? _obtainPrevious() {
    PdfBookmark? prevBookmark;
    int index = _bookmarkList.indexOf(this);
    --index;
    if (index >= 0) {
      prevBookmark = _bookmarkList[index] as PdfBookmark?;
    } else {
      if (_dictionary!.containsKey(_DictionaryProperties.prev)) {
        final _PdfDictionary? prev =
            _crossTable._getObject(_dictionary![_DictionaryProperties.prev])
                as _PdfDictionary?;
        prevBookmark = PdfBookmark._load(prev, _crossTable);
      }
    }
    return prevBookmark;
  }

  void _assignColor(PdfColor color) {
    final List<double> rgb = <double>[
      color._red.toDouble(),
      color._green.toDouble(),
      color._blue.toDouble()
    ];
    final _PdfArray colors = _PdfArray(rgb);
    _dictionary!.setProperty(_DictionaryProperties.c, colors);
  }

  void _assignTextStyle(List<PdfTextStyle> value) {
    for (final PdfTextStyle v in value) {
      int style = PdfTextStyle.values.indexOf(_obtainTextStyle());
      style |= PdfTextStyle.values.indexOf(v);
      _dictionary!._setNumber(_DictionaryProperties.f, style);
    }
  }

  PdfNamedDestination? _obtainNamedDestination() {
    final PdfDocument? loadedDocument = _crossTable._document;
    PdfNamedDestinationCollection? namedCollection;
    if (loadedDocument != null) {
      namedCollection = loadedDocument.namedDestinationCollection;
    }
    PdfNamedDestination? namedDestination;
    _IPdfPrimitive? destination;
    if (namedCollection != null) {
      if (_dictionary!.containsKey(_DictionaryProperties.a)) {
        final _PdfDictionary? action =
            _PdfCrossTable._dereference(_dictionary![_DictionaryProperties.a])
                as _PdfDictionary?;
        if (action != null && action.containsKey(_DictionaryProperties.d)) {
          destination =
              _PdfCrossTable._dereference(action[_DictionaryProperties.d]);
        }
      } else if (_dictionary!.containsKey(_DictionaryProperties.dest)) {
        destination =
            _crossTable._getObject(_dictionary![_DictionaryProperties.dest]);
      }

      if (destination != null) {
        final _PdfName? name = (destination is _PdfName) ? destination : null;
        final _PdfString? str =
            (destination is _PdfString) ? destination : null;
        String? title;
        if (name != null) {
          title = name._name;
        } else if (str != null) {
          title = str.value;
        }
        if (title != null) {
          for (int i = 0; i < namedCollection.count; i++) {
            final PdfNamedDestination nameDest = namedCollection[i];
            if (nameDest.title == title) {
              namedDestination = nameDest;
              break;
            }
          }
        }
      }
    }
    return namedDestination;
  }

  PdfDestination? _obtainDestination() {
    if (_dictionary!.containsKey(_DictionaryProperties.dest) &&
        (_destination == null)) {
      final _IPdfPrimitive? obj =
          _crossTable._getObject(_dictionary![_DictionaryProperties.dest]);
      _PdfArray? array = obj as _PdfArray?;
      final _PdfName? name = (obj is _PdfName) ? obj as _PdfName? : null;
      final PdfDocument? ldDoc = _crossTable._document;

      if (ldDoc != null) {
        if (name != null) {
          array = ldDoc._getNamedDestination(name);
        }
      }

      if (array != null) {
        final _PdfReferenceHolder? holder = array[0] as _PdfReferenceHolder?;
        PdfPage? page;
        if (holder != null) {
          final _PdfDictionary? dic =
              _crossTable._getObject(holder) as _PdfDictionary?;
          if (ldDoc != null && dic != null) {
            page = ldDoc.pages._getPage(dic);
          }
          _PdfName? mode;
          if (array.count > 1) {
            mode = array[1]! as _PdfName;
          }
          if (mode != null) {
            if (mode._name == _DictionaryProperties.xyz) {
              _PdfNumber? left;
              _PdfNumber? top;
              if (array.count > 2) {
                left = array[2]! as _PdfNumber;
              }
              if (array.count > 3) {
                top = array[3]! as _PdfNumber;
              }
              _PdfNumber? zoom;
              if (array.count > 4) {
                zoom = array[4]! as _PdfNumber;
              }

              if (page != null) {
                final double topValue =
                    (top == null) ? 0 : page.size.height - top.value!;
                final double leftValue =
                    (left == null) ? 0 : left.value! as double;
                _destination =
                    PdfDestination(page, Offset(leftValue, topValue));
                if (zoom != null) {
                  _destination!.zoom = zoom.value!.toDouble();
                }
              }
            } else {
              if (mode._name == _DictionaryProperties.fitR) {
                _PdfNumber? left;
                _PdfNumber? bottom;
                _PdfNumber? right;
                _PdfNumber? top;
                if (array.count > 2) {
                  left = array[2]! as _PdfNumber;
                }
                if (array.count > 3) {
                  bottom = array[3]! as _PdfNumber;
                }
                if (array.count > 4) {
                  right = array[4]! as _PdfNumber;
                }
                if (array.count > 5) {
                  top = array[5]! as _PdfNumber;
                }

                if (page != null) {
                  left = (left == null) ? _PdfNumber(0) : left;
                  bottom = (bottom == null) ? _PdfNumber(0) : bottom;
                  right = (right == null) ? _PdfNumber(0) : right;
                  top = (top == null) ? _PdfNumber(0) : top;

                  _destination = PdfDestination._(
                      page,
                      _Rectangle(
                          left.value!.toDouble(),
                          bottom.value!.toDouble(),
                          right.value!.toDouble(),
                          top.value!.toDouble()));
                  _destination!.mode = PdfDestinationMode.fitR;
                }
              } else if (mode._name == _DictionaryProperties.fitBH ||
                  mode._name == _DictionaryProperties.fitH) {
                _PdfNumber? top;
                if (array.count >= 3) {
                  top = array[2]! as _PdfNumber;
                }
                if (page != null) {
                  final double topValue =
                      (top == null) ? 0 : page.size.height - top.value!;
                  _destination = PdfDestination(page, Offset(0, topValue));
                  _destination!.mode = PdfDestinationMode.fitH;
                }
              } else {
                if (page != null && mode._name == _DictionaryProperties.fit) {
                  _destination = PdfDestination(page);
                  _destination!.mode = PdfDestinationMode.fitToPage;
                }
              }
            }
          } else {
            if (page != null) {
              _destination = PdfDestination(page);
              _destination!.mode = PdfDestinationMode.fitToPage;
            }
          }
        }
      }
    } else if (_dictionary!.containsKey(_DictionaryProperties.a) &&
        (_destination == null)) {
      _IPdfPrimitive? obj =
          _crossTable._getObject(_dictionary![_DictionaryProperties.a]);
      _PdfDictionary? destDic;
      if (obj is _PdfDictionary) {
        destDic = obj;
      }
      if (destDic != null) {
        obj = destDic[_DictionaryProperties.d];
      }
      if (obj is _PdfReferenceHolder) {
        obj = obj._object;
      }
      _PdfArray? array = (obj is _PdfArray) ? obj : null;
      final _PdfName? name = (obj is _PdfName) ? obj : null;
      final PdfDocument? ldDoc = _crossTable._document;
      if (ldDoc != null) {
        if (name != null) {
          array = ldDoc._getNamedDestination(name);
        }
      }
      if (array != null) {
        final _PdfReferenceHolder? holder = array[0] as _PdfReferenceHolder?;
        PdfPage? page;
        if (holder != null) {
          final _PdfDictionary? dic =
              _crossTable._getObject(holder) as _PdfDictionary?;
          if (dic != null && ldDoc != null) {
            page = ldDoc.pages._getPage(dic);
          }
        }

        _PdfName? mode;
        if (array.count > 1) {
          mode = array[1]! as _PdfName;
        }
        if (mode != null) {
          if (mode._name == _DictionaryProperties.fitBH ||
              mode._name == _DictionaryProperties.fitH) {
            _PdfNumber? top;
            if (array.count >= 3) {
              top = array[2]! as _PdfNumber;
            }
            if (page != null) {
              final double topValue =
                  (top == null) ? 0 : page.size.height - top.value!;
              _destination = PdfDestination(page, Offset(0, topValue));
              _destination!.mode = PdfDestinationMode.fitH;
            }
          } else if (mode._name == _DictionaryProperties.xyz) {
            _PdfNumber? left;
            _PdfNumber? top;
            if (array.count > 2) {
              left = array[2]! as _PdfNumber;
            }
            if (array.count > 3) {
              top = array[3]! as _PdfNumber;
            }
            _PdfNumber? zoom;
            if (array.count > 4 && (array[4] is _PdfNumber)) {
              zoom = array[4]! as _PdfNumber;
            }

            if (page != null) {
              final double topValue =
                  (top == null) ? 0 : page.size.height - top.value!;
              final double leftValue =
                  (left == null) ? 0 : left.value! as double;
              _destination = PdfDestination(page, Offset(leftValue, topValue));
              if (zoom != null) {
                _destination!.zoom = zoom.value!.toDouble();
              }
            }
          } else {
            if (page != null && mode._name == _DictionaryProperties.fit) {
              _destination = PdfDestination(page);
              _destination!.mode = PdfDestinationMode.fitToPage;
            }
          }
        } else {
          if (page != null) {
            _destination = PdfDestination(page);
            _destination!.mode = PdfDestinationMode.fitToPage;
          }
        }
      }
    }
    return _destination;
  }
}
