import 'dart:ui';

import '../../../interfaces/pdf_interface.dart';
import '../../actions/pdf_action.dart';
import '../../drawing/drawing.dart';
import '../../general/enum.dart';
import '../../general/pdf_destination.dart';
import '../../general/pdf_named_destination.dart';
import '../../general/pdf_named_destination_collection.dart';
import '../../graphics/pdf_color.dart';
import '../../io/pdf_constants.dart';
import '../../io/pdf_cross_table.dart';
import '../../pages/pdf_page.dart';
import '../../pages/pdf_page_collection.dart';
import '../../pdf_document/pdf_document.dart';
import '../../primitives/pdf_array.dart';
import '../../primitives/pdf_dictionary.dart';
import '../../primitives/pdf_name.dart';
import '../../primitives/pdf_number.dart';
import '../../primitives/pdf_reference_holder.dart';
import '../../primitives/pdf_string.dart';
import 'enums.dart';

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
/// List<int> bytes = await document.save();
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
    _helper.dictionary!.setProperty(
        PdfDictionaryProperties.parent, PdfReferenceHolder(parent));
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

  PdfBookmark._load(super.dictionary, PdfCrossTable super.crossTable)
      : super._load();

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

  /// Internal variable to store color.
  PdfColor _color = PdfColor(0, 0, 0);

  /// Internal variable to store action.
  PdfAction? _action;

  /// Internal variable to store RegExp.
  final RegExp _regex = RegExp(r'[\u0080-\u00FF]');

  /// Internal variable to store byte value.
  final List<int> _pdfEncodingByteToChar = <int>[
    0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20,
    21,
    22,
    23,
    24,
    25,
    26,
    27,
    28,
    29,
    30,
    31,
    32,
    33,
    34,
    35,
    36,
    37,
    38,
    39,
    40,
    41,
    42,
    43,
    44,
    45,
    46,
    47,
    48,
    49,
    50,
    51,
    52,
    53,
    54,
    55,
    56,
    57,
    58,
    59,
    60,
    61,
    62,
    63,
    64,
    65,
    66,
    67,
    68,
    69,
    70,
    71,
    72,
    73,
    74,
    75,
    76,
    77,
    78,
    79,
    80,
    81,
    82,
    83,
    84,
    85,
    86,
    87,
    88,
    89,
    90,
    91,
    92,
    93,
    94,
    95,
    96,
    97,
    98,
    99,
    100,
    101,
    102,
    103,
    104,
    105,
    106,
    107,
    108,
    109,
    110,
    111,
    112,
    113,
    114,
    115,
    116,
    117,
    118,
    119,
    120,
    121,
    122,
    123,
    124,
    125,
    126,
    127,
    0x2022,
    0x2020,
    0x2021,
    0x2026,
    0x2014,
    0x2013,
    0x0192,
    0x2044,
    0x2039,
    0x203a,
    0x2212,
    0x2030,
    0x201e,
    0x201c,
    0x201d,
    0x2018,
    0x2019,
    0x201a,
    0x2122,
    0xfb01,
    0xfb02,
    0x0141,
    0x0152,
    0x0160,
    0x0178,
    0x017d,
    0x0131,
    0x0142,
    0x0153,
    0x0161,
    0x017e,
    65533,
    0x20ac,
    161,
    162,
    163,
    164,
    165,
    166,
    167,
    168,
    169,
    170,
    171,
    172,
    173,
    174,
    175,
    176,
    177,
    178,
    179,
    180,
    181,
    182,
    183,
    184,
    185,
    186,
    187,
    188,
    189,
    190,
    191,
    192,
    193,
    194,
    195,
    196,
    197,
    198,
    199,
    200,
    201,
    202,
    203,
    204,
    205,
    206,
    207,
    208,
    209,
    210,
    211,
    212,
    213,
    214,
    215,
    216,
    217,
    218,
    219,
    220,
    221,
    222,
    223,
    224,
    225,
    226,
    227,
    228,
    229,
    230,
    231,
    232,
    233,
    234,
    235,
    236,
    237,
    238,
    239,
    240,
    241,
    242,
    243,
    244,
    245,
    246,
    247,
    248,
    249,
    250,
    251,
    252,
    253,
    254,
    255
  ];

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
  /// List<int> bytes = await document.save();
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
      _helper.dictionary!.setProperty(PdfDictionaryProperties.dest, value);
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
  /// List<int> bytes = await document.save();
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
      final PdfDictionary dictionary = PdfDictionary();
      dictionary.setProperty(
          PdfDictionaryProperties.d, PdfString(_namedDestination!.title));
      dictionary.setProperty(
          PdfDictionaryProperties.s, PdfName(PdfDictionaryProperties.goTo));
      dictionary.setProperty(
          PdfDictionaryProperties.a, PdfReferenceHolder(dictionary));
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
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  String get title {
    if (_isLoadedBookmark) {
      return _obtainTitle();
    } else {
      final PdfString? title =
          _helper.dictionary![PdfDictionaryProperties.title] as PdfString?;
      if (title != null && title.value != null) {
        return title.value!;
      } else {
        return '';
      }
    }
  }

  set title(String value) {
    _helper.dictionary![PdfDictionaryProperties.title] = PdfString(value);
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
  /// List<int> bytes = await document.save();
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
  /// List<int> bytes = await document.save();
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
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfAction? get action => _action;
  set action(PdfAction? value) {
    if (value != null && _action != value) {
      _action = value;
      _helper.dictionary!.setProperty(PdfDictionaryProperties.a,
          PdfReferenceHolder(PdfActionHelper.getHelper(_action!).dictionary));
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
  /// List<int> bytes = await document.save();
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
      _helper.dictionary!
          .setProperty(PdfDictionaryProperties.prev, PdfReferenceHolder(value));
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
      _helper.dictionary!
          .setProperty(PdfDictionaryProperties.next, PdfReferenceHolder(value));
    }
  }

  //Implementations
  @override
  List<PdfBookmarkBase> get _list {
    final List<PdfBookmarkBase> list = super._list;
    if (_isLoadedBookmark) {
      if (list.isEmpty) {
        _helper.reproduceTree();
      }
      return list;
    } else {
      return list;
    }
  }

  void _updateColor() {
    final PdfArray? array =
        _helper.dictionary![PdfDictionaryProperties.c] as PdfArray?;
    if (array != null && _color.isEmpty) {
      _helper.dictionary!.remove(PdfDictionaryProperties.c);
    } else {
      _helper.dictionary![PdfDictionaryProperties.c] =
          PdfColorHelper.toArray(_color);
    }
  }

  /// Updates the outline text style.
  void _updateTextStyle() {
    if (_textStyle.length == 1 && _textStyle[0] == PdfTextStyle.regular) {
      _helper.dictionary!.remove(PdfDictionaryProperties.f);
    } else {
      int value = 0;
      for (int i = 0; i < _textStyle.length; i++) {
        value |= _textStyle[i].index;
      }
      _helper.dictionary![PdfDictionaryProperties.f] = PdfNumber(value);
    }
  }

  String _obtainTitle() {
    String title = '';
    if (_helper.dictionary!.containsKey(PdfDictionaryProperties.title)) {
      final PdfString? str = PdfCrossTable.dereference(
          _helper.dictionary![PdfDictionaryProperties.title]) as PdfString?;
      if (str != null && str.value != null) {
        title = str.value!;
        if (_regex.hasMatch(title)) {
          for (int i = 0; i < title.length; i++) {
            if (_regex.hasMatch(title[i])) {
              title = title.replaceAll(
                  title[i],
                  String.fromCharCode(
                      _pdfEncodingByteToChar[title.codeUnitAt(i) & 0xff]));
            }
          }
        }
      }
    }
    return title;
  }

  PdfColor _obtainColor() {
    PdfColor color = PdfColor(0, 0, 0);
    if (_helper.dictionary!.containsKey(PdfDictionaryProperties.c)) {
      final PdfArray? colours = PdfCrossTable.dereference(
          _helper.dictionary![PdfDictionaryProperties.c]) as PdfArray?;
      if (colours != null && colours.count > 2) {
        double? red = 0;
        double green = 0;
        double blue = 0;
        PdfNumber? colorValue =
            PdfCrossTable.dereference(colours[0]) as PdfNumber?;
        if (colorValue != null) {
          red = colorValue.value as double?;
        }
        colorValue = PdfCrossTable.dereference(colours[1]) as PdfNumber?;
        if (colorValue != null) {
          green = colorValue.value!.toDouble();
        }
        colorValue = PdfCrossTable.dereference(colours[2]) as PdfNumber?;
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
    if (_helper.dictionary!.containsKey(PdfDictionaryProperties.f)) {
      final PdfNumber? flag = PdfCrossTable.dereference(
          _helper.dictionary![PdfDictionaryProperties.f]) as PdfNumber?;
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
      if (_helper.dictionary!.containsKey(PdfDictionaryProperties.next)) {
        final PdfDictionary? next = _helper._crossTable
                .getObject(_helper.dictionary![PdfDictionaryProperties.next])
            as PdfDictionary?;
        nextBookmark = PdfBookmark._load(next, _helper._crossTable);
      }
    }
    return nextBookmark;
  }

  PdfBookmark? _obtainPrevious() {
    PdfBookmark? prevBookmark;
    int index = _helper._bookmarkList.indexOf(this);
    --index;
    if (index >= 0) {
      prevBookmark = _helper._bookmarkList[index] as PdfBookmark?;
    } else {
      if (_helper.dictionary!.containsKey(PdfDictionaryProperties.prev)) {
        final PdfDictionary? prev = _helper._crossTable
                .getObject(_helper.dictionary![PdfDictionaryProperties.prev])
            as PdfDictionary?;
        prevBookmark = PdfBookmark._load(prev, _helper._crossTable);
      }
    }
    return prevBookmark;
  }

  void _assignColor(PdfColor color) {
    final List<double> rgb = <double>[
      color.r.toDouble(),
      color.g.toDouble(),
      color.b.toDouble()
    ];
    final PdfArray colors = PdfArray(rgb);
    _helper.dictionary!.setProperty(PdfDictionaryProperties.c, colors);
  }

  void _assignTextStyle(List<PdfTextStyle> value) {
    for (final PdfTextStyle v in value) {
      int style = PdfTextStyle.values.indexOf(_obtainTextStyle());
      style |= PdfTextStyle.values.indexOf(v);
      _helper.dictionary!.setNumber(PdfDictionaryProperties.f, style);
    }
  }

  PdfNamedDestination? _obtainNamedDestination() {
    final PdfDocument? loadedDocument = _helper._crossTable.document;
    PdfNamedDestinationCollection? namedCollection;
    if (loadedDocument != null) {
      namedCollection = loadedDocument.namedDestinationCollection;
    }
    PdfNamedDestination? namedDestination;
    IPdfPrimitive? destination;
    if (namedCollection != null) {
      if (_helper.dictionary!.containsKey(PdfDictionaryProperties.a)) {
        final PdfDictionary? action = PdfCrossTable.dereference(
            _helper.dictionary![PdfDictionaryProperties.a]) as PdfDictionary?;
        if (action != null && action.containsKey(PdfDictionaryProperties.d)) {
          destination =
              PdfCrossTable.dereference(action[PdfDictionaryProperties.d]);
        }
      } else if (_helper.dictionary!
          .containsKey(PdfDictionaryProperties.dest)) {
        destination = _helper._crossTable
            .getObject(_helper.dictionary![PdfDictionaryProperties.dest]);
      }

      if (destination != null) {
        final PdfName? name = (destination is PdfName) ? destination : null;
        final PdfString? str = (destination is PdfString) ? destination : null;
        String? title;
        if (name != null) {
          title = name.name;
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
    if (_helper.dictionary!.containsKey(PdfDictionaryProperties.dest) &&
        (_destination == null)) {
      final IPdfPrimitive? obj = _helper._crossTable
          .getObject(_helper.dictionary![PdfDictionaryProperties.dest]);
      PdfArray? array = obj as PdfArray?;
      final PdfName? name = (obj is PdfName) ? obj as PdfName? : null;
      final PdfDocument? ldDoc = _helper._crossTable.document;

      if (ldDoc != null) {
        if (name != null) {
          array = PdfDocumentHelper.getHelper(ldDoc).getNamedDestination(name);
        }
      }

      if (array != null) {
        final IPdfPrimitive? holder = array[0];
        PdfPage? page;
        if (holder != null && holder is PdfReferenceHolder) {
          final IPdfPrimitive? dic = _helper._crossTable.getObject(holder);
          if (ldDoc != null && dic != null && dic is PdfDictionary) {
            page = PdfPageCollectionHelper.getHelper(ldDoc.pages).getPage(dic);
          }
          IPdfPrimitive? mode;
          if (array.count > 1) {
            mode = array[1];
          }
          if (mode != null && mode is PdfName) {
            if (mode.name == PdfDictionaryProperties.xyz) {
              IPdfPrimitive? left;
              IPdfPrimitive? top;
              if (array.count > 2) {
                left = array[2];
              }
              if (array.count > 3) {
                top = array[3];
              }
              IPdfPrimitive? zoom;
              if (array.count > 4) {
                zoom = array[4];
              }
              if (page != null) {
                final double topValue = (top != null && top is PdfNumber)
                    ? page.size.height - top.value!
                    : 0;
                final double leftValue = (left != null && left is PdfNumber)
                    ? left.value! as double
                    : 0;
                _destination =
                    PdfDestination(page, Offset(leftValue, topValue));
                _destination!.zoom = (zoom != null && zoom is PdfNumber)
                    ? zoom.value!.toDouble()
                    : 0;
              }
            } else {
              if (mode.name == PdfDictionaryProperties.fitR) {
                IPdfPrimitive? left;
                IPdfPrimitive? bottom;
                IPdfPrimitive? right;
                IPdfPrimitive? top;
                if (array.count > 2) {
                  left = array[2];
                }
                if (array.count > 3) {
                  bottom = array[3];
                }
                if (array.count > 4) {
                  right = array[4];
                }
                if (array.count > 5) {
                  top = array[5];
                }
                if (page != null) {
                  _destination = PdfDestinationHelper.getDestination(
                      page,
                      PdfRectangle(
                          (left != null && left is PdfNumber)
                              ? left.value!.toDouble()
                              : 0,
                          (bottom != null && bottom is PdfNumber)
                              ? bottom.value!.toDouble()
                              : 0,
                          (right != null && right is PdfNumber)
                              ? right.value!.toDouble()
                              : 0,
                          (top != null && top is PdfNumber)
                              ? top.value!.toDouble()
                              : 0));
                  _destination!.mode = PdfDestinationMode.fitR;
                }
              } else if (mode.name == PdfDictionaryProperties.fitBH ||
                  mode.name == PdfDictionaryProperties.fitH) {
                IPdfPrimitive? top;
                if (array.count >= 3) {
                  top = array[2];
                }
                if (page != null) {
                  final double topValue = (top != null && top is PdfNumber)
                      ? page.size.height - top.value!
                      : 0;
                  _destination = PdfDestination(page, Offset(0, topValue));
                  _destination!.mode = PdfDestinationMode.fitH;
                }
              } else {
                if (page != null && mode.name == PdfDictionaryProperties.fit) {
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
    } else if (_helper.dictionary!.containsKey(PdfDictionaryProperties.a) &&
        (_destination == null)) {
      IPdfPrimitive? obj = _helper._crossTable
          .getObject(_helper.dictionary![PdfDictionaryProperties.a]);
      PdfDictionary? destDic;
      if (obj is PdfDictionary) {
        destDic = obj;
      }
      if (destDic != null) {
        obj = destDic[PdfDictionaryProperties.d];
      }
      if (obj is PdfReferenceHolder) {
        obj = obj.object;
      }
      PdfArray? array = (obj is PdfArray) ? obj : null;
      final PdfName? name = (obj is PdfName) ? obj : null;
      final PdfDocument? ldDoc = _helper._crossTable.document;
      if (ldDoc != null) {
        if (name != null) {
          array = PdfDocumentHelper.getHelper(ldDoc).getNamedDestination(name);
        }
      }
      if (array != null) {
        final IPdfPrimitive? holder = array[0];
        PdfPage? page;
        if (holder != null && holder is PdfReferenceHolder) {
          final IPdfPrimitive? dic = _helper._crossTable.getObject(holder);
          if (dic != null && ldDoc != null && dic is PdfDictionary) {
            page = PdfPageCollectionHelper.getHelper(ldDoc.pages).getPage(dic);
          }
        }
        IPdfPrimitive? mode;
        if (array.count > 1) {
          mode = array[1];
        }
        if (mode != null && mode is PdfName) {
          if (mode.name == PdfDictionaryProperties.fitBH ||
              mode.name == PdfDictionaryProperties.fitH) {
            IPdfPrimitive? top;
            if (array.count >= 3) {
              top = array[2];
            }
            if (page != null) {
              final double topValue = (top != null && top is PdfNumber)
                  ? page.size.height - top.value!
                  : 0;
              _destination = PdfDestination(page, Offset(0, topValue));
              _destination!.mode = PdfDestinationMode.fitH;
            }
          } else if (mode.name == PdfDictionaryProperties.xyz) {
            IPdfPrimitive? left;
            IPdfPrimitive? top;
            if (array.count > 2) {
              left = array[2];
            }
            if (array.count > 3) {
              top = array[3];
            }
            IPdfPrimitive? zoom;
            if (array.count > 4) {
              zoom = array[4];
            }
            if (page != null) {
              final double topValue = (top != null && top is PdfNumber)
                  ? page.size.height - top.value!
                  : 0;
              final double leftValue = (left != null && left is PdfNumber)
                  ? left.value! as double
                  : 0;
              _destination = PdfDestination(page, Offset(leftValue, topValue));
              _destination!.zoom = (zoom != null && zoom is PdfNumber)
                  ? zoom.value!.toDouble()
                  : 0;
            }
          } else {
            if (page != null && mode.name == PdfDictionaryProperties.fit) {
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

/// This class plays two roles: it's a base class for all bookmarks
/// and it's a root of a bookmarks tree.
///
/// ```dart
/// //Load the PDF document.
/// PdfDocument document = PdfDocument(inputBytes: inputBytes);
/// //Get the bookmark from index.
/// PdfBookmark bookmarks = document.bookmarks[0]
///   ..destination = PdfDestination(document.pages[1])
///   ..color = PdfColor(0, 255, 0)
///   ..textStyle = [PdfTextStyle.bold]
///   ..title = 'Changed title';
/// //Save the document.
/// List<int> bytes = await document.save();
/// //Dispose the document.
/// document.dispose();
/// ```
class PdfBookmarkBase implements IPdfWrapper {
  //Constructor
  /// Initializes a new instance of the [PdfBookmarkBase] class.
  PdfBookmarkBase._internal() : super() {
    _helper = PdfBookmarkBaseHelper(this);
  }

  PdfBookmarkBase._load(PdfDictionary? dictionary, PdfCrossTable? crossTable) {
    _helper = PdfBookmarkBaseHelper(this);
    _isLoadedBookmark = true;
    _helper.dictionary = dictionary;
    if (crossTable != null) {
      _helper._crossTable = crossTable;
    }
  }

  //Fields
  late PdfBookmarkBaseHelper _helper;

  /// Internal variable to store parent.
  PdfBookmarkBase? _parent;

  /// Internal variable to store loaded bookmark.
  List<PdfBookmark>? _bookmark;

  /// Whether the bookmark tree is expanded or not
  bool _expanded = false;
  List<PdfBookmarkBase>? _booklist;
  bool _isLoadedBookmark = false;

  //Properties
  /// Gets number of the elements in the collection. Read-Only.
  ///
  /// ```dart
  /// //Load the PDF document.
  /// PdfDocument document = PdfDocument(inputBytes: inputBytes);
  /// //get the bookmark count.
  /// int count = document.bookmarks.count;
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  int get count {
    final PdfDocument? document = _helper._crossTable.document;
    if (document != null) {
      if (_booklist == null) {
        _booklist = <PdfBookmarkBase>[];
        for (int n = 0; n < _list.length; n++) {
          _booklist!.add(_list[n]);
        }
      }
      return _list.length;
    } else {
      return _list.length;
    }
  }

  /// Gets the bookmark at specified index.
  ///
  /// ```dart
  /// //Load the PDF document.
  /// PdfDocument document = PdfDocument(inputBytes: inputBytes);
  /// //Get the bookmark from index.
  /// PdfBookmark bookmarks = document.bookmarks[0]
  ///   ..destination = PdfDestination(document.pages[1])
  ///   ..color = PdfColor(0, 255, 0)
  ///   ..textStyle = [PdfTextStyle.bold]
  ///   ..title = 'Changed title';
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfBookmark operator [](int index) {
    if (index < 0 || index >= count) {
      throw RangeError('index');
    }
    return _list[index] as PdfBookmark;
  }

  /// Gets whether to expand the node or not
  bool get _isExpanded {
    if (_helper.dictionary!.containsKey('Count')) {
      final PdfNumber number =
          _helper.dictionary![PdfDictionaryProperties.count]! as PdfNumber;
      return !(number.value! < 0);
    } else {
      return _expanded;
    }
  }

  /// Sets whether to expand the node or not
  set _isExpanded(bool value) {
    _expanded = value;
    if (count > 0) {
      final int newCount = _expanded ? _list.length : -_list.length;
      _helper.dictionary![PdfDictionaryProperties.count] = PdfNumber(newCount);
    }
  }

  //Public methods
  /// Adds the bookmark from the document.
  ///
  /// ```dart
  /// //Create a new document.
  /// PdfDocument document = PdfDocument();
  /// //Add bookmarks to the document.
  /// document.bookmarks.add('Page 1')
  ///   ..destination = PdfDestination(document.pages.add(), Offset(20, 20))
  ///   ..textStyle = [PdfTextStyle.bold]
  ///   ..color = PdfColor(255, 0, 0);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfBookmark add(String title,
      {bool isExpanded = false,
      PdfColor? color,
      PdfDestination? destination,
      PdfNamedDestination? namedDestination,
      PdfAction? action,
      List<PdfTextStyle>? textStyle}) {
    final PdfBookmark? previous = (count < 1) ? null : this[count - 1];
    final PdfBookmark outline =
        PdfBookmark._internal(title, this, previous, null);
    if (previous != null) {
      previous._next = outline;
    }
    _list.add(outline);
    _updateFields();
    return outline;
  }

  /// Determines whether the specified outline presents in the collection.
  /// ```dart
  /// //Create a new document.
  /// PdfDocument document = PdfDocument();
  /// //Add bookmarks to the document.
  /// PdfBookmark bookmark = document.bookmarks.add('Page 1')
  ///   ..destination = PdfDestination(document.pages.add(), Offset(20, 20));
  /// //check whether the specified bookmark present in the collection
  /// bool contains = document.bookmarks.contains(bookmark);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  bool contains(PdfBookmark outline) {
    return _list.contains(outline);
  }

  /// Remove the specified bookmark from the document.
  ///
  /// ```dart
  /// //Load the PDF document.
  /// PdfDocument document = PdfDocument(inputBytes: inputBytes);
  /// //Get all the bookmarks.
  /// PdfBookmarkBase bookmarks = document.bookmarks;
  /// //Remove specified bookmark.
  /// bookmarks.remove('bookmark');
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  void remove(String title) {
    int index = -1;
    if (_bookmark == null || _bookmark!.length < _list.length) {
      _bookmark = <PdfBookmark>[];
      for (int n = 0; n < _list.length; n++) {
        if (_list[n] is PdfBookmark) {
          _bookmark!.add(_list[n] as PdfBookmark);
        }
      }
    }
    for (int c = 0; c < _bookmark!.length; c++) {
      final PdfBookmark pdfbookmark = _bookmark![c];
      if (pdfbookmark.title == title) {
        index = c;
        break;
      }
    }
    removeAt(index);
  }

  /// Remove the bookmark from the document at the specified index.
  ///
  /// ```dart
  /// //Load the PDF document.
  /// PdfDocument document = PdfDocument(inputBytes: inputBytes);
  /// //Remove specified bookmark using index.
  /// document.bookmarks.removeAt(0);
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  void removeAt(int index) {
    if (_bookmark == null || _bookmark!.length < _list.length) {
      _bookmark = <PdfBookmark>[];
      for (int n = 0; n < _list.length; n++) {
        if (_list[n] is PdfBookmark?) {
          _bookmark!.add(_list[n] as PdfBookmark);
        }
      }
    }
    if (index < 0 || index >= _bookmark!.length) {
      throw RangeError.value(index);
    }
    final PdfBookmark current = _bookmark![index];
    if (index == 0) {
      if (current._helper.dictionary!
          .containsKey(PdfDictionaryProperties.next)) {
        _helper.dictionary!.setProperty(PdfDictionaryProperties.first,
            current._helper.dictionary![PdfDictionaryProperties.next]);
      } else {
        _helper.dictionary!.remove(PdfDictionaryProperties.first);
        _helper.dictionary!.remove(PdfDictionaryProperties.last);
      }
    } else if ((current._parent != null) &&
        (current._previous != null) &&
        (current._next != null)) {
      current._previous!._helper.dictionary!.setProperty(
          PdfDictionaryProperties.next,
          current._helper.dictionary![PdfDictionaryProperties.next]);
      current._next!._helper.dictionary!.setProperty(
          PdfDictionaryProperties.prev,
          current._helper.dictionary![PdfDictionaryProperties.prev]);
    } else if ((current._parent != null) &&
        (current._previous != null) &&
        (current._next == null)) {
      current._previous!._helper.dictionary!
          .remove(PdfDictionaryProperties.next);
      current._parent!._helper.dictionary!.setProperty(
          PdfDictionaryProperties.last,
          current._helper.dictionary![PdfDictionaryProperties.prev]);
    }
    if (current._parent != null) {
      current._parent!._list.remove(current);
    }
    _bookmark!.clear();
    _updateFields();
  }

  /// Removes all the bookmark from the collection.
  ///
  /// ```dart
  /// //Load the PDF document.
  /// PdfDocument document = PdfDocument(inputBytes: inputBytes);
  /// //Clear all the bookmarks.
  /// document.bookmarks.clear();
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  void clear() {
    _list.clear();
    if (_bookmark != null) {
      _bookmark!.clear();
    }
    if (_booklist != null) {
      _booklist!.clear();
    }
    _updateFields();
  }

  /// Inserts a new outline at the specified index.
  ///
  /// ```dart
  /// //Create a new document.
  /// PdfDocument document = PdfDocument();
  /// //Insert bookmark at specified index
  /// document.bookmarks.insert(0, 'bookmark')
  ///   ..destination = PdfDestination(document.pages.add(), Offset(20, 20));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfBookmark insert(int index, String title) {
    if (index < 0 || index > count) {
      throw RangeError.value(index);
    }
    PdfBookmark outline;
    if (index == count) {
      outline = add(title);
    } else {
      final PdfBookmark next = this[index];
      final PdfBookmark? prevoius = (index == 0) ? null : this[index - 1];
      outline = PdfBookmark._internal(title, this, prevoius, next);
      _list.insert(index, outline);
      if (prevoius != null) {
        prevoius._next = outline;
      }
      next._previous = outline;
      _updateFields();
    }
    return outline;
  }

  //Implementations
  /// Updates all outline dictionary fields.
  void _updateFields() {
    if (count > 0) {
      final int newCount = _isExpanded ? _list.length : -_list.length;
      _helper.dictionary![PdfDictionaryProperties.count] = PdfNumber(newCount);
      _helper.dictionary!.setProperty(
          PdfDictionaryProperties.first, PdfReferenceHolder(this[0]));
      _helper.dictionary!.setProperty(
          PdfDictionaryProperties.last, PdfReferenceHolder(this[count - 1]));
    } else {
      _helper.dictionary!.clear();
    }
  }

  /// internal method
  List<PdfBookmarkBase> get _list {
    return _helper._bookmarkList;
  }
}

// ignore: avoid_classes_with_only_static_members
/// [PdfBookmark] helper
class PdfBookmarkHelper {
  /// internal method
  static PdfBookmark internal(String title, PdfBookmarkBase parent,
      PdfBookmark? previous, PdfBookmark? next,
      {bool isExpanded = false,
      PdfColor? color,
      PdfDestination? destination,
      PdfNamedDestination? namedDestination,
      PdfAction? action,
      List<PdfTextStyle>? textStyle}) {
    return PdfBookmark._internal(title, parent, previous, next,
        isExpanded: isExpanded,
        color: color,
        destination: destination,
        namedDestination: namedDestination,
        action: action,
        textStyle: textStyle);
  }

  /// internal method
  static PdfBookmark load(PdfDictionary? dictionary, PdfCrossTable crossTable) {
    return PdfBookmark._load(dictionary, crossTable);
  }

  /// internal method
  static PdfBookmarkBase? getParent(PdfBookmark bookmark) {
    return bookmark._parent;
  }

  /// internal method
  static void setParent(PdfBookmark bookmark, PdfBookmarkBase? base) {
    bookmark._parent = base;
  }
}

/// [PdfBookmarkBase] helper
class PdfBookmarkBaseHelper {
  /// internal field
  PdfBookmarkBaseHelper(this.base);

  /// internal constructor
  PdfBookmarkBase base;

  final List<PdfBookmarkBase> _bookmarkList = <PdfBookmarkBase>[];
  PdfCrossTable _crossTable = PdfCrossTable();

  /// internal field
  PdfDictionary? dictionary = PdfDictionary();

  /// internal method
  static PdfBookmarkBaseHelper getHelper(PdfBookmarkBase bookmark) {
    return bookmark._helper;
  }

  /// internal method
  static PdfBookmarkBase loadInternal() {
    return PdfBookmarkBase._internal();
  }

  /// internal method
  static PdfBookmarkBase loaded(
      PdfDictionary? dictionary, PdfCrossTable crossTable) {
    return PdfBookmarkBase._load(dictionary, crossTable);
  }

  /// internal method
  IPdfPrimitive? get element => dictionary;
  set element(IPdfPrimitive? value) {
    throw ArgumentError("Primitive element can't be set");
  }

  /// internal method
  void reproduceTree() {
    PdfBookmark? currentBookmark = _getFirstBookMark(base);
    bool isBookmark = currentBookmark != null;
    while (isBookmark &&
        PdfBookmarkBaseHelper(currentBookmark!).dictionary != null) {
      PdfBookmarkHelper.setParent(currentBookmark, base);
      _bookmarkList.add(currentBookmark);
      currentBookmark = currentBookmark._next;
      isBookmark = currentBookmark != null;
    }
  }

  PdfBookmark? _getFirstBookMark(PdfBookmarkBase bookmark) {
    PdfBookmark? firstBookmark;
    final PdfDictionary dictionary =
        PdfBookmarkBaseHelper.getHelper(bookmark).dictionary!;
    if (dictionary.containsKey(PdfDictionaryProperties.first)) {
      final PdfDictionary? first =
          _crossTable.getObject(dictionary[PdfDictionaryProperties.first])
              as PdfDictionary?;
      firstBookmark = PdfBookmark._load(first, _crossTable);
    }
    return firstBookmark;
  }

  /// internal method
  static List<PdfBookmarkBase> getList(PdfBookmarkBase bookmark) {
    return bookmark._list;
  }
}

/// internal class
class CurrentNodeInfo {
  /// internal constructor
  CurrentNodeInfo(this.kids, [int? index]) {
    this.index = index ?? 0;
  }
  //Fields
  /// internal field
  late List<PdfBookmarkBase?> kids;

  /// internal field
  late int index;
}
