part of xlsio;

/// Represent the workbook serialize.
class SerializeWorkbook {
  /// Create an instances of serialize workbook.
  SerializeWorkbook(Workbook workbook) {
    _workbook = workbook;
  }

  /// Workbook to serialize.
  late Workbook _workbook;

  /// Relation id
  final List<String> _relationId = <String>[];

  int _iDxfIndex = 0;

  /// Possible value types for ConditionValue.
  final List<String> _valueTypes = <String>[
    'none',
    'num',
    'min',
    'max',
    'percent',
    'percentile',
    'formula',
    'autoMin',
    'autoMax'
  ];

  /// Names used in xml as IconSet type (order is important).
  final List<String> _iconSetTypeNames = <String>[
    '3Arrows',
    '3ArrowsGray',
    '3Flags',
    '3TrafficLights1',
    '3TrafficLights2',
    '3Signs',
    '3Symbols',
    '3Symbols2',
    '4Arrows',
    '4ArrowsGray',
    '4RedToBlack',
    '4Rating',
    '4TrafficLights',
    '5Arrows',
    '5ArrowsGray',
    '5Rating',
    '5Quarters',
    '3Stars',
    '3Triangles',
    '5Boxes'
  ];

  /// Serialize workbook
  void _saveInternal() {
    _updateGlobalStyles();
    _saveWorkbook();
    _saveWorksheets();
    _saveSharedString();
    _saveStyles();
    _saveApp(_workbook.builtInProperties);
    _saveCore(_workbook.builtInProperties);
    _saveContentType();
    _saveTopLevelRelation();
    _saveWorkbookRelation();
  }

  Future<void> _saveInternalAsync() async {
    await _updateGlobalStylesAsync().then((_) async {
      await _saveWorkbookAsync().then((_) async {
        await _saveWorksheetsAsync().then((_) async {
          await _saveSharedStringAsync().then((_) async {
            await _saveStylesAsync().then((_) async {
              await _saveAppAsync(_workbook.builtInProperties).then((_) async {
                await _saveCoreAsync(_workbook.builtInProperties)
                    .then((_) async {
                  await _saveContentTypeAsync().then((_) async {
                    await _saveTopLevelRelationAsync().then((_) async {
                      await _saveWorkbookRelationAsync();
                    });
                  });
                });
              });
            });
          });
        });
      });
    });
  }

  /// Serialize workbook.
  void _saveWorkbook() {
    final XmlBuilder builder = XmlBuilder();

    builder.processing('xml', 'version="1.0"');
    builder.element('workbook', nest: () {
      builder.namespace(
          'http://schemas.openxmlformats.org/spreadsheetml/2006/main');
      builder.attribute('xmlns:r',
          'http://schemas.openxmlformats.org/officeDocument/2006/relationships');

      builder.element('workbookPr', nest: () {
        builder.attribute('codeName', 'ThisWorkbook');
        builder.attribute('defaultThemeVersion', '153222');
      });
      _serializeWorkbookProtection(builder);
      builder.element('bookViews', nest: () {
        builder.element('workbookView', nest: () {
          int firstsheet = 0;
          if (_workbook.worksheets[0].visibility ==
              WorksheetVisibility.hidden) {
            for (int i = 1; i < _workbook.worksheets.count; i++) {
              if (_workbook.worksheets[i].visibility ==
                  WorksheetVisibility.visible) {
                firstsheet = i;
                break;
              }
            }
          }
          builder.attribute('activeTab', firstsheet.toString());
        });
      });
      builder.element('sheets', nest: () {
        for (int i = 0; i < _workbook.worksheets.count; i++) {
          builder.element('sheet', nest: () {
            builder.attribute('name', _workbook.worksheets[i].name);
            builder.attribute(
                'sheetId', _workbook.worksheets[i].index.toString());
            if (_workbook.worksheets[i].visibility ==
                WorksheetVisibility.hidden) {
              builder.attribute('state', 'hidden');
            }
            builder.attribute('r:id', 'rId${i + 1}');
          });
        }
      });
      final List<Name> list = _workbook.innerNamesCollection;
      if (list.isNotEmpty) {
        builder.element('definedNames', nest: () {
          for (int i = 0; i < list.length; i++) {
            builder.element('definedName', nest: () {
              builder.attribute('name', list[i].name);
              builder.attribute('comment', list[i].description);
              if (list[i].isLocal) {
                builder.attribute(
                  'localSheetId',
                  _getLocalSheetIndex(_workbook, list[i]).toString(),
                );
              }
              if (!list[i].isVisible) {
                builder.attribute('hidden', '1');
              }
              builder.text(list[i].value);
            });
          }
        });
      }
    });
    final String stringXml = builder.buildDocument().toString();
    final List<int> bytes = utf8.encode(stringXml);
    _addToArchive(bytes, 'xl/workbook.xml');
  }

  Future<void> _saveWorkbookAsync() async {
    final XmlBuilder builder = XmlBuilder();

    builder.processing('xml', 'version="1.0"');
    builder.element('workbook', nest: () async {
      builder.namespace(
          'http://schemas.openxmlformats.org/spreadsheetml/2006/main');
      builder.attribute('xmlns:r',
          'http://schemas.openxmlformats.org/officeDocument/2006/relationships');

      builder.element('workbookPr', nest: () async {
        builder.attribute('codeName', 'ThisWorkbook');
        builder.attribute('defaultThemeVersion', '153222');
      });
      _serializeWorkbookProtectionAsync(builder);
      builder.element('bookViews', nest: () async {
        builder.element('workbookView', nest: () async {
          int firstsheet = 0;
          if (_workbook.worksheets[0].visibility ==
              WorksheetVisibility.hidden) {
            for (int i = 1; i < _workbook.worksheets.count; i++) {
              if (_workbook.worksheets[i].visibility ==
                  WorksheetVisibility.visible) {
                firstsheet = i;
                break;
              }
            }
          }
          builder.attribute('activeTab', firstsheet.toString());
        });
      });
      builder.element('sheets', nest: () async {
        for (int i = 0; i < _workbook.worksheets.count; i++) {
          builder.element('sheet', nest: () async {
            builder.attribute('name', _workbook.worksheets[i].name);
            builder.attribute(
                'sheetId', _workbook.worksheets[i].index.toString());
            if (_workbook.worksheets[i].visibility ==
                WorksheetVisibility.hidden) {
              builder.attribute('state', 'hidden');
            }
            builder.attribute('r:id', 'rId${i + 1}');
          });
        }
      });
      final List<Name> list = _workbook.innerNamesCollection;
      if (list.isNotEmpty) {
        builder.element('definedNames', nest: () async {
          for (int i = 0; i < list.length; i++) {
            builder.element('definedName', nest: () async {
              builder.attribute('name', list[i].name);
              builder.attribute('comment', list[i].description);
              if (list[i].isLocal) {
                builder.attribute(
                  'localSheetId',
                  _getLocalSheetIndexAsync(_workbook, list[i]).toString(),
                );
              }
              if (!list[i].isVisible) {
                builder.attribute('hidden', '1');
              }
              builder.text(list[i].value);
            });
          }
        });
      }
    });
    final String stringXml = builder.buildDocument().toString();
    final List<int> bytes = utf8.encode(stringXml);
    _addToArchiveAsync(bytes, 'xl/workbook.xml');
  }

  /// Get local sSheet id.
  int _getLocalSheetIndex(Workbook workbook, Name list) {
    int result = -1;
    for (int i = 0; i < workbook.worksheets.count; i++) {
      if (workbook.worksheets[i].name == list.scope) {
        result = i;
      }
    }
    return result;
  }

  Future<int> _getLocalSheetIndexAsync(Workbook workbook, Name list) async {
    int result = -1;
    for (int i = 0; i < workbook.worksheets.count; i++) {
      if (workbook.worksheets[i].name == list.scope) {
        result = i;
      }
    }
    return result;
  }

  /// Serializes workbook protection options.
  void _serializeWorkbookProtection(XmlBuilder builder) {
    if (_workbook._bWindowProtect || _workbook._bCellProtect) {
      builder.element('workbookProtection', nest: () {
        if (_workbook._password != null) {
          final int usPassword = _workbook._isPassword;
          if (usPassword != 0) {
            builder.attribute('workbookPassword', usPassword.toRadixString(16));
          }
        }
        _serializeAttributes(
            builder, 'lockStructure', _workbook._bCellProtect, false);
        _serializeAttributes(
            builder, 'lockWindows', _workbook._bWindowProtect, false);
      });
    }
  }

  Future<void> _serializeWorkbookProtectionAsync(XmlBuilder builder) async {
    if (_workbook._bWindowProtect || _workbook._bCellProtect) {
      builder.element('workbookProtection', nest: () async {
        if (_workbook._password != null) {
          final int usPassword = _workbook._isPassword;
          if (usPassword != 0) {
            builder.attribute('workbookPassword', usPassword.toRadixString(16));
          }
        }
        _serializeAttributesAsync(
            builder, 'lockStructure', _workbook._bCellProtect, false);
        _serializeAttributesAsync(
            builder, 'lockWindows', _workbook._bWindowProtect, false);
      });
    }
  }

  /// serialize Attributes
  void _serializeAttributes(
      XmlBuilder builder, String attributeName, bool value, bool defaultValue) {
    String? strValue;
    if (value != defaultValue) {
      strValue = value ? '1' : '0';
    }
    if (strValue != null) {
      builder.attribute(attributeName, strValue);
    }
  }

  Future<void> _serializeAttributesAsync(XmlBuilder builder,
      String attributeName, bool value, bool defaultValue) async {
    String? strValue;
    if (value != defaultValue) {
      strValue = value ? '1' : '0';
    }
    if (strValue != null) {
      builder.attribute(attributeName, strValue);
    }
  }

  /// Serializes attribute if it differs from default value.
  void _serializeAttributeInt(
      XmlBuilder builder, String attributeName, int value, int defaultValue) {
    if (value != defaultValue) {
      final String strValue = value.toString();
      builder.attribute(attributeName, strValue);
    }
  }

  Future<void> _serializeAttributeIntAsync(XmlBuilder builder,
      String attributeName, int value, int defaultValue) async {
    if (value != defaultValue) {
      final String strValue = value.toString();
      builder.attribute(attributeName, strValue);
    }
  }

  /// Serialize worksheets.
  void _saveWorksheets() {
    final int length = _workbook.worksheets.count;
    for (int i = 0; i < length; i++) {
      final Worksheet worksheet = _workbook.worksheets[i];
      _updateHyperlinkCells(worksheet);
      _saveWorksheet(worksheet, i);
    }
  }

  Future<void> _saveWorksheetsAsync() async {
    final int length = _workbook.worksheets.count;
    for (int i = 0; i < length; i++) {
      final Worksheet worksheet = _workbook.worksheets[i];
      _updateHyperlinkCellsAsync(worksheet);
      _saveWorksheetAsync(worksheet, i);
    }
  }

  /// Update the Hyperlink cells
  void _updateHyperlinkCells(Worksheet worksheet) {
    for (final Hyperlink hyperlink in worksheet.hyperlinks.innerList) {
      final Row? row = worksheet.rows._getRow(hyperlink._row);
      if (row != null) {
        final Range? cell = row.ranges._getCell(hyperlink._column);
        if (cell != null) {
          if (hyperlink.textToDisplay != null &&
              cell.number == null &&
              cell.text == null) {
            cell.value = hyperlink.textToDisplay;
          } else if (cell.text != null) {
            cell.value = cell.text;
          } else if (cell.number != null) {
            cell.value = cell.number;
          } else {
            cell.value = hyperlink.address;
          }
        }
      }
    }
  }

  Future<void> _updateHyperlinkCellsAsync(Worksheet worksheet) async {
    for (final Hyperlink hyperlink in worksheet.hyperlinks.innerList) {
      final Row? row = worksheet.rows._getRow(hyperlink._row);
      if (row != null) {
        final Range? cell = row.ranges._getCell(hyperlink._column);
        if (cell != null) {
          if (hyperlink.textToDisplay != null &&
              cell.number == null &&
              cell.text == null) {
            cell.value = hyperlink.textToDisplay;
          } else if (cell.text != null) {
            cell.value = cell.text;
          } else if (cell.number != null) {
            cell.value = cell.number;
          } else {
            cell.value = hyperlink.address;
          }
        }
      }
    }
  }

  /// Serialize worksheet.
  void _saveWorksheet(Worksheet sheet, int index) {
    final XmlBuilder builder = XmlBuilder();

    builder.processing('xml', 'version="1.0"');
    builder.element('worksheet', nest: () {
      builder.namespace(
          'http://schemas.openxmlformats.org/spreadsheetml/2006/main');
      builder.attribute('xmlns:r',
          'http://schemas.openxmlformats.org/officeDocument/2006/relationships');
      builder.attribute('xmlns:x14',
          'http://schemas.microsoft.com/office/spreadsheetml/2009/9/main');
      builder.attribute('xmlns:mc',
          'http://schemas.openxmlformats.org/markup-compatibility/2006');

      builder.element('sheetPr', nest: () {
        if (!sheet._isSummaryRowBelow) {
          builder.element('OutlinePr', nest: () {
            builder.attribute('summaryBelow', '0');
          });
        }
        if (sheet.pageSetup.isFitToPage) {
          builder.element('pageSetUpPr', nest: () {
            builder.attribute('fitToPage', '1');
          });
        }
        if (sheet._isTapColorApplied) {
          _serializeTabColor(sheet, builder);
        }
      });
      _saveSheetView(sheet, builder);
      builder.element('sheetFormatPr', nest: () {
        builder.attribute('defaultRowHeight', sheet._standardHeight.toString());
      });

      if (sheet.columns.count != 0) {
        builder.element('cols', nest: () {
          for (int i = 1; i <= sheet.columns.count; i++) {
            final Column? column = sheet.columns[i];
            if (column != null) {
              builder.element('col', nest: () {
                final int iLastColumn =
                    _findSameColumns(sheet, column.index, _workbook);
                builder.attribute('min', column.index.toString());
                builder.attribute('max', iLastColumn.toString());
                i = iLastColumn;
                if (column.width != 0) {
                  final double dWidth =
                      sheet._evaluateFileColumnWidth(column.width);
                  builder.attribute('width', dWidth.toString());
                } else {
                  builder.attribute('width', '8.43');
                }
                if (column._isHidden) {
                  builder.attribute('hidden', '1');
                }
                builder.attribute('customWidth', '1');
              });
            }
          }
        });
      }
      builder.element('sheetData', nest: () {
        if (sheet.rows.count != 0) {
          for (final Row? row in sheet.rows.innerList) {
            if (row != null) {
              builder.element('row', nest: () {
                builder.attribute('r', row.index.toString());
                if (row.height != 0) {
                  builder.attribute('ht', row.height.toString());
                  builder.attribute('customHeight', '1');
                }
                if (row._isHidden) {
                  builder.attribute('hidden', '1');
                }
                if (row.ranges.count != 0) {
                  for (final Range? cell in row.ranges.innerList) {
                    if (cell != null) {
                      if (cell.rowSpan > 0) {
                        cell.rowSpan -= 1;
                      }
                      if (cell.columnSpan > 0) {
                        cell.columnSpan -= 1;
                      }
                      sheet.mergeCells =
                          _processMergeCells(cell, row.index, sheet.mergeCells);
                      if (cell._cellStyle != null || !cell.isDefaultFormat) {
                        cell._styleIndex = cell.cellStyle.index =
                            _processCellStyle(
                                cell.cellStyle as CellStyle, _workbook);
                      } else {
                        cell._styleIndex = -1;
                      }
                      builder.element('c', nest: () {
                        String? strFormula = cell.formula;
                        builder.attribute('r', cell.addressLocal);
                        if (cell._saveType != '' &&
                            (strFormula == null ||
                                strFormula == '' ||
                                strFormula[0] != '=' ||
                                cell._saveType == 's')) {
                          builder.attribute('t', cell._saveType);
                        }
                        if (cell._styleIndex > 0) {
                          builder.attribute('s', cell._styleIndex.toString());
                        }
                        String? cellValue;
                        if (sheet.calcEngine != null &&
                            cell.number == null &&
                            cell.text == null &&
                            cell._boolean == '' &&
                            cell._errorValue == '') {
                          cellValue = cell.calculatedValue;
                        } else if (cell._errorValue != '') {
                          cellValue = cell._errorValue;
                        } else if (cell._boolean != '') {
                          cellValue = cell._boolean;
                        } else if (cell.number != null) {
                          cellValue = cell.number.toString();
                        } else if (cell.text != null) {
                          if (cell._saveType == 's' && cell._textIndex != -1) {
                            cellValue = cell._textIndex.toString();
                          } else {
                            cellValue = cell.text;
                          }
                        }
                        if (strFormula != null &&
                            strFormula != '' &&
                            strFormula[0] == '=' &&
                            cell._saveType != 's') {
                          if (cell._saveType != '') {
                            builder.attribute('t', cell._saveType);
                          }
                          strFormula =
                              strFormula.substring(1).replaceAll("'", '"');
                          final int i = strFormula.indexOf('!');
                          int indexOfOp = (strFormula.contains('+'))
                              ? strFormula.indexOf('+')
                              : strFormula.indexOf('-');
                          indexOfOp = (indexOfOp == -1)
                              ? strFormula.indexOf('*')
                              : indexOfOp;
                          indexOfOp = (indexOfOp == -1)
                              ? strFormula.indexOf('/')
                              : indexOfOp;

                          if (i != -1 &&
                              indexOfOp != -1 &&
                              strFormula[i - 1] == '"' &&
                              strFormula[indexOfOp + 1] == '"') {
                            final String cellRef =
                                strFormula.substring(0, indexOfOp);
                            final String operatorString =
                                strFormula.substring(indexOfOp, indexOfOp + 1);
                            final String sheetName =
                                strFormula.substring(indexOfOp + 2, i - 1);
                            strFormula =
                                "$cellRef$operatorString'$sheetName'${strFormula.substring(i)}";
                          }
                          if (i != -1 &&
                              strFormula[0] == '"' &&
                              strFormula[i - 1] == '"') {
                            final String sheetName =
                                strFormula.substring(1, i - 1);
                            strFormula =
                                "'$sheetName'${strFormula.substring(i)}";
                          }
                          if (strFormula.contains('MINIFS')) {
                            strFormula = strFormula.replaceAllMapped(
                                RegExp('MINIFS'),
                                (Match match) => '_xlfn.${match.group(0)}');
                          } else if (strFormula.contains('MAXIFS')) {
                            strFormula = strFormula.replaceAllMapped(
                                RegExp('MAXIFS'),
                                (Match match) => '_xlfn.${match.group(0)}');
                          }
                          builder.element('f', nest: strFormula);
                        }
                        if (cellValue != null &&
                            (cell._saveType == 'str' || cellValue.isNotEmpty)) {
                          builder.element('v', nest: cellValue);
                        }
                      });
                    }
                  }
                }
              });
            }
          }
        }
      });
      if (sheet._isPasswordProtected) {
        builder.element('sheetProtection', nest: () {
          if (sheet._algorithmName != null) {
            // ignore: unnecessary_null_checks
            builder.attribute('algorithmName', sheet._algorithmName!);
            builder.attribute('hashValue', base64.encode(sheet._hashValue));
            builder.attribute('saltValue', base64.encode(sheet._saltValue));
            builder.attribute('spinCount', sheet._spinCount);
          } else if (sheet._isPassword != 1) {
            final String password = sheet._isPassword.toRadixString(16);
            builder.attribute('password', password);
          }
          List<String> attributes;
          List<bool> flags;
          List<bool> defaultValues;
          attributes = sheet._protectionAttributes;
          flags = sheet._flag;
          defaultValues = sheet._defaultValues;
          // ignore: prefer_final_locals
          for (int i = 0, iCount = attributes.length; i < iCount; i++) {
            _serializeProtectionAttribute(
                builder, attributes[i], flags[i], defaultValues[i]);
          }
        });
      }
      //Serializing AutoFilter
      _serializeAutoFilters(builder, sheet.autoFilters);

      if (sheet.mergeCells.innerList.isNotEmpty) {
        builder.element('mergeCells', nest: () {
          builder.attribute(
              'count', sheet.mergeCells.innerList.length.toString());
          for (final MergeCell mCell in sheet.mergeCells.innerList) {
            builder.element('mergeCell', nest: () {
              builder.attribute('ref', mCell._reference);
            });
          }
        });
      }
      _serializeConditionalFormatting(builder, sheet);
      _serializeDataValidations(builder, sheet);
      _serializeHyperlinks(builder, sheet);
      if (sheet.pageSetup.showGridlines ||
          sheet.pageSetup.showHeadings ||
          sheet.pageSetup.isCenterHorizontally ||
          sheet.pageSetup.isCenterVertically) {
        _serializePrintOptions(builder, sheet);
      }
      _validatePageMargins(sheet);
      _serializePageMargins(builder, sheet);

      if (sheet.pageSetup.order == ExcelPageOrder.overThenDown ||
          sheet.pageSetup.orientation == ExcelPageOrientation.landscape ||
          sheet.pageSetup.printErrors != CellErrorPrintOptions.displayed ||
          sheet.pageSetup.isBlackAndWhite ||
          sheet.pageSetup.isDraft ||
          (sheet.pageSetup.printQuality != 0 &&
              sheet.pageSetup.printQuality != 600) ||
          !sheet.pageSetup.autoFirstPageNumber ||
          sheet.pageSetup.fitToPagesWide > 1 ||
          sheet.pageSetup.fitToPagesTall > 1 ||
          sheet.pageSetup.firstPageNumber != 1 ||
          sheet.pageSetup.paperSize != ExcelPaperSize.paperA4) {
        _serializePageSetup(builder, sheet);
      }
      builder.element('headerFooter', nest: () {
        builder.attribute('scaleWithDoc', '1');
        builder.attribute('alignWithMargins', '0');
        builder.attribute('differentFirst', '0');
        builder.attribute('differentOddEven', '0');
      });

      if ((sheet.pictures.count > 0) ||
          (sheet.charts != null && sheet.chartCount > 0)) {
        _workbook._drawingCount++;
        _saveDrawings(sheet);
        if (sheet.charts != null && sheet.chartCount > 0) {
          sheet.charts!.serializeChartsSync(sheet);
        }
        builder.element('drawing', nest: () {
          int id = 1;
          const String rId = 'rId1';
          if (_relationId.isNotEmpty) {
            if (sheet.hyperlinks.count > 0) {
              for (int i = 0; i < sheet.hyperlinks.count; i++) {
                if (sheet.hyperlinks[i]._attachedType ==
                        ExcelHyperlinkAttachedType.range &&
                    sheet.hyperlinks[i].type != HyperlinkType.workbook) {
                  id++;
                }
              }
            }
            builder.attribute('r:id', 'rId$id');
          } else {
            builder.attribute('r:id', rId);
          }
        });
      }

      final _TableSerialization tableSerialization =
          _TableSerialization(_workbook);
      tableSerialization._serializeTables(builder, sheet);

      builder.element('extLst', nest: () {
        _serializeConditionalFormattingExt(builder, sheet);
      });
      final List<int> rel = _saveSheetRelations(sheet);

      _addToArchive(rel, 'xl/worksheets/_rels/sheet${index + 1}.xml.rels');
    });
    final String stringXml = builder.buildDocument().toString();
    final List<int> bytes = utf8.encode(stringXml);
    _addToArchive(bytes, 'xl/worksheets/sheet${index + 1}.xml');
  }

  Future<void> _saveWorksheetAsync(Worksheet sheet, int index) async {
    final XmlBuilder builder = XmlBuilder();

    builder.processing('xml', 'version="1.0"');
    builder.element('worksheet', nest: () async {
      builder.namespace(
          'http://schemas.openxmlformats.org/spreadsheetml/2006/main');
      builder.attribute('xmlns:r',
          'http://schemas.openxmlformats.org/officeDocument/2006/relationships');
      builder.attribute('xmlns:x14',
          'http://schemas.microsoft.com/office/spreadsheetml/2009/9/main');
      builder.attribute('xmlns:mc',
          'http://schemas.openxmlformats.org/markup-compatibility/2006');

      builder.element('sheetPr', nest: () async {
        if (!sheet._isSummaryRowBelow) {
          builder.element('OutlinePr', nest: () async {
            builder.attribute('summaryBelow', '0');
          });
        }
        if (sheet.pageSetup.isFitToPage) {
          builder.element('pageSetUpPr', nest: () async {
            builder.attribute('fitToPage', '1');
          });
        }
        if (sheet._isTapColorApplied) {
          _serializeTabColorAsync(sheet, builder);
        }
      });
      _saveSheetViewAsync(sheet, builder);
      builder.element('sheetFormatPr', nest: () async {
        builder.attribute('defaultRowHeight', sheet._standardHeight.toString());
      });

      if (sheet.columns.count != 0) {
        builder.element('cols', nest: () async {
          for (int i = 1; i <= sheet.columns.count; i++) {
            final Column? column = sheet.columns[i];
            if (column != null) {
              builder.element('col', nest: () async {
                final int iLastColumn =
                    _findSameColumns(sheet, column.index, _workbook);
                builder.attribute('min', column.index.toString());
                builder.attribute('max', iLastColumn.toString());
                i = iLastColumn;
                if (column.width != 0) {
                  final double dWidth =
                      sheet._evaluateFileColumnWidth(column.width);
                  builder.attribute('width', dWidth.toString());
                } else {
                  builder.attribute('width', '8.43');
                }
                if (column._isHidden) {
                  builder.attribute('hidden', '1');
                }
                builder.attribute('customWidth', '1');
              });
            }
          }
        });
      }
      builder.element('sheetData', nest: () async {
        if (sheet.rows.count != 0) {
          for (final Row? row in sheet.rows.innerList) {
            if (row != null) {
              builder.element('row', nest: () async {
                builder.attribute('r', row.index.toString());
                if (row.height != 0) {
                  builder.attribute('ht', row.height.toString());
                  builder.attribute('customHeight', '1');
                }
                if (row._isHidden) {
                  builder.attribute('hidden', '1');
                }
                if (row.ranges.count != 0) {
                  for (final Range? cell in row.ranges.innerList) {
                    if (cell != null) {
                      if (cell.rowSpan > 0) {
                        cell.rowSpan -= 1;
                      }
                      if (cell.columnSpan > 0) {
                        cell.columnSpan -= 1;
                      }
                      sheet.mergeCells =
                          _processMergeCells(cell, row.index, sheet.mergeCells);

                      if (cell._cellStyle != null || !cell.isDefaultFormat) {
                        cell._styleIndex = cell.cellStyle.index =
                            _processCellStyle(
                                cell.cellStyle as CellStyle, _workbook);
                      } else {
                        cell._styleIndex = -1;
                      }
                      builder.element('c', nest: () async {
                        String? strFormula = cell.formula;
                        builder.attribute('r', cell.addressLocal);
                        if (cell._saveType != '' &&
                            (strFormula == null ||
                                strFormula == '' ||
                                strFormula[0] != '=' ||
                                cell._saveType == 's')) {
                          builder.attribute('t', cell._saveType);
                        }
                        if (cell._styleIndex > 0) {
                          builder.attribute('s', cell._styleIndex.toString());
                        }
                        String? cellValue;
                        if (sheet.calcEngine != null &&
                            cell.number == null &&
                            cell.text == null &&
                            cell._boolean == '' &&
                            cell._errorValue == '') {
                          cellValue = cell.calculatedValue;
                        } else if (cell._errorValue != '') {
                          cellValue = cell._errorValue;
                        } else if (cell._boolean != '') {
                          cellValue = cell._boolean;
                        } else if (cell.number != null) {
                          cellValue = cell.number.toString();
                        } else if (cell.text != null) {
                          if (cell._saveType == 's' && cell._textIndex != -1) {
                            cellValue = cell._textIndex.toString();
                          } else {
                            cellValue = cell.text;
                          }
                        }
                        if (strFormula != null &&
                            strFormula != '' &&
                            strFormula[0] == '=' &&
                            cell._saveType != 's') {
                          if (cell._saveType != '') {
                            builder.attribute('t', cell._saveType);
                          }
                          strFormula =
                              strFormula.substring(1).replaceAll("'", '"');
                          final int i = strFormula.indexOf('!');
                          if (i != -1 &&
                              strFormula[0] == '"' &&
                              strFormula[i - 1] == '"') {
                            final String sheetName =
                                strFormula.substring(1, i - 1);
                            strFormula =
                                "'$sheetName'${strFormula.substring(i)}";
                          }
                          if (strFormula.contains('MINIFS')) {
                            strFormula = strFormula.replaceAllMapped(
                                RegExp('MINIFS'),
                                (Match match) => '_xlfn.${match.group(0)}');
                          } else if (strFormula.contains('MAXIFS')) {
                            strFormula = strFormula.replaceAllMapped(
                                RegExp('MAXIFS'),
                                (Match match) => '_xlfn.${match.group(0)}');
                          }
                          builder.element('f', nest: strFormula);
                        }
                        if (cellValue != null &&
                            (cell._saveType == 'str' || cellValue.isNotEmpty)) {
                          builder.element('v', nest: cellValue);
                        }
                      });
                    }
                  }
                }
              });
            }
          }
        }
      });
      if (sheet._isPasswordProtected) {
        builder.element('sheetProtection', nest: () async {
          if (sheet._algorithmName != null) {
            // ignore: unnecessary_null_checks
            builder.attribute('algorithmName', sheet._algorithmName!);
            builder.attribute('hashValue', base64.encode(sheet._hashValue));
            builder.attribute('saltValue', base64.encode(sheet._saltValue));
            builder.attribute('spinCount', sheet._spinCount);
          } else if (sheet._isPassword != 1) {
            final String password = sheet._isPassword.toRadixString(16);
            builder.attribute('password', password);
          }
          List<String> attributes;
          List<bool> flags;
          List<bool> defaultValues;
          attributes = sheet._protectionAttributes;
          flags = sheet._flag;
          defaultValues = sheet._defaultValues;
          // ignore: prefer_final_locals
          for (int i = 0, iCount = attributes.length; i < iCount; i++) {
            _serializeProtectionAttributeAsync(
                builder, attributes[i], flags[i], defaultValues[i]);
          }
        });
      }
      //Serializing AutoFilter
      _serializeAutoFiltersAsync(builder, sheet.autoFilters);
      if (sheet.mergeCells.innerList.isNotEmpty) {
        builder.element('mergeCells', nest: () async {
          builder.attribute(
              'count', sheet.mergeCells.innerList.length.toString());
          for (final MergeCell mCell in sheet.mergeCells.innerList) {
            builder.element('mergeCell', nest: () async {
              builder.attribute('ref', mCell._reference);
            });
          }
        });
      }
      _serializeConditionalFormattingAsync(builder, sheet);
      _serializeDataValidationsAsync(builder, sheet);
      _serializeHyperlinksAsync(builder, sheet);
      if (sheet.pageSetup.showGridlines ||
          sheet.pageSetup.showHeadings ||
          sheet.pageSetup.isCenterHorizontally ||
          sheet.pageSetup.isCenterVertically) {
        _serializePrintOptionsAsync(builder, sheet);
      }
      _validatePageMarginsAsync(sheet);
      _serializePageMarginsAsync(builder, sheet);
      if (sheet.pageSetup.order == ExcelPageOrder.overThenDown ||
          sheet.pageSetup.orientation == ExcelPageOrientation.landscape ||
          sheet.pageSetup.printErrors != CellErrorPrintOptions.displayed ||
          sheet.pageSetup.isBlackAndWhite ||
          sheet.pageSetup.isDraft ||
          (sheet.pageSetup.printQuality != 0 &&
              sheet.pageSetup.printQuality != 600) ||
          !sheet.pageSetup.autoFirstPageNumber ||
          sheet.pageSetup.fitToPagesWide > 1 ||
          sheet.pageSetup.fitToPagesTall > 1 ||
          sheet.pageSetup.firstPageNumber != 1 ||
          sheet.pageSetup.paperSize != ExcelPaperSize.paperA4) {
        _serializePageSetupAsync(builder, sheet);
      }
      builder.element('headerFooter', nest: () async {
        builder.attribute('scaleWithDoc', '1');
        builder.attribute('alignWithMargins', '0');
        builder.attribute('differentFirst', '0');
        builder.attribute('differentOddEven', '0');
      });

      if ((sheet.pictures.count > 0) ||
          (sheet.charts != null && sheet.chartCount > 0)) {
        _workbook._drawingCount++;
        _saveDrawingsAsync(sheet);
        if (sheet.charts != null && sheet.chartCount > 0) {
          sheet.charts!.serializeCharts(sheet);
        }
        builder.element('drawing', nest: () async {
          int id = 1;
          const String rId = 'rId1';
          if (_relationId.isNotEmpty) {
            if (sheet.hyperlinks.count > 0) {
              for (int i = 0; i < sheet.hyperlinks.count; i++) {
                if (sheet.hyperlinks[i]._attachedType ==
                        ExcelHyperlinkAttachedType.range &&
                    sheet.hyperlinks[i].type != HyperlinkType.workbook) {
                  id++;
                }
              }
            }
            builder.attribute('r:id', 'rId$id');
          } else {
            builder.attribute('r:id', rId);
          }
        });
      }
      final _TableSerialization tableSerialization =
          _TableSerialization(_workbook);
      tableSerialization._serializeTablesAsync(builder, sheet);
      builder.element('extLst', nest: () async {
        _serializeConditionalFormattingExtAsync(builder, sheet);
      });
      _addToArchiveAsync(_saveSheetRelations(sheet),
          'xl/worksheets/_rels/sheet${index + 1}.xml.rels');
    });
    final String stringXml = builder.buildDocument().toString();
    final List<int> bytes = utf8.encode(stringXml);
    _addToArchiveAsync(bytes, 'xl/worksheets/sheet${index + 1}.xml');
  }

  /// Serializes worksheet printOptions
  void _serializePrintOptions(XmlBuilder builder, Worksheet sheet) {
    builder.element('printOptions', nest: () {
      if (sheet.pageSetup.isCenterHorizontally) {
        builder.attribute('horizontalCentered', '1');
      }
      if (sheet.pageSetup.isCenterVertically) {
        builder.attribute('verticalCentered', '1');
      }
      if (sheet.pageSetup.showHeadings) {
        builder.attribute('headings', '1');
      }
      if (sheet.pageSetup.showGridlines) {
        builder.attribute('gridLines', '1');
      }
    });
  }

  Future<void> _serializePrintOptionsAsync(
      XmlBuilder builder, Worksheet sheet) async {
    builder.element('printOptions', nest: () async {
      if (sheet.pageSetup.isCenterHorizontally) {
        builder.attribute('horizontalCentered', '1');
      }
      if (sheet.pageSetup.isCenterVertically) {
        builder.attribute('verticalCentered', '1');
      }
      if (sheet.pageSetup.showHeadings) {
        builder.attribute('headings', '1');
      }
      if (sheet.pageSetup.showGridlines) {
        builder.attribute('gridLines', '1');
      }
    });
  }

  /// Validate whether Page margins are fit into the Page
  void _validatePageMargins(Worksheet sheet) {
    if ((sheet.pageSetup as _PageSetupImpl)
            ._paperHight
            .containsKey(sheet.pageSetup.paperSize) &&
        (sheet.pageSetup as _PageSetupImpl)
            ._paperWidth
            .containsKey(sheet.pageSetup.paperSize)) {
      final double maxHight =
          sheet.pageSetup.topMargin + sheet.pageSetup.bottomMargin;
      final double maxWidth =
          sheet.pageSetup.leftMargin + sheet.pageSetup.rightMargin;
      (sheet.pageSetup as _PageSetupImpl)
          ._paperHight
          .forEach((ExcelPaperSize key, double value) {
        if (sheet.pageSetup.paperSize == key) {
          if (maxHight > value) {
            throw Exception(
                'Top Margin and Bottom Margin size exceeds the allowed size');
          }
        }
      });
      (sheet.pageSetup as _PageSetupImpl)
          ._paperWidth
          .forEach((ExcelPaperSize key, double value) {
        if (sheet.pageSetup.paperSize == key) {
          if (maxWidth > value) {
            throw Exception(
                'Left Margin and Right Margin size exceeds the allowed size');
          }
        }
      });
    }
  }

  Future<void> _validatePageMarginsAsync(Worksheet sheet) async {
    if ((sheet.pageSetup as _PageSetupImpl)
            ._paperHight
            .containsKey(sheet.pageSetup.paperSize) &&
        (sheet.pageSetup as _PageSetupImpl)
            ._paperWidth
            .containsKey(sheet.pageSetup.paperSize)) {
      final double maxHight =
          sheet.pageSetup.topMargin + sheet.pageSetup.bottomMargin;
      final double maxWidth =
          sheet.pageSetup.leftMargin + sheet.pageSetup.rightMargin;
      (sheet.pageSetup as _PageSetupImpl)
          ._paperHight
          .forEach((ExcelPaperSize key, double value) {
        if (sheet.pageSetup.paperSize == key) {
          if (maxHight > value) {
            throw Exception(
                'Top Margin and Bottom Margin size exceeds the allowed size');
          }
        }
      });
      (sheet.pageSetup as _PageSetupImpl)
          ._paperWidth
          .forEach((ExcelPaperSize key, double value) {
        if (sheet.pageSetup.paperSize == key) {
          if (maxWidth > value) {
            throw Exception(
                'Left Margin and Right Margin size exceeds the allowed size');
          }
        }
      });
    }
  }

  /// Serializes pageMargins
  void _serializePageMargins(XmlBuilder builder, Worksheet sheet) {
    builder.element('pageMargins', nest: () {
      builder.attribute('left', sheet.pageSetup.leftMargin.toString());
      builder.attribute('right', sheet.pageSetup.rightMargin.toString());
      builder.attribute('top', sheet.pageSetup.topMargin.toString());
      builder.attribute('bottom', sheet.pageSetup.bottomMargin.toString());
      builder.attribute('header', sheet.pageSetup.headerMargin.toString());
      builder.attribute('footer', sheet.pageSetup.footerMargin.toString());
    });
  }

  Future<void> _serializePageMarginsAsync(
      XmlBuilder builder, Worksheet sheet) async {
    builder.element('pageMargins', nest: () async {
      builder.attribute('left', sheet.pageSetup.leftMargin.toString());
      builder.attribute('right', sheet.pageSetup.rightMargin.toString());
      builder.attribute('top', sheet.pageSetup.topMargin.toString());
      builder.attribute('bottom', sheet.pageSetup.bottomMargin.toString());
      builder.attribute('header', sheet.pageSetup.headerMargin.toString());
      builder.attribute('footer', sheet.pageSetup.footerMargin.toString());
    });
  }

  /// Serialize pageSetup
  void _serializePageSetup(XmlBuilder builder, Worksheet sheet) {
    builder.element('pageSetup', nest: () {
      _serializePaperSize(builder, sheet);

      if (sheet.pageSetup.firstPageNumber != 1) {
        builder.attribute(
            'firstPageNumber', sheet.pageSetup.firstPageNumber.toString());
      }
      if (sheet.pageSetup.fitToPagesWide > 1) {
        builder.attribute(
            'fitToWidth', sheet.pageSetup.fitToPagesWide.toString());
      }
      if (sheet.pageSetup.fitToPagesTall > 1) {
        builder.attribute(
            'fitToHeight', sheet.pageSetup.fitToPagesTall.toString());
      }
      if (sheet.pageSetup.order == ExcelPageOrder.overThenDown) {
        builder.attribute('pageOrder', 'overThenDown');
      }
      if (sheet.pageSetup.orientation == ExcelPageOrientation.landscape) {
        builder.attribute('orientation', 'landscape');
      } else {
        builder.attribute('orientation', 'portrait');
      }
      if (sheet.pageSetup.isBlackAndWhite) {
        builder.attribute('blackAndWhite', '1');
      }
      if (sheet.pageSetup.isDraft) {
        builder.attribute('draft', '1');
      }
      if (!sheet.pageSetup.autoFirstPageNumber) {
        builder.attribute('useFirstPageNumber', '1');
      }
      if (sheet.pageSetup.printErrors != CellErrorPrintOptions.displayed) {
        switch (sheet.pageSetup.printErrors) {
          case CellErrorPrintOptions.blank:
            builder.attribute('errors', 'blank');
            break;
          case CellErrorPrintOptions.dash:
            builder.attribute('errors', 'dash');
            break;
          case CellErrorPrintOptions.notAvailable:
            builder.attribute('errors', 'NA');
            break;
          case CellErrorPrintOptions.displayed:
            break;
        }
      }
      if (sheet.pageSetup.printQuality != 0 &&
          sheet.pageSetup.printQuality != 600) {
        if (sheet.pageSetup.printQuality <= 38528) {
          builder.attribute(
              'horizontalDpi', sheet.pageSetup.printQuality.toString());
          builder.attribute(
              'verticalDpi', sheet.pageSetup.printQuality.toString());
        } else {
          builder.attribute('horizontalDpi', '38528');
          builder.attribute('verticalDpi', '38528');
        }
      }
    });
  }

  Future<void> _serializePageSetupAsync(
      XmlBuilder builder, Worksheet sheet) async {
    builder.element('pageSetup', nest: () async {
      _serializePaperSizeAsync(builder, sheet);
      if (sheet.pageSetup.firstPageNumber != 1) {
        builder.attribute(
            'firstPageNumber', sheet.pageSetup.firstPageNumber.toString());
      }
      if (sheet.pageSetup.fitToPagesWide > 1) {
        builder.attribute(
            'fitToWidth', sheet.pageSetup.fitToPagesWide.toString());
      }
      if (sheet.pageSetup.fitToPagesTall > 1) {
        builder.attribute(
            'fitToHeight', sheet.pageSetup.fitToPagesTall.toString());
      }
      if (sheet.pageSetup.order == ExcelPageOrder.overThenDown) {
        builder.attribute('pageOrder', 'overThenDown');
      }
      if (sheet.pageSetup.orientation == ExcelPageOrientation.landscape) {
        builder.attribute('orientation', 'landscape');
      } else {
        builder.attribute('orientation', 'portrait');
      }
      if (sheet.pageSetup.isBlackAndWhite) {
        builder.attribute('blackAndWhite', '1');
      }
      if (sheet.pageSetup.isDraft) {
        builder.attribute('draft', '1');
      }
      if (!sheet.pageSetup.autoFirstPageNumber) {
        builder.attribute('useFirstPageNumber', '1');
      }
      if (sheet.pageSetup.printErrors != CellErrorPrintOptions.displayed) {
        switch (sheet.pageSetup.printErrors) {
          case CellErrorPrintOptions.blank:
            builder.attribute('errors', 'blank');
            break;
          case CellErrorPrintOptions.dash:
            builder.attribute('errors', 'dash');
            break;
          case CellErrorPrintOptions.notAvailable:
            builder.attribute('errors', 'NA');
            break;
          case CellErrorPrintOptions.displayed:
            break;
        }
      }
      if (sheet.pageSetup.printQuality != 0 &&
          sheet.pageSetup.printQuality != 600) {
        if (sheet.pageSetup.printQuality <= 38528) {
          builder.attribute(
              'horizontalDpi', sheet.pageSetup.printQuality.toString());
          builder.attribute(
              'verticalDpi', sheet.pageSetup.printQuality.toString());
        } else {
          builder.attribute('horizontalDpi', '38528');
          builder.attribute('verticalDpi', '38528');
        }
      }
    });
  }

  /// Serialize paperSize
  void _serializePaperSize(XmlBuilder builder, Worksheet sheet) {
    switch (sheet.pageSetup.paperSize) {
      case ExcelPaperSize.a2Paper:
        builder.attribute('paperSize', '66');
        break;
      case ExcelPaperSize.paperDsheet:
        builder.attribute('paperSize', '25');
        break;
      case ExcelPaperSize.paperEnvelope10:
        builder.attribute('paperSize', '20');
        break;
      case ExcelPaperSize.paperEnvelope11:
        builder.attribute('paperSize', '21');
        break;
      case ExcelPaperSize.paperEnvelope12:
        builder.attribute('paperSize', '22');
        break;
      case ExcelPaperSize.paperEnvelope14:
        builder.attribute('paperSize', '23');
        break;
      case ExcelPaperSize.paperEnvelope9:
        builder.attribute('paperSize', '19');
        break;
      case ExcelPaperSize.paperEnvelopeB4:
        builder.attribute('paperSize', '33');
        break;
      case ExcelPaperSize.paperEnvelopeB5:
        builder.attribute('paperSize', '34');
        break;
      case ExcelPaperSize.paperEnvelopeB6:
        builder.attribute('paperSize', '35');
        break;
      case ExcelPaperSize.paperEnvelopeC3:
        builder.attribute('paperSize', '29');
        break;
      case ExcelPaperSize.paperEnvelopeC4:
        builder.attribute('paperSize', '30');
        break;
      case ExcelPaperSize.paperEnvelopeC5:
        builder.attribute('paperSize', '28');
        break;
      case ExcelPaperSize.paperEnvelopeC6:
        builder.attribute('paperSize', '31');
        break;
      case ExcelPaperSize.paperEnvelopeC65:
        builder.attribute('paperSize', '32');
        break;
      case ExcelPaperSize.paperEnvelopeDL:
        builder.attribute('paperSize', '27');
        break;
      case ExcelPaperSize.paperEnvelopeItaly:
        builder.attribute('paperSize', '36');
        break;
      case ExcelPaperSize.paperEnvelopeMonarch:
        builder.attribute('paperSize', '37');
        break;
      case ExcelPaperSize.paperEnvelopePersonal:
        builder.attribute('paperSize', '38');
        break;
      case ExcelPaperSize.paperEsheet:
        builder.attribute('paperSize', '26');
        break;
      case ExcelPaperSize.paperExecutive:
        builder.attribute('paperSize', '7');
        break;
      case ExcelPaperSize.paperFanfoldLegalGerman:
        builder.attribute('paperSize', '41');
        break;
      case ExcelPaperSize.paperFanfoldStdGerman:
        builder.attribute('paperSize', '40');
        break;
      case ExcelPaperSize.paperFanfoldUS:
        builder.attribute('paperSize', '39');
        break;
      case ExcelPaperSize.paperFolio:
        builder.attribute('paperSize', '14');
        break;
      case ExcelPaperSize.paperLedger:
        builder.attribute('paperSize', '4');
        break;
      case ExcelPaperSize.paperLegal:
        builder.attribute('paperSize', '5');
        break;
      case ExcelPaperSize.paperLetter:
        builder.attribute('paperSize', '1');
        break;
      case ExcelPaperSize.paperLetterSmall:
        builder.attribute('paperSize', '2');
        break;
      case ExcelPaperSize.paperNote:
        builder.attribute('paperSize', '18');
        break;
      case ExcelPaperSize.paperQuarto:
        builder.attribute('paperSize', '15');
        break;
      case ExcelPaperSize.paperStatement:
        builder.attribute('paperSize', '6');
        break;
      case ExcelPaperSize.paperTabloid:
        builder.attribute('paperSize', '3');
        break;
      case ExcelPaperSize.paperUser:
        builder.attribute('paperSize', '256');
        break;
      case ExcelPaperSize.standardPaper9By11:
        builder.attribute('paperSize', '44');
        break;
      case ExcelPaperSize.standardPaper10By11:
        builder.attribute('paperSize', '45');
        break;
      case ExcelPaperSize.standardPaper15By11:
        builder.attribute('paperSize', '46');
        break;
      case ExcelPaperSize.tabloidExtraPaper:
        builder.attribute('paperSize', '52');
        break;
      case ExcelPaperSize.superASuperAA4Paper:
        builder.attribute('paperSize', '57');
        break;
      case ExcelPaperSize.superBSuperBA3Paper:
        builder.attribute('paperSize', '58');
        break;
      case ExcelPaperSize.paper10x14:
        builder.attribute('paperSize', '16');
        break;
      case ExcelPaperSize.paper11x17:
        builder.attribute('paperSize', '17');
        break;
      case ExcelPaperSize.paperA3:
        builder.attribute('paperSize', '8');
        break;
      case ExcelPaperSize.paperA4:
        builder.attribute('paperSize', '9');
        break;
      case ExcelPaperSize.paperA4Small:
        builder.attribute('paperSize', '10');
        break;
      case ExcelPaperSize.paperA5:
        builder.attribute('paperSize', '11');
        break;
      case ExcelPaperSize.paperB4:
        builder.attribute('paperSize', '12');
        break;
      case ExcelPaperSize.paperB5:
        builder.attribute('paperSize', '13');
        break;
      case ExcelPaperSize.paperCsheet:
        builder.attribute('paperSize', '24');
        break;
      case ExcelPaperSize.iSOB4:
        builder.attribute('paperSize', '42');
        break;
      case ExcelPaperSize.japaneseDoublePostcard:
        builder.attribute('paperSize', '43');
        break;
      case ExcelPaperSize.inviteEnvelope:
        builder.attribute('paperSize', '47');
        break;
      case ExcelPaperSize.letterExtraPaper9275By12:
        builder.attribute('paperSize', '50');
        break;
      case ExcelPaperSize.legalExtraPaper9275By15:
        builder.attribute('paperSize', '51');
        break;
      case ExcelPaperSize.a4ExtraPaper:
        builder.attribute('paperSize', '53');
        break;
      case ExcelPaperSize.letterTransversePaper:
        builder.attribute('paperSize', '54');
        break;
      case ExcelPaperSize.a4TransversePaper:
        builder.attribute('paperSize', '55');
        break;
      case ExcelPaperSize.letterExtraTransversePaper:
        builder.attribute('paperSize', '56');
        break;
      case ExcelPaperSize.letterPlusPaper:
        builder.attribute('paperSize', '59');
        break;
      case ExcelPaperSize.a4PlusPaper:
        builder.attribute('paperSize', '60');
        break;
      case ExcelPaperSize.a5TransversePaper:
        builder.attribute('paperSize', '61');
        break;
      case ExcelPaperSize.jISB5TransversePaper:
        builder.attribute('paperSize', '62');
        break;
      case ExcelPaperSize.a3ExtraPaper:
        builder.attribute('paperSize', '63');
        break;
      case ExcelPaperSize.a5ExtraPpaper:
        builder.attribute('paperSize', '64');
        break;
      case ExcelPaperSize.iSOB5ExtraPaper:
        builder.attribute('paperSize', '65');
        break;
      case ExcelPaperSize.a3TransversePaper:
        builder.attribute('paperSize', '67');
        break;
      case ExcelPaperSize.a3ExtraTransversePaper:
        builder.attribute('paperSize', '68');
        break;
    }
  }

  Future<void> _serializePaperSizeAsync(
      XmlBuilder builder, Worksheet sheet) async {
    switch (sheet.pageSetup.paperSize) {
      case ExcelPaperSize.a2Paper:
        builder.attribute('paperSize', '66');
        break;
      case ExcelPaperSize.paperDsheet:
        builder.attribute('paperSize', '25');
        break;
      case ExcelPaperSize.paperEnvelope10:
        builder.attribute('paperSize', '20');
        break;
      case ExcelPaperSize.paperEnvelope11:
        builder.attribute('paperSize', '21');
        break;
      case ExcelPaperSize.paperEnvelope12:
        builder.attribute('paperSize', '22');
        break;
      case ExcelPaperSize.paperEnvelope14:
        builder.attribute('paperSize', '23');
        break;
      case ExcelPaperSize.paperEnvelope9:
        builder.attribute('paperSize', '19');
        break;
      case ExcelPaperSize.paperEnvelopeB4:
        builder.attribute('paperSize', '33');
        break;
      case ExcelPaperSize.paperEnvelopeB5:
        builder.attribute('paperSize', '34');
        break;
      case ExcelPaperSize.paperEnvelopeB6:
        builder.attribute('paperSize', '35');
        break;
      case ExcelPaperSize.paperEnvelopeC3:
        builder.attribute('paperSize', '29');
        break;
      case ExcelPaperSize.paperEnvelopeC4:
        builder.attribute('paperSize', '30');
        break;
      case ExcelPaperSize.paperEnvelopeC5:
        builder.attribute('paperSize', '28');
        break;
      case ExcelPaperSize.paperEnvelopeC6:
        builder.attribute('paperSize', '31');
        break;
      case ExcelPaperSize.paperEnvelopeC65:
        builder.attribute('paperSize', '32');
        break;
      case ExcelPaperSize.paperEnvelopeDL:
        builder.attribute('paperSize', '27');
        break;
      case ExcelPaperSize.paperEnvelopeItaly:
        builder.attribute('paperSize', '36');
        break;
      case ExcelPaperSize.paperEnvelopeMonarch:
        builder.attribute('paperSize', '37');
        break;
      case ExcelPaperSize.paperEnvelopePersonal:
        builder.attribute('paperSize', '38');
        break;
      case ExcelPaperSize.paperEsheet:
        builder.attribute('paperSize', '26');
        break;
      case ExcelPaperSize.paperExecutive:
        builder.attribute('paperSize', '7');
        break;
      case ExcelPaperSize.paperFanfoldLegalGerman:
        builder.attribute('paperSize', '41');
        break;
      case ExcelPaperSize.paperFanfoldStdGerman:
        builder.attribute('paperSize', '40');
        break;
      case ExcelPaperSize.paperFanfoldUS:
        builder.attribute('paperSize', '39');
        break;
      case ExcelPaperSize.paperFolio:
        builder.attribute('paperSize', '14');
        break;
      case ExcelPaperSize.paperLedger:
        builder.attribute('paperSize', '4');
        break;
      case ExcelPaperSize.paperLegal:
        builder.attribute('paperSize', '5');
        break;
      case ExcelPaperSize.paperLetter:
        builder.attribute('paperSize', '1');
        break;
      case ExcelPaperSize.paperLetterSmall:
        builder.attribute('paperSize', '2');
        break;
      case ExcelPaperSize.paperNote:
        builder.attribute('paperSize', '18');
        break;
      case ExcelPaperSize.paperQuarto:
        builder.attribute('paperSize', '15');
        break;
      case ExcelPaperSize.paperStatement:
        builder.attribute('paperSize', '6');
        break;
      case ExcelPaperSize.paperTabloid:
        builder.attribute('paperSize', '3');
        break;
      case ExcelPaperSize.paperUser:
        builder.attribute('paperSize', '256');
        break;
      case ExcelPaperSize.standardPaper9By11:
        builder.attribute('paperSize', '44');
        break;
      case ExcelPaperSize.standardPaper10By11:
        builder.attribute('paperSize', '45');
        break;
      case ExcelPaperSize.standardPaper15By11:
        builder.attribute('paperSize', '46');
        break;
      case ExcelPaperSize.tabloidExtraPaper:
        builder.attribute('paperSize', '52');
        break;
      case ExcelPaperSize.superASuperAA4Paper:
        builder.attribute('paperSize', '57');
        break;
      case ExcelPaperSize.superBSuperBA3Paper:
        builder.attribute('paperSize', '58');
        break;
      case ExcelPaperSize.paper10x14:
        builder.attribute('paperSize', '16');
        break;
      case ExcelPaperSize.paper11x17:
        builder.attribute('paperSize', '17');
        break;
      case ExcelPaperSize.paperA3:
        builder.attribute('paperSize', '8');
        break;
      case ExcelPaperSize.paperA4:
        builder.attribute('paperSize', '9');
        break;
      case ExcelPaperSize.paperA4Small:
        builder.attribute('paperSize', '10');
        break;
      case ExcelPaperSize.paperA5:
        builder.attribute('paperSize', '11');
        break;
      case ExcelPaperSize.paperB4:
        builder.attribute('paperSize', '12');
        break;
      case ExcelPaperSize.paperB5:
        builder.attribute('paperSize', '13');
        break;
      case ExcelPaperSize.paperCsheet:
        builder.attribute('paperSize', '24');
        break;
      case ExcelPaperSize.iSOB4:
        builder.attribute('paperSize', '42');
        break;
      case ExcelPaperSize.japaneseDoublePostcard:
        builder.attribute('paperSize', '43');
        break;
      case ExcelPaperSize.inviteEnvelope:
        builder.attribute('paperSize', '47');
        break;
      case ExcelPaperSize.letterExtraPaper9275By12:
        builder.attribute('paperSize', '50');
        break;
      case ExcelPaperSize.legalExtraPaper9275By15:
        builder.attribute('paperSize', '51');
        break;
      case ExcelPaperSize.a4ExtraPaper:
        builder.attribute('paperSize', '53');
        break;
      case ExcelPaperSize.letterTransversePaper:
        builder.attribute('paperSize', '54');
        break;
      case ExcelPaperSize.a4TransversePaper:
        builder.attribute('paperSize', '55');
        break;
      case ExcelPaperSize.letterExtraTransversePaper:
        builder.attribute('paperSize', '56');
        break;
      case ExcelPaperSize.letterPlusPaper:
        builder.attribute('paperSize', '59');
        break;
      case ExcelPaperSize.a4PlusPaper:
        builder.attribute('paperSize', '60');
        break;
      case ExcelPaperSize.a5TransversePaper:
        builder.attribute('paperSize', '61');
        break;
      case ExcelPaperSize.jISB5TransversePaper:
        builder.attribute('paperSize', '62');
        break;
      case ExcelPaperSize.a3ExtraPaper:
        builder.attribute('paperSize', '63');
        break;
      case ExcelPaperSize.a5ExtraPpaper:
        builder.attribute('paperSize', '64');
        break;
      case ExcelPaperSize.iSOB5ExtraPaper:
        builder.attribute('paperSize', '65');
        break;
      case ExcelPaperSize.a3TransversePaper:
        builder.attribute('paperSize', '67');
        break;
      case ExcelPaperSize.a3ExtraTransversePaper:
        builder.attribute('paperSize', '68');
        break;
    }
  }

  /// Serializes single protection option.
  void _serializeProtectionAttribute(
      XmlBuilder builder, String attributeName, bool flag, bool defaultValue) {
    final bool value = flag;
    _serializeAttributes(builder, attributeName, value, defaultValue);
  }

  Future<void> _serializeProtectionAttributeAsync(XmlBuilder builder,
      String attributeName, bool flag, bool defaultValue) async {
    final bool value = flag;
    _serializeAttributesAsync(builder, attributeName, value, defaultValue);
  }

  /// Serialize hyperlinks
  void _serializeHyperlinks(XmlBuilder builder, Worksheet sheet) {
    if (sheet.hyperlinks.count > 0) {
      final int iCount = sheet.hyperlinks.count;
      final List<String> hyperLinkType = List<String>.filled(iCount, '');
      for (int i = 0; i < sheet.hyperlinks.count; i++) {
        final Hyperlink hyperLink = sheet.hyperlinks[i];
        hyperLinkType[i] =
            hyperLink._attachedType.toString().split('.').toList().removeAt(1);
      }
      if (iCount == 0 || !hyperLinkType.contains('range')) {
        return;
      }
      builder.element('hyperlinks', nest: () {
        int id = 1;
        for (final Hyperlink link in sheet.hyperlinks.innerList) {
          if (link._attachedType == ExcelHyperlinkAttachedType.range) {
            builder.element('hyperlink', nest: () {
              if (link.type == HyperlinkType.workbook) {
                builder.attribute('ref', link.reference);
                builder.attribute('location', link.address);
              } else {
                builder.attribute('ref', link.reference);
                final String rId = 'rId$id';
                builder.attribute('r:id', rId);
                _relationId.add(rId);
                id++;
              }
              if (link.screenTip != null) {
                // ignore: unnecessary_null_checks
                builder.attribute('tooltip', link.screenTip!);
              }
              if (link.textToDisplay != null) {
                // ignore: unnecessary_null_checks
                builder.attribute('display', link.textToDisplay!);
              } else {
                builder.attribute('display', link.address);
              }
            });
          }
        }
      });
    }
  }

  Future<void> _serializeHyperlinksAsync(
      XmlBuilder builder, Worksheet sheet) async {
    if (sheet.hyperlinks.count > 0) {
      final int iCount = sheet.hyperlinks.count;
      final List<String> hyperLinkType = List<String>.filled(iCount, '');
      for (int i = 0; i < sheet.hyperlinks.count; i++) {
        final Hyperlink hyperLink = sheet.hyperlinks[i];
        hyperLinkType[i] =
            hyperLink._attachedType.toString().split('.').toList().removeAt(1);
      }
      if (iCount == 0 || !hyperLinkType.contains('range')) {
        return;
      }
      builder.element('hyperlinks', nest: () async {
        int id = 1;
        for (final Hyperlink link in sheet.hyperlinks.innerList) {
          if (link._attachedType == ExcelHyperlinkAttachedType.range) {
            builder.element('hyperlink', nest: () async {
              if (link.type == HyperlinkType.workbook) {
                builder.attribute('ref', link.reference);
                builder.attribute('location', link.address);
              } else {
                builder.attribute('ref', link.reference);
                final String rId = 'rId$id';
                builder.attribute('r:id', rId);
                _relationId.add(rId);
                id++;
              }
              if (link.screenTip != null) {
                // ignore: unnecessary_null_checks
                builder.attribute('tooltip', link.screenTip!);
              }
              if (link.textToDisplay != null) {
                // ignore: unnecessary_null_checks
                builder.attribute('display', link.textToDisplay!);
              } else {
                builder.attribute('display', link.address);
              }
            });
          }
        }
      });
    }
  }

  /// Serialize drawings
  void _saveDrawings(Worksheet sheet) {
    final XmlBuilder builder = XmlBuilder();
    builder.processing('xml', 'version="1.0"');
    builder.element('xdr:wsDr', nest: () {
      builder.attribute('xmlns:xdr',
          'http://schemas.openxmlformats.org/drawingml/2006/spreadsheetDrawing');
      builder.attribute(
          'xmlns:a', 'http://schemas.openxmlformats.org/drawingml/2006/main');
      final int chartCount = sheet.chartCount;
      if (chartCount != 0 && sheet.charts != null) {
        sheet.charts!.serializeChartDrawingSync(builder, sheet);
      }
      final int idIndex = 0 + chartCount;
      final List<String> idRelation = <String>[];
      if (sheet.pictures.count != 0) {
        int imgId = 0;
        int idHyperlink = 1;
        int hyperlinkCount = 0;
        for (final Picture picture in sheet.pictures.innerList) {
          if (picture.height != 0 && picture.width != 0) {
            if (picture.lastRow == 0 || picture.lastRow < picture.row) {
              _updateLastRowOffset(sheet, picture);
            } else if (picture.lastRow != 0) {
              picture.lastRowOffset = 0;
            }
            if (picture.lastColumn == 0 ||
                picture.lastColumn < picture.column) {
              _updateLastColumnOffSet(sheet, picture);
            } else if (picture.lastColumn != 0) {
              picture.lastColOffset = 0;
            }
          }
          imgId++;
          builder.element('xdr:twoCellAnchor', nest: () {
            builder.attribute('editAs', 'twoCell');
            builder.element('xdr:from', nest: () {
              builder.element('xdr:col', nest: picture.column - 1);
              builder.element('xdr:colOff', nest: 0);
              builder.element('xdr:row', nest: picture.row - 1);
              builder.element('xdr:rowOff', nest: 0);
            });

            builder.element('xdr:to', nest: () {
              builder.element('xdr:col', nest: picture.lastColumn - 1);
              builder.element('xdr:colOff',
                  nest: picture.lastColOffset.round());
              builder.element('xdr:row', nest: picture.lastRow - 1);
              builder.element('xdr:rowOff',
                  nest: picture.lastRowOffset.round());
            });

            builder.element('xdr:pic', nest: () {
              builder.attribute('macro', '');
              builder.element('xdr:nvPicPr', nest: () {
                builder.element('xdr:cNvPr', nest: () {
                  builder.attribute('id', imgId);
                  builder.attribute('name', 'Picture$imgId');
                  if (picture._isHyperlink) {
                    builder.element('a:hlinkClick', nest: () {
                      builder.attribute('xmlns:r',
                          'http://schemas.openxmlformats.org/officeDocument/2006/relationships');
                      int id = idIndex + imgId + idHyperlink;
                      String rId = 'rId$id';
                      if (idRelation.contains(rId)) {
                        id = id + 1;
                        rId = 'rId$id';
                      }
                      builder.attribute('r:id', rId);
                      idRelation.add(rId);
                      sheet._hyperlinkRelationId.add(rId);
                      idHyperlink++;
                      if (picture.hyperlink != null &&
                          picture.hyperlink!.screenTip != null) {
                        builder.attribute(
                            'tooltip',
                            // ignore: unnecessary_null_checks
                            picture.hyperlink!.screenTip!);
                      }
                    });
                  }
                });
                builder.element('xdr:cNvPicPr', nest: () {
                  builder.element('a:picLocks', nest: () {
                    builder.attribute('noChangeAspect', 1);
                  });
                });
              });

              builder.element('xdr:blipFill', nest: () {
                builder.element('a:blip', nest: () {
                  builder.attribute('xmlns:r',
                      'http://schemas.openxmlformats.org/officeDocument/2006/relationships');
                  int id;
                  String rId;
                  if (idRelation.isEmpty) {
                    id = idIndex + imgId + hyperlinkCount;
                    rId = 'rId$id';
                    builder.attribute('r:embed', rId);
                    idRelation.add(rId);
                  } else {
                    id = idIndex + imgId + hyperlinkCount;
                    rId = 'rId$id';
                    if (idRelation.contains(rId)) {
                      id = id + 1;
                      rId = 'rId$id';
                      if (idRelation.contains(rId)) {
                        id = id + 1;
                        rId = 'rId$id';
                      }
                    }
                    builder.attribute('r:embed', rId);
                    idRelation.add(rId);
                    if (picture._isHyperlink) {
                      hyperlinkCount++;
                    }
                  }
                  builder.attribute('cstate', 'print');
                });

                builder.element('a:stretch', nest: () {
                  builder.element('a:fillRect', nest: () {});
                });
              });

              builder.element('xdr:spPr', nest: () {
                builder.element('a:xfrm', nest: () {
                  if (picture.rotation != 0 &&
                      picture.rotation <= 3600 &&
                      picture.rotation >= -3600) {
                    builder.attribute('rot', picture.rotation * 60000);
                  }
                  if (picture.verticalFlip) {
                    builder.attribute('flipV', '1');
                  }
                  if (picture.horizontalFlip) {
                    builder.attribute('flipH', '1');
                  }
                  builder.element('a:off', nest: () {
                    builder.attribute('x', '0');
                    builder.attribute('y', '0');
                  });
                  builder.element('a:ext', nest: () {
                    builder.attribute('cx', '0');
                    builder.attribute('cy', '0');
                  });
                });

                builder.element('a:prstGeom', nest: () {
                  builder.attribute('prst', 'rect');
                  builder.element('a:avLst', nest: () {});
                });
              });
            });
            builder.element('xdr:clientData', nest: () {});
          });
          final List<int>? imageData = picture.imageData;
          _workbook._imageCount += 1;
          String imgPath;
          if (Picture.isJpeg(imageData)) {
            imgPath = 'xl/media/image${_workbook._imageCount}.jpeg';
            if (!_workbook._defaultContentTypes.containsKey('jpeg')) {
              _workbook._defaultContentTypes['jpeg'] = 'image/jpeg';
            }
          } else {
            imgPath = 'xl/media/image${_workbook._imageCount}.png';
            if (!_workbook._defaultContentTypes.containsKey('png')) {
              _workbook._defaultContentTypes['png'] = 'image/png';
            }
          }
          if (imageData != null) {
            _addToArchive(imageData, imgPath);
          }
        }
      }
    });
    _saveDrawingRelations(sheet);
    final String stringXml = builder.buildDocument().copy().toString();
    final List<int> bytes = utf8.encode(stringXml);
    _addToArchive(bytes, 'xl/drawings/drawing${_workbook._drawingCount}.xml');
  }

  Future<void> _saveDrawingsAsync(Worksheet sheet) async {
    final XmlBuilder builder = XmlBuilder();
    builder.processing('xml', 'version="1.0"');
    builder.element('xdr:wsDr', nest: () async {
      builder.attribute('xmlns:xdr',
          'http://schemas.openxmlformats.org/drawingml/2006/spreadsheetDrawing');
      builder.attribute(
          'xmlns:a', 'http://schemas.openxmlformats.org/drawingml/2006/main');
      final int chartCount = sheet.chartCount;
      if (chartCount != 0 && sheet.charts != null) {
        sheet.charts!.serializeChartDrawing(builder, sheet);
      }
      final int idIndex = 0 + chartCount;
      final List<String> idRelation = <String>[];
      if (sheet.pictures.count != 0) {
        int imgId = 0;
        int idHyperlink = 1;
        int hyperlinkCount = 0;
        for (final Picture picture in sheet.pictures.innerList) {
          if (picture.height != 0 && picture.width != 0) {
            if (picture.lastRow == 0 || picture.lastRow < picture.row) {
              _updateLastRowOffsetAsync(sheet, picture);
            } else if (picture.lastRow != 0) {
              picture.lastRowOffset = 0;
            }
            if (picture.lastColumn == 0 ||
                picture.lastColumn < picture.column) {
              _updateLastColumnOffSetAsync(sheet, picture);
            } else if (picture.lastColumn != 0) {
              picture.lastColOffset = 0;
            }
          }
          imgId++;
          builder.element('xdr:twoCellAnchor', nest: () async {
            builder.attribute('editAs', 'twoCell');
            builder.element('xdr:from', nest: () async {
              builder.element('xdr:col', nest: picture.column - 1);
              builder.element('xdr:colOff', nest: 0);
              builder.element('xdr:row', nest: picture.row - 1);
              builder.element('xdr:rowOff', nest: 0);
            });

            builder.element('xdr:to', nest: () async {
              builder.element('xdr:col', nest: picture.lastColumn - 1);
              builder.element('xdr:colOff',
                  nest: picture.lastColOffset.round());
              builder.element('xdr:row', nest: picture.lastRow - 1);
              builder.element('xdr:rowOff',
                  nest: picture.lastRowOffset.round());
            });

            builder.element('xdr:pic', nest: () async {
              builder.attribute('macro', '');
              builder.element('xdr:nvPicPr', nest: () async {
                builder.element('xdr:cNvPr', nest: () async {
                  builder.attribute('id', imgId);
                  builder.attribute('name', 'Picture$imgId');
                  if (picture._isHyperlink) {
                    builder.element('a:hlinkClick', nest: () async {
                      builder.attribute('xmlns:r',
                          'http://schemas.openxmlformats.org/officeDocument/2006/relationships');
                      int id = idIndex + imgId + idHyperlink;
                      String rId = 'rId$id';
                      if (idRelation.contains(rId)) {
                        id = id + 1;
                        rId = 'rId$id';
                      }
                      builder.attribute('r:id', rId);
                      idRelation.add(rId);
                      sheet._hyperlinkRelationId.add(rId);
                      idHyperlink++;
                      if (picture.hyperlink != null &&
                          picture.hyperlink!.screenTip != null) {
                        builder.attribute(
                            'tooltip',
                            // ignore: unnecessary_null_checks
                            picture.hyperlink!.screenTip!);
                      }
                    });
                  }
                });
                builder.element('xdr:cNvPicPr', nest: () async {
                  builder.element('a:picLocks', nest: () async {
                    builder.attribute('noChangeAspect', 1);
                  });
                });
              });

              builder.element('xdr:blipFill', nest: () async {
                builder.element('a:blip', nest: () async {
                  builder.attribute('xmlns:r',
                      'http://schemas.openxmlformats.org/officeDocument/2006/relationships');
                  int id;
                  String rId;
                  if (idRelation.isEmpty) {
                    id = idIndex + imgId + hyperlinkCount;
                    rId = 'rId$id';
                    builder.attribute('r:embed', rId);
                    idRelation.add(rId);
                  } else {
                    id = idIndex + imgId + hyperlinkCount;
                    rId = 'rId$id';
                    if (idRelation.contains(rId)) {
                      id = id + 1;
                      rId = 'rId$id';
                      if (idRelation.contains(rId)) {
                        id = id + 1;
                        rId = 'rId$id';
                      }
                    }
                    builder.attribute('r:embed', rId);
                    idRelation.add(rId);
                    if (picture._isHyperlink) {
                      hyperlinkCount++;
                    }
                  }
                  builder.attribute('cstate', 'print');
                });

                builder.element('a:stretch', nest: () async {
                  builder.element('a:fillRect', nest: () async {});
                });
              });

              builder.element('xdr:spPr', nest: () async {
                builder.element('a:xfrm', nest: () async {
                  if (picture.rotation != 0 &&
                      picture.rotation <= 3600 &&
                      picture.rotation >= -3600) {
                    builder.attribute('rot', picture.rotation * 60000);
                  }
                  if (picture.verticalFlip) {
                    builder.attribute('flipV', '1');
                  }
                  if (picture.horizontalFlip) {
                    builder.attribute('flipH', '1');
                  }
                  builder.element('a:off', nest: () async {
                    builder.attribute('x', '0');
                    builder.attribute('y', '0');
                  });
                  builder.element('a:ext', nest: () async {
                    builder.attribute('cx', '0');
                    builder.attribute('cy', '0');
                  });
                });

                builder.element('a:prstGeom', nest: () async {
                  builder.attribute('prst', 'rect');
                  builder.element('a:avLst', nest: () async {});
                });
              });
            });
            builder.element('xdr:clientData', nest: () async {});
          });
          final List<int>? imageData = picture.imageData;
          _workbook._imageCount += 1;
          String imgPath;
          if (Picture.isJpeg(imageData)) {
            imgPath = 'xl/media/image${_workbook._imageCount}.jpeg';
            if (!_workbook._defaultContentTypes.containsKey('jpeg')) {
              _workbook._defaultContentTypes['jpeg'] = 'image/jpeg';
            }
          } else {
            imgPath = 'xl/media/image${_workbook._imageCount}.png';
            if (!_workbook._defaultContentTypes.containsKey('png')) {
              _workbook._defaultContentTypes['png'] = 'image/png';
            }
          }
          if (imageData != null) {
            _addToArchiveAsync(imageData, imgPath);
          }
        }
      }
    });
    _saveDrawingRelationsAsync(sheet);
    final String stringXml = builder.buildDocument().copy().toString();
    final List<int> bytes = utf8.encode(stringXml);
    _addToArchiveAsync(
        bytes, 'xl/drawings/drawing${_workbook._drawingCount}.xml');
  }

  /// Serialize drawing relations.
  void _saveDrawingRelations(Worksheet sheet) {
    int idIndex = 0;
    final XmlBuilder builder = XmlBuilder();
    builder.processing('xml', 'version="1.0"');
    builder.element('Relationships', nest: () {
      builder.namespace(
          'http://schemas.openxmlformats.org/package/2006/relationships');
      if (sheet.chartCount != 0) {
        final int length = sheet.chartCount;
        for (int i = 1; i <= length; i++) {
          builder.element('Relationship', nest: () {
            builder.attribute('Id', 'rId${idIndex + i}');
            builder.attribute('Type',
                'http://schemas.openxmlformats.org/officeDocument/2006/relationships/chart');
            builder.attribute('Target',
                '/xl/charts/chart${sheet.workbook.chartCount + i}.xml');
          });
        }
        idIndex = length;
      }
      if (sheet.hyperlinks.count > 0) {
        final int length = sheet.hyperlinks.count;
        int j = 0;
        for (int i = 0; i < length; i++) {
          if (sheet.hyperlinks[i]._attachedType ==
              ExcelHyperlinkAttachedType.shape) {
            builder.element('Relationship', nest: () {
              builder.attribute('Id', sheet._hyperlinkRelationId[j]);
              builder.attribute('Type',
                  'http://schemas.openxmlformats.org/officeDocument/2006/relationships/hyperlink');
              if (sheet.hyperlinks[i].type == HyperlinkType.workbook) {
                String address = sheet.hyperlinks[i].address;
                address = address.startsWith('#') ? address : '#$address';
                builder.attribute('Target', address);
              } else {
                builder.attribute('Target', sheet.hyperlinks[i].address);
              }
              if (sheet.hyperlinks[i].type != HyperlinkType.workbook) {
                builder.attribute('TargetMode', 'External');
              }
            });
            j++;
          }
        }
      }
      if (sheet.pictures.count != 0) {
        final int length = sheet.pictures.count;
        int id = _workbook._imageCount - sheet.pictures.count;
        int idHyperlink = 0;
        for (int i = 1; i <= length; i++) {
          id++;
          builder.element('Relationship', nest: () {
            String imgPath;
            if (Picture.isPng(sheet.pictures[i - 1].imageData)) {
              imgPath = '/xl/media/image$id.png';
            } else {
              imgPath = '/xl/media/image$id.jpeg';
            }
            if (sheet.pictures[i - 1]._isHyperlink) {
              builder.attribute('Id', 'rId${idIndex + i + idHyperlink}');
              builder.attribute('Type',
                  'http://schemas.openxmlformats.org/officeDocument/2006/relationships/image');
              builder.attribute('Target', imgPath);
              idHyperlink++;
            } else {
              builder.attribute('Id', 'rId${idIndex + i + idHyperlink}');
              builder.attribute('Type',
                  'http://schemas.openxmlformats.org/officeDocument/2006/relationships/image');
              builder.attribute('Target', imgPath);
            }
          });
        }
      }
    });

    final String stringXml = builder.buildDocument().copy().toString();
    final List<int> bytes = utf8.encode(stringXml);
    _addToArchive(
        bytes, 'xl/drawings/_rels/drawing${_workbook._drawingCount}.xml.rels');
  }

  Future<void> _saveDrawingRelationsAsync(Worksheet sheet) async {
    int idIndex = 0;
    final XmlBuilder builder = XmlBuilder();
    builder.processing('xml', 'version="1.0"');
    builder.element('Relationships', nest: () async {
      builder.namespace(
          'http://schemas.openxmlformats.org/package/2006/relationships');
      if (sheet.chartCount != 0) {
        final int length = sheet.chartCount;
        for (int i = 1; i <= length; i++) {
          builder.element('Relationship', nest: () async {
            builder.attribute('Id', 'rId${idIndex + i}');
            builder.attribute('Type',
                'http://schemas.openxmlformats.org/officeDocument/2006/relationships/chart');
            builder.attribute('Target',
                '/xl/charts/chart${sheet.workbook.chartCount + i}.xml');
          });
        }
        idIndex = length;
      }
      if (sheet.hyperlinks.count > 0) {
        final int length = sheet.hyperlinks.count;
        int j = 0;
        for (int i = 0; i < length; i++) {
          if (sheet.hyperlinks[i]._attachedType ==
              ExcelHyperlinkAttachedType.shape) {
            builder.element('Relationship', nest: () async {
              builder.attribute('Id', sheet._hyperlinkRelationId[j]);
              builder.attribute('Type',
                  'http://schemas.openxmlformats.org/officeDocument/2006/relationships/hyperlink');
              if (sheet.hyperlinks[i].type == HyperlinkType.workbook) {
                String address = sheet.hyperlinks[i].address;
                address = address.startsWith('#') ? address : '#$address';
                builder.attribute('Target', address);
              } else {
                builder.attribute('Target', sheet.hyperlinks[i].address);
              }
              if (sheet.hyperlinks[i].type != HyperlinkType.workbook) {
                builder.attribute('TargetMode', 'External');
              }
            });
            j++;
          }
        }
      }
      if (sheet.pictures.count != 0) {
        final int length = sheet.pictures.count;
        int id = _workbook._imageCount - sheet.pictures.count;
        int idHyperlink = 0;
        for (int i = 1; i <= length; i++) {
          id++;
          builder.element('Relationship', nest: () async {
            String imgPath;
            if (Picture.isPng(sheet.pictures[i - 1].imageData)) {
              imgPath = '/xl/media/image$id.png';
            } else {
              imgPath = '/xl/media/image$id.jpeg';
            }
            if (sheet.pictures[i - 1]._isHyperlink) {
              builder.attribute('Id', 'rId${idIndex + i + idHyperlink}');
              builder.attribute('Type',
                  'http://schemas.openxmlformats.org/officeDocument/2006/relationships/image');
              builder.attribute('Target', imgPath);
              idHyperlink++;
            } else {
              builder.attribute('Id', 'rId${idIndex + i + idHyperlink}');
              builder.attribute('Type',
                  'http://schemas.openxmlformats.org/officeDocument/2006/relationships/image');
              builder.attribute('Target', imgPath);
            }
          });
        }
      }
    });

    final String stringXml = builder.buildDocument().copy().toString();
    final List<int> bytes = utf8.encode(stringXml);
    _addToArchiveAsync(
        bytes, 'xl/drawings/_rels/drawing${_workbook._drawingCount}.xml.rels');
  }

  /// Updates the picture shape last row offset.
  void _updateLastRowOffset(Worksheet sheet, Picture picture) {
    double iCurHeight = picture.height.toDouble();
    int iCurRow = picture.row;
    int iCurOffset = 0;

    while (iCurHeight >= 0) {
      double iRowHeight;
      if (sheet.rows.count != 0 &&
          iCurRow - 1 < sheet.rows.count &&
          sheet.rows[iCurRow] != null) {
        iRowHeight = _convertToPixels((sheet.rows[iCurRow]!.height == 0)
            ? 15
            : sheet.rows[iCurRow]!.height);
      } else {
        iRowHeight = _convertToPixels(15);
      }
      final double iSpaceInCell =
          iRowHeight - ((iCurOffset * iRowHeight) / 256);

      if (iSpaceInCell > iCurHeight) {
        picture.lastRow = iCurRow;
        picture.lastRowOffset = iCurOffset + (iCurHeight * 256 / iRowHeight);
        double rowHiddenHeight;
        if (sheet.rows.count != 0 &&
            iCurRow < sheet.rows.count &&
            sheet.rows[iCurRow] != null) {
          rowHiddenHeight = _convertToPixels((sheet.rows[iCurRow]!.height == 0)
              ? 15
              : sheet.rows[iCurRow]!.height);
        } else {
          rowHiddenHeight = _convertToPixels(15);
        }

        picture.lastRowOffset = (rowHiddenHeight * picture.lastRowOffset) / 256;
        picture.lastRowOffset =
            (picture.lastRowOffset / _workbook._unitProportions[7])
                .round()
                .toDouble();
        break;
      } else {
        iCurHeight -= iSpaceInCell;
        iCurRow++;
        iCurOffset = 0;
      }
    }
  }

  Future<void> _updateLastRowOffsetAsync(
      Worksheet sheet, Picture picture) async {
    double iCurHeight = picture.height.toDouble();
    int iCurRow = picture.row;
    int iCurOffset = 0;

    while (iCurHeight >= 0) {
      double iRowHeight = 0;
      if (sheet.rows.count != 0 &&
          iCurRow - 1 < sheet.rows.count &&
          sheet.rows[iCurRow] != null) {
        iRowHeight = _convertToPixels((sheet.rows[iCurRow]!.height == 0)
            ? 15
            : sheet.rows[iCurRow]!.height);
      } else {
        iRowHeight = _convertToPixels(15);
      }
      final double iSpaceInCell =
          iRowHeight - ((iCurOffset * iRowHeight) / 256);

      if (iSpaceInCell > iCurHeight) {
        picture.lastRow = iCurRow;
        picture.lastRowOffset = iCurOffset + (iCurHeight * 256 / iRowHeight);
        double rowHiddenHeight = 0;
        if (sheet.rows.count != 0 &&
            iCurRow < sheet.rows.count &&
            sheet.rows[iCurRow] != null) {
          rowHiddenHeight = _convertToPixels((sheet.rows[iCurRow]!.height == 0)
              ? 15
              : sheet.rows[iCurRow]!.height);
        } else {
          rowHiddenHeight = _convertToPixels(15);
        }

        picture.lastRowOffset = (rowHiddenHeight * picture.lastRowOffset) / 256;
        picture.lastRowOffset =
            (picture.lastRowOffset / _workbook._unitProportions[7])
                .round()
                .toDouble();
        break;
      } else {
        iCurHeight -= iSpaceInCell;
        iCurRow++;
        iCurOffset = 0;
      }
    }
  }

  /// Updates the picture shape last column offset.
  void _updateLastColumnOffSet(Worksheet sheet, Picture picture) {
    double iCurWidth = picture.width.toDouble();
    int iCurCol = picture.column;
    double iCurOffset = 0;

    while (iCurWidth >= 0) {
      double iColWidth;
      Column? col = sheet.columns[iCurCol];
      if (sheet.columns.count != 0 &&
          iCurCol - 1 < sheet.columns.count &&
          col != null) {
        iColWidth = _columnWidthToPixels(col.width == 0 ? 8.43 : col.width);
      } else {
        iColWidth = _columnWidthToPixels(8.43);
      }
      final double iSpaceInCell = iColWidth - (iCurOffset * iColWidth / 1024);

      if (iSpaceInCell > iCurWidth) {
        picture.lastColumn = iCurCol;
        picture.lastColOffset = iCurOffset + (iCurWidth * 1024 / iColWidth);
        double colHiddenWidth;
        col = sheet.columns[iCurCol];
        if (sheet.columns.count != 0 &&
            iCurCol - 1 < sheet.columns.count &&
            col != null) {
          colHiddenWidth =
              _columnWidthToPixels(col.width == 0 ? 8.43 : col.width);
        } else {
          colHiddenWidth = _columnWidthToPixels(8.43);
        }

        picture.lastColOffset = (colHiddenWidth * picture.lastColOffset) / 1024;
        picture.lastColOffset =
            (picture.lastColOffset / _workbook._unitProportions[7])
                .round()
                .toDouble();

        break;
      } else {
        iCurWidth -= iSpaceInCell;
        iCurCol++;
        iCurOffset = 0;
      }
    }
  }

  Future<void> _updateLastColumnOffSetAsync(
      Worksheet sheet, Picture picture) async {
    double iCurWidth = picture.width.toDouble();
    int iCurCol = picture.column;
    double iCurOffset = 0;

    while (iCurWidth >= 0) {
      double iColWidth = 0;
      Column? col = sheet.columns[iCurCol];
      if (sheet.columns.count != 0 &&
          iCurCol - 1 < sheet.columns.count &&
          col != null) {
        iColWidth = _columnWidthToPixels(col.width == 0 ? 8.43 : col.width);
      } else {
        iColWidth = _columnWidthToPixels(8.43);
      }
      final double iSpaceInCell = iColWidth - (iCurOffset * iColWidth / 1024);

      if (iSpaceInCell > iCurWidth) {
        picture.lastColumn = iCurCol;
        picture.lastColOffset = iCurOffset + (iCurWidth * 1024 / iColWidth);
        double colHiddenWidth = 0;
        col = sheet.columns[iCurCol];
        if (sheet.columns.count != 0 &&
            iCurCol - 1 < sheet.columns.count &&
            col != null) {
          colHiddenWidth =
              _columnWidthToPixels(col.width == 0 ? 8.43 : col.width);
        } else {
          colHiddenWidth = _columnWidthToPixels(8.43);
        }

        picture.lastColOffset = (colHiddenWidth * picture.lastColOffset) / 1024;
        picture.lastColOffset =
            (picture.lastColOffset / _workbook._unitProportions[7])
                .round()
                .toDouble();

        break;
      } else {
        iCurWidth -= iSpaceInCell;
        iCurCol++;
        iCurOffset = 0;
      }
    }
  }

  /// Converts the given value to pixels.
  double _convertToPixels(double value) {
    return value * _workbook._unitProportions[6];
  }

  /// Converts column width to pixels.
  static double _columnWidthToPixels(double val) {
    const int dDigitWidth = 7;
    final double fileWidth = (val > 1)
        ? ((val * dDigitWidth + 5) / dDigitWidth * 256.0) / 256.0
        : (val * (dDigitWidth + 5) / dDigitWidth * 256.0) / 256.0;
    return _trunc(
        ((256 * fileWidth + _trunc(128 / dDigitWidth)) / 256) * dDigitWidth);
  }

  /// Trucates the given value.
  static double _trunc(double x) {
    final double n = x - x % 1;
    return n == 0 && (x < 0 || (x == 0)) ? -0 : n;
  }

  /// Serialize sheet relations.
  List<int> _saveSheetRelations(Worksheet sheet) {
    final XmlBuilder builder = XmlBuilder();
    builder.processing('xml', 'version="1.0"');
    builder.element('Relationships', nest: () {
      builder.namespace(
          'http://schemas.openxmlformats.org/package/2006/relationships');

      if (sheet.hyperlinks.count > 0) {
        int id = 1;
        for (final Hyperlink link in sheet.hyperlinks.innerList) {
          if (link._attachedType == ExcelHyperlinkAttachedType.range &&
              link.type != HyperlinkType.workbook) {
            builder.element('Relationship', nest: () {
              builder.attribute('Id', 'rId$id');
              builder.attribute('Type',
                  'http://schemas.openxmlformats.org/officeDocument/2006/relationships/hyperlink');
              builder.attribute('Target', link.address);
              builder.attribute('TargetMode', 'External');
            });
            id++;
          }
        }
      }
      if (sheet.pictures.count > 0) {
        builder.element('Relationship', nest: () {
          int id = 1;
          const String rId = 'rId1';
          if (_relationId.isNotEmpty) {
            if (sheet.hyperlinks.count > 0) {
              for (int i = 0; i < sheet.hyperlinks.count; i++) {
                if (sheet.hyperlinks[i]._attachedType ==
                        ExcelHyperlinkAttachedType.range &&
                    sheet.hyperlinks[i].type != HyperlinkType.workbook) {
                  id++;
                }
              }
            }
            builder.attribute('Id', 'rId$id');
          } else {
            builder.attribute('Id', rId);
          }
          builder.attribute('Type',
              'http://schemas.openxmlformats.org/officeDocument/2006/relationships/drawing');
          builder.attribute(
              'Target', '../drawings/drawing${_workbook._drawingCount}.xml');
        });
      } else if (sheet.charts != null && sheet.chartCount > 0) {
        builder.element('Relationship', nest: () {
          int id = 1;
          const String rId = 'rId1';
          if (_relationId.isNotEmpty) {
            if (sheet.hyperlinks.count > 0) {
              for (int i = 0; i < sheet.hyperlinks.count; i++) {
                if (sheet.hyperlinks[i]._attachedType ==
                        ExcelHyperlinkAttachedType.range &&
                    sheet.hyperlinks[i].type != HyperlinkType.workbook) {
                  id++;
                }
              }
            }
            builder.attribute('Id', 'rId$id');
          } else {
            builder.attribute('Id', rId);
          }
          builder.attribute('Type',
              'http://schemas.openxmlformats.org/officeDocument/2006/relationships/drawing');
          builder.attribute(
              'Target', '../drawings/drawing${_workbook._drawingCount}.xml');
        });
      }
      final int length = sheet.tableCollection._count;
      int rid;
      int index;
      int id = 1;
      if (length > 0) {
        if (sheet.hyperlinks.count > 0) {
          for (int hyperlinkCount = 0;
              hyperlinkCount < sheet.hyperlinks.count;
              hyperlinkCount++) {
            if (sheet.hyperlinks[hyperlinkCount]._attachedType ==
                    ExcelHyperlinkAttachedType.range &&
                sheet.hyperlinks[hyperlinkCount].type !=
                    HyperlinkType.workbook) {
              id++;
            }
          }
        }
        if (sheet.pictures.count > 0) {
          for (int pictureCount = 0;
              pictureCount < sheet.pictures.count;
              pictureCount++) {
            id++;
          }
        }
        for (int tableCount = _workbook._previousTableCount;
            tableCount < _workbook._tableCount;
            tableCount++) {
          builder.element('Relationship', nest: () {
            rid = id++;
            index = tableCount + 1;
            builder.attribute('Id', 'rId$rid');
            builder.attribute('Type',
                'http://schemas.openxmlformats.org/officeDocument/2006/relationships/table');
            builder.attribute('Target', '../tables/table$index.xml');
          });
        }
        _workbook._previousTableCount = _workbook._tableCount;
      }
    });
    final String stringXml = builder.buildDocument().copy().toString();
    return utf8.encode(stringXml);
  }

  /// Serialize sheet view.
  static void _saveSheetView(Worksheet sheet, XmlBuilder builder) {
    builder.element('sheetViews', nest: () {
      builder.element('sheetView', nest: () {
        builder.attribute('workbookViewId', '0');
        if (sheet.isRightToLeft) {
          builder.attribute('rightToLeft', '1');
        }
        if (!sheet.showGridlines) {
          builder.attribute('showGridLines', '0');
        }
        if (sheet._isfreezePane ||
            sheet._verticalSplit != 0 ||
            sheet._horizontalSplit != 0) {
          _savePane(sheet, builder);
        }
      });
    });
  }

  static Future<void> _saveSheetViewAsync(
      Worksheet sheet, XmlBuilder builder) async {
    builder.element('sheetViews', nest: () async {
      builder.element('sheetView', nest: () async {
        builder.attribute('workbookViewId', '0');
        if (sheet.isRightToLeft) {
          builder.attribute('rightToLeft', '1');
        }
        if (!sheet.showGridlines) {
          builder.attribute('showGridLines', '0');
        }
        if (sheet._isfreezePane ||
            sheet._verticalSplit != 0 ||
            sheet._horizontalSplit != 0) {
          _savePaneAsync(sheet, builder);
        }
      });
    });
  }

  /// Serialize worksheet Pane.
  static void _savePane(Worksheet sheet, XmlBuilder builder) {
    builder.element('pane', nest: () {
      if (sheet._verticalSplit != 0) {
        builder.attribute('xSplit', sheet._verticalSplit.toString());
      }
      if (sheet._horizontalSplit != 0) {
        builder.attribute('ySplit', sheet._horizontalSplit.toString());
      }
      if (sheet._topLeftCell != '') {
        builder.attribute('topLeftCell', sheet._topLeftCell);
      }
      switch (sheet._activePane) {
        case _ActivePane.bottomRight:
          builder.attribute('activePane', 'bottomRight');
          break;
        case _ActivePane.bottomLeft:
          builder.attribute('activePane', 'bottomLeft');
          break;
        case _ActivePane.topRight:
          builder.attribute('activePane', 'topRight');
          break;
        case _ActivePane.topLeft:
          builder.attribute('activePane', 'topLeft');
          break;
      }
      builder.attribute('state', 'frozen');
    });
  }

  static Future<void> _savePaneAsync(
      Worksheet sheet, XmlBuilder builder) async {
    builder.element('pane', nest: () async {
      if (sheet._verticalSplit != 0) {
        builder.attribute('xSplit', sheet._verticalSplit.toString());
      }
      if (sheet._horizontalSplit != 0) {
        builder.attribute('ySplit', sheet._horizontalSplit.toString());
      }
      if (sheet._topLeftCell != '') {
        builder.attribute('topLeftCell', sheet._topLeftCell);
      }
      switch (sheet._activePane) {
        case _ActivePane.bottomRight:
          builder.attribute('activePane', 'bottomRight');
          break;
        case _ActivePane.bottomLeft:
          builder.attribute('activePane', 'bottomLeft');
          break;
        case _ActivePane.topRight:
          builder.attribute('activePane', 'topRight');
          break;
        case _ActivePane.topLeft:
          builder.attribute('activePane', 'topLeft');
          break;
      }
      builder.attribute('state', 'frozen');
    });
  }

  /// Serialize workbook shared string.
  void _saveSharedString() {
    final XmlBuilder builder = XmlBuilder();
    final int length = _workbook._sharedStrings.length;
    if (length > 0) {
      builder.processing('xml', 'version="1.0"');
      builder.element('sst', nest: () {
        builder.attribute('xmlns',
            'http://schemas.openxmlformats.org/spreadsheetml/2006/main');
        builder.attribute('uniqueCount', length.toString());
        builder.attribute('count', _workbook._sharedStringCount.toString());
        _workbook._sharedStrings.forEach((String key, int value) {
          if (key.indexOf('<r>') != 0) {
            builder.element('si', nest: () {
              builder.element('t', nest: () {
                builder.text(key);
              });
            });
          } else {
            builder.element('si', nest: () {
              builder.text(key);
            });
          }
        });
      });
      final String stringXml = builder.buildDocument().toString();
      final List<int> bytes = utf8.encode(stringXml);
      _addToArchive(bytes, 'xl/sharedStrings.xml');
    }
  }

  Future<void> _saveSharedStringAsync() async {
    final XmlBuilder builder = XmlBuilder();
    final int length = _workbook._sharedStrings.length;
    if (length > 0) {
      builder.processing('xml', 'version="1.0"');
      builder.element('sst', nest: () async {
        builder.attribute('xmlns',
            'http://schemas.openxmlformats.org/spreadsheetml/2006/main');
        builder.attribute('uniqueCount', length.toString());
        builder.attribute('count', _workbook._sharedStringCount.toString());
        _workbook._sharedStrings.forEach((String key, int value) {
          if (key.indexOf('<r>') != 0) {
            builder.element('si', nest: () async {
              builder.element('t', nest: () async {
                builder.text(key);
              });
            });
          } else {
            builder.element('si', nest: () async {
              builder.text(key);
            });
          }
        });
      });
      final String stringXml = builder.buildDocument().toString();
      final List<int> bytes = utf8.encode(stringXml);
      _addToArchiveAsync(bytes, 'xl/sharedStrings.xml');
    }
  }

  /// Serialize app properties
  void _saveApp(BuiltInProperties builtInProperties) {
    final XmlBuilder builder = XmlBuilder();

    builder.processing('xml', 'version="1.0"');
    builder.element('Properties', nest: () {
      builder.attribute('xmlns',
          'http://schemas.openxmlformats.org/officeDocument/2006/extended-properties');
      builder.element('Application', nest: 'Essential XlsIO');

      if (builtInProperties.manager != null) {
        builder.element('Manager', nest: builtInProperties.manager);
      }

      if (builtInProperties.company != null) {
        builder.element('Company', nest: builtInProperties.company);
      }
    });
    final String stringXml = builder.buildDocument().toString();
    final List<int> bytes = utf8.encode(stringXml);
    _addToArchive(bytes, 'docProps/app.xml');
  }

  Future<void> _saveAppAsync(BuiltInProperties builtInProperties) async {
    final XmlBuilder builder = XmlBuilder();

    builder.processing('xml', 'version="1.0"');
    builder.element('Properties', nest: () async {
      builder.attribute('xmlns',
          'http://schemas.openxmlformats.org/officeDocument/2006/extended-properties');
      builder.element('Application', nest: 'Essential XlsIO');

      if (builtInProperties.manager != null) {
        builder.element('Manager', nest: builtInProperties.manager);
      }

      if (builtInProperties.company != null) {
        builder.element('Company', nest: builtInProperties.company);
      }
    });
    final String stringXml = builder.buildDocument().toString();
    final List<int> bytes = utf8.encode(stringXml);
    _addToArchiveAsync(bytes, 'docProps/app.xml');
  }

  /// Serialize core properties
  void _saveCore(BuiltInProperties builtInProperties) {
    final XmlBuilder builder = XmlBuilder();

    builder.processing('xml', 'version="1.0"');
    builder.element('cp:coreProperties', nest: () {
      builder.attribute('xmlns:cp',
          'http://schemas.openxmlformats.org/package/2006/metadata/core-properties');
      builder.attribute('xmlns:dc', 'http://purl.org/dc/elements/1.1/');
      builder.attribute('xmlns:dcterms', 'http://purl.org/dc/terms/');
      builder.attribute('xmlns:dcmitype', 'http://purl.org/dc/dcmitype/');
      builder.attribute(
          'xmlns:xsi', 'http://www.w3.org/2001/XMLSchema-instance');
      final DateTime createdDate = DateTime.now();

      if (builtInProperties.author != null) {
        builder.element('dc:creator', nest: builtInProperties.author);
      }
      if (builtInProperties.subject != null) {
        builder.element('dc:subject', nest: builtInProperties.subject);
      }
      if (builtInProperties.category != null) {
        builder.element('dc:category', nest: builtInProperties.category);
      }
      if (builtInProperties.comments != null) {
        builder.element('dc:description', nest: builtInProperties.comments);
      }
      if (builtInProperties.title != null) {
        builder.element('dc:title', nest: builtInProperties.title);
      }
      if (builtInProperties.tags != null) {
        builder.element('dc:keywords', nest: builtInProperties.tags);
      }
      if (builtInProperties.status != null) {
        builder.element('dc:contentStatus', nest: builtInProperties.status);
      }
      if (builtInProperties.createdDate != null) {
        builder.element('dcterms:created', nest: () {
          builder.attribute('xsi:type', 'dcterms:W3CDTF');
          builder.text(builtInProperties.createdDate!.toIso8601String());
        });
      } else {
        builder.element('dcterms:created', nest: () {
          builder.attribute('xsi:type', 'dcterms:W3CDTF');
          builder.text(createdDate.toIso8601String());
        });
      }
      if (builtInProperties.modifiedDate != null) {
        builder.element('dcterms:modified', nest: () {
          builder.attribute('xsi:type', 'dcterms:W3CDTF');
          builder.text(builtInProperties.modifiedDate!.toIso8601String());
        });
      } else {
        builder.element('dcterms:modified', nest: () {
          builder.attribute('xsi:type', 'dcterms:W3CDTF');
          builder.text(createdDate.toIso8601String());
        });
      }
    });
    final String stringXml = builder.buildDocument().toString();
    final List<int> bytes = utf8.encode(stringXml);
    _addToArchive(bytes, 'docProps/core.xml');
  }

  Future<void> _saveCoreAsync(BuiltInProperties builtInProperties) async {
    final XmlBuilder builder = XmlBuilder();

    builder.processing('xml', 'version="1.0"');
    builder.element('cp:coreProperties', nest: () async {
      builder.attribute('xmlns:cp',
          'http://schemas.openxmlformats.org/package/2006/metadata/core-properties');
      builder.attribute('xmlns:dc', 'http://purl.org/dc/elements/1.1/');
      builder.attribute('xmlns:dcterms', 'http://purl.org/dc/terms/');
      builder.attribute('xmlns:dcmitype', 'http://purl.org/dc/dcmitype/');
      builder.attribute(
          'xmlns:xsi', 'http://www.w3.org/2001/XMLSchema-instance');
      final DateTime createdDate = DateTime.now();

      if (builtInProperties.author != null) {
        builder.element('dc:creator', nest: builtInProperties.author);
      }
      if (builtInProperties.subject != null) {
        builder.element('dc:subject', nest: builtInProperties.subject);
      }
      if (builtInProperties.category != null) {
        builder.element('dc:category', nest: builtInProperties.category);
      }
      if (builtInProperties.comments != null) {
        builder.element('dc:description', nest: builtInProperties.comments);
      }
      if (builtInProperties.title != null) {
        builder.element('dc:title', nest: builtInProperties.title);
      }
      if (builtInProperties.tags != null) {
        builder.element('dc:keywords', nest: builtInProperties.tags);
      }
      if (builtInProperties.status != null) {
        builder.element('dc:contentStatus', nest: builtInProperties.status);
      }
      if (builtInProperties.createdDate != null) {
        builder.element('dcterms:created', nest: () async {
          builder.attribute('xsi:type', 'dcterms:W3CDTF');
          builder.text(builtInProperties.createdDate!.toIso8601String());
        });
      } else {
        builder.element('dcterms:created', nest: () async {
          builder.attribute('xsi:type', 'dcterms:W3CDTF');
          builder.text(createdDate.toIso8601String());
        });
      }
      if (builtInProperties.modifiedDate != null) {
        builder.element('dcterms:modified', nest: () async {
          builder.attribute('xsi:type', 'dcterms:W3CDTF');
          builder.text(builtInProperties.modifiedDate!.toIso8601String());
        });
      } else {
        builder.element('dcterms:modified', nest: () async {
          builder.attribute('xsi:type', 'dcterms:W3CDTF');
          builder.text(createdDate.toIso8601String());
        });
      }
    });
    final String stringXml = builder.buildDocument().toString();
    final List<int> bytes = utf8.encode(stringXml);
    _addToArchiveAsync(bytes, 'docProps/core.xml');
  }

  /// Serialize content type.
  void _saveContentType() {
    final XmlBuilder builder = XmlBuilder();
    builder.processing('xml', 'version="1.0"');
    builder.element('Types', nest: () {
      builder.attribute('xmlns',
          'http://schemas.openxmlformats.org/package/2006/content-types');

      builder.element('Default', nest: () {
        builder.attribute('Extension', 'xml');
        builder.attribute('ContentType', 'application/xml');
      });
      builder.element('Default', nest: () {
        builder.attribute('Extension', 'rels');
        builder.attribute('ContentType',
            'application/vnd.openxmlformats-package.relationships+xml');
      });
      builder.element('Override', nest: () {
        builder.attribute('PartName', '/xl/styles.xml');
        builder.attribute('ContentType',
            'application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml');
      });
      builder.element('Override', nest: () {
        builder.attribute('PartName', '/xl/workbook.xml');
        builder.attribute('ContentType',
            'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml');
      });
      builder.element('Override', nest: () {
        builder.attribute('PartName', '/docProps/app.xml');
        builder.attribute('ContentType',
            'application/vnd.openxmlformats-officedocument.extended-properties+xml');
      });
      builder.element('Override', nest: () {
        builder.attribute('PartName', '/docProps/core.xml');
        builder.attribute('ContentType',
            'application/vnd.openxmlformats-package.core-properties+xml');
      });
      final int length = _workbook.worksheets.count;
      int drawingIndex = 1;
      int chartIndex = 1;
      for (int i = 0; i < length; i++) {
        final int index = i + 1;
        builder.element('Override', nest: () {
          builder.attribute('PartName', '/xl/worksheets/sheet$index.xml');
          builder.attribute('ContentType',
              'application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml');
        });
        if ((_workbook._imageCount > 0 &&
                _workbook.worksheets[i].pictures.count > 0) ||
            _workbook.worksheets[i].charts != null &&
                _workbook.worksheets[i].chartCount > 0) {
          if (_workbook.worksheets[i].charts != null &&
              _workbook.worksheets[i].chartCount > 0) {
            final int chartCount = _workbook.worksheets[i].chartCount;
            for (int index = 1; index <= chartCount; index++) {
              builder.element('Override', nest: () {
                builder.attribute(
                    'PartName', '/xl/charts/chart$chartIndex.xml');
                builder.attribute('ContentType',
                    'application/vnd.openxmlformats-officedocument.drawingml.chart+xml');
              });
              chartIndex++;
            }
          }
          builder.element('Override', nest: () {
            builder.attribute(
                'PartName', '/xl/drawings/drawing$drawingIndex.xml');
            builder.attribute('ContentType',
                'application/vnd.openxmlformats-officedocument.drawing+xml');
          });
          drawingIndex++;
        }
      }

      for (int tableCount = 0;
          tableCount < _workbook._tableCount;
          tableCount++) {
        final int tableIndex = tableCount + 1;
        builder.element('Override', nest: () {
          builder.attribute('PartName', '/xl/tables/table$tableIndex.xml');
          builder.attribute('ContentType',
              'application/vnd.openxmlformats-officedocument.spreadsheetml.table+xml');
        });
      }

      if (_workbook._imageCount > 0) {
        for (final dynamic key in _workbook._defaultContentType.keys) {
          builder.element('Default', nest: () {
            builder.attribute('Extension', key);
            builder.attribute(
                'ContentType',
                // ignore: unnecessary_null_checks
                _workbook._defaultContentTypes[key]!);
          });
        }
      }

      if (_workbook._sharedStringCount > 0) {
        builder.element('Override', nest: () {
          builder.attribute('PartName', '/xl/sharedStrings.xml');
          builder.attribute('ContentType',
              'application/vnd.openxmlformats-officedocument.spreadsheetml.sharedStrings+xml');
        });
      }
    });
    final String stringXml = builder.buildDocument().toString();
    final List<int> bytes = utf8.encode(stringXml);
    _addToArchive(bytes, '[Content_Types].xml');
  }

  Future<void> _saveContentTypeAsync() async {
    final XmlBuilder builder = XmlBuilder();
    builder.processing('xml', 'version="1.0"');
    builder.element('Types', nest: () async {
      builder.attribute('xmlns',
          'http://schemas.openxmlformats.org/package/2006/content-types');

      builder.element('Default', nest: () async {
        builder.attribute('Extension', 'xml');
        builder.attribute('ContentType', 'application/xml');
      });
      builder.element('Default', nest: () async {
        builder.attribute('Extension', 'rels');
        builder.attribute('ContentType',
            'application/vnd.openxmlformats-package.relationships+xml');
      });
      builder.element('Override', nest: () async {
        builder.attribute('PartName', '/xl/styles.xml');
        builder.attribute('ContentType',
            'application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml');
      });
      builder.element('Override', nest: () async {
        builder.attribute('PartName', '/xl/workbook.xml');
        builder.attribute('ContentType',
            'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml');
      });
      builder.element('Override', nest: () async {
        builder.attribute('PartName', '/docProps/app.xml');
        builder.attribute('ContentType',
            'application/vnd.openxmlformats-officedocument.extended-properties+xml');
      });
      builder.element('Override', nest: () async {
        builder.attribute('PartName', '/docProps/core.xml');
        builder.attribute('ContentType',
            'application/vnd.openxmlformats-package.core-properties+xml');
      });
      final int length = _workbook.worksheets.count;
      int drawingIndex = 1;
      int chartIndex = 1;
      for (int i = 0; i < length; i++) {
        final int index = i + 1;
        builder.element('Override', nest: () async {
          builder.attribute('PartName', '/xl/worksheets/sheet$index.xml');
          builder.attribute('ContentType',
              'application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml');
        });
        if ((_workbook._imageCount > 0 &&
                _workbook.worksheets[i].pictures.count > 0) ||
            _workbook.worksheets[i].charts != null &&
                _workbook.worksheets[i].chartCount > 0) {
          if (_workbook.worksheets[i].charts != null &&
              _workbook.worksheets[i].chartCount > 0) {
            final int chartCount = _workbook.worksheets[i].chartCount;
            for (int index = 1; index <= chartCount; index++) {
              builder.element('Override', nest: () async {
                builder.attribute(
                    'PartName', '/xl/charts/chart$chartIndex.xml');
                builder.attribute('ContentType',
                    'application/vnd.openxmlformats-officedocument.drawingml.chart+xml');
              });
              chartIndex++;
            }
          }
          builder.element('Override', nest: () async {
            builder.attribute(
                'PartName', '/xl/drawings/drawing$drawingIndex.xml');
            builder.attribute('ContentType',
                'application/vnd.openxmlformats-officedocument.drawing+xml');
          });
          drawingIndex++;
        }
      }

      for (int tableCount = 0;
          tableCount < _workbook._tableCount;
          tableCount++) {
        final int tableIndex = tableCount + 1;
        builder.element('Override', nest: () async {
          builder.attribute('PartName', '/xl/tables/table$tableIndex.xml');
          builder.attribute('ContentType',
              'application/vnd.openxmlformats-officedocument.spreadsheetml.table+xml');
        });
      }

      if (_workbook._imageCount > 0) {
        for (final dynamic key in _workbook._defaultContentType.keys) {
          builder.element('Default', nest: () async {
            builder.attribute('Extension', key);
            builder.attribute(
                'ContentType',
                // ignore: unnecessary_null_checks
                _workbook._defaultContentTypes[key]!);
          });
        }
      }

      if (_workbook._sharedStringCount > 0) {
        builder.element('Override', nest: () async {
          builder.attribute('PartName', '/xl/sharedStrings.xml');
          builder.attribute('ContentType',
              'application/vnd.openxmlformats-officedocument.spreadsheetml.sharedStrings+xml');
        });
      }
    });
    final String stringXml = builder.buildDocument().toString();
    final List<int> bytes = utf8.encode(stringXml);
    _addToArchiveAsync(bytes, '[Content_Types].xml');
  }

  /// Serialize workbook releation.
  void _saveWorkbookRelation() {
    final XmlBuilder builder = XmlBuilder();

    builder.processing('xml', 'version="1.0"');
    builder.element('Relationships', nest: () {
      builder.attribute('xmlns',
          'http://schemas.openxmlformats.org/package/2006/relationships');

      final int length = _workbook.worksheets.count;
      int count = 0;
      int index;
      for (int i = 0; i < length; i++, count++) {
        builder.element('Relationship', nest: () {
          index = i + 1;
          builder.attribute('Id', 'rId$index');
          builder.attribute('Type',
              'http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet');
          builder.attribute('Target', 'worksheets/sheet$index.xml');
        });
      }
      count = ++count;
      builder.element('Relationship', nest: () {
        builder.attribute('Id', 'rId$count');
        builder.attribute('Type',
            'http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles');
        builder.attribute('Target', 'styles.xml');
      });
      if (_workbook._sharedStringCount > 0) {
        count = ++count;
        builder.element('Relationship', nest: () {
          builder.attribute('Id', 'rId$count');
          builder.attribute('Type',
              'http://schemas.openxmlformats.org/officeDocument/2006/relationships/sharedStrings');
          builder.attribute('Target', 'sharedStrings.xml');
        });
      }
    });
    final String stringXml = builder.buildDocument().toString();
    final List<int> bytes = utf8.encode(stringXml);
    _addToArchive(bytes, 'xl/_rels/workbook.xml.rels');
  }

  Future<void> _saveWorkbookRelationAsync() async {
    final XmlBuilder builder = XmlBuilder();

    builder.processing('xml', 'version="1.0"');
    builder.element('Relationships', nest: () async {
      builder.attribute('xmlns',
          'http://schemas.openxmlformats.org/package/2006/relationships');

      final int length = _workbook.worksheets.count;
      int count = 0;
      int index;
      for (int i = 0; i < length; i++, count++) {
        builder.element('Relationship', nest: () async {
          index = i + 1;
          builder.attribute('Id', 'rId$index');
          builder.attribute('Type',
              'http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet');
          builder.attribute('Target', 'worksheets/sheet$index.xml');
        });
      }
      count = ++count;
      builder.element('Relationship', nest: () async {
        builder.attribute('Id', 'rId$count');
        builder.attribute('Type',
            'http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles');
        builder.attribute('Target', 'styles.xml');
      });
      if (_workbook._sharedStringCount > 0) {
        count = ++count;
        builder.element('Relationship', nest: () async {
          builder.attribute('Id', 'rId$count');
          builder.attribute('Type',
              'http://schemas.openxmlformats.org/officeDocument/2006/relationships/sharedStrings');
          builder.attribute('Target', 'sharedStrings.xml');
        });
      }
    });
    final String stringXml = builder.buildDocument().toString();
    final List<int> bytes = utf8.encode(stringXml);
    _addToArchiveAsync(bytes, 'xl/_rels/workbook.xml.rels');
  }

  /// Serialize top level releation.
  void _saveTopLevelRelation() {
    final XmlBuilder builder = XmlBuilder();

    builder.processing('xml', 'version="1.0"');
    builder.element('Relationships', nest: () {
      builder.attribute('xmlns',
          'http://schemas.openxmlformats.org/package/2006/relationships');

      builder.element('Relationship', nest: () {
        builder.attribute('Id', 'rId1');
        builder.attribute('Type',
            'http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument');
        builder.attribute('Target', 'xl/workbook.xml');
      });

      builder.element('Relationship', nest: () {
        builder.attribute('Id', 'rId2');
        builder.attribute('Type',
            'http://schemas.openxmlformats.org/officeDocument/2006/relationships/extended-properties');
        builder.attribute('Target', 'docProps/app.xml');
      });

      builder.element('Relationship', nest: () {
        builder.attribute('Id', 'rId3');
        builder.attribute('Type',
            'http://schemas.openxmlformats.org/package/2006/relationships/metadata/core-properties');
        builder.attribute('Target', 'docProps/core.xml');
      });
    });
    final String stringXml = builder.buildDocument().toString();
    final List<int> bytes = utf8.encode(stringXml);
    _addToArchive(bytes, '_rels/.rels');
  }

  Future<void> _saveTopLevelRelationAsync() async {
    final XmlBuilder builder = XmlBuilder();

    builder.processing('xml', 'version="1.0"');
    builder.element('Relationships', nest: () async {
      builder.attribute('xmlns',
          'http://schemas.openxmlformats.org/package/2006/relationships');

      builder.element('Relationship', nest: () async {
        builder.attribute('Id', 'rId1');
        builder.attribute('Type',
            'http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument');
        builder.attribute('Target', 'xl/workbook.xml');
      });

      builder.element('Relationship', nest: () async {
        builder.attribute('Id', 'rId2');
        builder.attribute('Type',
            'http://schemas.openxmlformats.org/officeDocument/2006/relationships/extended-properties');
        builder.attribute('Target', 'docProps/app.xml');
      });

      builder.element('Relationship', nest: () async {
        builder.attribute('Id', 'rId3');
        builder.attribute('Type',
            'http://schemas.openxmlformats.org/package/2006/relationships/metadata/core-properties');
        builder.attribute('Target', 'docProps/core.xml');
      });
    });
    final String stringXml = builder.buildDocument().toString();
    final List<int> bytes = utf8.encode(stringXml);
    _addToArchiveAsync(bytes, '_rels/.rels');
  }

  /// Serialize content type.
  void _saveStyles() {
    _updateCellStyleXfs();
    final XmlBuilder builder = XmlBuilder();
    builder.processing('xml', 'version="1.0"');
    builder.element('styleSheet', nest: () {
      builder.attribute(
          'xmlns', 'http://schemas.openxmlformats.org/spreadsheetml/2006/main');
      builder.attribute('xmlns:mc',
          'http://schemas.openxmlformats.org/markup-compatibility/2006');
      builder.attribute('mc:Ignorable', 'x14ac');
      builder.attribute('xmlns:x14ac',
          'http://schemas.microsoft.com/office/spreadsheetml/2009/9/ac');

      _saveNumberFormats(builder);
      _saveFonts(builder);
      _saveFills(builder);
      _saveBorders(builder);
      _saveCellStyleXfs(builder);
      _saveCellXfs(builder);
      _saveGlobalCellstyles(builder);
      _serialiseDxfs(builder);
    });
    final String stringXml = builder.buildDocument().toString();
    final List<int> bytes = utf8.encode(stringXml);
    _addToArchive(bytes, 'xl/styles.xml');
  }

  Future<void> _saveStylesAsync() async {
    _updateCellStyleXfsAsync();
    final XmlBuilder builder = XmlBuilder();
    builder.processing('xml', 'version="1.0"');
    builder.element('styleSheet', nest: () async {
      builder.attribute(
          'xmlns', 'http://schemas.openxmlformats.org/spreadsheetml/2006/main');
      builder.attribute('xmlns:mc',
          'http://schemas.openxmlformats.org/markup-compatibility/2006');
      builder.attribute('mc:Ignorable', 'x14ac');
      builder.attribute('xmlns:x14ac',
          'http://schemas.microsoft.com/office/spreadsheetml/2009/9/ac');

      _saveNumberFormatsAsync(builder);
      _saveFontsAsync(builder);
      _saveFillsAsync(builder);
      _saveBordersAsync(builder);
      _saveCellStyleXfsAsync(builder);
      _saveCellXfsAsync(builder);
      _saveGlobalCellstylesAsync(builder);
      _serialiseDxfsAsync(builder);
    });
    final String stringXml = builder.buildDocument().toString();
    final List<int> bytes = utf8.encode(stringXml);
    _addToArchiveAsync(bytes, 'xl/styles.xml');
  }

  /// Update the global style.
  void _updateGlobalStyles() {
    for (final Style style in _workbook.styles.innerList) {
      final CellStyle cellStyle = style as CellStyle;
      if (cellStyle.isGlobalStyle) {
        if (cellStyle.name == '') {
          _workbook.styles.addStyle(cellStyle);
        }
        final _GlobalStyle globalStyle = _GlobalStyle();
        globalStyle._name = cellStyle.name;
        globalStyle._xfId = cellStyle.index;
        globalStyle._numberFormat = cellStyle.numberFormat;
        globalStyle._builtinId = cellStyle._builtinId;
        _workbook._globalStyles[globalStyle._name] = globalStyle;
      }
    }
  }

  Future<void> _updateGlobalStylesAsync() async {
    for (final Style style in _workbook.styles.innerList) {
      final CellStyle cellStyle = style as CellStyle;
      if (cellStyle.isGlobalStyle) {
        if (cellStyle.name == '') {
          _workbook.styles.addStyle(cellStyle);
        }
        final _GlobalStyle globalStyle = _GlobalStyle();
        globalStyle._name = cellStyle.name;
        globalStyle._xfId = cellStyle.index;
        globalStyle._numberFormat = cellStyle.numberFormat;
        globalStyle._builtinId = cellStyle._builtinId;
        _workbook._globalStyles[globalStyle._name] = globalStyle;
      }
    }
  }

  /// Process the cell style.
  int _processCellStyle(CellStyle style, Workbook workbook) {
    final int index = workbook.styles.innerList.indexOf(style);
    if (style.isGlobalStyle &&
        index >= 0 &&
        index > workbook.styles.innerList.length - 1) {
      _processNumFormatId(style, workbook);
      if (style.name == '') {
        workbook.styles.addStyle(style);
      }
      return style.index;
    } else if (index == -1) {
      _processNumFormatId(style, workbook);
      workbook.styles.addStyle(style);
      return style.index;
    } else {
      return index;
    }
  }

  /// Process the number format for cell style.
  void _processNumFormatId(CellStyle style, Workbook workbook) {
    if (style.numberFormat != 'General' &&
        !_workbook.innerFormats._contains(style.numberFormatIndex)) {
      _workbook.innerFormats._createFormat(style.numberFormat);
    }
  }

  /// Update cell Xfx Style
  void _updateCellStyleXfs() {
    for (final Style cellStyle in _workbook.styles.innerList) {
      final CellStyle style = cellStyle as CellStyle;
      _CellStyleXfs cellXfs;
      if (style.isGlobalStyle) {
        cellXfs = _CellXfs();
        if (_workbook._globalStyles.containsKey(style.name)) {
          (cellXfs as _CellXfs)._xfId =
              _workbook._globalStyles[style.name]!._xfId;
        }
      } else {
        cellXfs = _CellXfs();
        (cellXfs as _CellXfs)._xfId = 0;
      }
      final _ExtendCompareStyle compareFontResult = _workbook._isNewFont(style);
      if (!compareFontResult._result) {
        final Font font = Font();
        font.bold = style.bold;
        font.italic = style.italic;
        font.name = style.fontName;
        font.size = style.fontSize;
        font.underline = style.underline;
        if (style.fontColor.length == 7) {
          font.color = 'FF${style.fontColor.replaceAll('#', '')}';
        } else {
          font.color = style.fontColor;
        }
        _workbook.fonts.add(font);
        cellXfs._fontId = _workbook.fonts.length - 1;
      } else {
        cellXfs._fontId = compareFontResult._index;
      }
      if (style.backColor != '#FFFFFF' && style.backColor.length == 7) {
        final String backColor = 'FF${style.backColor.replaceAll('#', '')}';
        if (_workbook.fills.containsKey(backColor)) {
          final int? fillId = _workbook.fills[backColor];
          cellXfs._fillId = fillId!;
        } else {
          final int fillId = _workbook.fills.length + 2;
          _workbook.fills[backColor] = fillId;
          cellXfs._fillId = fillId;
        }
      } else if (style.backColor.length > 7) {
        final String backColorRgb = style.backColor;
        if (_workbook.fills.containsKey(backColorRgb)) {
          final int? fillId = _workbook.fills[backColorRgb];
          cellXfs._fillId = fillId!;
        } else {
          final int fillId = _workbook.fills.length + 2;
          _workbook.fills[backColorRgb] = fillId;
          cellXfs._fillId = fillId;
        }
      } else {
        cellXfs._fillId = 0;
      }

      //Add border
      if (!Workbook._isNewBorder(style)) {
        _workbook.borders.add(style.borders);
        cellXfs._borderId = _workbook.borders.length;
      } else {
        cellXfs._borderId = 0;
      }

      //Add Number Format
      if (style.numberFormat != 'GENERAL') {
        if (_workbook.innerFormats._contains(style.numberFormatIndex)) {
          final _Format format =
              _workbook.innerFormats[style.numberFormatIndex];
          cellXfs._numberFormatId = format._index;
        } else {
          cellXfs._numberFormatId =
              _workbook.innerFormats._createFormat(style.numberFormat);
        }
      } else {
        if (style.numberFormat == 'GENERAL' && style.numberFormatIndex == 14) {
          cellXfs._numberFormatId = 14;
        } else {
          cellXfs._numberFormatId = 0;
        }
      }
      //Add alignment
      cellXfs._alignment = _Alignment();
      cellXfs._alignment!.indent = style.indent;
      cellXfs._alignment!.horizontal =
          style.hAlign.toString().split('.').toList().removeAt(1);
      cellXfs._alignment!.vertical =
          style.vAlign.toString().split('.').toList().removeAt(1);
      cellXfs._alignment!.wrapText = style.wrapText ? 1 : 0;
      cellXfs._alignment!.rotation = style.rotation;

      // Add protection
      if (!style.locked) {
        cellXfs._locked = 0;
      }
      if (style.isGlobalStyle) {
        _workbook._cellStyleXfs.add(cellXfs);
        _workbook._cellXfs.add(cellXfs as _CellXfs);
      } else {
        //Add cellxfs
        _workbook._cellXfs.add(cellXfs as _CellXfs);
      }
    }
  }

  Future<void> _updateCellStyleXfsAsync() async {
    for (final Style cellStyle in _workbook.styles.innerList) {
      final CellStyle style = cellStyle as CellStyle;
      _CellStyleXfs cellXfs;
      if (style.isGlobalStyle) {
        cellXfs = _CellXfs();
        if (_workbook._globalStyles.containsKey(style.name)) {
          (cellXfs as _CellXfs)._xfId =
              _workbook._globalStyles[style.name]!._xfId;
        }
      } else {
        cellXfs = _CellXfs();
        (cellXfs as _CellXfs)._xfId = 0;
      }
      final _ExtendCompareStyle compareFontResult = _workbook._isNewFont(style);
      if (!compareFontResult._result) {
        final Font font = Font();
        font.bold = style.bold;
        font.italic = style.italic;
        font.name = style.fontName;
        font.size = style.fontSize;
        font.underline = style.underline;
        if (style.fontColor.length == 7) {
          font.color = 'FF${style.fontColor.replaceAll('#', '')}';
        } else {
          font.color = style.fontColor;
        }
        _workbook.fonts.add(font);
        cellXfs._fontId = _workbook.fonts.length - 1;
      } else {
        cellXfs._fontId = compareFontResult._index;
      }
      if (style.backColor != '#FFFFFF' && style.backColor.length == 7) {
        final String backColor = 'FF${style.backColor.replaceAll('#', '')}';
        if (_workbook.fills.containsKey(backColor)) {
          final int? fillId = _workbook.fills[backColor];
          cellXfs._fillId = fillId!;
        } else {
          final int fillId = _workbook.fills.length + 2;
          _workbook.fills[backColor] = fillId;
          cellXfs._fillId = fillId;
        }
      } else if (style.backColor.length > 7) {
        final String backColorRgb = style.backColor;
        if (_workbook.fills.containsKey(backColorRgb)) {
          final int? fillId = _workbook.fills[backColorRgb];
          cellXfs._fillId = fillId!;
        } else {
          final int fillId = _workbook.fills.length + 2;
          _workbook.fills[backColorRgb] = fillId;
          cellXfs._fillId = fillId;
        }
      } else {
        cellXfs._fillId = 0;
      }

      //Add border
      if (!Workbook._isNewBorder(style)) {
        _workbook.borders.add(style.borders);
        cellXfs._borderId = _workbook.borders.length;
      } else {
        cellXfs._borderId = 0;
      }

      //Add Number Format
      if (style.numberFormat != 'GENERAL') {
        if (_workbook.innerFormats._contains(style.numberFormatIndex)) {
          final _Format format =
              _workbook.innerFormats[style.numberFormatIndex];
          cellXfs._numberFormatId = format._index;
        } else {
          cellXfs._numberFormatId =
              _workbook.innerFormats._createFormat(style.numberFormat);
        }
      } else {
        if (style.numberFormat == 'GENERAL' && style.numberFormatIndex == 14) {
          cellXfs._numberFormatId = 14;
        } else {
          cellXfs._numberFormatId = 0;
        }
      }
      //Add alignment
      cellXfs._alignment = _Alignment();
      cellXfs._alignment!.indent = style.indent;
      cellXfs._alignment!.horizontal =
          style.hAlign.toString().split('.').toList().removeAt(1);
      cellXfs._alignment!.vertical =
          style.vAlign.toString().split('.').toList().removeAt(1);
      cellXfs._alignment!.wrapText = style.wrapText ? 1 : 0;
      cellXfs._alignment!.rotation = style.rotation;

      // Add protection
      if (!style.locked) {
        cellXfs._locked = 0;
      }
      if (style.isGlobalStyle) {
        _workbook._cellStyleXfs.add(cellXfs);
        _workbook._cellXfs.add(cellXfs as _CellXfs);
      } else {
        //Add cellxfs
        _workbook._cellXfs.add(cellXfs as _CellXfs);
      }
    }
  }

  /// Serialize number formats.
  void _saveNumberFormats(XmlBuilder builder) {
    final List<_Format> arrFormats = _workbook.innerFormats._getUsedFormats();
    if (arrFormats.isNotEmpty) {
      builder.element('numFmts', nest: () {
        builder.attribute('count', arrFormats.length.toString());
        for (int i = 0; i < arrFormats.length; i++) {
          builder.element('numFmt', nest: () {
            builder.attribute('numFmtId', arrFormats[i]._index.toString());
            final String formatString =
                arrFormats[i]._formatString!.replaceAll("'", '"');
            builder.attribute('formatCode', formatString);
          });
        }
      });
    }
  }

  Future<void> _saveNumberFormatsAsync(XmlBuilder builder) async {
    final List<_Format> arrFormats = _workbook.innerFormats._getUsedFormats();
    if (arrFormats.isNotEmpty) {
      builder.element('numFmts', nest: () async {
        builder.attribute('count', arrFormats.length.toString());
        for (int i = 0; i < arrFormats.length; i++) {
          builder.element('numFmt', nest: () async {
            builder.attribute('numFmtId', arrFormats[i]._index.toString());
            final String formatString =
                arrFormats[i]._formatString!.replaceAll("'", '"');
            builder.attribute('formatCode', formatString);
          });
        }
      });
    }
  }

  /// Serialize fonts.
  void _saveFonts(XmlBuilder builder) {
    builder.element('fonts', nest: () {
      builder.attribute('count', _workbook.fonts.length.toString());
      if (_workbook.fonts.isNotEmpty) {
        for (int i = 0; i < _workbook.fonts.length; i++) {
          final Font font = _workbook.fonts[i];
          builder.element('font', nest: () {
            if (font.bold) {
              builder.element('b', nest: () {});
            }
            if (font.italic) {
              builder.element('i', nest: () {});
            }
            if (font.underline) {
              builder.element('u', nest: () {});
            }
            builder.element('sz', nest: () {
              builder.attribute('val', font.size.toString());
            });
            builder.element('color', nest: () {
              builder.attribute('rgb', font.color);
            });
            builder.element('name', nest: () {
              builder.attribute('val', font.name);
            });
          });
        }
      }
    });
  }

  Future<void> _saveFontsAsync(XmlBuilder builder) async {
    builder.element('fonts', nest: () async {
      builder.attribute('count', _workbook.fonts.length.toString());
      if (_workbook.fonts.isNotEmpty) {
        for (int i = 0; i < _workbook.fonts.length; i++) {
          final Font font = _workbook.fonts[i];
          builder.element('font', nest: () async {
            if (font.bold) {
              builder.element('b', nest: () async {});
            }
            if (font.italic) {
              builder.element('i', nest: () async {});
            }
            if (font.underline) {
              builder.element('u', nest: () async {});
            }
            builder.element('sz', nest: () async {
              builder.attribute('val', font.size.toString());
            });
            builder.element('color', nest: () async {
              builder.attribute('rgb', font.color);
            });
            builder.element('name', nest: () async {
              builder.attribute('val', font.name);
            });
          });
        }
      }
    });
  }

  /// Serialize fills.
  void _saveFills(XmlBuilder builder) {
    builder.element('fills', nest: () {
      builder.attribute('count', (_workbook.fills.length + 2).toString());
      builder.element('fill', nest: () {
        builder.element('patternFill', nest: () {
          builder.attribute('patternType', 'none');
        });
      });
      builder.element('fill', nest: () {
        builder.element('patternFill', nest: () {
          builder.attribute('patternType', 'gray125');
        });
      });
      if (_workbook.fills.isNotEmpty) {
        _workbook.fills.forEach((String key, int value) {
          builder.element('fill', nest: () {
            builder.element('patternFill', nest: () {
              builder.attribute('patternType', 'solid');
              builder.element('fgColor', nest: () {
                builder.attribute('rgb', key);
              });
              builder.element('bgColor', nest: () {
                builder.attribute('rgb', 'FFFFFFFF');
              });
            });
          });
        });
      }
    });
  }

  Future<void> _saveFillsAsync(XmlBuilder builder) async {
    builder.element('fills', nest: () async {
      builder.attribute('count', (_workbook.fills.length + 2).toString());
      builder.element('fill', nest: () async {
        builder.element('patternFill', nest: () async {
          builder.attribute('patternType', 'none');
        });
      });
      builder.element('fill', nest: () async {
        builder.element('patternFill', nest: () async {
          builder.attribute('patternType', 'gray125');
        });
      });
      if (_workbook.fills.isNotEmpty) {
        _workbook.fills.forEach((String key, int value) {
          builder.element('fill', nest: () async {
            builder.element('patternFill', nest: () async {
              builder.attribute('patternType', 'solid');
              builder.element('fgColor', nest: () async {
                builder.attribute('rgb', key);
              });
              builder.element('bgColor', nest: () async {
                builder.attribute('rgb', 'FFFFFFFF');
              });
            });
          });
        });
      }
    });
  }

  /// Serialize borders.
  void _saveBorders(XmlBuilder builder) {
    builder.element('borders', nest: () {
      builder.attribute('count', (_workbook.borders.length + 1).toString());
      builder.element('border', nest: () {
        builder.element('left', nest: () {});
        builder.element('right', nest: () {});
        builder.element('top', nest: () {});
        builder.element('bottom', nest: () {});
        builder.element('diagonal', nest: () {});
      });
      if (_workbook.borders.isNotEmpty) {
        for (final Borders borders in _workbook.borders) {
          if (Workbook._isAllBorder(borders)) {
            builder.element('border', nest: () {
              _serializeBorder(borders.all, builder, 'left');
              _serializeBorder(borders.all, builder, 'right');
              _serializeBorder(borders.all, builder, 'top');
              _serializeBorder(borders.all, builder, 'bottom');
              _serializeBorder(borders.all, builder, 'diagonal');
            });
          } else {
            _serializeBorders(borders, builder);
          }
        }
      }
    });
  }

  Future<void> _saveBordersAsync(XmlBuilder builder) async {
    builder.element('borders', nest: () async {
      builder.attribute('count', (_workbook.borders.length + 1).toString());
      builder.element('border', nest: () async {
        builder.element('left', nest: () async {});
        builder.element('right', nest: () async {});
        builder.element('top', nest: () async {});
        builder.element('bottom', nest: () async {});
        builder.element('diagonal', nest: () async {});
      });
      if (_workbook.borders.isNotEmpty) {
        for (final Borders borders in _workbook.borders) {
          if (Workbook._isAllBorder(borders)) {
            builder.element('border', nest: () async {
              _serializeBorderAsync(borders.all, builder, 'left');
              _serializeBorderAsync(borders.all, builder, 'right');
              _serializeBorderAsync(borders.all, builder, 'top');
              _serializeBorderAsync(borders.all, builder, 'bottom');
              _serializeBorderAsync(borders.all, builder, 'diagonal');
            });
          } else {
            _serializeBordersAsync(borders, builder);
          }
        }
      }
    });
  }

  /// serializeBorders collection.
  void _serializeBorders(Borders borders, XmlBuilder builder) {
    builder.element('border', nest: () {
      _serializeBorder(borders.left, builder, 'left');
      _serializeBorder(borders.right, builder, 'right');
      _serializeBorder(borders.top, builder, 'top');
      _serializeBorder(borders.bottom, builder, 'bottom');
    });
  }

  Future<void> _serializeBordersAsync(
      Borders borders, XmlBuilder builder) async {
    builder.element('border', nest: () async {
      _serializeBorderAsync(borders.left, builder, 'left');
      _serializeBorderAsync(borders.right, builder, 'right');
      _serializeBorderAsync(borders.top, builder, 'top');
      _serializeBorderAsync(borders.bottom, builder, 'bottom');
    });
  }

  /// Serialize borders.
  void _serializeBorder(Border border, XmlBuilder builder, String borderType) {
    builder.element(borderType, nest: () {
      builder.attribute(
          'style', border.lineStyle.toString().split('.').toList().removeAt(1));
      builder.element('color', nest: () {
        if (border.color.length == 7) {
          builder.attribute('rgb', 'FF${border.color.replaceAll('#', '')}');
        } else {
          builder.attribute('rgb', border.color);
        }
      });
    });
  }

  Future<void> _serializeBorderAsync(
      Border border, XmlBuilder builder, String borderType) async {
    builder.element(borderType, nest: () async {
      builder.attribute(
          'style', border.lineStyle.toString().split('.').toList().removeAt(1));
      builder.element('color', nest: () async {
        if (border.color.length == 7) {
          builder.attribute('rgb', 'FF${border.color.replaceAll('#', '')}');
        } else {
          builder.attribute('rgb', border.color);
        }
      });
    });
  }

  /// Serialize cell styles xfs.
  void _saveCellStyleXfs(XmlBuilder builder) {
    builder.element('cellStyleXfs', nest: () {
      builder.attribute(
          'count', (_workbook._cellStyleXfs.length + 1).toString());
      builder.element('xf', nest: () {
        builder.attribute('numFmtId', '0');
        builder.attribute('fontId', '0');
        builder.attribute('fillId', '0');
        builder.attribute('borderId', '0');
      });
      if (_workbook._cellStyleXfs.isNotEmpty) {
        for (final _CellStyleXfs cellStyleXfs in _workbook._cellStyleXfs) {
          builder.element('xf', nest: () {
            builder.attribute(
                'numFmtId', cellStyleXfs._numberFormatId.toString());
            builder.attribute('fontId', cellStyleXfs._fontId.toString());
            builder.attribute('fillId', cellStyleXfs._fillId.toString());
            builder.attribute('borderId', cellStyleXfs._borderId.toString());
          });
        }
      }
    });
  }

  Future<void> _saveCellStyleXfsAsync(XmlBuilder builder) async {
    builder.element('cellStyleXfs', nest: () async {
      builder.attribute(
          'count', (_workbook._cellStyleXfs.length + 1).toString());
      builder.element('xf', nest: () async {
        builder.attribute('numFmtId', '0');
        builder.attribute('fontId', '0');
        builder.attribute('fillId', '0');
        builder.attribute('borderId', '0');
      });
      if (_workbook._cellStyleXfs.isNotEmpty) {
        for (final _CellStyleXfs cellStyleXfs in _workbook._cellStyleXfs) {
          builder.element('xf', nest: () async {
            builder.attribute(
                'numFmtId', cellStyleXfs._numberFormatId.toString());
            builder.attribute('fontId', cellStyleXfs._fontId.toString());
            builder.attribute('fillId', cellStyleXfs._fillId.toString());
            builder.attribute('borderId', cellStyleXfs._borderId.toString());
          });
        }
      }
    });
  }

  /// Serialize cell styles xfs.
  void _saveCellXfs(XmlBuilder builder) {
    builder.element('cellXfs', nest: () {
      builder.attribute('count', _workbook._cellXfs.length.toString());
      if (_workbook._cellXfs.isNotEmpty) {
        for (final _CellXfs cellXf in _workbook._cellXfs) {
          builder.element('xf', nest: () {
            builder.attribute('numFmtId', cellXf._numberFormatId.toString());
            builder.attribute('fontId', cellXf._fontId.toString());
            builder.attribute('fillId', cellXf._fillId.toString());
            builder.attribute('borderId', cellXf._borderId.toString());
            builder.attribute('xfId', cellXf._xfId.toString());
            _saveAlignment(cellXf, builder);
            _saveProtection(cellXf, builder);
          });
        }
      }
    });
  }

  Future<void> _saveCellXfsAsync(XmlBuilder builder) async {
    builder.element('cellXfs', nest: () async {
      builder.attribute('count', _workbook._cellXfs.length.toString());
      if (_workbook._cellXfs.isNotEmpty) {
        for (final _CellXfs cellXf in _workbook._cellXfs) {
          builder.element('xf', nest: () async {
            builder.attribute('numFmtId', cellXf._numberFormatId.toString());
            builder.attribute('fontId', cellXf._fontId.toString());
            builder.attribute('fillId', cellXf._fillId.toString());
            builder.attribute('borderId', cellXf._borderId.toString());
            builder.attribute('xfId', cellXf._xfId.toString());
            _saveAlignmentAsync(cellXf, builder);
            _saveProtectionAsync(cellXf, builder);
          });
        }
      }
    });
  }

  ///Serialize Protection.
  void _saveProtection(_CellStyleXfs cellXf, XmlBuilder builder) {
    if (cellXf._locked != 1) {
      builder.element('protection', nest: () {
        builder.attribute('locked', cellXf._locked.toString());
      });
    }
  }

  Future<void> _saveProtectionAsync(
      _CellStyleXfs cellXf, XmlBuilder builder) async {
    if (cellXf._locked != 1) {
      builder.element('protection', nest: () async {
        builder.attribute('locked', cellXf._locked.toString());
      });
    }
  }

  /// Serialize alignment.
  void _saveAlignment(_CellStyleXfs cellXf, XmlBuilder builder) {
    builder.element('alignment', nest: () {
      if (cellXf._alignment != null) {
        if (cellXf._alignment!.horizontal != '') {
          builder.attribute(
              'horizontal', cellXf._alignment!.horizontal.toLowerCase());
        }
        if (cellXf._alignment!.indent != 0) {
          builder.attribute('indent', cellXf._alignment!.indent.toString());
        } else if (cellXf._alignment!.rotation != 0) {
          builder.attribute(
              'textRotation', cellXf._alignment!.rotation.toString());
        }
        if (cellXf._alignment!.vertical != '') {
          builder.attribute(
              'vertical', cellXf._alignment!.vertical.toLowerCase());
        }
        builder.attribute('wrapText', cellXf._alignment!.wrapText.toString());
      }
    });
  }

  Future<void> _saveAlignmentAsync(
      _CellStyleXfs cellXf, XmlBuilder builder) async {
    builder.element('alignment', nest: () async {
      if (cellXf._alignment != null) {
        if (cellXf._alignment!.horizontal != '') {
          builder.attribute(
              'horizontal', cellXf._alignment!.horizontal.toLowerCase());
        }
        if (cellXf._alignment!.indent != 0) {
          builder.attribute('indent', cellXf._alignment!.indent.toString());
        } else if (cellXf._alignment!.rotation != 0) {
          builder.attribute(
              'textRotation', cellXf._alignment!.rotation.toString());
        }
        if (cellXf._alignment!.vertical != '') {
          builder.attribute(
              'vertical', cellXf._alignment!.vertical.toLowerCase());
        }
        builder.attribute('wrapText', cellXf._alignment!.wrapText.toString());
      }
    });
  }

  /// Serialize cell styles.
  void _saveGlobalCellstyles(XmlBuilder builder) {
    final int length = _workbook._globalStyles.length + 1;
    builder.element('cellStyles', nest: () {
      builder.attribute('count', length.toString());
      builder.element('cellStyle', nest: () {
        builder.attribute('name', 'Normal');
        builder.attribute('xfId', '0');
        builder.attribute('builtinId', '0');
      });
      _workbook._globalStyles.forEach((String key, _GlobalStyle value) {
        builder.element('cellStyle', nest: () {
          if (key != '') {
            builder.attribute('name', key);
            builder.attribute(
                'xfId', _workbook._globalStyles[key]!._xfId.toString());
            if (_workbook._globalStyles[key]!._builtinId != 0) {
              builder.attribute('builtinId',
                  _workbook._globalStyles[key]!._builtinId.toString());
            }
          }
        });
      });
    });
  }

  Future<void> _saveGlobalCellstylesAsync(XmlBuilder builder) async {
    final int length = _workbook._globalStyles.length + 1;
    builder.element('cellStyles', nest: () async {
      builder.attribute('count', length.toString());
      builder.element('cellStyle', nest: () async {
        builder.attribute('name', 'Normal');
        builder.attribute('xfId', '0');
        builder.attribute('builtinId', '0');
      });
      _workbook._globalStyles.forEach((String key, _GlobalStyle value) {
        builder.element('cellStyle', nest: () async {
          if (key != '') {
            builder.attribute('name', key);
            builder.attribute(
                'xfId', _workbook._globalStyles[key]!._xfId.toString());
            if (_workbook._globalStyles[key]!._builtinId != 0) {
              builder.attribute('builtinId',
                  _workbook._globalStyles[key]!._builtinId.toString());
            }
          }
        });
      });
    });
  }

  /// Process the Merge cell.
  MergedCellCollection _processMergeCells(
      Range cell, int rowIndex, MergedCellCollection mergeCells) {
    if (cell.rowSpan != 0 || cell.columnSpan != 0) {
      final MergeCell mCell = MergeCell();
      mCell.x = cell._index;
      mCell.width = cell.columnSpan;
      mCell.y = rowIndex;
      mCell.height = cell.rowSpan;
      final String startCell = Range._getCellName(mCell.y, mCell.x);
      final String endCell = Range._getCellName(
          rowIndex + mCell.height, cell._index + mCell.width);
      mCell._reference = '$startCell:$endCell';
      mergeCells.addCell(mCell);
      final _ExtendCell start = _ExtendCell();
      start._x = mCell.x;
      start._y = mCell.y;
      final _ExtendCell end = _ExtendCell();
      end._x = cell._index + mCell.width;
      end._y = rowIndex + mCell.height;
      _updatedMergedCellStyles(start, end, cell);
    }
    return mergeCells;
  }

  /// Update merged cell styles
  void _updatedMergedCellStyles(
      _ExtendCell sCell, _ExtendCell eCell, Range cell) {
    final Workbook workbook = cell.workbook;
    for (int x = sCell._x; x <= eCell._x; x++) {
      for (int y = sCell._y; y <= eCell._y; y++) {
        final _ExtendStyle extendStyle = _ExtendStyle();
        extendStyle._x = x;
        extendStyle._y = y;
        extendStyle._styleIndex = cell._styleIndex;
        if (workbook._mergedCellsStyle.containsKey(Range._getCellName(y, x))) {
          workbook._mergedCellsStyle.remove(Range._getCellName(y, x));
        }
        workbook._mergedCellsStyle[Range._getCellName(y, x)] = extendStyle;
      }
    }
  }

  /// Serialize DataValidations
  void _serializeDataValidations(XmlBuilder builder, Worksheet sheet) {
    final _DataValidationTable dataValidationTable = sheet._dvTable;

    if (dataValidationTable._count == 0) {
      return;
    }

    for (int dvTable = 0; dvTable < dataValidationTable._count; dvTable++) {
      for (int dvCollection = 0;
          dvCollection <
              dataValidationTable._dataValidationCollectionList.length;
          dvCollection++) {
        final _DataValidationCollection dataValidationCollection =
            dataValidationTable._dataValidationCollectionList[dvCollection];
        _serializeDataValidationCollection(builder, dataValidationCollection);
      }
    }
  }

  Future<void> _serializeDataValidationsAsync(
      XmlBuilder builder, Worksheet sheet) async {
    final _DataValidationTable dataValidationTable = sheet._dvTable;

    if (dataValidationTable._count == 0) {
      return;
    }

    for (int dvTable = 0; dvTable < dataValidationTable._count; dvTable++) {
      for (int dvCollection = 0;
          dvCollection <
              dataValidationTable._dataValidationCollectionList.length;
          dvCollection++) {
        final _DataValidationCollection dataValidationCollection =
            dataValidationTable._dataValidationCollectionList[dvCollection];
        _serializeDataValidationCollectionAsync(
            builder, dataValidationCollection);
      }
    }
  }

  ///Serialize DataValidation Collection
  void _serializeDataValidationCollection(
      XmlBuilder builder, _DataValidationCollection dataValidationCollection) {
    if (dataValidationCollection.count == 0) {
      return;
    }

    builder.element('dataValidations', nest: () {
      _serializeAttributeInt(
          builder, 'count', dataValidationCollection.count, 0);

      if (dataValidationCollection._isPromptBoxPositionFixedVal) {
        _serializeAttributeInt(builder, 'xWindow',
            dataValidationCollection._promptBoxVPositionVal, 0);

        _serializeAttributeInt(builder, 'yWindow',
            dataValidationCollection._promptBoxHPositionVal, 0);
      }

      for (int dvList = 0;
          dvList < dataValidationCollection._dataValidationList.length;
          dvList++) {
        _serializeDataValidation(
            builder, dataValidationCollection._dataValidationList[dvList]);
      }
    });
  }

  Future<void> _serializeDataValidationCollectionAsync(XmlBuilder builder,
      _DataValidationCollection dataValidationCollection) async {
    if (dataValidationCollection.count == 0) {
      return;
    }

    builder.element('dataValidations', nest: () async {
      _serializeAttributeIntAsync(
          builder, 'count', dataValidationCollection.count, 0);
      if (dataValidationCollection._isPromptBoxPositionFixedVal) {
        _serializeAttributeIntAsync(builder, 'xWindow',
            dataValidationCollection._promptBoxVPositionVal, 0);
        _serializeAttributeIntAsync(builder, 'yWindow',
            dataValidationCollection._promptBoxHPositionVal, 0);
      }

      for (int dvList = 0;
          dvList < dataValidationCollection._dataValidationList.length;
          dvList++) {
        _serializeDataValidationAsync(
            builder, dataValidationCollection._dataValidationList[dvList]);
      }
    });
  }

  ///DataType properties for DataValidation
  String _getDataType(ExcelDataValidationType dataTypeDataVal) {
    switch (dataTypeDataVal) {
      case ExcelDataValidationType.textLength:
        return 'textLength';

      case ExcelDataValidationType.date:
        return 'date';

      case ExcelDataValidationType.decimal:
        return 'decimal';

      case ExcelDataValidationType.formula:
        return 'custom';

      case ExcelDataValidationType.integer:
        return 'whole';

      case ExcelDataValidationType.time:
        return 'time';

      case ExcelDataValidationType.user:
        return 'list';

      case ExcelDataValidationType.any:
        return 'any';
    }
  }

  ///ErrorStyle properties for DataValidation
  String _getErrorStyle(ExcelDataValidationErrorStyle errorStyleDataVal) {
    switch (errorStyleDataVal) {
      case ExcelDataValidationErrorStyle.information:
        return 'info';

      case ExcelDataValidationErrorStyle.warning:
        return 'warning';

      case ExcelDataValidationErrorStyle.stop:
        return 'stop';
    }
  }

  ///ComparisonOperator properties for DataValidation
  String _getComparisonOperator(
      ExcelDataValidationComparisonOperator dataValComparisonOperator) {
    switch (dataValComparisonOperator) {
      case ExcelDataValidationComparisonOperator.equal:
        return 'equal';

      case ExcelDataValidationComparisonOperator.greater:
        return 'greaterThan';

      case ExcelDataValidationComparisonOperator.greaterOrEqual:
        return 'greaterThanOrEqual';

      case ExcelDataValidationComparisonOperator.less:
        return 'lessThan';

      case ExcelDataValidationComparisonOperator.lessOrEqual:
        return 'lessThanOrEqual';

      case ExcelDataValidationComparisonOperator.notBetween:
        return 'notBetween';

      case ExcelDataValidationComparisonOperator.notEqual:
        return 'notEqual';

      case ExcelDataValidationComparisonOperator.between:
        return 'between';
    }
  }

  ///method for comparing String value
  void _serializeDataValStringAttribute(XmlBuilder builder,
      String attributeName, String value, String defaultValue) {
    if (value != defaultValue) {
      builder.attribute(attributeName, value);
    }
  }

  Future<void> _serializeDataValStringAttributeAsync(XmlBuilder builder,
      String attributeName, String value, String defaultValue) async {
    if (value != defaultValue) {
      builder.attribute(attributeName, value);
    }
  }

  /// Serialize DataValidation
  void _serializeDataValidation(
      XmlBuilder builder, _DataValidationImpl dataValidationImpl) {
    builder.element('dataValidation', nest: () {
      final ExcelDataValidationType dataType = dataValidationImpl.allowType;

      if (dataType != ExcelDataValidationType.any) {
        builder.attribute('type', _getDataType(dataType));
      }

      final ExcelDataValidationErrorStyle errorStyle =
          dataValidationImpl.errorStyle;

      if (errorStyle != ExcelDataValidationErrorStyle.stop) {
        builder.attribute('errorStyle', _getErrorStyle(errorStyle));
      }
      final ExcelDataValidationComparisonOperator comparisonOperator =
          dataValidationImpl.comparisonOperator;

      if (comparisonOperator != ExcelDataValidationComparisonOperator.between &&
          _getDataType(dataType) != 'custom') {
        builder.attribute(
            'operator', _getComparisonOperator(comparisonOperator));
      }

      _serializeAttributes(
          builder, 'allowBlank', dataValidationImpl.isEmptyCellAllowed, false);

      _serializeAttributes(builder, 'showDropDown',
          dataValidationImpl.isSuppressDropDownArrow, false);

      _serializeAttributes(
          builder, 'showInputMessage', dataValidationImpl.showPromptBox, false);

      _serializeAttributes(
          builder, 'showErrorMessage', dataValidationImpl.showErrorBox, false);

      _serializeDataValStringAttribute(
          builder, 'errorTitle', dataValidationImpl.errorBoxTitle, '');

      _serializeDataValStringAttribute(
          builder, 'error', dataValidationImpl.errorBoxText, '');

      _serializeDataValStringAttribute(
          builder, 'promptTitle', dataValidationImpl.promptBoxTitle, '');

      _serializeDataValStringAttribute(
          builder, 'prompt', dataValidationImpl.promptBoxText, '');

      _serializeDataValStringAttribute(
          builder, 'sqref', dataValidationImpl._cellRange, '');

      if ('textLength' == _getDataType(dataType) ||
          'decimal' == _getDataType(dataType) ||
          'whole' == _getDataType(dataType)) {
        final String firstFormula = dataValidationImpl.firstFormula;
        final String secondFormula = dataValidationImpl.secondFormula;
        if (firstFormula != '') {
          builder.element('formula1', nest: firstFormula);
        }
        if (secondFormula != '') {
          builder.element('formula2', nest: secondFormula);
        }
      } else if ('time' == _getDataType(dataType)) {
        final String firstFormula = dataValidationImpl.firstFormula;
        final String secondFormula = dataValidationImpl.secondFormula;
        final List<String> firstFormulaCheck = firstFormula.split(':');
        final List<String> secondFormulaCheck = secondFormula.split(':');
        late Duration duration;
        late double firstFormulaVal;
        late double secondFormulaVal;
        late String firstTimeVal;
        late String secondTimeVal;
        if (firstFormulaCheck.length == 2) {
          final int? hour = int.tryParse(firstFormulaCheck[0]);
          final int? min = int.tryParse(firstFormulaCheck[1]);

          if (hour != null && min != null) {
            duration = Duration(hours: hour, minutes: min);

            firstFormulaVal = (duration.inMinutes / 60) / 24;
            firstTimeVal = firstFormulaVal.toString();
          } else {
            firstTimeVal = firstFormula;
          }
        }

        if (firstFormulaCheck.length == 3) {
          final int? hour = int.tryParse(firstFormulaCheck[0]);
          final int? min = int.tryParse(firstFormulaCheck[1]);
          final int? sec = int.tryParse(firstFormulaCheck[2]);

          if (hour != null && min != null && sec != null) {
            duration = Duration(hours: hour, minutes: min, seconds: sec);

            firstFormulaVal = ((duration.inSeconds / 60) / 60) / 24;
            firstTimeVal = firstFormulaVal.toString();
          } else {
            firstTimeVal = firstFormula;
          }
        }

        if (secondFormulaCheck.length == 2) {
          final int? hour = int.tryParse(secondFormulaCheck[0]);
          final int? min = int.tryParse(secondFormulaCheck[1]);

          if (hour != null && min != null) {
            duration = Duration(hours: hour, minutes: min);

            secondFormulaVal = (duration.inMinutes / 60) / 24;
            secondTimeVal = secondFormulaVal.toString();
          } else {
            secondTimeVal = secondFormula;
          }
        }

        if (secondFormulaCheck.length == 3) {
          final int? hour = int.tryParse(secondFormulaCheck[0]);
          final int? min = int.tryParse(secondFormulaCheck[1]);
          final int? sec = int.tryParse(secondFormulaCheck[2]);

          if (hour != null && min != null && sec != null) {
            duration = Duration(hours: hour, minutes: min, seconds: sec);

            secondFormulaVal = ((duration.inSeconds / 60) / 60) / 24;
            secondTimeVal = secondFormulaVal.toString();
          } else {
            secondTimeVal = secondFormula;
          }
        }

        if (firstFormulaCheck.length != 2 && firstFormulaCheck.length != 3) {
          firstTimeVal = firstFormula;
        }
        if (secondFormulaCheck.length != 2 && secondFormulaCheck.length != 3) {
          secondTimeVal = secondFormula;
        }
        if (firstTimeVal != '') {
          builder.element('formula1', nest: firstTimeVal);
        }
        if (secondTimeVal != '') {
          builder.element('formula2', nest: secondTimeVal);
        }
      } else if ('list' == _getDataType(dataType)) {
        final List<String> firstFormula = dataValidationImpl.listOfValues;
        late String listOfValues = '';
        if (firstFormula.isNotEmpty) {
          for (int listVal = 0; listVal < firstFormula.length; listVal++) {
            late String comma;
            if (listVal == 0) {
              comma = '';
            } else {
              comma = ',';
            }

            listOfValues = listOfValues + comma + firstFormula[listVal];
          }

          builder.element('formula1', nest: '" $listOfValues"');
        } else {
          final String firstFormulaSelect =
              dataValidationImpl._dataRangeVal.addressGlobal;

          builder.element('formula1', nest: firstFormulaSelect);
        }
      } else if ('custom' == _getDataType(dataType)) {
        final String firstFormula = dataValidationImpl.firstFormula;
        final String secondFormula = dataValidationImpl.secondFormula;
        if (firstFormula.isNotEmpty) {
          builder.element('formula1', nest: firstFormula);
        } else if (firstFormula == '' && secondFormula.isNotEmpty) {
          builder.element('formula1', nest: secondFormula);
        }
      } else {
        final DateTime firstDateTime = dataValidationImpl._firstDateTimeVal;
        final DateTime secondDateTime = dataValidationImpl.secondDateTime;
        final String firstDateTimeVal =
            Range._toOADate(firstDateTime).toString();
        final String secondDateTimeVal =
            Range._toOADate(secondDateTime).toString();
        if (firstDateTime != DateTime(1)) {
          builder.element('formula1', nest: firstDateTimeVal);
        }
        if (secondDateTime != DateTime(1)) {
          builder.element('formula2', nest: secondDateTimeVal);
        }
      }
    });
  }

  Future<void> _serializeDataValidationAsync(
      XmlBuilder builder, _DataValidationImpl dataValidationImpl) async {
    builder.element('dataValidation', nest: () {
      final ExcelDataValidationType dataType = dataValidationImpl.allowType;

      if (dataType != ExcelDataValidationType.any) {
        builder.attribute('type', _getDataType(dataType));
      }

      final ExcelDataValidationErrorStyle errorStyle =
          dataValidationImpl.errorStyle;

      if (errorStyle != ExcelDataValidationErrorStyle.stop) {
        builder.attribute('errorStyle', _getErrorStyle(errorStyle));
      }
      final ExcelDataValidationComparisonOperator comparisonOperator =
          dataValidationImpl.comparisonOperator;

      if (comparisonOperator != ExcelDataValidationComparisonOperator.between &&
          _getDataType(dataType) != 'custom') {
        builder.attribute(
            'operator', _getComparisonOperator(comparisonOperator));
      }

      _serializeAttributesAsync(
          builder, 'allowBlank', dataValidationImpl.isEmptyCellAllowed, false);

      _serializeAttributesAsync(builder, 'showDropDown',
          dataValidationImpl.isSuppressDropDownArrow, false);

      _serializeAttributesAsync(
          builder, 'showInputMessage', dataValidationImpl.showPromptBox, false);

      _serializeAttributesAsync(
          builder, 'showErrorMessage', dataValidationImpl.showErrorBox, false);

      _serializeDataValStringAttributeAsync(
          builder, 'errorTitle', dataValidationImpl.errorBoxTitle, '');

      _serializeDataValStringAttributeAsync(
          builder, 'error', dataValidationImpl.errorBoxText, '');

      _serializeDataValStringAttributeAsync(
          builder, 'promptTitle', dataValidationImpl.promptBoxTitle, '');

      _serializeDataValStringAttributeAsync(
          builder, 'prompt', dataValidationImpl.promptBoxText, '');

      _serializeDataValStringAttributeAsync(
          builder, 'sqref', dataValidationImpl._cellRange, '');

      if ('textLength' == _getDataType(dataType) ||
          'decimal' == _getDataType(dataType) ||
          'whole' == _getDataType(dataType)) {
        final String firstFormula = dataValidationImpl.firstFormula;
        final String secondFormula = dataValidationImpl.secondFormula;
        if (firstFormula != '') {
          builder.element('formula1', nest: firstFormula);
        }
        if (secondFormula != '') {
          builder.element('formula2', nest: secondFormula);
        }
      } else if ('time' == _getDataType(dataType)) {
        final String firstFormula = dataValidationImpl.firstFormula;
        final String secondFormula = dataValidationImpl.secondFormula;
        final List<String> firstFormulaCheck = firstFormula.split(':');
        final List<String> secondFormulaCheck = secondFormula.split(':');
        late Duration duration;
        late double firstFormulaVal;
        late double secondFormulaVal;
        late String firstTimeVal;
        late String secondTimeVal;
        if (firstFormulaCheck.length == 2) {
          final int? hour = int.tryParse(firstFormulaCheck[0]);
          final int? min = int.tryParse(firstFormulaCheck[1]);

          if (hour != null && min != null) {
            duration = Duration(hours: hour, minutes: min);

            firstFormulaVal = (duration.inMinutes / 60) / 24;
            firstTimeVal = firstFormulaVal.toString();
          } else {
            firstTimeVal = firstFormula;
          }
        }

        if (firstFormulaCheck.length == 3) {
          final int? hour = int.tryParse(firstFormulaCheck[0]);
          final int? min = int.tryParse(firstFormulaCheck[1]);
          final int? sec = int.tryParse(firstFormulaCheck[2]);

          if (hour != null && min != null && sec != null) {
            duration = Duration(hours: hour, minutes: min, seconds: sec);

            firstFormulaVal = ((duration.inSeconds / 60) / 60) / 24;
            firstTimeVal = firstFormulaVal.toString();
          } else {
            firstTimeVal = firstFormula;
          }
        }

        if (secondFormulaCheck.length == 2) {
          final int? hour = int.tryParse(secondFormulaCheck[0]);
          final int? min = int.tryParse(secondFormulaCheck[1]);

          if (hour != null && min != null) {
            duration = Duration(hours: hour, minutes: min);

            secondFormulaVal = (duration.inMinutes / 60) / 24;
            secondTimeVal = secondFormulaVal.toString();
          } else {
            secondTimeVal = secondFormula;
          }
        }

        if (secondFormulaCheck.length == 3) {
          final int? hour = int.tryParse(secondFormulaCheck[0]);
          final int? min = int.tryParse(secondFormulaCheck[1]);
          final int? sec = int.tryParse(secondFormulaCheck[2]);

          if (hour != null && min != null && sec != null) {
            duration = Duration(hours: hour, minutes: min, seconds: sec);

            secondFormulaVal = ((duration.inSeconds / 60) / 60) / 24;
            secondTimeVal = secondFormulaVal.toString();
          } else {
            secondTimeVal = secondFormula;
          }
        }

        if (firstFormulaCheck.length != 2 && firstFormulaCheck.length != 3) {
          firstTimeVal = firstFormula;
        }
        if (secondFormulaCheck.length != 2 && secondFormulaCheck.length != 3) {
          secondTimeVal = secondFormula;
        }
        if (firstTimeVal != '') {
          builder.element('formula1', nest: firstTimeVal);
        }
        if (secondTimeVal != '') {
          builder.element('formula2', nest: secondTimeVal);
        }
      } else if ('list' == _getDataType(dataType)) {
        final List<String> firstFormula = dataValidationImpl.listOfValues;
        late String listOfValues = '';
        if (firstFormula.isNotEmpty) {
          for (int listVal = 0; listVal < firstFormula.length; listVal++) {
            late String comma;
            if (listVal == 0) {
              comma = '';
            } else {
              comma = ',';
            }

            listOfValues = listOfValues + comma + firstFormula[listVal];
          }

          builder.element('formula1', nest: '" $listOfValues"');
        } else {
          final String firstFormulaSelect =
              dataValidationImpl._dataRangeVal.addressGlobal;

          builder.element('formula1', nest: firstFormulaSelect);
        }
      } else if ('custom' == _getDataType(dataType)) {
        final String firstFormula = dataValidationImpl.firstFormula;
        final String secondFormula = dataValidationImpl.secondFormula;
        if (firstFormula.isNotEmpty) {
          builder.element('formula1', nest: firstFormula);
        } else if (firstFormula == '' && secondFormula.isNotEmpty) {
          builder.element('formula1', nest: secondFormula);
        }
      } else {
        final DateTime firstDateTime = dataValidationImpl._firstDateTimeVal;
        final DateTime secondDateTime = dataValidationImpl.secondDateTime;
        final String firstDateTimeVal =
            Range._toOADate(firstDateTime).toString();
        final String secondDateTimeVal =
            Range._toOADate(secondDateTime).toString();
        if (firstDateTime != DateTime(1)) {
          builder.element('formula1', nest: firstDateTimeVal);
        }
        if (secondDateTime != DateTime(1)) {
          builder.element('formula2', nest: secondDateTimeVal);
        }
      }
    });
  }

  void _serializeConditionalFormatting(XmlBuilder builder, Worksheet sheet) {
    if (sheet.conditionalFormats.isNotEmpty) {
      final int iCount = sheet.conditionalFormats.length;
      int iPriority = 1;
      int iPriorityCount = 0;
      for (int i = 0; i < iCount; i++) {
        final _ConditionalFormatsImpl conditionalFormats =
            sheet.conditionalFormats[i];
        final List<dynamic> result = _serializeConditionalFormats(
            builder, _iDxfIndex, iPriority, iPriorityCount, conditionalFormats);
        _iDxfIndex = result[0] as int;
        iPriority = result[1] as int;
        iPriorityCount = result[2] as int;
      }
    }
  }

  Future<void> _serializeConditionalFormattingAsync(
      XmlBuilder builder, Worksheet sheet) async {
    if (sheet.conditionalFormats.isNotEmpty) {
      final int iCount = sheet.conditionalFormats.length;
      int iPriority = 1;
      int iPriorityCount = 0;
      for (int i = 0; i < iCount; i++) {
        final _ConditionalFormatsImpl conditionalFormats =
            sheet.conditionalFormats[i];
        final List<dynamic> result = _serializeConditionalFormats(
            builder, _iDxfIndex, iPriority, iPriorityCount, conditionalFormats);
        _iDxfIndex = result[0] as int;
        iPriority = result[1] as int;
        iPriorityCount = result[2] as int;
      }
    }
  }

  List<dynamic> _serializeConditionalFormats(XmlBuilder builder, int iDxfIndex,
      int iPriority, int iPriorityCount, _ConditionalFormatsImpl formats) {
    final int iRulesCount = formats.count;
    bool serializeCF = false;
    if (iRulesCount == 0)
      return <dynamic>[iDxfIndex, iPriority, iPriorityCount];
    for (final _ConditionalFormatImpl format in formats.innerList) {
      if (format.formatType == ExcelCFType.iconSet) {
        _IconSetImpl? iconSet;
        if (format.iconSet != null) {
          iconSet = format.iconSet as _IconSetImpl?;
        }
        if (iconSet != null && iconSet._isCustom) {
          format._bCFHasExtensionList = true;
        } else if (format.iconSet!.iconSet == ExcelIconSetType.threeTriangles ||
            format.iconSet!.iconSet == ExcelIconSetType.threeStars ||
            format.iconSet!.iconSet == ExcelIconSetType.fiveBoxes) {
          format._bCFHasExtensionList = true;
        }
      }
      if (!format._bCFHasExtensionList) {
        serializeCF = true;
      }
    }
    if (serializeCF) {
      builder.element('conditionalFormatting', nest: () {
        builder.attribute('sqref', formats._cellList);
        int iCount = iRulesCount + iPriorityCount;
        iPriorityCount += iRulesCount;
        for (int i = 0; i < iRulesCount; i++) {
          final ConditionalFormat condition = formats.innerList[i];
          if (!(condition as _ConditionalFormatImpl)._bCFHasExtensionList) {
            final List<dynamic> result = _serializeCondition(
                builder, condition, '', iDxfIndex, iPriority, iCount);
            iDxfIndex = result[0] as int;
            iPriority = result[1] as int;
            iCount = result[2] as int;
          }
        }
      });
    }
    return <dynamic>[iDxfIndex, iPriority, iPriorityCount];
  }

  List<dynamic> _serializeCondition(
      XmlBuilder builder,
      ConditionalFormat condition,
      String prefix,
      int iDxfIndex,
      int iPriority,
      int iCount) {
    final _ConditionalFormatImpl condFormat =
        condition as _ConditionalFormatImpl;
    _IconSetImpl? iconSet;
    if (condFormat.iconSet != null) {
      iconSet = condFormat.iconSet as _IconSetImpl?;
    }
    final ExcelCFType cfType = condition.formatType;
    final ExcelComparisonOperator comparisonOperator = condition.operator;
    final CFTimePeriods cfTimePeriod = condition.timePeriodType;
    builder.element('${prefix}cfRule', nest: () {
      builder.attribute('type', _getCFType(cfType, comparisonOperator));
      if (_checkFormat(condition)) {
        builder.attribute('dxfId', iDxfIndex.toString());
        iDxfIndex++;
      }
      if (condition.stopIfTrue) {
        builder.attribute('stopIfTrue', '1');
      }
      if (cfType == ExcelCFType.cellValue) {
        builder.attribute(
            'operator', _getCFComparisonOperatorName(condition.operator));
      }
      if (cfType == ExcelCFType.specificText) {
        builder.attribute(
            'operator', _getCFComparisonOperatorName(condition.operator));
        // ignore: unnecessary_null_checks
        builder.attribute('text', condition.text!);
      }
      if (cfType == ExcelCFType.timePeriod) {
        builder.attribute('timePeriod', _getCFTimePeriodType(cfTimePeriod));
      }

      builder.attribute('priority', iCount);
      iCount--;

      if (cfType == ExcelCFType.topBottom) {
        _serializeAttributes(builder, 'bottom',
            condition.topBottom!.type == ExcelCFTopBottomType.bottom, false);
        _serializeAttributes(
            builder, 'percent', condition.topBottom!.percent, false);
        builder.attribute('rank', condition.topBottom!.rank.toString());
      }
      if (cfType == ExcelCFType.aboveBelowAverage) {
        final String avgStrType = condition.aboveBelowAverage!.averageType
            .toString()
            .split('.')
            .toList()
            .removeAt(1)
            .toLowerCase();
        _serializeAttributes(
            builder, 'aboveAverage', !avgStrType.contains('below'), true);
        _serializeAttributes(
            builder, 'equalAverage', avgStrType.contains('equal'), false);
        if (avgStrType.contains('stddev')) {
          builder.attribute(
              'stdDev', condition.aboveBelowAverage!.stdDevValue.toString());
        }
      }
      if (condition.firstFormula != '') {
        String v1 = condition.firstFormula;
        if (v1[0] == '=') {
          v1 = v1.substring(1);
        }
        v1 = v1.replaceAll("'", '"');
        builder.element('${prefix}formula', nest: v1);
      }
      if (condition.secondFormula != '') {
        String v1 = condition.secondFormula;
        if (v1[0] == '=') {
          v1 = v1.substring(1);
        }
        v1 = v1.replaceAll("'", '"');
        builder.element('${prefix}formula', nest: v1);
      }
      if (cfType == ExcelCFType.dataBar) {
        _serializeDataBar(builder, condition.dataBar!);
      }
      if (cfType == ExcelCFType.colorScale) {
        _serializeColorScale(builder, condition.colorScale!);
      } else if (cfType == ExcelCFType.iconSet) {
        if (condFormat._bCFHasExtensionList ||
            (iconSet != null && iconSet._isCustom)) {
          _serializeIconSet(builder, iconSet!, condFormat._bCFHasExtensionList,
              iconSet._isCustom);
        } else {
          _serializeIconSet(builder, iconSet!, false, false);
        }
      }
      if (condition.dataBar != null &&
          (condition.dataBar! as _DataBarImpl)._hasExtensionList) {
        builder.element('extLst', nest: () {
          builder.namespace(
              'http://schemas.openxmlformats.org/spreadsheetml/2006/main');
          builder.element('ext', nest: () {
            builder.namespace(
                'http://schemas.openxmlformats.org/spreadsheetml/2006/main');

            builder.attribute('uri', '{B025F937-C7B1-47D3-B67F-A62EFF666E3E}');
            builder.attribute('xmlns:x14',
                'http://schemas.microsoft.com/office/spreadsheetml/2009/9/main');

            builder.element('x14:id',
                nest: (condition.dataBar! as _DataBarImpl)._stGUID);
          });
        });
      }
    });
    return <dynamic>[iDxfIndex, iPriority, iCount];
  }

  /// Serializes color scale of conditional format.
  void _serializeColorScale(XmlBuilder builder, ColorScale colorScale) {
    builder.element('colorScale', nest: () {
      final List<ColorConditionValue> arrConditions = colorScale.criteria;
      for (int i = 0; i < arrConditions.length; i++) {
        _serializeConditionValueObject(
            builder, arrConditions[i], false, false, false);
      }

      for (int i = 0; i < arrConditions.length; i++) {
        _serializeRgbColor(builder, 'color', arrConditions[i].formatColor);
      }
    });
  }

  /// Serializes icon set.
  void _serializeIconSet(XmlBuilder builder, IconSet iconSet,
      bool cfHasExtensionList, bool isCustom) {
    String element;
    if (cfHasExtensionList || isCustom) {
      element = 'x14:iconSet';
    } else {
      element = 'iconSet';
    }

    builder.element(element, nest: () {
      final int index = iconSet.iconSet.index;
      final String strType = _iconSetTypeNames[index];

      builder.attribute('iconSet', strType);
      _serializeAttributes(builder, 'percent', iconSet.percentileValues, false);
      _serializeAttributes(builder, 'reverse', iconSet.reverseOrder, false);
      _serializeAttributes(builder, 'showValue', !iconSet.showIconOnly, true);

      if (isCustom) {
        _serializeAttributes(builder, 'custom', true, false);
      }

      final List<ConditionValue> arrConditions = iconSet.iconCriteria;
      for (int i = 0; i < arrConditions.length; i++) {
        _serializeConditionValueObject(
            builder, arrConditions[i], true, cfHasExtensionList, isCustom);
      }
      if (isCustom) {
        for (int i = 0; i < arrConditions.length; i++) {
          _serializeCustomCFIcon(
              builder, arrConditions[i] as IconConditionValue, true);
        }
      }
    });
  }

  /// Serializes data bar.
  void _serializeDataBar(XmlBuilder builder, DataBar dataBar) {
    builder.element('dataBar', nest: () {
      _serializeAttributeInt(builder, 'minLength', dataBar.percentMin, 0);
      _serializeAttributeInt(builder, 'maxLength', dataBar.percentMax, 100);
      _serializeAttributes(builder, 'showValue', dataBar.showValue, true);

      _serializeConditionValueObjectForDataBar(
          builder, dataBar.minPoint, false, true);
      _serializeConditionValueObjectForDataBar(
          builder, dataBar.maxPoint, false, false);
      _serializeRgbColor(builder, 'color', dataBar.barColor);
    });
  }

  /// Serializes conditional value object.
  void _serializeConditionValueObject(
      XmlBuilder builder,
      ConditionValue conditionValue,
      bool isIconSet,
      bool cfHasExtensionList,
      bool isCustom) {
    String prefix = '';
    if (cfHasExtensionList || isCustom) {
      prefix = 'x14:';
    }
    builder.element('${prefix}cfvo', nest: () {
      final int index = conditionValue.type.index;
      final String strType = _valueTypes[index];
      String value = conditionValue.value;

      builder.attribute('type', strType);

      if (strType == 'formula' && value.startsWith(Range._defaultEquivalent)) {
        value = value.replaceAll(Range._defaultEquivalent, '');
      }

      if (!cfHasExtensionList) {
        builder.attribute('val', value);
      } else if (!cfHasExtensionList) {
        builder.attribute('val', value);
      }

      builder.attribute('gte', (conditionValue.operator).index.toString());

      if (cfHasExtensionList || isCustom) {
        builder.element('xm:f', nest: value);
      }
    });
  }

  /// Serializes conditional value object.
  void _serializeConditionValueObjectForDataBar(XmlBuilder builder,
      ConditionValue conditionValue, bool isIconSet, bool isMinPoint) {
    builder.element('cfvo', nest: () {
      int index = conditionValue.type.index;
      if (index == 7) {
        if (isMinPoint) {
          index = 2;
        } else {
          index = 3;
        }
      }
      final String strType = _valueTypes[index];
      builder.attribute('type', strType);
      builder.attribute('val', conditionValue.value);
      if (isIconSet) {
        builder.attribute('gte', (conditionValue.operator).index.toString());
      }
    });
  }

  /// Serializes Custom iconset object.
  void _serializeCustomCFIcon(
      XmlBuilder builder, IconConditionValue conditionValue, bool isIconSet) {
    builder.element('x14:cfIcon', nest: () {
      String iconType = '';
      if (conditionValue.iconSet.toString() == '-1') {
        iconType = 'NoIcons';
      } else {
        iconType = _iconSetTypeNames[conditionValue.iconSet.index];
      }
      final String iconIndex = conditionValue.index.toString();
      builder.attribute('iconSet', iconType);
      builder.attribute('iconId', iconIndex);
    });
  }

  /// Serializes Rgb color value.
  void _serializeRgbColor(XmlBuilder builder, String tagName, String color) {
    builder.element(tagName, nest: () {
      String colorValue = color;
      if (colorValue.length <= 7) {
        colorValue = 'FF${color.replaceAll('#', '')}';
      }
      builder.attribute('rgb', colorValue);
    });
  }

  Future<void> _serializeRgbColorAsync(
      XmlBuilder builder, String tagName, String color) async {
    builder.element(tagName, nest: () async {
      String colorValue = color;
      if (colorValue.length <= 7) {
        colorValue = 'FF${color.replaceAll('#', '')}';
      }
      builder.attribute('rgb', colorValue);
    });
  }

  /// Returns CF type string name.
  String _getCFType(ExcelCFType typeCF, ExcelComparisonOperator compOperator) {
    switch (typeCF) {
      case ExcelCFType.cellValue:
        return 'cellIs';
      case ExcelCFType.specificText:
        switch (compOperator) {
          case ExcelComparisonOperator.beginsWith:
            return 'beginsWith';
          case ExcelComparisonOperator.containsText:
            return 'containsText';
          case ExcelComparisonOperator.endsWith:
            return 'endsWith';
          case ExcelComparisonOperator.notContainsText:
            return 'notContainsText';
          case ExcelComparisonOperator.none:
          case ExcelComparisonOperator.between:
          case ExcelComparisonOperator.notBetween:
          case ExcelComparisonOperator.equal:
          case ExcelComparisonOperator.notEqual:
          case ExcelComparisonOperator.greater:
          case ExcelComparisonOperator.less:
          case ExcelComparisonOperator.greaterOrEqual:
          case ExcelComparisonOperator.lessOrEqual:
            throw Exception('ComOperator');
        }
      case ExcelCFType.formula:
        return 'expression';
      case ExcelCFType.dataBar:
        return 'dataBar';
      case ExcelCFType.unique:
        return 'uniqueValues';
      case ExcelCFType.duplicate:
        return 'duplicateValues';
      case ExcelCFType.iconSet:
        return 'iconSet';
      case ExcelCFType.colorScale:
        return 'colorScale';
      case ExcelCFType.blank:
        return 'containsBlanks';
      case ExcelCFType.noBlank:
        return 'notContainsBlanks';
      case ExcelCFType.containsErrors:
        return 'containsErrors';
      case ExcelCFType.notContainsErrors:
        return 'notContainsErrors';
      case ExcelCFType.timePeriod:
        return 'timePeriod';
      case ExcelCFType.topBottom:
        return 'top10';
      case ExcelCFType.aboveBelowAverage:
        return 'aboveAverage';
    }
  }

  /// Returns CF comparison operator string name.
  String _getCFComparisonOperatorName(
      ExcelComparisonOperator comparisonOperator) {
    switch (comparisonOperator) {
      case ExcelComparisonOperator.between:
        return 'between';
      case ExcelComparisonOperator.beginsWith:
        return 'beginsWith';
      case ExcelComparisonOperator.containsText:
        return 'containsText';
      case ExcelComparisonOperator.endsWith:
        return 'endsWith';
      case ExcelComparisonOperator.notContainsText:
        return 'notContains';
      case ExcelComparisonOperator.equal:
        return 'equal';
      case ExcelComparisonOperator.greater:
        return 'greaterThan';
      case ExcelComparisonOperator.greaterOrEqual:
        return 'greaterThanOrEqual';
      case ExcelComparisonOperator.less:
        return 'lessThan';
      case ExcelComparisonOperator.lessOrEqual:
        return 'lessThanOrEqual';
      case ExcelComparisonOperator.none:
        return 'notContains';
      case ExcelComparisonOperator.notBetween:
        return 'notBetween';
      case ExcelComparisonOperator.notEqual:
        return 'notEqual';
    }
  }

  /// Return the CF time period string name
  String _getCFTimePeriodType(CFTimePeriods cfTimePeriod) {
    switch (cfTimePeriod) {
      case CFTimePeriods.today:
        return 'today';
      case CFTimePeriods.yesterday:
        return 'yesterday';
      case CFTimePeriods.tomorrow:
        return 'tomorrow';
      case CFTimePeriods.last7Days:
        return 'last7Days';
      case CFTimePeriods.lastWeek:
        return 'lastWeek';
      case CFTimePeriods.thisWeek:
        return 'thisWeek';
      case CFTimePeriods.nextWeek:
        return 'nextWeek';
      case CFTimePeriods.lastMonth:
        return 'lastMonth';
      case CFTimePeriods.thisMonth:
        return 'thisMonth';
      case CFTimePeriods.nextMonth:
        return 'nextMonth';
    }
  }

  /// Serialize Dxfs.
  void _serialiseDxfs(XmlBuilder builder) {
    builder.element('dxfs', nest: () {
      for (final Worksheet sheet in _workbook.worksheets.innerList) {
        if (sheet.autoFilters._innerList.isNotEmpty) {
          for (int i = 0; i < sheet.autoFilters.count; i++) {
            if (sheet.autoFilters[i]._filtertype ==
                _ExcelFilterType.colorFilter) {
              _serializeDxfColorFilter(
                  builder, sheet.autoFilters[i] as _AutoFilterImpl);
            }
          }
        }
        if (sheet.conditionalFormats.isNotEmpty) {
          final int iCount = sheet.conditionalFormats.length;
          for (int i = 0; i < iCount; i++) {
            final _ConditionalFormatsImpl condFormats =
                sheet.conditionalFormats[i];
            for (final _ConditionalFormatImpl condition
                in condFormats.innerList) {
              if (_checkFormat(condition)) {
                _serializeDxf(builder, condition);
              }
            }
          }
        }
      }
    });
  }

  Future<void> _serialiseDxfsAsync(XmlBuilder builder) async {
    builder.element('dxfs', nest: () async {
      for (final Worksheet sheet in _workbook.worksheets.innerList) {
        if (sheet.autoFilters._innerList.isNotEmpty) {
          for (int i = 0; i < sheet.autoFilters.count; i++) {
            if (sheet.autoFilters[i]._filtertype ==
                _ExcelFilterType.colorFilter) {
              _serializeDxfColorFilterAsync(
                  builder, sheet.autoFilters[i] as _AutoFilterImpl);
            }
          }
        }
        if (sheet.conditionalFormats.isNotEmpty) {
          final int iCount = sheet.conditionalFormats.length;
          for (int i = 0; i < iCount; i++) {
            final _ConditionalFormatsImpl condFormats =
                sheet.conditionalFormats[i];
            for (final _ConditionalFormatImpl condition
                in condFormats.innerList) {
              if (_checkFormat(condition)) {
                _serializeDxfAsync(builder, condition);
              }
            }
          }
        }
      }
    });
  }

  ///Serialize color filter dxf style.
  void _serializeDxfColorFilter(
      XmlBuilder builder, _AutoFilterImpl autoFilter) {
    builder.element('dxf', nest: () {
      _serializeDxfColorFilterFill(
          builder, autoFilter._filteredItems as _ColorFilter);
    });
  }

  Future<void> _serializeDxfColorFilterAsync(
      XmlBuilder builder, _AutoFilterImpl autoFilter) async {
    builder.element('dxf', nest: () async {
      _serializeDxfColorFilterFillAsync(
          builder, autoFilter._filteredItems as _ColorFilter);
    });
  }

  ///Serialize dxf color filter style fill.
  void _serializeDxfColorFilterFill(
      XmlBuilder builder, _ColorFilter colorFilter) {
    String foreColor;
    builder.element('fill', nest: () {
      builder.element('patternFill', nest: () {
        if (colorFilter._colorFilterType == ExcelColorFilterType.cellColor &&
            colorFilter._color == '#000000')
          builder.attribute('patternType', 'none');
        else
          builder.attribute('patternType', 'solid');

        if (colorFilter._color == '#000000') {
          if (colorFilter._colorFilterType == ExcelColorFilterType.cellColor) {
            builder.element('fgColor', nest: () {
              builder.attribute('indexed', '64');
            });
          } else {
            builder.element('fgColor', nest: () {
              builder.attribute('indexed', '66');
            });
          }
        } else {
          if (colorFilter._color.length == 7) {
            foreColor = 'FF${colorFilter._color.replaceAll('#', '')}';
          } else {
            foreColor = colorFilter._color;
          }
          builder.element('fgColor', nest: () {
            builder.attribute('rgb', foreColor);
          });
        }
      });
    });
  }

  Future<void> _serializeDxfColorFilterFillAsync(
      XmlBuilder builder, _ColorFilter colorFilter) async {
    String foreColor;
    builder.element('fill', nest: () async {
      builder.element('patternFill', nest: () async {
        if (colorFilter._colorFilterType == ExcelColorFilterType.cellColor &&
            colorFilter._color == '#000000')
          builder.attribute('patternType', 'none');
        else
          builder.attribute('patternType', 'solid');

        if (colorFilter._color == '#000000') {
          if (colorFilter._colorFilterType == ExcelColorFilterType.cellColor) {
            builder.element('fgColor', nest: () async {
              builder.attribute('indexed', '64');
            });
          } else {
            builder.element('fgColor', nest: () async {
              builder.attribute('indexed', '66');
            });
          }
        } else {
          if (colorFilter._color.length == 7) {
            foreColor = 'FF${colorFilter._color.replaceAll('#', '')}';
          } else {
            foreColor = colorFilter._color;
          }
          builder.element('fgColor', nest: () async {
            builder.attribute('rgb', foreColor);
          });
        }
      });
    });
  }

  /// Serializes Dxf style.
  void _serializeDxf(XmlBuilder builder, _ConditionalFormatImpl condition) {
    builder.element('dxf', nest: () {
      _serializeDxfFont(builder, condition);
      _serializeDxfNumberFormat(builder, condition);
      _serializeDxfFill(builder, condition);
      _serializeDxfBorders(builder, condition);
    });
  }

  Future<void> _serializeDxfAsync(
      XmlBuilder builder, _ConditionalFormatImpl condition) async {
    builder.element('dxf', nest: () async {
      _serializeDxfFontAsync(builder, condition);
      _serializeDxfNumberFormatAsync(builder, condition);
      _serializeDxfFillAsync(builder, condition);
      _serializeDxfBordersAsync(builder, condition);
    });
  }

  /// Serializes Dxf style font.
  void _serializeDxfFont(XmlBuilder builder, _ConditionalFormatImpl condition) {
    if (condition.isBold ||
        condition.isItalic ||
        condition.underline ||
        condition.fontColor != '#000000') {
      builder.element('font', nest: () {
        if (condition.isBold) {
          builder.element('b', nest: () {});
        }
        if (condition.isItalic) {
          builder.element('i', nest: () {});
        }
        if (condition.underline) {
          builder.element('u', nest: () {});
        }
        String fontColor;
        if (condition.fontColor.length <= 7) {
          fontColor = 'FF${condition.fontColor.replaceAll('#', '')}';
        } else {
          fontColor = condition.fontColor;
        }
        builder.element('color', nest: () {
          builder.attribute('rgb', fontColor);
        });
      });
    }
  }

  Future<void> _serializeDxfFontAsync(
      XmlBuilder builder, _ConditionalFormatImpl condition) async {
    if (condition.isBold ||
        condition.isItalic ||
        condition.underline ||
        condition.fontColor != '#000000') {
      builder.element('font', nest: () async {
        if (condition.isBold) {
          builder.element('b', nest: () async {});
        }
        if (condition.isItalic) {
          builder.element('i', nest: () async {});
        }
        if (condition.underline) {
          builder.element('u', nest: () async {});
        }
        String fontColor;
        if (condition.fontColor.length <= 7) {
          fontColor = 'FF${condition.fontColor.replaceAll('#', '')}';
        } else {
          fontColor = condition.fontColor;
        }
        builder.element('color', nest: () async {
          builder.attribute('rgb', fontColor);
        });
      });
    }
  }

  /// Serializes Dxf number format.
  void _serializeDxfNumberFormat(
      XmlBuilder builder, _ConditionalFormatImpl condition) {
    if (condition.numberFormat != 'General') {
      int index;
      _Format? format;
      if (_workbook.innerFormats._contains(condition._numberFormatIndex)) {
        format = _workbook.innerFormats[condition._numberFormatIndex];
        index = format._index;
      } else {
        index = _workbook.innerFormats._createFormat(condition.numberFormat);
      }
      builder.element('numFmt', nest: () {
        builder.attribute('numFmtId', index.toString());
        final String formatString = format!._formatString!.replaceAll("'", '"');
        builder.attribute('formatCode', formatString);
      });
    }
  }

  Future<void> _serializeDxfNumberFormatAsync(
      XmlBuilder builder, _ConditionalFormatImpl condition) async {
    if (condition.numberFormat != 'General') {
      int index;
      _Format? format;
      if (_workbook.innerFormats._contains(condition._numberFormatIndex)) {
        format = _workbook.innerFormats[condition._numberFormatIndex];
        index = format._index;
      } else {
        index = _workbook.innerFormats._createFormat(condition.numberFormat);
      }
      builder.element('numFmt', nest: () async {
        builder.attribute('numFmtId', index.toString());
        final String formatString = format!._formatString!.replaceAll("'", '"');
        builder.attribute('formatCode', formatString);
      });
    }
  }

  /// Serializes Dxf style fill.
  void _serializeDxfFill(XmlBuilder builder, _ConditionalFormatImpl condition) {
    String backColor;
    if (condition.backColor != '#FFFFFF') {
      if (condition.backColor.length == 7) {
        backColor = 'FF${condition.backColor.replaceAll('#', '')}';
      } else {
        backColor = condition.backColor;
      }
      builder.element('fill', nest: () {
        builder.element('patternFill', nest: () {
          builder.element('bgColor', nest: () {
            builder.attribute('rgb', backColor);
          });
        });
      });
    }
  }

  Future<void> _serializeDxfFillAsync(
      XmlBuilder builder, _ConditionalFormatImpl condition) async {
    String backColor;
    if (condition.backColor != '#FFFFFF') {
      if (condition.backColor.length == 7) {
        backColor = 'FF${condition.backColor.replaceAll('#', '')}';
      } else {
        backColor = condition.backColor;
      }
      builder.element('fill', nest: () async {
        builder.element('patternFill', nest: () async {
          builder.element('bgColor', nest: () async {
            builder.attribute('rgb', backColor);
          });
        });
      });
    }
  }

  /// Serializes Dxf borders.
  void _serializeDxfBorders(
      XmlBuilder builder, _ConditionalFormatImpl condition) {
    if (condition.leftBorderStyle != LineStyle.none ||
        condition.rightBorderStyle != LineStyle.none ||
        condition.topBorderStyle != LineStyle.none ||
        condition.bottomBorderStyle != LineStyle.none) {
      builder.element('border', nest: () {
        if (condition.leftBorderStyle != LineStyle.none) {
          _serializeDxfBorder(builder, 'left', condition.leftBorderStyle,
              condition.leftBorderColor);
        }
        if (condition.rightBorderStyle != LineStyle.none) {
          _serializeDxfBorder(builder, 'right', condition.rightBorderStyle,
              condition.rightBorderColor);
        }
        if (condition.topBorderStyle != LineStyle.none) {
          _serializeDxfBorder(builder, 'top', condition.topBorderStyle,
              condition.topBorderColor);
        }
        if (condition.bottomBorderStyle != LineStyle.none) {
          _serializeDxfBorder(builder, 'bottom', condition.bottomBorderStyle,
              condition.bottomBorderColor);
        }
      });
    }
  }

  Future<void> _serializeDxfBordersAsync(
      XmlBuilder builder, _ConditionalFormatImpl condition) async {
    if (condition.leftBorderStyle != LineStyle.none ||
        condition.rightBorderStyle != LineStyle.none ||
        condition.topBorderStyle != LineStyle.none ||
        condition.bottomBorderStyle != LineStyle.none) {
      builder.element('border', nest: () async {
        if (condition.leftBorderStyle != LineStyle.none) {
          _serializeDxfBorderAsync(builder, 'left', condition.leftBorderStyle,
              condition.leftBorderColor);
        }
        if (condition.rightBorderStyle != LineStyle.none) {
          _serializeDxfBorderAsync(builder, 'right', condition.rightBorderStyle,
              condition.rightBorderColor);
        }
        if (condition.topBorderStyle != LineStyle.none) {
          _serializeDxfBorderAsync(builder, 'top', condition.topBorderStyle,
              condition.topBorderColor);
        }
        if (condition.bottomBorderStyle != LineStyle.none) {
          _serializeDxfBorderAsync(builder, 'bottom',
              condition.bottomBorderStyle, condition.bottomBorderColor);
        }
      });
    }
  }

  /// Serializes Dxf border.
  void _serializeDxfBorder(XmlBuilder builder, String value,
      LineStyle borderStyle, String borderColor) {
    builder.element(value, nest: () {
      final String strStyle =
          borderStyle.toString().split('.').toList().removeAt(1).toLowerCase();
      builder.attribute('style', strStyle);
      builder.element('color', nest: () {
        if (borderColor.length <= 7) {
          builder.attribute('rgb', 'FF${borderColor.replaceAll('#', '')}');
        } else {
          builder.attribute('rgb', borderColor);
        }
      });
    });
  }

  Future<void> _serializeDxfBorderAsync(XmlBuilder builder, String value,
      LineStyle borderStyle, String borderColor) async {
    builder.element(value, nest: () async {
      final String strStyle =
          borderStyle.toString().split('.').toList().removeAt(1).toLowerCase();
      builder.attribute('style', strStyle);
      builder.element('color', nest: () async {
        if (borderColor.length <= 7) {
          builder.attribute('rgb', 'FF${borderColor.replaceAll('#', '')}');
        } else {
          builder.attribute('rgb', borderColor);
        }
      });
    });
  }

  /// Serializes conditional formattings.
  void _serializeConditionalFormattingExt(XmlBuilder builder, Worksheet sheet) {
    final bool hasExtensionList = _hasExtensionListOnCF(sheet);
    if (!hasExtensionList) {
      return;
    }
    int iPriority = 1;
    int iPriorityCount = 0;

    if (hasExtensionList) {
      builder.element('ext', nest: () {
        builder.namespace(
            'http://schemas.openxmlformats.org/spreadsheetml/2006/main');
        builder.attribute('uri', '{78C0D931-6437-407d-A8EE-F0AAD7539E65}');
        builder.attribute('xmlns:x14',
            'http://schemas.microsoft.com/office/spreadsheetml/2009/9/main');

        builder.element('x14:conditionalFormattings', nest: () {
          for (final ConditionalFormats conditions
              in sheet.conditionalFormats) {
            for (int i = 0; i < conditions.count; i++) {
              final ConditionalFormat condition =
                  (conditions as _ConditionalFormatsImpl).innerList[i];
              final _ConditionalFormatImpl format =
                  condition as _ConditionalFormatImpl;
              _IconSetImpl? iconSet;
              if (format.iconSet != null) {
                iconSet = format.iconSet! as _IconSetImpl;
              }
              if (format._bCFHasExtensionList) {
                final _ConditionalFormatsImpl formats = conditions;
                format._rangeRefernce = (formats._cellList.isNotEmpty)
                    ? (' ${formats._cellList}')
                    : '';

                if ((condition.formatType == ExcelCFType.formula &&
                        condition.firstFormula != '') ||
                    condition.formatType == ExcelCFType.specificText &&
                        condition.firstFormula != '' &&
                        (condition.operator ==
                                ExcelComparisonOperator.beginsWith ||
                            condition.operator ==
                                ExcelComparisonOperator.endsWith ||
                            condition.operator ==
                                ExcelComparisonOperator.containsText ||
                            condition.operator ==
                                ExcelComparisonOperator.notContainsText) ||
                    condition.formatType == ExcelCFType.cellValue &&
                        condition.firstFormula != '' &&
                        (condition.operator == ExcelComparisonOperator.equal ||
                            condition.operator ==
                                ExcelComparisonOperator.notEqual ||
                            condition.operator ==
                                ExcelComparisonOperator.greater ||
                            condition.operator ==
                                ExcelComparisonOperator.greaterOrEqual ||
                            condition.operator ==
                                ExcelComparisonOperator.less ||
                            condition.operator ==
                                ExcelComparisonOperator.lessOrEqual ||
                            (condition.secondFormula != '' &&
                                (condition.operator ==
                                        ExcelComparisonOperator.between ||
                                    condition.operator ==
                                        ExcelComparisonOperator.notBetween)))) {
                  builder.element('x14:conditionalFormatting', nest: () {
                    builder.attribute('xmlns:xm',
                        'http://schemas.microsoft.com/office/excel/2006/main');
                    builder.element('x14:cfRule', nest: () {
                      builder.attribute('type',
                          _getCFType(condition.formatType, condition.operator));
                      if (format._priority > 1) {
                        builder.attribute(
                            'priority', format._priority.toString());
                      } else {
                        builder.attribute('priority', iPriority.toString());
                        iPriority++;
                      }
                      if (condition.formatType == ExcelCFType.cellValue ||
                          condition.formatType == ExcelCFType.specificText) {
                        builder.attribute('operator',
                            _getCFComparisonOperatorName(condition.operator));
                      }
                      // writer.WriteAttributeString(IdAttributeName, format.ST_GUID.ToString());
                      final _ConditionalFormatImpl conFormatImpl = condition;
                      final String strFormula1 = conFormatImpl.firstFormula;
                      final String strFormula2 = conFormatImpl.secondFormula;
                      if (strFormula1 != '' && strFormula1 != '') {
                        builder.element('xm:f', nest: strFormula1);
                      }
                      if (strFormula2 != '' && strFormula2 != '') {
                        builder.element('xm:f', nest: strFormula2);
                      } else if (format._range != null) {
                        builder.element('xm:f',
                            nest: (format._range)!.addressGlobal);
                      }

                      builder.element('dxf', nest: () {
                        _serializeDxfFont(builder, condition);
                        _serializeDxfFill(builder, condition);
                        _serializeDxfBorders(builder, condition);
                      });
                    });
                    builder.element('xm:sqref', nest: format._rangeRefernce);
                  });
                }
              }
              if (condition.iconSet != null &&
                  (format._bCFHasExtensionList ||
                      format.iconSet!.iconSet == ExcelIconSetType.threeStars ||
                      (iconSet != null && iconSet._isCustom) ||
                      format.iconSet!.iconSet == ExcelIconSetType.fiveBoxes ||
                      format.iconSet!.iconSet ==
                          ExcelIconSetType.threeTriangles)) {
                final int iDxfIndex = _iDxfIndex;

                builder.element('x14:conditionalFormatting', nest: () {
                  builder.attribute('xmlns:xm',
                      'http://schemas.microsoft.com/office/excel/2006/main');
                  final List<dynamic> result = _serializeCondition(builder,
                      condition, 'x14:', iDxfIndex, iPriority, iPriorityCount);
                  _iDxfIndex = result[0] as int;
                  iPriority = result[1] as int;
                  iPriorityCount = result[2] as int;

                  final _ConditionalFormatsImpl formats = conditions;
                  final String strAddress = (formats._cellList.isNotEmpty)
                      ? (' ${formats._cellList}')
                      : '';
                  builder.element('xm:sqref', nest: strAddress);
                });
              }
              if (condition.dataBar != null &&
                  (condition.dataBar! as _DataBarImpl)._hasExtensionList) {
                final DataBar dataBar = condition.dataBar!;
                final _DataBarImpl dataBarImpl = dataBar as _DataBarImpl;

                builder.element('x14:conditionalFormatting', nest: () {
                  builder.element('x14:cfRule', nest: () {
                    builder.attribute('type', 'dataBar');
                    // ignore: unnecessary_null_checks
                    builder.attribute('id', dataBarImpl._stGUID!);

                    builder.element('x14:dataBar', nest: () {
                      builder.attribute(
                          'border', (dataBar.hasBorder) ? '1' : '0');
                      builder.attribute(
                          'gradient', (dataBar.hasGradientFill) ? '1' : '0');
                      builder.attribute(
                          'minLength', dataBar.percentMin.toString());
                      builder.attribute(
                          'maxLength', dataBar.percentMax.toString());
                      builder.attribute('direction',
                          dataBar.dataBarDirection.toString().substring(17));
                      builder.attribute('negativeBarColorSameAsPositive',
                          (dataBarImpl._hasDiffNegativeBarColor) ? '0' : '1');
                      builder.attribute(
                          'negativeBarBorderColorSameAsPositive',
                          (dataBarImpl._hasDiffNegativeBarBorderColor)
                              ? '0'
                              : '1');
                      builder.attribute('axisPosition',
                          dataBar.dataBarAxisPosition.toString().substring(20));

                      _serializeConditionValueObjectExt(
                          builder, dataBar.minPoint, false, true);
                      _serializeConditionValueObjectExt(
                          builder, dataBar.maxPoint, false, false);

                      if (dataBar.borderColor != '') {
                        _serializeRgbColor(
                            builder, 'x14:borderColor', dataBar.borderColor);
                      }
                      if (dataBar.negativeFillColor != '') {
                        _serializeRgbColor(builder, 'x14:negativeFillColor',
                            dataBar.negativeFillColor);
                      }
                      if (dataBar.negativeBorderColor != '') {
                        _serializeRgbColor(builder, 'x14:negativeBorderColor',
                            dataBar.negativeBorderColor);
                      }
                      if (dataBar.barAxisColor != '') {
                        _serializeRgbColor(
                            builder, 'x14:axisColor', dataBar.barAxisColor);
                      }
                    });
                  });
                });
              }
            }
          }
        });
      });
    }
  }

  Future<void> _serializeConditionalFormattingExtAsync(
      XmlBuilder builder, Worksheet sheet) async {
    final bool hasExtensionList = _hasExtensionListOnCF(sheet);
    if (!hasExtensionList) {
      return;
    }
    int iPriority = 1;
    int iPriorityCount = 0;

    if (hasExtensionList) {
      builder.element('ext', nest: () async {
        builder.namespace(
            'http://schemas.openxmlformats.org/spreadsheetml/2006/main');
        builder.attribute('uri', '{78C0D931-6437-407d-A8EE-F0AAD7539E65}');
        builder.attribute('xmlns:x14',
            'http://schemas.microsoft.com/office/spreadsheetml/2009/9/main');

        builder.element('x14:conditionalFormattings', nest: () async {
          for (final ConditionalFormats conditions
              in sheet.conditionalFormats) {
            for (int i = 0; i < conditions.count; i++) {
              final ConditionalFormat condition =
                  (conditions as _ConditionalFormatsImpl).innerList[i];
              final _ConditionalFormatImpl format =
                  condition as _ConditionalFormatImpl;
              _IconSetImpl? iconSet;
              if (format.iconSet != null) {
                iconSet = format.iconSet! as _IconSetImpl;
              }
              if (format._bCFHasExtensionList) {
                final _ConditionalFormatsImpl formats = conditions;
                format._rangeRefernce = (formats._cellList.isNotEmpty)
                    ? (' ${formats._cellList}')
                    : '';

                if ((condition.formatType == ExcelCFType.formula &&
                        condition.firstFormula != '') ||
                    condition.formatType == ExcelCFType.specificText &&
                        condition.firstFormula != '' &&
                        (condition.operator ==
                                ExcelComparisonOperator.beginsWith ||
                            condition.operator ==
                                ExcelComparisonOperator.endsWith ||
                            condition.operator ==
                                ExcelComparisonOperator.containsText ||
                            condition.operator ==
                                ExcelComparisonOperator.notContainsText) ||
                    condition.formatType == ExcelCFType.cellValue &&
                        condition.firstFormula != '' &&
                        (condition.operator == ExcelComparisonOperator.equal ||
                            condition.operator ==
                                ExcelComparisonOperator.notEqual ||
                            condition.operator ==
                                ExcelComparisonOperator.greater ||
                            condition.operator ==
                                ExcelComparisonOperator.greaterOrEqual ||
                            condition.operator ==
                                ExcelComparisonOperator.less ||
                            condition.operator ==
                                ExcelComparisonOperator.lessOrEqual ||
                            (condition.secondFormula != '' &&
                                (condition.operator ==
                                        ExcelComparisonOperator.between ||
                                    condition.operator ==
                                        ExcelComparisonOperator.notBetween)))) {
                  builder.element('x14:conditionalFormatting', nest: () async {
                    builder.attribute('xmlns:xm',
                        'http://schemas.microsoft.com/office/excel/2006/main');
                    builder.element('x14:cfRule', nest: () async {
                      builder.attribute('type',
                          _getCFType(condition.formatType, condition.operator));

                      if (format._priority > 1) {
                        builder.attribute(
                            'priority', format._priority.toString());
                      } else {
                        builder.attribute('priority', iPriority.toString());
                        iPriority++;
                      }
                      if (condition.formatType == ExcelCFType.cellValue ||
                          condition.formatType == ExcelCFType.specificText) {
                        builder.attribute('operator',
                            _getCFComparisonOperatorName(condition.operator));
                      }
                      // writer.WriteAttributeString(IdAttributeName, format.ST_GUID.ToString());
                      final _ConditionalFormatImpl conFormatImpl = condition;
                      final String strFormula1 = conFormatImpl.firstFormula;
                      final String strFormula2 = conFormatImpl.secondFormula;
                      if (strFormula1 != '' && strFormula1 != '') {
                        builder.element('xm:f', nest: strFormula1);
                      }
                      if (strFormula2 != '' && strFormula2 != '') {
                        builder.element('xm:f', nest: strFormula2);
                      } else if (format._range != null) {
                        builder.element('xm:f',
                            nest: (format._range)!.addressGlobal);
                      }

                      builder.element('dxf', nest: () async {
                        _serializeDxfFontAsync(builder, condition);
                        _serializeDxfFillAsync(builder, condition);
                        _serializeDxfBordersAsync(builder, condition);
                      });
                    });
                    builder.element('xm:sqref', nest: format._rangeRefernce);
                  });
                }
              }
              if (condition.iconSet != null &&
                  (format._bCFHasExtensionList ||
                      format.iconSet!.iconSet == ExcelIconSetType.threeStars ||
                      (iconSet != null && iconSet._isCustom) ||
                      format.iconSet!.iconSet == ExcelIconSetType.fiveBoxes ||
                      format.iconSet!.iconSet ==
                          ExcelIconSetType.threeTriangles)) {
                final int iDxfIndex = _iDxfIndex;

                builder.element('x14:conditionalFormatting', nest: () {
                  builder.attribute('xmlns:xm',
                      'http://schemas.microsoft.com/office/excel/2006/main');
                  final List<dynamic> result = _serializeCondition(builder,
                      condition, 'x14:', iDxfIndex, iPriority, iPriorityCount);
                  _iDxfIndex = result[0] as int;
                  iPriority = result[1] as int;
                  iPriorityCount = result[2] as int;

                  final _ConditionalFormatsImpl formats = conditions;
                  final String strAddress = (formats._cellList.isNotEmpty)
                      ? (' ${formats._cellList}')
                      : '';
                  builder.element('xm:sqref', nest: strAddress);
                });
              }
              if (condition.dataBar != null &&
                  (condition.dataBar! as _DataBarImpl)._hasExtensionList) {
                final DataBar dataBar = condition.dataBar!;
                final _DataBarImpl dataBarImpl = dataBar as _DataBarImpl;

                builder.element('x14:conditionalFormatting', nest: () async {
                  builder.element('x14:cfRule', nest: () async {
                    builder.attribute('type', 'dataBar');
                    // ignore: unnecessary_null_checks
                    builder.attribute('id', dataBarImpl._stGUID!);

                    builder.element('x14:dataBar', nest: () async {
                      builder.attribute(
                          'border', (dataBar.hasBorder) ? '1' : '0');
                      builder.attribute(
                          'gradient', (dataBar.hasGradientFill) ? '1' : '0');
                      builder.attribute(
                          'minLength', dataBar.percentMin.toString());
                      builder.attribute(
                          'maxLength', dataBar.percentMax.toString());
                      builder.attribute('direction',
                          dataBar.dataBarDirection.toString().substring(17));
                      builder.attribute('negativeBarColorSameAsPositive',
                          (dataBarImpl._hasDiffNegativeBarColor) ? '0' : '1');
                      builder.attribute(
                          'negativeBarBorderColorSameAsPositive',
                          (dataBarImpl._hasDiffNegativeBarBorderColor)
                              ? '0'
                              : '1');
                      builder.attribute('axisPosition',
                          dataBar.dataBarAxisPosition.toString().substring(20));

                      _serializeConditionValueObjectExtAsync(
                          builder, dataBar.minPoint, false, true);
                      _serializeConditionValueObjectExtAsync(
                          builder, dataBar.maxPoint, false, false);
                      if (dataBar.borderColor != '') {
                        _serializeRgbColorAsync(
                            builder, 'x14:borderColor', dataBar.borderColor);
                      }
                      if (dataBar.negativeFillColor != '') {
                        _serializeRgbColorAsync(builder,
                            'x14:negativeFillColor', dataBar.negativeFillColor);
                      }
                      if (dataBar.negativeBorderColor != '') {
                        _serializeRgbColorAsync(
                            builder,
                            'x14:negativeBorderColor',
                            dataBar.negativeBorderColor);
                      }
                      if (dataBar.barAxisColor != '') {
                        _serializeRgbColorAsync(
                            builder, 'x14:axisColor', dataBar.barAxisColor);
                      }
                    });
                  });
                });
              }
            }
          }
        });
      });
    }
  }

  /// Check whether the sheet has conditional formats or not.
  bool _hasExtensionListOnCF(Worksheet sheet) {
    if (sheet.conditionalFormats.isEmpty) {
      return false;
    }
    bool hasExtensionList = false;
    for (final ConditionalFormats conditions in sheet.conditionalFormats) {
      for (int i = 0; i < conditions.count; i++) {
        final ConditionalFormat condition =
            (conditions as _ConditionalFormatsImpl).innerList[i];
        if (condition.dataBar != null &&
            (condition.dataBar! as _DataBarImpl)._hasExtensionList) {
          hasExtensionList = true;
          break;
        } else if ((condition as _ConditionalFormatImpl)._bCFHasExtensionList &&
            condition.formatType == ExcelCFType.specificText) {
          hasExtensionList = true;
          break;
        } else if ((condition.iconSet != null) &&
            condition._bCFHasExtensionList) {
          hasExtensionList = true;
          break;
        } else if (condition._bCFHasExtensionList &&
            condition.formatType == ExcelCFType.formula &&
            condition.firstFormula != '' &&
            condition.firstFormula.contains('!')) {
          hasExtensionList = true;
          break;
        } else if (condition._bCFHasExtensionList &&
            condition.formatType == ExcelCFType.cellValue) {
          hasExtensionList = true;
          break;
        }
      }
    }
    if (hasExtensionList) {
      return true;
    }
    return false;
  }

  /// Serializes conditional value object.
  void _serializeConditionValueObjectExt(XmlBuilder builder,
      ConditionValue conditionValue, bool isIconSet, bool isMinPoint) {
    builder.element('x14:cfvo', nest: () {
      int index = conditionValue.type.index;
      if (!isIconSet) {
        index = index == 7
            ? isMinPoint
                ? 7
                : 8
            : index;
      }
      final String strType = _valueTypes[index];
      builder.attribute('type', strType);
      builder.attribute('val', conditionValue.value);
      if (isIconSet) {
        builder.attribute('gte', (conditionValue.operator).index.toString());
      }
    });
  }

  Future<void> _serializeConditionValueObjectExtAsync(XmlBuilder builder,
      ConditionValue conditionValue, bool isIconSet, bool isMinPoint) async {
    builder.element('x14:cfvo', nest: () async {
      int index = conditionValue.type.index;
      if (!isIconSet) {
        index = index == 7
            ? isMinPoint
                ? 7
                : 8
            : index;
      }
      final String strType = _valueTypes[index];
      builder.attribute('type', strType);
      builder.attribute('val', conditionValue.value);
      if (isIconSet) {
        builder.attribute('gte', (conditionValue.operator).index.toString());
      }
    });
  }

  // Check whether to apply format or not.
  bool _checkFormat(_ConditionalFormatImpl condition) {
    return condition.backColor != '#FFFFFF' ||
        condition.isBold ||
        condition.isItalic ||
        condition.underline ||
        condition.fontColor != '#000000' ||
        condition.numberFormat != 'General' ||
        condition.leftBorderStyle != LineStyle.none ||
        condition.rightBorderStyle != LineStyle.none ||
        condition.topBorderStyle != LineStyle.none ||
        condition.bottomBorderStyle != LineStyle.none;
  }

  /// Add the workbook data with filename to ZipArchive.
  void _addToArchive(List<int> data, String fileName) {
    final ArchiveFile item = ArchiveFile(fileName, data.length, data);
    _workbook.archive.addFile(item);
  }

  Future<void> _addToArchiveAsync(List<int> data, String fileName) async {
    final ArchiveFile item = ArchiveFile(fileName, data.length, data);
    _workbook.archive.addFile(item);
  }

  /// Checks whether columns after iColumnIndex have the same settings and
  /// returns the last number in the sequence.
  static int _findSameColumns(
      Worksheet sheet, int iColumnIndex, Workbook workbook) {
    final Column? currentColumn = sheet.columns[iColumnIndex];

    while (iColumnIndex <= sheet.columns.count) {
      final int iCurrentColumn = iColumnIndex + 1;

      final Column? columnToCompare = sheet.columns[iCurrentColumn];

      if (columnToCompare != null &&
          columnToCompare.width == currentColumn!.width &&
          columnToCompare._isHidden == currentColumn._isHidden) {
        iColumnIndex++;
      } else {
        break;
      }
    }
    return iColumnIndex;
  }

  ///Serializes auto filters.
  void _serializeAutoFilters(
      XmlBuilder builder, AutoFilterCollection? autoFilters) {
    if (autoFilters == null || autoFilters._innerList.isEmpty) {
      return;
    }
    builder.element('autoFilter', nest: () {
      builder.attribute('ref', autoFilters.filterRange.addressLocal);

      // ignore: always_specify_types
      for (int i = 0; i < autoFilters.count; i++) {
        final _AutoFilterImpl autoFilter = autoFilters[i] as _AutoFilterImpl;

        if (autoFilter._isFiltered) {
          _serializeFilterColumn(builder, autoFilter);
        }
      }
    });
  }

  Future<void> _serializeAutoFiltersAsync(
      XmlBuilder builder, AutoFilterCollection? autoFilters) async {
    if (autoFilters == null || autoFilters._innerList.isEmpty) {
      return;
    }
    builder.element('autoFilter', nest: () async {
      builder.attribute('ref', autoFilters.filterRange.addressLocal);

      // ignore: always_specify_types
      for (int i = 0; i < autoFilters.count; i++) {
        final _AutoFilterImpl autoFilter = autoFilters[i] as _AutoFilterImpl;

        if (autoFilter._isFiltered) {
          _serializeFilterColumnAsync(builder, autoFilter);
        }
      }
    });
  }

  /// Serializes filter column.
  void _serializeFilterColumn(
    XmlBuilder builder,
    _AutoFilterImpl autoFilter,
  ) {
    builder.element('filterColumn', nest: () {
      _serializeAttributeInt(builder, 'colId', autoFilter._colIndex - 1, -1);

      switch (autoFilter._typeOfFilter) {
        case _ExcelFilterType.combinationFilter:
          _serializeFilters(builder, autoFilter);
          break;
        case _ExcelFilterType.customFilter:
          _serializeCustomFilter(builder, autoFilter);
          break;
        case _ExcelFilterType.dynamicFilter:
          _serializeDateFilter(
              builder, autoFilter._filteredItems as _DynamicFilter);
          break;
        case _ExcelFilterType.colorFilter:
          _serializeColorFilter(
              builder, autoFilter._filteredItems as _ColorFilter);
          break;
        case _ExcelFilterType.iconFilter:
          break;
        case _ExcelFilterType.notUsed:
          break;
      }
    });
  }

  Future<void> _serializeFilterColumnAsync(
    XmlBuilder builder,
    _AutoFilterImpl autoFilter,
  ) async {
    builder.element('filterColumn', nest: () async {
      _serializeAttributeIntAsync(
          builder, 'colId', autoFilter._colIndex - 1, -1);
      switch (autoFilter._typeOfFilter) {
        case _ExcelFilterType.combinationFilter:
          _serializeFiltersAsync(builder, autoFilter);
          break;
        case _ExcelFilterType.customFilter:
          _serializeCustomFilterAsync(builder, autoFilter);
          break;
        case _ExcelFilterType.dynamicFilter:
          _serializeDateFilterAsync(
              builder, autoFilter._filteredItems as _DynamicFilter);
          break;
        case _ExcelFilterType.colorFilter:
          _serializeColorFilterAsync(
              builder, autoFilter._filteredItems as _ColorFilter);
          break;
        case _ExcelFilterType.iconFilter:
          break;
        case _ExcelFilterType.notUsed:
          break;
      }
    });
  }

  /// Serialize color filter.
  void _serializeColorFilter(XmlBuilder builder, _ColorFilter filter) {
    builder.element('colorFilter', nest: () {
      builder.attribute('dxfId', _iDxfIndex.toString());
      _iDxfIndex++;
      if (filter._colorFilterType == ExcelColorFilterType.fontColor) {
        builder.attribute('cellColor', '0');
      }
    });
  }

  Future<void> _serializeColorFilterAsync(
      XmlBuilder builder, _ColorFilter filter) async {
    builder.element('colorFilter', nest: () async {
      builder.attribute('dxfId', _iDxfIndex.toString());
      _iDxfIndex++;
      if (filter._colorFilterType == ExcelColorFilterType.fontColor) {
        builder.attribute('cellColor', '0');
      }
    });
  }

  /// Serialize the dynmaic filter.
  void _serializeDateFilter(XmlBuilder builder, _DynamicFilter filter) {
    if (filter._dateFilterType != DynamicFilterType.none) {
      builder.element('dynamicFilter', nest: () {
        final String? dateTime =
            _convertDateFilterTypeToString(filter._dateFilterType);
        builder.attribute('type', dateTime.toString());
      });
    }
  }

  Future<void> _serializeDateFilterAsync(
      XmlBuilder builder, _DynamicFilter filter) async {
    if (filter._dateFilterType != DynamicFilterType.none) {
      builder.element('dynamicFilter', nest: () async {
        builder.attribute('type',
            _convertDateFilterTypeToString(filter._dateFilterType).toString());
      });
    }
  }

  /// Convert dynamic filter type to string.
  String? _convertDateFilterTypeToString(DynamicFilterType filterType) {
    switch (filterType) {
      case DynamicFilterType.tomorrow:
        return 'tomorrow';

      case DynamicFilterType.today:
        return 'today';

      case DynamicFilterType.yesterday:
        return 'yesterday';

      case DynamicFilterType.nextWeek:
        return 'nextWeek';

      case DynamicFilterType.thisWeek:
        return 'thisWeek';

      case DynamicFilterType.lastWeek:
        return 'lastWeek';

      case DynamicFilterType.nextMonth:
        return 'nextMonth';

      case DynamicFilterType.thisMonth:
        return 'thisMonth';

      case DynamicFilterType.lastMonth:
        return 'lastMonth';

      case DynamicFilterType.nextQuarter:
        return 'nextQuarter';

      case DynamicFilterType.thisQuarter:
        return 'thisQuarter';

      case DynamicFilterType.lastQuarter:
        return 'lastQuarter';

      case DynamicFilterType.nextYear:
        return 'nextYear';

      case DynamicFilterType.thisYear:
        return 'thisYear';

      case DynamicFilterType.lastYear:
        return 'lastYear';

      case DynamicFilterType.yearToDate:
        return 'yearToDate';

      case DynamicFilterType.january:
        return 'M1';

      case DynamicFilterType.february:
        return 'M2';

      case DynamicFilterType.march:
        return 'M3';

      case DynamicFilterType.april:
        return 'M4';

      case DynamicFilterType.may:
        return 'M5';

      case DynamicFilterType.june:
        return 'M6';

      case DynamicFilterType.july:
        return 'M7';

      case DynamicFilterType.august:
        return 'M8';

      case DynamicFilterType.september:
        return 'M9';

      case DynamicFilterType.october:
        return 'M10';

      case DynamicFilterType.november:
        return 'M11';

      case DynamicFilterType.december:
        return 'M12';

      case DynamicFilterType.quarter1:
        return 'Q1';

      case DynamicFilterType.quarter2:
        return 'Q2';

      case DynamicFilterType.quarter3:
        return 'Q3';

      case DynamicFilterType.quarter4:
        return 'Q4';
      case DynamicFilterType.none:
        break;
    }
    return null;
  }

  ///SerializeCombination filter
  void _serializeFilters(XmlBuilder builder, _AutoFilterImpl autoFilter) {
    builder.element('filters', nest: () {
      if (autoFilter._filteredItems._filterType ==
          _ExcelFilterType.combinationFilter) {
        _serializeCombinationFilters(
            builder, autoFilter._filteredItems as _CombinationFilter);
      }
    });
  }

  Future<void> _serializeFiltersAsync(
      XmlBuilder builder, _AutoFilterImpl autoFilter) async {
    builder.element('filters', nest: () async {
      if (autoFilter._filteredItems._filterType ==
          _ExcelFilterType.combinationFilter) {
        _serializeCombinationFiltersAsync(
            builder, autoFilter._filteredItems as _CombinationFilter);
      }
    });
  }

  ///SerializeCombination filter
  void _serializeCombinationFilters(
      XmlBuilder builder, _CombinationFilter combinationFilter) {
    if (combinationFilter._isBlank) {
      builder.attribute('blank', 1);
    }
    for (final _MultipleFilter multipleFilter
        in combinationFilter._filterCollection) {
      switch (multipleFilter._combinationFilterType) {
        case _ExcelCombinationFilterType.textFilter:
          _serializeFilter(builder, (multipleFilter as _TextFilter)._text);
          break;
        case _ExcelCombinationFilterType.dateTimeFilter:
          _serializeDateTimeFilter(builder, multipleFilter as _DateTimeFilter);
          break;
      }
    }
  }

  Future<void> _serializeCombinationFiltersAsync(
      XmlBuilder builder, _CombinationFilter combinationFilter) async {
    if (combinationFilter._isBlank) {
      builder.attribute('blank', 1);
    }
    for (final _MultipleFilter multipleFilter
        in combinationFilter._filterCollection) {
      switch (multipleFilter._combinationFilterType) {
        case _ExcelCombinationFilterType.textFilter:
          _serializeFilterAsync(builder, (multipleFilter as _TextFilter)._text);
          break;
        case _ExcelCombinationFilterType.dateTimeFilter:
          _serializeDateTimeFilterAsync(
              builder, multipleFilter as _DateTimeFilter);
          break;
      }
    }
  }

  /// Serialize the date time filter.
  void _serializeDateTimeFilter(XmlBuilder builder, _DateTimeFilter filter) {
    final DateTimeFilterType dateGroup = filter._groupingType;
    final DateTime date = filter._dateTimeValue;
    builder.element('dateGroupItem', nest: () {
      if (_getDateTimevalue(dateGroup) >=
          _getDateTimevalue(DateTimeFilterType.year))
        builder.attribute('year', date.year.toString());
      if (_getDateTimevalue(dateGroup) >=
          _getDateTimevalue(DateTimeFilterType.month))
        builder.attribute('month', date.month.toString());
      if (_getDateTimevalue(dateGroup) >=
          _getDateTimevalue(DateTimeFilterType.day))
        builder.attribute('day', date.day.toString());
      if (_getDateTimevalue(dateGroup) >=
          _getDateTimevalue(DateTimeFilterType.hour))
        builder.attribute('hour', date.hour.toString());
      if (_getDateTimevalue(dateGroup) >=
          _getDateTimevalue(DateTimeFilterType.minute))
        builder.attribute('minute', date.minute.toString());
      if (_getDateTimevalue(dateGroup) >=
          _getDateTimevalue(DateTimeFilterType.second))
        builder.attribute('second', date.second.toString());
      final String dateTimeStr = _getDateTimeString(dateGroup);
      builder.attribute('dateTimeGrouping', dateTimeStr);
    });
  }

  Future<void> _serializeDateTimeFilterAsync(
      XmlBuilder builder, _DateTimeFilter filter) async {
    final DateTimeFilterType dateGroup = filter._groupingType;
    final DateTime date = filter._dateTimeValue;
    builder.element('dateGroupItem', nest: () {
      if (_getDateTimevalue(dateGroup) >=
          _getDateTimevalue(DateTimeFilterType.year))
        builder.attribute('year', date.year.toString());
      if (_getDateTimevalue(dateGroup) >=
          _getDateTimevalue(DateTimeFilterType.month))
        builder.attribute('month', date.month.toString());
      if (_getDateTimevalue(dateGroup) >=
          _getDateTimevalue(DateTimeFilterType.day))
        builder.attribute('day', date.day.toString());
      if (_getDateTimevalue(dateGroup) >=
          _getDateTimevalue(DateTimeFilterType.hour))
        builder.attribute('hour', date.hour.toString());
      if (_getDateTimevalue(dateGroup) >=
          _getDateTimevalue(DateTimeFilterType.minute))
        builder.attribute('minute', date.minute.toString());
      if (_getDateTimevalue(dateGroup) >=
          _getDateTimevalue(DateTimeFilterType.second))
        builder.attribute('second', date.second.toString());
      final String dateTimeStr = _getDateTimeString(dateGroup);
      builder.attribute('dateTimeGrouping', dateTimeStr);
    });
  }

  /// Get the int value based on date time grouping type.
  int _getDateTimevalue(DateTimeFilterType date) {
    switch (date) {
      case DateTimeFilterType.year:
        return 0;
      case DateTimeFilterType.month:
        return 1;
      case DateTimeFilterType.day:
        return 2;
      case DateTimeFilterType.hour:
        return 3;
      case DateTimeFilterType.minute:
        return 4;
      case DateTimeFilterType.second:
        return 5;
    }
  }

  /// Get the string value based on date time grouping type.
  String _getDateTimeString(DateTimeFilterType date) {
    switch (date) {
      case DateTimeFilterType.year:
        return 'year';
      case DateTimeFilterType.month:
        return 'month';
      case DateTimeFilterType.day:
        return 'day';
      case DateTimeFilterType.hour:
        return 'hour';
      case DateTimeFilterType.minute:
        return 'minute';
      case DateTimeFilterType.second:
        return 'second';
    }
  }

  ///Serialization of filter
  void _serializeFilter(XmlBuilder builder, String strFilterValue) {
    builder.element('filter', nest: () {
      builder.attribute('val', strFilterValue);
    });
  }

  Future<void> _serializeFilterAsync(
      XmlBuilder builder, String strFilterValue) async {
    builder.element('filter', nest: () async {
      builder.attribute('val', strFilterValue);
    });
  }

  /// Serializes custom filters.
  void _serializeCustomFilter(XmlBuilder builder, _AutoFilterImpl autoFilter) {
    builder.element('customFilters', nest: () {
      final bool isAnd = autoFilter.logicalOperator == ExcelLogicalOperator.and;
      _serializeAttributes(builder, 'and', isAnd, false);
      if (autoFilter.isFirstCondition) {
        __serializeCustomFilters(
            builder, autoFilter.firstCondition, autoFilter);
      }
      if (autoFilter.isSecondCondition) {
        __serializeCustomFilters(
            builder, autoFilter.firstCondition, autoFilter);
        __serializeCustomFilters(
            builder, autoFilter.secondCondition, autoFilter);
      }
    });
  }

  Future<void> _serializeCustomFilterAsync(
      XmlBuilder builder, _AutoFilterImpl autoFilter) async {
    builder.element('customFilters', nest: () async {
      final bool isAnd = autoFilter.logicalOperator == ExcelLogicalOperator.and;
      _serializeAttributesAsync(builder, 'and', isAnd, false);
      if (autoFilter.isFirstCondition) {
        __serializeCustomFiltersAsync(
            builder, autoFilter.firstCondition, autoFilter);
      }
      if (autoFilter.isSecondCondition) {
        __serializeCustomFiltersAsync(
            builder, autoFilter.firstCondition, autoFilter);
        __serializeCustomFiltersAsync(
            builder, autoFilter.secondCondition, autoFilter);
      }
    });
  }

  /// Serializes custom filters.
  void __serializeCustomFilters(XmlBuilder builder,
      AutoFilterCondition autoFilterCondition, _AutoFilterImpl autoFilter) {
    _customFilterCondition(builder, autoFilterCondition, autoFilter, 0);
  }

  Future<void> __serializeCustomFiltersAsync(
      XmlBuilder builder,
      AutoFilterCondition autoFilterCondition,
      _AutoFilterImpl autoFilter) async {
    _customFilterConditionAsync(builder, autoFilterCondition, autoFilter, 0);
  }

  /// Returns auto filter condition operator name.
  String _getAFconditionalOperatorName(ExcelFilterCondition filterCondition) {
    String empty = '';
    switch (filterCondition) {
      case ExcelFilterCondition.less:
        empty = 'lessThan';
        break;
      case ExcelFilterCondition.endsWith:
      case ExcelFilterCondition.beginsWith:
      case ExcelFilterCondition.contains:
      case ExcelFilterCondition.equal:
        empty = 'equal';
        break;
      case ExcelFilterCondition.lessOrEqual:
        empty = 'lessThanOrEqual';
        break;
      case ExcelFilterCondition.greater:
        empty = 'greaterThan';
        break;
      case ExcelFilterCondition.doesNotContain:
      case ExcelFilterCondition.doesNotBeginWith:
      case ExcelFilterCondition.doesNotEndWith:
      case ExcelFilterCondition.notEqual:
        empty = 'notEqual';
        break;
      case ExcelFilterCondition.greaterOrEqual:
        empty = 'greaterThanOrEqual';
        break;
    }
    return empty;
  }

  ///Serialize custom filter
  void _customFilterCondition(
      XmlBuilder builder,
      AutoFilterCondition autoFilterCondition,
      _AutoFilterImpl autoFilter,
      int dataindex) {
    ExcelFilterCondition conditionOperator =
        autoFilterCondition.conditionOperator;
    builder.element('customFilter', nest: () {
      if (autoFilterCondition._dataType ==
          _ExcelFilterDataType.matchAllNonBlanks) {
        builder.attribute('operator', 'notEqual');
        builder.attribute('val', 0);
      } else {
        conditionOperator = autoFilterCondition.conditionOperator;
        final String operatorValue =
            _getAFconditionalOperatorName(conditionOperator);

        if (operatorValue != 'equal') {
          builder.attribute('operator', operatorValue);
        }
        Object strval = _conditionValue(autoFilterCondition);
        if (conditionOperator == ExcelFilterCondition.contains ||
            conditionOperator == ExcelFilterCondition.doesNotContain ||
            conditionOperator == ExcelFilterCondition.beginsWith ||
            conditionOperator == ExcelFilterCondition.doesNotBeginWith) {
          strval = '$strval*';
        }

        if (conditionOperator == ExcelFilterCondition.contains ||
            conditionOperator == ExcelFilterCondition.doesNotContain ||
            conditionOperator == ExcelFilterCondition.endsWith ||
            conditionOperator == ExcelFilterCondition.doesNotEndWith) {
          strval = '*$strval';
        }

        builder.attribute('val', strval);
      }
    });
  }

  Future<void> _customFilterConditionAsync(
      XmlBuilder builder,
      AutoFilterCondition autoFilterCondition,
      _AutoFilterImpl autoFilter,
      int dataindex) async {
    ExcelFilterCondition conditionOperator =
        autoFilterCondition.conditionOperator;
    builder.element('customFilter', nest: () {
      if (autoFilterCondition._dataType ==
          _ExcelFilterDataType.matchAllNonBlanks) {
        builder.attribute('operator', 'notEqual');
        builder.attribute('val', 0);
      } else {
        conditionOperator = autoFilterCondition.conditionOperator;
        final String operatorValue =
            _getAFconditionalOperatorName(conditionOperator);

        if (operatorValue != 'equal') {
          builder.attribute('operator', operatorValue);
        }
        Object strval = _conditionValue(autoFilterCondition);
        if (conditionOperator == ExcelFilterCondition.contains ||
            conditionOperator == ExcelFilterCondition.doesNotContain ||
            conditionOperator == ExcelFilterCondition.beginsWith ||
            conditionOperator == ExcelFilterCondition.doesNotBeginWith) {
          strval = '$strval*';
        }

        if (conditionOperator == ExcelFilterCondition.contains ||
            conditionOperator == ExcelFilterCondition.doesNotContain ||
            conditionOperator == ExcelFilterCondition.endsWith ||
            conditionOperator == ExcelFilterCondition.doesNotEndWith) {
          strval = '*$strval';
        }

        builder.attribute('val', strval);
      }
    });
  }

  /// Returns auto filter condition value.
  Object _conditionValue(AutoFilterCondition autoFilterCondition) {
    Object empty = '';
    switch (autoFilterCondition._dataType) {
      case _ExcelFilterDataType.notUsed:
        break;
      case _ExcelFilterDataType.floatingPoint:
        empty = autoFilterCondition.numberValue;
        break;
      case _ExcelFilterDataType.string:
        empty = autoFilterCondition.textValue;
        break;
      case _ExcelFilterDataType.boolean:
        break;
      case _ExcelFilterDataType.errorCode:
        break;
      case _ExcelFilterDataType.matchAllBlanks:
        break;
      case _ExcelFilterDataType.matchAllNonBlanks:
        break;
    }
    return empty;
  }

  ///Serialize tabcolor
  void _serializeTabColor(Worksheet sheet, XmlBuilder builder) {
    String worksheetTabColor = '';

    if (sheet.tabColor.length == 7) {
      worksheetTabColor = 'FF${sheet.tabColor.replaceAll('#', '')}';
    } else {
      worksheetTabColor = sheet.tabColor;
    }
    builder.element('tabColor', nest: () {
      builder.attribute('rgb', worksheetTabColor);
    });
  }

  Future<void> _serializeTabColorAsync(
      Worksheet sheet, XmlBuilder builder) async {
    String worksheetTabColor = '';

    if (sheet.tabColor.length == 7) {
      worksheetTabColor = 'FF${sheet.tabColor.replaceAll('#', '')}';
    } else {
      worksheetTabColor = sheet.tabColor;
    }
    builder.element('tabColor', nest: () async {
      builder.attribute('rgb', worksheetTabColor);
    });
  }
}
