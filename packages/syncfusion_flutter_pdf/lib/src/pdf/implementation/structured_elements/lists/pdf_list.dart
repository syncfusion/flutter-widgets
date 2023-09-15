import '../../drawing/drawing.dart';
import '../../graphics/brushes/pdf_solid_brush.dart';
import '../../graphics/figures/base/element_layouter.dart';
import '../../graphics/figures/base/layout_element.dart';
import '../../graphics/figures/base/text_layouter.dart';
import '../../graphics/figures/enums.dart';
import '../../graphics/fonts/pdf_font.dart';
import '../../graphics/fonts/pdf_string_format.dart';
import '../../graphics/pdf_graphics.dart';
import '../../graphics/pdf_pen.dart';
import '../../pages/pdf_page.dart';
import 'pdf_list_item.dart';
import 'pdf_list_item_collection.dart';
import 'pdf_list_layouter.dart';

/// Represents base class for lists.
///
/// ```dart
/// //Create a new PDF document.
/// PdfDocument document = PdfDocument();
/// //Create a new ordered list.
/// PdfOrderedList(
///     text: 'PDF\nXlsIO\nDocIO\nPPT',
///     font: PdfStandardFont(PdfFontFamily.helvetica, 16,
///         style: PdfFontStyle.italic),
///     format: PdfStringFormat(lineSpacing: 20),
///     marker: PdfOrderedMarker(style: PdfNumberStyle.numeric),
///     style: PdfNumberStyle.numeric,
///     indent: 15,
///     textIndent: 10)
///   ..draw(
///       page: document.pages.add(), bounds: const Rect.fromLTWH(20, 20, 0, 0));
/// //Save the document.
/// List<int> bytes = await document.save();
/// //Dispose the document.
/// document.dispose();
/// ```
abstract class PdfList extends PdfLayoutElement {
  //Fields
  /// Tabulation for items.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Create a new ordered list.
  /// PdfOrderedList(
  ///     text: 'PDF\nXlsIO\nDocIO\nPPT',
  ///     font: PdfStandardFont(PdfFontFamily.helvetica, 16,
  ///         style: PdfFontStyle.italic),
  ///     format: PdfStringFormat(lineSpacing: 20),
  ///     marker: PdfOrderedMarker(style: PdfNumberStyle.numeric),
  ///     style: PdfNumberStyle.numeric,
  ///     indent: 15,
  ///     textIndent: 10)
  ///   ..draw(
  ///       page: document.pages.add(), bounds: const Rect.fromLTWH(20, 20, 0, 0));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  late double indent;

  /// Indent between marker and text.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Create a new ordered list.
  /// PdfOrderedList(
  ///     text: 'PDF\nXlsIO\nDocIO\nPPT',
  ///     font: PdfStandardFont(PdfFontFamily.helvetica, 16,
  ///         style: PdfFontStyle.italic),
  ///     format: PdfStringFormat(lineSpacing: 20),
  ///     marker: PdfOrderedMarker(style: PdfNumberStyle.numeric),
  ///     style: PdfNumberStyle.numeric,
  ///     indent: 15,
  ///     textIndent: 10)
  ///   ..draw(
  ///       page: document.pages.add(), bounds: const Rect.fromLTWH(20, 20, 0, 0));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  late double textIndent;

  /// The pen for the list.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Create a new ordered list.
  /// PdfOrderedList(
  ///     text: 'PDF\nXlsIO\nDocIO\nPPT',
  ///     font: PdfStandardFont(PdfFontFamily.helvetica, 16,
  ///         style: PdfFontStyle.italic),
  ///     format: PdfStringFormat(lineSpacing: 20),
  ///     marker: PdfOrderedMarker(style: PdfNumberStyle.numeric),
  ///     style: PdfNumberStyle.numeric,
  ///     indent: 15,
  ///     textIndent: 10)
  ///   ..pen = PdfPens.red
  ///   ..draw(
  ///       page: document.pages.add(), bounds: const Rect.fromLTWH(20, 20, 0, 0));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfPen? pen;

  /// The brush for the list.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Create a new ordered list.
  /// PdfOrderedList(
  ///     text: 'PDF\nXlsIO\nDocIO\nPPT',
  ///     font: PdfStandardFont(PdfFontFamily.helvetica, 16,
  ///         style: PdfFontStyle.italic),
  ///     format: PdfStringFormat(lineSpacing: 20),
  ///     marker: PdfOrderedMarker(style: PdfNumberStyle.numeric),
  ///     style: PdfNumberStyle.numeric,
  ///     indent: 15,
  ///     textIndent: 10)
  ///   ..brush = PdfBrushes.red
  ///   ..draw(
  ///       page: document.pages.add(), bounds: const Rect.fromLTWH(20, 20, 0, 0));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfBrush? brush;

  /// The string format for the list.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Create a new ordered list.
  /// PdfOrderedList(
  ///     text: 'PDF\nXlsIO\nDocIO\nPPT',
  ///     font: PdfStandardFont(PdfFontFamily.helvetica, 16,
  ///         style: PdfFontStyle.italic),
  ///     format: PdfStringFormat(lineSpacing: 20),
  ///     marker: PdfOrderedMarker(style: PdfNumberStyle.numeric),
  ///     style: PdfNumberStyle.numeric,
  ///     indent: 15,
  ///     textIndent: 10)
  ///   ..draw(
  ///       page: document.pages.add(), bounds: const Rect.fromLTWH(20, 20, 0, 0));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfStringFormat? stringFormat;

  //Properties
  /// Gets items of the list.
  ///
  /// ```dart
  /// //Create a new instance of PdfDocument class.
  /// PdfDocument document = PdfDocument();
  /// //Create a new list.
  /// PdfOrderedList(
  ///     indent: 10,
  ///     textIndent: 10,
  ///     font: PdfStandardFont(PdfFontFamily.timesRoman, 10,
  ///         style: PdfFontStyle.italic))
  ///   ..items.add(PdfListItem(text: 'PDF'))
  ///   ..draw(page: document.pages.add(), bounds: Rect.fromLTWH(10, 10, 0, 0));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfListItemCollection get items {
    _helper.items ??= PdfListItemCollection();
    return _helper.items!;
  }

  /// Gets or sets the list font.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Create a new ordered list.
  /// PdfOrderedList(
  ///     text: 'PDF\nXlsIO\nDocIO\nPPT',
  ///     font: PdfStandardFont(PdfFontFamily.helvetica, 16,
  ///         style: PdfFontStyle.italic),
  ///     format: PdfStringFormat(lineSpacing: 20),
  ///     marker: PdfOrderedMarker(style: PdfNumberStyle.numeric),
  ///     style: PdfNumberStyle.numeric,
  ///     indent: 15,
  ///     textIndent: 10)
  ///   ..draw(
  ///       page: document.pages.add(), bounds: const Rect.fromLTWH(20, 20, 0, 0));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfFont? get font => _helper.font;
  set font(PdfFont? value) {
    if (value != null) {
      _helper.font = value;
    }
  }

  //Events
  /// Event that rises when item begin layout.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Create a new list.
  /// PdfOrderedList(
  ///     text: 'PDF\nXlsIO\nDocIO\nPPT',
  ///     font: PdfStandardFont(PdfFontFamily.helvetica, 16,
  ///         style: PdfFontStyle.italic),
  ///     format: PdfStringFormat(lineSpacing: 20))
  ///   //Begin item layout event.
  ///   ..beginItemLayout = (Object sender, BeginItemLayoutArgs args) {
  ///     args.item.text += '_Beginsave';
  ///   }
  ///   //End item layout event.
  ///   ..endItemLayout = (Object sender, EndItemLayoutArgs args) {
  ///     args.page.graphics.drawRectangle(
  ///         brush: PdfBrushes.red,
  ///         bounds: const Rect.fromLTWH(400, 400, 100, 100));
  ///   }
  ///   ..draw(
  ///       page: document.pages.add(), bounds: const Rect.fromLTWH(20, 20, 0, 0));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  BeginItemLayoutCallback? beginItemLayout;

  /// Event that rises when item end layout.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Create a new list.
  /// PdfOrderedList(
  ///     text: 'PDF\nXlsIO\nDocIO\nPPT',
  ///     font: PdfStandardFont(PdfFontFamily.helvetica, 16,
  ///         style: PdfFontStyle.italic),
  ///     format: PdfStringFormat(lineSpacing: 20))
  ///   //Begin item layout event.
  ///   ..beginItemLayout = (Object sender, BeginItemLayoutArgs args) {
  ///     args.item.text += '_Beginsave';
  ///   }
  ///   //End item layout event.
  ///   ..endItemLayout = (Object sender, EndItemLayoutArgs args) {
  ///     args.page.graphics.drawRectangle(
  ///         brush: PdfBrushes.red,
  ///         bounds: const Rect.fromLTWH(400, 400, 100, 100));
  ///   }
  ///   ..draw(
  ///       page: document.pages.add(), bounds: const Rect.fromLTWH(20, 20, 0, 0));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  EndItemLayoutCallback? endItemLayout;

  late PdfListHelper _helper;
}

/// [PdfList] helper
class PdfListHelper {
  /// internal construtor
  PdfListHelper(this.list) {
    list._helper = this;
  }

  /// Creates an item collection.
  static PdfListItemCollection createItems(String text) {
    return PdfListItemCollection(text.split('\n'));
  }

  /// internal field
  PdfListItemCollection? items;

  /// internal field
  PdfFont? font;

  /// internal field
  late PdfList list;

  /// internal method
  static PdfListHelper getHelper(PdfList list) {
    return list._helper;
  }

  /// Layouts on the specified Page.
  PdfLayoutResult? layout(PdfLayoutParams param) {
    final PdfListLayouter layouter = PdfListLayouter(list);
    return layouter.layout(param);
  }

  /// Draws list on the Graphics.
  void drawInternal(PdfGraphics graphics, PdfRectangle bounds) {
    final PdfLayoutParams param = PdfLayoutParams();
    param.bounds = bounds;
    param.format = PdfLayoutFormat();
    param.format!.layoutType = PdfLayoutType.onePage;
    final PdfListLayouter layouter = PdfListLayouter(list);
    layouter.graphics = graphics;
    layouter.layoutInternal(param);
  }

  /// Rise the BeginItemLayout event.
  void onBeginItemLayout(BeginItemLayoutArgs args) {
    if (list.beginItemLayout != null) {
      list.beginItemLayout!(list, args);
    }
  }

  /// Rise the EndItemLayout event.
  void onEndItemLayout(EndItemLayoutArgs args) {
    if (list.endItemLayout != null) {
      list.endItemLayout!(list, args);
    }
  }
}

/// Represents begin layout event arguments.
///
///
/// ```dart
/// //Create a new PDF document.
/// PdfDocument document = PdfDocument();
/// //Create a new list.
/// PdfOrderedList(
///     text: 'PDF\nXlsIO\nDocIO\nPPT',
///     font: PdfStandardFont(PdfFontFamily.helvetica, 16,
///         style: PdfFontStyle.italic),
///     format: PdfStringFormat(lineSpacing: 20))
///   //Begin item layout event.
///   ..beginItemLayout = (Object sender, BeginItemLayoutArgs args) {
///     args.item.text += '_Beginsave';
///   }
///   //End item layout event.
///   ..endItemLayout = (Object sender, EndItemLayoutArgs args) {
///     args.page.graphics.drawRectangle(
///         brush: PdfBrushes.red,
///         bounds: const Rect.fromLTWH(400, 400, 100, 100));
///   }
///   ..draw(
///       page: document.pages.add(), bounds: const Rect.fromLTWH(20, 20, 0, 0));
/// //Save the document.
/// List<int> bytes = await document.save();
/// //Dispose the document.
/// document.dispose();
/// ```
class BeginItemLayoutArgs {
  /// Initializes a new instance of the [BeginItemLayoutArgs] class.
  BeginItemLayoutArgs._internal(this._item, this._page);

  //Fields
  //Item that layout.
  final PdfListItem _item;

  //The page in which item start layout.
  final PdfPage _page;

  //Properties
  /// Gets the item.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Create a new list.
  /// PdfOrderedList(
  ///     text: 'PDF\nXlsIO\nDocIO\nPPT',
  ///     font: PdfStandardFont(PdfFontFamily.helvetica, 16,
  ///         style: PdfFontStyle.italic),
  ///     format: PdfStringFormat(lineSpacing: 20))
  ///   //Begin item layout event.
  ///   ..beginItemLayout = (Object sender, BeginItemLayoutArgs args) {
  ///     args.item.text += '_Beginsave';
  ///   }
  ///   //End item layout event.
  ///   ..endItemLayout = (Object sender, EndItemLayoutArgs args) {
  ///     args.page.graphics.drawRectangle(
  ///         brush: PdfBrushes.red,
  ///         bounds: const Rect.fromLTWH(400, 400, 100, 100));
  ///   }
  ///   ..draw(
  ///       page: document.pages.add(), bounds: const Rect.fromLTWH(20, 20, 0, 0));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfListItem get item => _item;

  /// Gets the page.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Create a new list.
  /// PdfOrderedList(
  ///     text: 'PDF\nXlsIO\nDocIO\nPPT',
  ///     font: PdfStandardFont(PdfFontFamily.helvetica, 16,
  ///         style: PdfFontStyle.italic),
  ///     format: PdfStringFormat(lineSpacing: 20))
  ///   //Begin item layout event.
  ///   ..beginItemLayout = (Object sender, BeginItemLayoutArgs args) {
  ///     args.item.text += '_Beginsave';
  ///     PdfPage page = args.page;
  ///   }
  ///   //End item layout event.
  ///   ..endItemLayout = (Object sender, EndItemLayoutArgs args) {
  ///     args.page.graphics.drawRectangle(
  ///         brush: PdfBrushes.red,
  ///         bounds: const Rect.fromLTWH(400, 400, 100, 100));
  ///   }
  ///   ..draw(
  ///       page: document.pages.add(), bounds: const Rect.fromLTWH(20, 20, 0, 0));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfPage get page => _page;
}

// ignore: avoid_classes_with_only_static_members
/// [BeginItemLayoutArgs] helper
class BeginItemLayoutArgsHelper {
  /// internal method
  static BeginItemLayoutArgs internal(PdfListItem item, PdfPage page) {
    return BeginItemLayoutArgs._internal(item, page);
  }
}

/// Represents end layout event arguments.
///
/// ```dart
/// //Create a new PDF document.
/// PdfDocument document = PdfDocument();
/// //Create a new list.
/// PdfOrderedList oList = PdfOrderedList(
///     text: 'PDF\nXlsIO\nDocIO\nPPT',
///     font: PdfStandardFont(PdfFontFamily.helvetica, 16,
///         style: PdfFontStyle.italic),
///     format: PdfStringFormat(lineSpacing: 20));
/// oList.beginItemLayout = (Object sender, BeginItemLayoutArgs args) {
///   args.item.text += '_Beginsave';
/// };
/// //End item layout event.
/// oList.endItemLayout = (Object sender, EndItemLayoutArgs args) {
///   args.page.graphics.drawRectangle(
///       brush: PdfBrushes.red, bounds: const Rect.fromLTWH(400, 400, 100, 100));
/// };
/// oList.draw(
///     page: document.pages.add(), bounds: const Rect.fromLTWH(20, 20, 0, 0));
/// //Save the document.
/// List<int> bytes = await document.save();
/// //Dispose the document.
/// document.dispose();
/// ```
class EndItemLayoutArgs {
  /// Initializes a new instance of the [EndItemLayoutArgs] class.
  EndItemLayoutArgs._internal(this._item, this._page);

  //Fields
  //Item that layouted.
  final PdfListItem _item;

  //The page in which item ended layout.
  final PdfPage _page;

  //Properties
  /// Gets the item.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Create a new list.
  /// PdfOrderedList(
  ///     text: 'PDF\nXlsIO\nDocIO\nPPT',
  ///     font: PdfStandardFont(PdfFontFamily.helvetica, 16,
  ///         style: PdfFontStyle.italic),
  ///     format: PdfStringFormat(lineSpacing: 20))
  ///   //Begin item layout event.
  ///   ..beginItemLayout = (Object sender, BeginItemLayoutArgs args) {
  ///     args.item.text += '_Beginsave';
  ///   }
  ///   //End item layout event.
  ///   ..endItemLayout = (Object sender, EndItemLayoutArgs args) {
  ///     args.page.graphics.drawRectangle(
  ///         brush: PdfBrushes.red,
  ///         bounds: const Rect.fromLTWH(400, 400, 100, 100));
  ///     PdfListItem item = args.item;
  ///   }
  ///   ..draw(
  ///       page: document.pages.add(), bounds: const Rect.fromLTWH(20, 20, 0, 0));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfListItem get item => _item;

  /// Gets the page.
  ///
  /// ```dart
  /// //Create a new PDF document.
  /// PdfDocument document = PdfDocument();
  /// //Create a new list.
  /// PdfOrderedList(
  ///     text: 'PDF\nXlsIO\nDocIO\nPPT',
  ///     font: PdfStandardFont(PdfFontFamily.helvetica, 16,
  ///         style: PdfFontStyle.italic),
  ///     format: PdfStringFormat(lineSpacing: 20))
  ///   //Begin item layout event.
  ///   ..beginItemLayout = (Object sender, BeginItemLayoutArgs args) {
  ///     args.item.text += '_Beginsave';
  ///   }
  ///   //End item layout event.
  ///   ..endItemLayout = (Object sender, EndItemLayoutArgs args) {
  ///     args.page.graphics.drawRectangle(
  ///         brush: PdfBrushes.red,
  ///         bounds: const Rect.fromLTWH(400, 400, 100, 100));
  ///   }
  ///   ..draw(
  ///       page: document.pages.add(), bounds: const Rect.fromLTWH(20, 20, 0, 0));
  /// //Save the document.
  /// List<int> bytes = await document.save();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfPage get page => _page;
}

// ignore: avoid_classes_with_only_static_members
/// [EndItemLayoutArgs] helper
class EndItemLayoutArgsHelper {
  /// internal method
  static EndItemLayoutArgs internal(PdfListItem item, PdfPage page) {
    return EndItemLayoutArgs._internal(item, page);
  }
}

/// typedef for handling BeginItemLayoutEvent.
///
/// ```dart
/// //Create a new PDF document.
/// PdfDocument document = PdfDocument();
/// //Create a new list.
/// PdfOrderedList(
///     text: 'PDF\nXlsIO\nDocIO\nPPT',
///     font: PdfStandardFont(PdfFontFamily.helvetica, 16,
///         style: PdfFontStyle.italic),
///     format: PdfStringFormat(lineSpacing: 20))
///   //Begin item layout event.
///   ..beginItemLayout = (Object sender, BeginItemLayoutArgs args) {
///     args.item.text += '_Beginsave';
///   }
///   //End item layout event.
///   ..endItemLayout = (Object sender, EndItemLayoutArgs args) {
///     args.page.graphics.drawRectangle(
///         brush: PdfBrushes.red,
///         bounds: const Rect.fromLTWH(400, 400, 100, 100));
///   }
///   ..draw(
///       page: document.pages.add(), bounds: const Rect.fromLTWH(20, 20, 0, 0));
/// //Save the document.
/// List<int> bytes = await document.save();
/// //Dispose the document.
/// document.dispose();
/// ```
typedef BeginItemLayoutCallback = void Function(
    Object sender, BeginItemLayoutArgs args);

/// typedef for handling EndItemLayoutEvent.
///
/// ```dart
/// //Create a new PDF document.
/// PdfDocument document = PdfDocument();
/// //Create a new list.
/// PdfOrderedList(
///     text: 'PDF\nXlsIO\nDocIO\nPPT',
///     font: PdfStandardFont(PdfFontFamily.helvetica, 16,
///         style: PdfFontStyle.italic),
///     format: PdfStringFormat(lineSpacing: 20))
///   //Begin item layout event.
///   ..beginItemLayout = (Object sender, BeginItemLayoutArgs args) {
///     args.item.text += '_Beginsave';
///   }
///   //End item layout event.
///   ..endItemLayout = (Object sender, EndItemLayoutArgs args) {
///     args.page.graphics.drawRectangle(
///         brush: PdfBrushes.red,
///         bounds: const Rect.fromLTWH(400, 400, 100, 100));
///   }
///   ..draw(
///       page: document.pages.add(), bounds: const Rect.fromLTWH(20, 20, 0, 0));
/// //Save the document.
/// List<int> bytes = await document.save();
/// //Dispose the document.
/// document.dispose();
/// ```
typedef EndItemLayoutCallback = void Function(
    Object sender, EndItemLayoutArgs args);
