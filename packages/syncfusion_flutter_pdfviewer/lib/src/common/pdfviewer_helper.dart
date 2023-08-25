import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../control/pdftextline.dart';
import 'mobile_helper.dart'
    if (dart.library.html) 'package:syncfusion_flutter_pdfviewer/src/common/web_helper.dart'
    as helper;

/// Indicates whether the current environment is running in Desktop
bool kIsDesktop = kIsWeb || Platform.isMacOS || Platform.isWindows;

/// Indicates whether the current environment is running in macOS
bool kIsMacOS = helper.getPlatformType() == 'macos';

/// TextSelectionHelper for storing information of text selection.
class TextSelectionHelper {
  /// It will be true,if text selection is started.
  bool selectionEnabled = false;

  /// It will be true,if mouse pointer text selection for web is started.
  bool mouseSelectionEnabled = false;

  /// Glyph which is first at selected text of the selection.
  TextGlyph? firstSelectedGlyph;

  /// Page number in which text selection is started.
  int? viewId;

  /// Cursor page number in which mouse hover is happening.
  int? cursorPageNumber;

  /// Represents the global region of text selection.
  Rect? globalSelectedRegion;

  /// Copied text of text selection.
  String? copiedText;

  /// X position of start bubble.
  double? startBubbleX;

  /// Y position of start bubble.
  double? startBubbleY;

  /// X position of end bubble.
  double? endBubbleX;

  /// Y position of end bubble.
  double? endBubbleY;

  /// heightPercentage of pdf page
  double? heightPercentage;

  /// TextLine from Pdf library.
  List<TextLine>? textLines;

  /// TextLine from Pdf library used while mouse cursor hovering.
  List<TextLine>? cursorTextLines;

  /// Line of the start bubble.
  TextLine? startBubbleLine;

  /// Line of the end bubble.
  TextLine? endBubbleLine;

  /// Entry history of text selection
  LocalHistoryEntry? historyEntry;

  /// Checks whether the cursor is in viewport or not.
  bool isCursorExit = false;

  /// Checks whether the cursor reached top of the viewport or not.
  bool isCursorReachedTop = false;

  /// Initial scroll offset before scrolling while selection perform.
  double initialScrollOffset = 0;

  /// Final scroll offset after scrolling while selection perform.
  double finalScrollOffset = 0;

  /// Checks whether the tap selection is enabled or not.
  bool enableTapSelection = false;

  /// Start index of the selected text line.
  int startIndex = 0;

  /// End index of the selected text line.
  int endIndex = 0;

  /// Gets the selected text lines.
  List<PdfTextLine> selectedTextLines = <PdfTextLine>[];
}

/// Determines different page navigation.
enum Navigation {
  /// Performs page navigation to specific page
  jumpToPage,

  /// Navigates to first page
  firstPage,

  /// Navigates to next page
  nextPage,

  /// Navigates to last page
  lastPage,

  /// Navigates to previous page
  previousPage
}

/// Retrieve the signature form field details
class SignatureData {
  /// Constructor for signature data
  SignatureData({
    required this.field,
    required this.pageIndex,
  });

  /// Signature field
  final PdfSignatureField field;

  /// Page index of signature field
  final int pageIndex;
}

/// Retrieve the text form field details
class TextBoxData {
  /// Constructor for text box field data
  TextBoxData({
    required this.field,
    required this.pageIndex,
  });

  /// Text box field
  final PdfTextBoxField field;

  /// Page index of text box field
  final int pageIndex;
}

/// Retrieve the radio button form field details
class RadioButtonData {
  /// Constructor for radio button data
  RadioButtonData({
    required this.field,
    required this.pageIndex,
  });

  /// Radio button field
  final PdfRadioButtonListField field;

  /// Page index of radio button field
  final int pageIndex;
}

/// Retrieve the checkbox form field details
class CheckBoxData {
  /// Constructor for check box data
  CheckBoxData({
    required this.field,
    required this.pageIndex,
  });

  /// Checkbox field
  final PdfCheckBoxField field;

  /// Page index of checkbox field
  final int pageIndex;
}

/// selected Item list for check box
class SelectedCheckBoxItem {
  /// Constructor for selected check box data
  SelectedCheckBoxItem(this.value, this.index);

  /// Selected value of field
  final String? value;

  /// Index of selected field
  final bool? index;
}

/// Retrieve the combo box form field details
class ComboBoxData {
  /// Constructor for combo box data
  ComboBoxData({
    required this.field,
    required this.pageIndex,
  });

  /// Combo box field
  final PdfComboBoxField field;

  /// Page index of combo box field
  final int pageIndex;
}

/// Retrieve the combo box Item details
class ComboBoxItemData {
  /// Constructor for combo box items
  ComboBoxItemData({
    required this.items,
    required this.pageIndex,
    required this.field,
    required this.selectedItem,
  });

  /// List of items in combo box
  final List<String> items;

  /// PageIndex of combo box field
  final int pageIndex;

  /// Combo box field
  final PdfComboBoxField field;

  /// Selected Item of the combo box
  final String? selectedItem;
}
