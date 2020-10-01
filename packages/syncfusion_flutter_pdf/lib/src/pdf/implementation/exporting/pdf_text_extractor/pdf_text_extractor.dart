part of pdf;

/// Represents a text extractor from an existing PDF document
class PdfTextExtractor {
  //Constructor
  /// Initialize a new instance of the [PdfTextExtractor] class
  /// from the instance of [PdfDocument]
  ///
  /// ```dart
  /// //Load an exisiting PDF document.
  /// PdfDocument document = PdfDocument.fromBase64String(pdfData);
  /// //Extract text from all pages
  /// String text = PdfTextExtractor(document).extractText();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  PdfTextExtractor(PdfDocument document) {
    if (document != null) {
      if (!document._isLoadedDocument) {
        ArgumentError.value(document, 'document',
            'document instance is not a loaded PDF document');
      }
      _document = document;
    } else {
      ArgumentError.checkNotNull(document);
    }
    _initialize();
  }

  //Fields
  PdfDocument _document;
  List<String> _symbolChars;
  String _currentFont;
  double _fontSize;
  PdfPage _currentPage;
  _PageResourceLoader _resourceLoader;
  int _currentPageIndex;

  //Public methods
  /// Extract text from an existing PDF document
  ///
  /// startPageIndex and endPageIndex specifies the page range to be selected
  /// to extract text.
  /// for example, startPageIndex is 0 and endPageIndex is 9
  /// is used to extract text from first page to 10 page of loaded PDF
  ///
  /// for extracting text from particular page,
  /// we can set an index of the page to startPageIndex
  ///
  /// ```dart
  /// //Load an exisiting PDF document.
  /// PdfDocument document = PdfDocument.fromBase64String(pdfData);
  /// //Extract text from all pages
  /// String text = PdfTextExtractor(document).extractText();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  String extractText({int startPageIndex, int endPageIndex}) {
    return _extractText(startPageIndex, endPageIndex);
  }

  /// Extract [TextLine] from an existing PDF document
  ///
  /// startPageIndex and endPageIndex specifies the page range to be selected
  /// to extract text line.
  /// for example, startPageIndex is 0 and endPageIndex is 9
  /// is used to extract text line from first page to 10 page of loaded PDF
  ///
  /// for extracting text line from particular page,
  /// we can set an index of the page to startPageIndex
  ///
  /// ```dart
  /// //Load an exisiting PDF document.
  /// PdfDocument document = PdfDocument.fromBase64String(pdfData);
  /// //Extract text from all pages
  /// List<TextLine> textLine = PdfTextExtractor(document).extractTextWithLine();
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  List<TextLine> extractTextWithLine({int startPageIndex, int endPageIndex}) {
    return _extractTextWithLine(startPageIndex, endPageIndex);
  }

  /// Returns the information of the matched texts in a specific page
  /// based on the list of string to be searched
  ///
  /// startPageIndex and endPageIndex specifies the page range to be selected
  /// to find text.
  /// for example, startPageIndex is 0 and endPageIndex is 9
  /// is used to find text from first page to 10 page of loaded PDF
  ///
  /// for finding text and get matched item from particular page,
  /// we can set an index of the page to startPageIndex
  ///
  /// search option defines the constants that specify the option
  /// for text search
  ///
  /// ```dart
  /// //Load an exisiting PDF document.
  /// PdfDocument document = PdfDocument.fromBase64String(pdfData);
  /// //list of string to be searched.
  /// List<String> searchString = <String>['text1', 'text2'];
  /// //Find text and get matched items.
  /// List<MatchedItem> textLine = PdfTextExtractor(document).findText(searchString);
  /// //Dispose the document.
  /// document.dispose();
  /// ```
  List<MatchedItem> findText(List<String> searchString,
      {int startPageIndex, int endPageIndex, TextSearchOption searchOption}) {
    return _findText(searchString, startPageIndex, endPageIndex, searchOption);
  }

  //Implementation
  void _checkPageNumber(int pageNumber) {
    if (pageNumber < 0 || pageNumber >= _document.pages.count) {
      throw ArgumentError.value(pageNumber, 'Index out of range');
    }
  }

  void _initialize() {
    _symbolChars = <String>['(', ')', '[', ']', '<', '>'];
    _resourceLoader = _PageResourceLoader();
  }

  String _extractText(int startPageIndex, int endPageIndex) {
    if (startPageIndex == null) {
      if (endPageIndex != null) {
        throw ArgumentError.value(
            endPageIndex, 'Invalid argument. start page index cannot be null');
      } else {
        return _extractTextFromRange(0, _document.pages.count - 1);
      }
    } else if (endPageIndex == null) {
      _checkPageNumber(startPageIndex);
      final String text = _getText(_document.pages[startPageIndex]);
      return text ?? '';
    } else {
      _checkPageNumber(startPageIndex);
      _checkPageNumber(endPageIndex);
      return _extractTextFromRange(startPageIndex, endPageIndex);
    }
  }

  List<TextLine> _extractTextWithLine(int startPageIndex, int endPageIndex) {
    if (startPageIndex == null) {
      if (endPageIndex != null) {
        throw ArgumentError.value(
            endPageIndex, 'Invalid argument. start page index cannot be null');
      } else {
        return _extractTextLineFromRange(0, _document.pages.count - 1);
      }
    } else if (endPageIndex == null) {
      _checkPageNumber(startPageIndex);
      return _getTextLine(_document.pages[startPageIndex]);
    } else {
      _checkPageNumber(startPageIndex);
      _checkPageNumber(endPageIndex);
      return _extractTextLineFromRange(startPageIndex, endPageIndex);
    }
  }

  List<MatchedItem> _findText(List<String> searchString, int startPageIndex,
      int endPageIndex, TextSearchOption searchOption) {
    if (startPageIndex == null) {
      if (endPageIndex != null) {
        throw ArgumentError.value(
            endPageIndex, 'Invalid argument. start page index cannot be null');
      } else {
        return _findTextFromRange(
            0, _document.pages.count - 1, searchString, searchOption);
      }
    } else if (endPageIndex == null) {
      _checkPageNumber(startPageIndex);
      return _searchInBackground(
          _document.pages[startPageIndex], searchString, searchOption);
    } else {
      _checkPageNumber(startPageIndex);
      _checkPageNumber(endPageIndex);
      return _findTextFromRange(
          startPageIndex, endPageIndex, searchString, searchOption);
    }
  }

  String _extractTextFromRange(int startPageIndex, int endPageIndex) {
    String resultText = '';
    for (int i = startPageIndex; i <= endPageIndex; i++) {
      final String text = _getText(_document.pages[i]);
      resultText =
          resultText + (i > startPageIndex ? '\r\n' : '') + (text ?? '');
    }
    return resultText;
  }

  List<TextLine> _extractTextLineFromRange(
      int startPageIndex, int endPageIndex) {
    final List<TextLine> result = <TextLine>[];
    for (int i = startPageIndex; i <= endPageIndex; i++) {
      _currentPageIndex = i;
      final List<TextLine> textLines = _getTextLine(_document.pages[i]);
      if (textLines.isNotEmpty) {
        result.addAll(textLines);
      }
    }
    return result;
  }

  List<MatchedItem> _findTextFromRange(int startPageIndex, int endPageIndex,
      List<String> searchString, TextSearchOption searchOption) {
    final List<MatchedItem> result = <MatchedItem>[];
    for (int i = startPageIndex; i <= endPageIndex; i++) {
      _currentPageIndex = i;
      final List<MatchedItem> textLines =
          _searchInBackground(_document.pages[i], searchString, searchOption);
      if (textLines.isNotEmpty) {
        result.addAll(textLines);
      }
    }
    return result;
  }

  String _getText(PdfPage page) {
    _currentPage = page;
    _fontSize = 0;
    String resultantText;
    page._isTextExtraction = true;
    final bool isChanged = _checkPageDictionary(page);
    final bool isContentChanged = _checkContentArray(page);
    final _PdfRecordCollection recordCollection = _getRecordCollection(page);
    _PdfPageResources pageResources = _resourceLoader.getPageResources(page);
    resultantText = _renderText(recordCollection, pageResources);
    recordCollection._recordCollection.clear();
    pageResources.resources.clear();
    if (pageResources._fontCollection != null &&
        pageResources._fontCollection.isNotEmpty) {
      pageResources._fontCollection.clear();
    }
    pageResources = null;
    if (resultantText != null && resultantText != '') {
      resultantText = _skipEscapeSequence(resultantText);
    }
    page._contents._isChanged = isContentChanged;
    page._dictionary._isChanged = isChanged;
    page._isTextExtraction = false;
    return resultantText;
  }

  List<TextLine> _getTextLine(PdfPage pdfPage) {
    final List<TextLine> result = <TextLine>[];
    _currentPage = pdfPage;
    _fontSize = 0;
    pdfPage._isTextExtraction = true;
    final bool isChanged = _checkPageDictionary(pdfPage);
    final bool isContentChanged = _checkContentArray(pdfPage);
    final _PdfRecordCollection recordCollection = _getRecordCollection(pdfPage);
    final _PdfPageResources pageResources =
        _resourceLoader.getPageResources(pdfPage);
    final _ImageRenderer renderer = _ImageRenderer(recordCollection,
        pageResources, pdfPage.size.height * 1.3333333333333333);
    renderer._isExtractLineCollection = true;
    renderer._renderAsImage();
    renderer._isExtractLineCollection = false;
    int i = 0;
    double width = 0;
    double height = 0;
    double dx = 0;
    double dy = 0;
    int offsetY = 0;
    double yPos = 0;
    String pagestring = '';
    int lineStartIndex = 0;
    int wordEndIndex = 0;
    TextLine textLine = TextLine._();
    if (pagestring == '') {
      renderer.imageRenderGlyphList.forEach((_Glyph s) {
        pagestring = pagestring + s.toUnicode;
      });
    }
    if (renderer.extractTextElement.isNotEmpty) {
      for (int k = 0; k < renderer.extractTextElement.length; k++) {
        if (i < renderer.imageRenderGlyphList.length) {
          yPos = renderer.imageRenderGlyphList[i].boundingRect.top;
          if ((i != 0 &&
                  yPos.toInt() != offsetY &&
                  renderer.extractTextElement[k].renderedText != '' &&
                  renderer.extractTextElement[k].renderedText != ' ') ||
              (i == renderer.imageRenderGlyphList.length - 1)) {
            offsetY = yPos.toInt();
            if (textLine.wordCollection.isNotEmpty) {
              result.add(_prepareTextLine(
                  textLine, renderer, lineStartIndex, wordEndIndex));
            }
            lineStartIndex = i;
            textLine = TextLine._();
          }
          final _TextElement textElement = renderer.extractTextElement[k];
          final List<String> words = textElement.renderedText.split(' ');
          textElement._text = ' ';
          TextWord textwords;
          for (int x = 0; x < words.length; x++) {
            if (pagestring.contains(words[x]) &&
                words[x] != null &&
                words[x].isNotEmpty) {
              textwords = TextWord._();
              String tempText = '';
              int lastIndex = i;
              for (int m = i; m < i + words[x].length; m++) {
                final TextGlyph textGlyph = TextGlyph._();
                textGlyph.fontName = textElement.fontName;
                textGlyph.fontSize = textElement.fontSize;
                textGlyph.fontStyle = textElement.fontStyle;
                textGlyph.text = renderer.imageRenderGlyphList[m].toUnicode;
                tempText += textGlyph.text;
                textGlyph.bounds = Rect.fromLTRB(
                    renderer.imageRenderGlyphList[m].boundingRect.left,
                    renderer.imageRenderGlyphList[m].boundingRect.top,
                    renderer.imageRenderGlyphList[m].boundingRect.right,
                    renderer.imageRenderGlyphList[m].boundingRect.bottom);
                textwords.glyphs.add(textGlyph);
                lastIndex = m;
                if (words[x] == tempText) {
                  break;
                }
              }
              dx = renderer.imageRenderGlyphList[i].boundingRect.left;
              dy = renderer.imageRenderGlyphList[i].boundingRect.top;
              height = renderer.imageRenderGlyphList[i].boundingRect.height;
              if (dx >
                  renderer.imageRenderGlyphList[lastIndex].boundingRect.left) {
                width = (dx -
                        renderer.imageRenderGlyphList[lastIndex].boundingRect
                            .left) +
                    renderer.imageRenderGlyphList[lastIndex].boundingRect.width;
              } else {
                width = (renderer
                        .imageRenderGlyphList[lastIndex].boundingRect.left) +
                    renderer.imageRenderGlyphList[lastIndex].boundingRect.width;
              }
              i = lastIndex + 1;
              textwords.bounds = Rect.fromLTWH(dx, dy, width - dx, height);
              textwords.text = words[x];
              textwords.fontName = textElement.fontName;
              textwords.fontSize = textElement.fontSize;
              textwords.fontStyle = textElement.fontStyle;
              textLine.wordCollection.add(textwords);
              wordEndIndex = i;
            }
            textElement._text = words[x];
            if (textElement._text != null && textElement._text != '') {
              if (x < words.length - 1) {
                i = i + 1;
              }
              if (x < words.length - 1 &&
                  (i <= renderer.imageRenderGlyphList.length - 1
                      ? renderer.imageRenderGlyphList[i].toUnicode == ' '
                      : false)) {
                i = i + 1;
              }
            } else {
              if (i <= renderer.imageRenderGlyphList.length - 1) {
                if (x != words.length - 1 &&
                    renderer.imageRenderGlyphList[i].toUnicode == ' ') {
                  i = i + 1;
                }
              }
            }
          }
          if (i != 0 &&
                  yPos.toInt() != offsetY &&
                  renderer.extractTextElement[k].renderedText != '' &&
                  renderer.extractTextElement[k].renderedText != ' ' ||
              (i == renderer.imageRenderGlyphList.length - 1)) {
            if (renderer.extractTextElement.isNotEmpty && k == 0) {
              offsetY = yPos.toInt();
              if (textLine.wordCollection.isNotEmpty) {
                result.add(_prepareTextLine(
                    textLine, renderer, lineStartIndex, wordEndIndex));
              }
              lineStartIndex = i;
              textLine = TextLine._();
            }
          }
        }
      }
      final _TextElement element =
          renderer.extractTextElement[renderer.extractTextElement.length - 1];
      if (textLine.wordCollection.isNotEmpty &&
          !result.contains(textLine) &&
          element.renderedText != '' &&
          element.renderedText != ' ') {
        result.add(
            _prepareTextLine(textLine, renderer, lineStartIndex, wordEndIndex));
        textLine = TextLine._();
      }
    }
    if (textLine.wordCollection.isNotEmpty && !result.contains(textLine)) {
      result.add(
          _prepareTextLine(textLine, renderer, lineStartIndex, wordEndIndex));
      textLine = TextLine._();
    }
    pdfPage._contents._isChanged = isContentChanged;
    pdfPage._dictionary._isChanged = isChanged;
    pdfPage._isTextExtraction = false;
    return result;
  }

  List<MatchedItem> _searchInBackground(
      PdfPage page, List<String> searchString, TextSearchOption searchOption) {
    final List<MatchedItem> result = <MatchedItem>[];
    final String pageText = _getText(page);
    if (pageText != '') {
      bool isMatched = false;
      for (int i = 0; i < searchString.length; i++) {
        final String term = searchString[i];
        if (searchOption != null &&
            (searchOption == TextSearchOption.caseSensitive ||
                searchOption == TextSearchOption.both)) {
          if (pageText.contains(term)) {
            isMatched = true;
            break;
          }
        } else if (pageText.toLowerCase().contains(term.toLowerCase())) {
          isMatched = true;
          break;
        }
      }
      if (isMatched) {
        _currentPage = page;
        _fontSize = 0;
        page._isTextExtraction = true;
        final bool isChanged = _checkPageDictionary(page);
        final bool isContentChanged = _checkContentArray(page);
        final _PdfRecordCollection recordCollection =
            _getRecordCollection(page);
        final _PdfPageResources pageResources =
            _resourceLoader.getPageResources(page);
        final _ImageRenderer renderer = _ImageRenderer(recordCollection,
            pageResources, page.size.height * 1.3333333333333333);
        renderer._renderAsImage();
        String renderedString = '';
        final Map<int, int> combinedGlyphLength = <int, int>{};
        if (renderer.imageRenderGlyphList.isNotEmpty) {
          renderer.imageRenderGlyphList.forEach((_Glyph glyph) {
            final String currentText = glyph.toUnicode;
            if (currentText.length > 1) {
              combinedGlyphLength[renderedString.length] = currentText.length;
            }
            renderedString = renderedString + glyph.toUnicode;
          });
          if (renderedString != '') {
            final Map<String, List<int>> mappedIndexes = <String, List<int>>{};
            if (searchOption == null ||
                (searchOption != TextSearchOption.caseSensitive &&
                    searchOption != TextSearchOption.both)) {
              renderedString = renderedString.toLowerCase();
            }
            final int textLength = renderedString.length;
            searchString.forEach((String term) {
              if (term != '' && !mappedIndexes.containsKey(term)) {
                final List<int> indexes = <int>[];
                final String currentText = (searchOption != null &&
                        (searchOption == TextSearchOption.caseSensitive ||
                            searchOption == TextSearchOption.both))
                    ? term.toString()
                    : term.toLowerCase();
                int startIndex = 0;
                final int length = currentText.length;
                while (startIndex <= textLength &&
                    renderedString.contains(currentText, startIndex)) {
                  int index = renderedString.indexOf(currentText, startIndex);
                  final int tempIndex = index;
                  if (searchOption != null &&
                      (searchOption == TextSearchOption.wholeWords ||
                          searchOption == TextSearchOption.both)) {
                    if (index == 0 ||
                        _hasEscapeCharacter(renderedString[index - 1])) {
                      if (index + length == textLength) {
                        if (combinedGlyphLength.isNotEmpty) {
                          index = _checkCombinedTextIndex(
                              index, combinedGlyphLength);
                        }
                        indexes.add(index);
                      } else if (_hasEscapeCharacter(
                          renderedString[index + length])) {
                        if (combinedGlyphLength.isNotEmpty) {
                          index = _checkCombinedTextIndex(
                              index, combinedGlyphLength);
                        }
                        indexes.add(index);
                      }
                    }
                  } else {
                    if (combinedGlyphLength.isNotEmpty) {
                      index =
                          _checkCombinedTextIndex(index, combinedGlyphLength);
                    }
                    indexes.add(index);
                  }
                  startIndex = tempIndex + 1;
                }
                if (indexes.isNotEmpty) {
                  indexes.forEach((int index) {
                    final Rect rect = _calculatedTextounds(
                        renderer.imageRenderGlyphList, term, index, page);
                    result.add(MatchedItem._(term, rect, _currentPageIndex));
                  });
                }
              }
            });
          }
        }
        page._contents._isChanged = isContentChanged;
        page._dictionary._isChanged = isChanged;
        page._isTextExtraction = false;
      }
    }
    return result;
  }

  int _checkCombinedTextIndex(
      int textIndex, Map<int, int> combinedGlyphLength) {
    int adjustableLength = 0;
    combinedGlyphLength.forEach((int index, int length) {
      if (index < textIndex) {
        adjustableLength += (length - 1);
      }
    });
    return textIndex - adjustableLength;
  }

  _PdfRecordCollection _getRecordCollection(PdfPage page) {
    _PdfRecordCollection recordCollection;
    final List<int> combinedData = page.layers._combineContent(true);
    if (combinedData != null) {
      final _ContentParser parser = _ContentParser(combinedData);
      parser._isTextExtractionProcess = true;
      recordCollection = parser._readContent();
      parser._isTextExtractionProcess = false;
    }
    return recordCollection;
  }

  bool _checkPageDictionary(PdfPage page) {
    return page._dictionary._isChanged != null && page._dictionary._isChanged
        ? true
        : false;
  }

  bool _checkContentArray(PdfPage page) {
    bool isContentChanged = false;
    if (page._dictionary.containsKey(_DictionaryProperties.contents)) {
      final _IPdfPrimitive contents =
          page._dictionary[_DictionaryProperties.contents];
      if (contents is _PdfReferenceHolder) {
        final _PdfReferenceHolder holder = contents;
        final _IPdfPrimitive primitive = holder.object;
        if (primitive is _PdfArray) {
          isContentChanged = primitive._isChanged ? true : false;
        } else if (primitive is _PdfStream) {
          isContentChanged = primitive._isChanged ? true : false;
        }
      } else if (contents is _PdfArray) {
        isContentChanged = contents._isChanged ? true : false;
      }
    }
    return isContentChanged;
  }

  Rect _calculatedTextounds(
      List<_Glyph> glyphs, String text, int index, PdfPage page) {
    final _Glyph startGlyph = glyphs[index];
    double x = startGlyph.boundingRect.left;
    double y = startGlyph.boundingRect.top;
    double width = 0;
    double height = startGlyph.boundingRect.height;
    //For conmplex script glyph mapping
    int endIndex = index + text.length - 1;
    int length = text.length;
    String tempString = '';
    for (int i = 0; i < text.length; i++) {
      tempString += glyphs[index + i].toUnicode;
      if (tempString == text) {
        endIndex = index + i;
        length = i + 1;
        break;
      }
    }
    final _Glyph endGlyph = glyphs[endIndex];
    if (startGlyph.boundingRect.top == endGlyph.boundingRect.top ||
        (startGlyph.boundingRect.top - endGlyph.boundingRect.top).abs() <
            0.001) {
      if (x > endGlyph.boundingRect.left) {
        width = (x - endGlyph.boundingRect.left) + endGlyph.boundingRect.width;
        if (page._rotation == PdfPageRotateAngle.rotateAngle0 ||
            page._rotation == PdfPageRotateAngle.rotateAngle180) {
          width = startGlyph.boundingRect.height;
          for (int i = 0; i < length; i++) {
            height += glyphs[index + i].boundingRect.width;
            if (glyphs[index + i].boundingRect.height > width) {
              width = glyphs[index + i].boundingRect.height;
            }
          }
        } else {
          width = startGlyph.boundingRect.width;
          for (int i = 0; i < length; i++) {
            height += glyphs[index + i].boundingRect.height;
            if (glyphs[index + i].boundingRect.width > width) {
              width = glyphs[index + i].boundingRect.width;
            }
          }
        }
        x -= width;
      } else {
        width = (endGlyph.boundingRect.left - x) + endGlyph.boundingRect.width;
      }
    } else if (startGlyph.boundingRect.left == endGlyph.boundingRect.left ||
        (startGlyph.boundingRect.left - endGlyph.boundingRect.left).abs() <
            0.001) {
      if (startGlyph.boundingRect.top != endGlyph.boundingRect.top &&
          !((startGlyph.boundingRect.top - endGlyph.boundingRect.top).abs() <
              0.001)) {
        height = 0;
        if (page._rotation == PdfPageRotateAngle.rotateAngle0 ||
            page._rotation == PdfPageRotateAngle.rotateAngle180) {
          width = startGlyph.boundingRect.height;
          for (int i = 0; i < length; i++) {
            height += glyphs[index + i].boundingRect.width;
            if (glyphs[index + i].boundingRect.height > 0) {
              width = glyphs[index + i].boundingRect.height;
            }
          }
        } else {
          width = startGlyph.boundingRect.width;
          for (int i = 0; i < length; i++) {
            height += glyphs[index + i].boundingRect.height;
            width = glyphs[index + i].boundingRect.width;
          }
        }
        if (y > endGlyph.boundingRect.top || startGlyph.rotationAngle == 270) {
          x = startGlyph.boundingRect.left - width + 1;
          y = startGlyph.boundingRect.top - height;
        } else if (y < endGlyph.boundingRect.top ||
            startGlyph.rotationAngle == 90) {
          x = startGlyph.boundingRect.left - 1;
          y = startGlyph.boundingRect.top;
        }
      }
    }
    return Rect.fromLTWH(x, y, width, height);
  }

  bool _hasEscapeCharacter(String text) {
    return text.contains(' ') ||
        text.contains('\\u0007') ||
        text.contains('\\') ||
        text.contains('\\b') ||
        text.contains('\\f') ||
        text.contains('\\r') ||
        text.contains('\\t') ||
        text.contains('\\n') ||
        text.contains('\\v') ||
        text.contains("\\'") ||
        text.contains('\\u0000');
  }

  TextLine _prepareTextLine(TextLine textLine, _ImageRenderer renderer,
      int lineStartIndex, int glyphIndex) {
    bool isSameFontName = true;
    bool isSameFontSize = true;
    bool isSameFontStyle = true;
    String fontName = '';
    double fontSize = 0;
    textLine.pageIndex = _currentPageIndex;
    List<PdfFontStyle> fontStyle = <PdfFontStyle>[PdfFontStyle.regular];
    textLine.bounds = Rect.fromLTWH(
        renderer.imageRenderGlyphList[lineStartIndex].boundingRect.left,
        renderer.imageRenderGlyphList[glyphIndex - 1].boundingRect.top,
        renderer.imageRenderGlyphList[glyphIndex - 1].boundingRect.right -
            renderer.imageRenderGlyphList[lineStartIndex].boundingRect.left,
        renderer.imageRenderGlyphList[glyphIndex - 1].boundingRect.height);

    for (int i = lineStartIndex; i < glyphIndex; i++) {
      final _Glyph glyph = renderer.imageRenderGlyphList[i];
      if (i == 0) {
        fontName = glyph.fontFamily;
        fontSize = glyph.fontSize;
        fontStyle = glyph.fontStyle;
      }
      textLine.text += glyph.toUnicode;
      if (fontName == glyph.fontFamily && isSameFontName) {
        textLine.fontName = fontName;
      } else {
        isSameFontName = false;
        textLine.fontName = '';
      }
      if (fontSize == glyph.fontSize && isSameFontSize) {
        textLine.fontSize = fontSize;
      } else {
        isSameFontSize = false;
        textLine.fontSize = 0;
      }

      if (fontStyle == glyph.fontStyle && isSameFontStyle) {
        textLine.fontStyle = fontStyle;
      } else {
        isSameFontStyle = false;
        textLine.fontStyle = <PdfFontStyle>[PdfFontStyle.regular];
      }
      if (!isSameFontName) {
        isSameFontName = true;
      }
      if (!isSameFontSize) {
        isSameFontSize = true;
      }
      if (!isSameFontStyle) {
        isSameFontStyle = true;
      }
    }
    return textLine;
  }

  String _renderText(
      _PdfRecordCollection recordCollection, _PdfPageResources pageResources) {
    String resultantText = '';
    if (recordCollection != null &&
        recordCollection._recordCollection.isNotEmpty) {
      final List<_PdfRecord> records = recordCollection._recordCollection;
      for (int i = 0; i < records.length; i++) {
        final _PdfRecord record = records[i];
        final String token = record._operatorName;
        final List<String> elements = record._operands;
        for (int j = 0; j < _symbolChars.length; j++) {
          if (token.contains(_symbolChars[j])) {
            token.replaceAll(_symbolChars[j], '');
          }
        }
        switch (token.trim()) {
          case 'T*':
            {
              resultantText += '\r\n';
              break;
            }
          case 'Tf':
            {
              _renderFont(elements, pageResources);
              break;
            }
          case 'ET':
            {
              resultantText += '\r\n';
              break;
            }
          case 'Tj':
          case 'TJ':
          case '\'':
            {
              final String resultText =
                  _renderTextElement(elements, token, pageResources);
              if (resultText != null) {
                resultantText += resultText;
              }
              if (token == '\'') {
                resultantText += '\r\n';
              }
              break;
            }
          case 'Do':
            {
              final String result =
                  _getXObject(resultantText, elements, pageResources);
              if (result != null && result != '') {
                resultantText += result;
              }
              break;
            }
          default:
            break;
        }
      }
    }
    return resultantText;
  }

  String _skipEscapeSequence(String text) {
    int index = -1;
    do {
      index = text.indexOf('\\', index + 1);
      if (text.length > index + 1) {
        final String nextLiteral = text[index + 1];
        if (index >= 0 &&
            (nextLiteral == '\\' || nextLiteral == '(' || nextLiteral == ')')) {
          text = text.replaceFirst(text[index], '', index);
        }
      } else {
        text = text.replaceFirst(text[index], '', index);
        index = -1;
      }
    } while (index >= 0);
    return text;
  }

  void _renderFont(List<String> elements, _PdfPageResources resources) {
    int i = 0;
    for (i = 0; i < elements.length; i++) {
      if (elements[i].contains('/')) {
        _currentFont = elements[i].replaceAll('/', '');
        break;
      }
    }
    _fontSize = double.tryParse(elements[i + 1]);
    if (resources.containsKey(_currentFont)) {
      final _FontStructure structure =
          resources[_currentFont] as _FontStructure;
      if (structure._isStandardFont) {
        structure._createStandardFont(_fontSize);
      } else if (structure._isStandardCJKFont) {
        structure._createStandardCJKFont(_fontSize);
      }
    }
  }

  String _renderTextElement(List<String> elements, String tokenType,
      _PdfPageResources pageResources) {
    try {
      String text = elements.join();
      if (!pageResources.containsKey(_currentFont)) {
        if (_currentFont != null && _currentFont.contains('-')) {
          _currentFont = _currentFont.replaceAll('-', '#2D');
        }
      }
      if (pageResources.containsKey(_currentFont)) {
        _FontStructure fontStructure;
        final dynamic returnValue = pageResources[_currentFont];
        if (returnValue != null && returnValue is _FontStructure) {
          fontStructure = returnValue;
        }
        fontStructure.isTextExtraction = true;
        if (fontStructure != null) {
          fontStructure.fontSize = _fontSize;
        }
        text = fontStructure.decodeTextExtraction(text, true);
        fontStructure.isTextExtraction = false;
      }
      return text;
    } catch (e) {
      return null;
    }
  }

  String _getXObject(String resultantText, List<String> xobjectElement,
      _PdfPageResources pageResources) {
    String result;
    final String key = xobjectElement[0].replaceAll('/', '');
    if (pageResources.containsKey(key)) {
      final dynamic element = pageResources[key];
      if (element is _XObjectElement) {
        final _PdfRecordCollection collection = element.render(pageResources);
        final _PdfDictionary xobjects = element.dictionary;
        _PdfPageResources childResource = _PdfPageResources();
        if (xobjects.containsKey(_DictionaryProperties.resources)) {
          _PdfDictionary pageDictionary = _PdfDictionary();
          final _IPdfPrimitive resource =
              xobjects[_DictionaryProperties.resources];
          if (resource is _PdfReferenceHolder &&
              resource.object is _PdfDictionary) {
            pageDictionary = resource.object;
          } else if (resource is _PdfDictionary) {
            pageDictionary = resource;
          }
          childResource = _resourceLoader.updatePageResources(
              childResource, _resourceLoader.getFormResources(pageDictionary));
          childResource = _resourceLoader.updatePageResources(childResource,
              _resourceLoader.getFontResources(pageDictionary, _currentPage));
        } else {
          childResource = _updateFontResources(pageResources);
        }
        result = _renderText(collection, childResource);
        collection._recordCollection.clear();
      }
    }
    return result;
  }

  _PdfPageResources _updateFontResources(_PdfPageResources pageResources) {
    final _PdfPageResources resources = _PdfPageResources();
    pageResources.resources.forEach((String key, dynamic value) {
      if (value is _FontStructure) {
        resources.resources[key] = value;
        resources._fontCollection[key] = value;
      }
    });
    return resources;
  }
}
