import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

/// TextSelectionHelper for storing information of text selection.
class TextSelectionHelper {
  /// It will be true,if text selection is started.
  bool selectionEnabled = false;

  /// firstGlyphOffset of the selection.
  Offset firstGlyphOffset;

  /// Page number in which text selection is started.
  int viewId;

  /// Represents the global region of text selection.
  Rect globalSelectedRegion;

  /// Copied text of text selection.
  String copiedText;

  /// X position of start bubble.
  double startBubbleX;

  /// Y position of start bubble.
  double startBubbleY;

  /// X position of end bubble.
  double endBubbleX;

  /// Y position of end bubble.
  double endBubbleY;

  /// heightPercentage of pdf page
  double heightPercentage;

  /// TextLine from Pdf library.
  List<TextLine> textLines;

  /// Line of the start bubble.
  TextLine startBubbleLine;

  /// Line of the end bubble.
  TextLine endBubbleLine;

  /// Entry history of text selection
  LocalHistoryEntry historyEntry;
}
