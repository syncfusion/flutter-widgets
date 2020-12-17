part of xlsio;

/// Represent the workbook serialize.
class SerializeWorkbook {
  /// Create an instances of serialize workbook.
  SerializeWorkbook(Workbook workbook) {
    _workbook = workbook;
  }

  /// Workbook to serialize.
  Workbook _workbook;

  /// Relation id
  final List<String> _relationId = [];

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

  /// Serialize workbook.
  void _saveWorkbook() {
    final builder = XmlBuilder();

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
          builder.attribute('activeTab', '0');
        });
      });
      builder.element('sheets', nest: () {
        for (int i = 0; i < _workbook.worksheets.count; i++) {
          builder.element('sheet', nest: () {
            builder.attribute('name', _workbook.worksheets[i].name);
            builder.attribute('sheetId', (i + 1).toString());
            builder.attribute('r:id', 'rId' + (i + 1).toString());
          });
        }
      });
    });
    final stringXml = builder.buildDocument().copy().toString();
    final bytes = utf8.encode(stringXml);
    _addToArchive(bytes, 'xl/workbook.xml');
  }

  /// Serializes workbook protection options.
  void _serializeWorkbookProtection(final builder) {
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

  /// serialize Attributes
  void _serializeAttributes(
      final builder, String attributeName, bool value, bool defaultValue) {
    String strValue;
    if (value != defaultValue) {
      strValue = value ? '1' : '0';
    }
    if (strValue != null) builder.attribute(attributeName, strValue);
  }

  /// Serialize worksheets.
  void _saveWorksheets() {
    final length = _workbook.worksheets.count;
    for (int i = 0; i < length; i++) {
      final worksheet = _workbook.worksheets[i];
      _updateHyperlinkCells(worksheet);
      _saveWorksheet(worksheet, i);
    }
  }

  /// Update the Hyperlink cells
  void _updateHyperlinkCells(Worksheet worksheet) {
    for (final Hyperlink hyperlink in worksheet.hyperlinks.innerList) {
      final Row row = worksheet.rows._getRow(hyperlink._row);
      if (row != null) {
        final Range cell = row.ranges._getCell(hyperlink._column);
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
    final builder = XmlBuilder();

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

      if (!sheet._isSummaryRowBelow) {
        builder.element('sheetPr', nest: () {
          builder.element('OutlinePr', nest: () {
            builder.attribute('summaryBelow', '0');
          });
        });
      } else {
        builder.element('sheetPr', nest: () {});
      }
      _saveSheetView(sheet, builder);
      if (sheet.columns != null && sheet.columns.count != 0) {
        builder.element('cols', nest: () {
          for (final Column column in sheet.columns.innerList) {
            builder.element('col', nest: () {
              builder.attribute('min', column.index.toString());
              builder.attribute('max', column.index.toString());
              if (column.width != null && column.width != 0) {
                builder.attribute('width', column.width.toString());
              } else {
                builder.attribute('width', '8.43');
              }
              builder.attribute('customWidth', '1');
            });
          }
        });
      }
      builder.element('sheetData', nest: () {
        if (sheet.rows != null) {
          for (final row in sheet.rows.innerList) {
            if (row != null) {
              builder.element('row', nest: () {
                builder.attribute('r', row.index.toString());
                if (row.height != null && row.height != 0) {
                  builder.attribute('ht', row.height.toString());
                  builder.attribute('customHeight', '1');
                }
                if (row.ranges != null) {
                  for (final cell in row.ranges.innerList) {
                    if (cell != null) {
                      if (cell.rowSpan > 0) cell.rowSpan -= 1;
                      if (cell.columnSpan > 0) cell.columnSpan -= 1;
                      sheet.mergeCells =
                          _processMergeCells(cell, row.index, sheet.mergeCells);
                      if (cell.cellStyle != null || !cell.isDefaultFormat) {
                        cell._styleIndex = cell.cellStyle.index =
                            _processCellStyle(cell.cellStyle, _workbook);
                      } else {
                        cell._styleIndex = -1;
                      }
                      builder.element('c', nest: () {
                        String strFormula = cell.formula;
                        builder.attribute('r', cell.addressLocal);
                        if (cell._saveType != null &&
                            (strFormula == null ||
                                strFormula == '' ||
                                strFormula[0] != '=' ||
                                cell._saveType == 's')) {
                          builder.attribute('t', cell._saveType);
                        }
                        if (cell._styleIndex != -1) {
                          builder.attribute('s', cell._styleIndex.toString());
                        }
                        String cellValue;
                        if (sheet.calcEngine != null &&
                            cell.number == null &&
                            cell.text == null &&
                            cell._boolean == null &&
                            cell._errorValue == null) {
                          cellValue = cell.calculatedValue;
                        } else if (cell._errorValue != null) {
                          cellValue = cell._errorValue;
                        } else if (cell._boolean != null) {
                          cellValue = cell._boolean;
                        } else if (cell.number != null) {
                          cellValue = cell.number.toString();
                        } else if (cell.text != null) {
                          if (cell._saveType == 's') {
                            cellValue = cell._textIndex.toString();
                          } else {
                            cellValue = cell.text;
                          }
                        }
                        if (strFormula != null &&
                            strFormula != '' &&
                            strFormula[0] == '=' &&
                            cell._saveType != 's') {
                          builder.attribute('t', cell._saveType);
                          strFormula =
                              strFormula.substring(1).replaceAll('\'', '\"');
                          builder.element('f', nest: strFormula);
                        }
                        builder.element('v', nest: cellValue);
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
        final ExcelSheetProtectionOption protection = sheet._innerProtection;
        builder.element('sheetProtection', nest: () {
          if (sheet._algorithmName != null) {
            builder.attribute('algorithmName', sheet._algorithmName);
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
                builder, attributes[i], flags[i], defaultValues[i], protection);
          }
        });
      }
      if (sheet.mergeCells != null && sheet.mergeCells.innerList.isNotEmpty) {
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
      _serializeHyperlinks(builder, sheet);
      builder.element('pageMargins', nest: () {
        builder.attribute('left', '0.75');
        builder.attribute('right', '0.75');
        builder.attribute('top', '1');
        builder.attribute('bottom', '1');
        builder.attribute('header', '0.5');
        builder.attribute('footer', '0.5');
      });
      builder.element('headerFooter', nest: () {
        builder.attribute('scaleWithDoc', '1');
        builder.attribute('alignWithMargins', '0');
        builder.attribute('differentFirst', '0');
        builder.attribute('differentOddEven', '0');
      });
      if ((sheet.pictures != null && sheet.pictures.count > 0) ||
          (sheet.charts != null && sheet.chartCount > 0)) {
        _workbook._drawingCount++;
        _saveDrawings(sheet);
        if (sheet.charts != null && sheet.chartCount > 0) {
          sheet.charts.serializeCharts(sheet);
        }
        builder.element('drawing', nest: () {
          int id = 1;
          final String rId = 'rId1';
          if (_relationId != null) {
            if (sheet.hyperlinks.count > 0) {
              for (int i = 0; i < sheet.hyperlinks.count; i++) {
                if (sheet.hyperlinks[i]._attachedType ==
                        ExcelHyperlinkAttachedType.range &&
                    sheet.hyperlinks[i].type != HyperlinkType.workbook) {
                  id++;
                }
              }
            }
            builder.attribute('r:id', 'rId' + id.toString());
          } else {
            builder.attribute('r:id', rId);
          }
        });
      }
      final rel = _saveSheetRelations(sheet);
      _addToArchive(rel,
          'xl/worksheets/_rels/sheet' + sheet.index.toString() + '.xml.rels');
    });
    final stringXml = builder.buildDocument().copy().toString();
    final bytes = utf8.encode(stringXml);
    _addToArchive(
        bytes, 'xl/worksheets' '/sheet' + (index + 1).toString() + '.xml');
  }

  /// Serializes single protection option.
  void _serializeProtectionAttribute(final builder, String attributeName,
      bool flag, bool defaultValue, ExcelSheetProtectionOption protection) {
    final bool value = flag;
    _serializeAttributes(builder, attributeName, value, defaultValue);
  }

  /// Serialize hyperlinks
  void _serializeHyperlinks(final builder, Worksheet sheet) {
    if (sheet.hyperlinks != null && sheet.hyperlinks.count > 0) {
      final int iCount = sheet.hyperlinks.count;
      final List<String> hyperLinkType = List(iCount);
      for (int i = 0; i < sheet.hyperlinks.count; i++) {
        final Hyperlink hyperLink = sheet.hyperlinks[i];
        hyperLinkType[i] = hyperLink._attachedType
            .toString()
            .split('.')
            .toList()
            .removeAt(1)
            .toString();
      }
      if (iCount == 0 || !hyperLinkType.contains('range')) {
        return;
      }
      builder.element('hyperlinks', nest: () {
        for (final Hyperlink link in sheet.hyperlinks.innerList) {
          if (link._attachedType == ExcelHyperlinkAttachedType.range) {
            builder.element('hyperlink', nest: () {
              if (link.type == HyperlinkType.workbook) {
                builder.attribute('ref', link.reference);
                builder.attribute('location', link.address);
              } else {
                builder.attribute('ref', link.reference);
                final String id = link._rId.toString();
                final String rId = 'rId' + id.toString();
                builder.attribute('r:id', rId);
                _relationId.add(rId);
              }
              if (link.screenTip != null) {
                builder.attribute('tooltip', link.screenTip);
              }
              if (link.textToDisplay != null) {
                builder.attribute('display', link.textToDisplay);
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
    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0"');
    builder.element('xdr:wsDr', nest: () {
      builder.attribute('xmlns:xdr',
          'http://schemas.openxmlformats.org/drawingml/2006/spreadsheetDrawing');
      builder.attribute(
          'xmlns:a', 'http://schemas.openxmlformats.org/drawingml/2006/main');
      final chartCount = sheet.chartCount;
      if (chartCount != 0 && sheet.charts != null) {
        sheet.charts.serializeChartDrawing(builder, sheet);
      }
      final idIndex = 0 + chartCount;
      final List<String> idRelation = [];
      if (sheet.pictures.count != 0) {
        int imgId = 0;
        int idHyperlink = 1;
        int hyperlinkCount = 0;
        for (final Picture picture in sheet.pictures.innerList) {
          if (picture.height != 0 && picture.width != 0) {
            if (picture.lastRow == null ||
                picture.lastRow == 0 ||
                picture.lastRow < picture.row) {
              _updateLastRowOffset(sheet, picture);
            } else if (picture.lastRow != null && picture.lastRow != 0) {
              picture.lastRowOffset = 0;
            }
            if (picture.lastColumn == null ||
                picture.lastColumn == 0 ||
                picture.lastColumn < picture.column) {
              _updateLastColumnOffSet(sheet, picture);
            } else if (picture.lastColumn != null && picture.lastColumn != 0) {
              picture.lastColOffset = 0;
            }
          }
          imgId++;
          builder.element('xdr:twoCellAnchor', nest: () {
            builder.attribute('editAs', 'twoCell');
            builder.element('xdr:from', nest: () {
              builder.element('xdr:col', nest: (picture.column - 1));
              builder.element('xdr:colOff', nest: 0);
              builder.element('xdr:row', nest: (picture.row - 1));
              builder.element('xdr:rowOff', nest: 0);
            });

            builder.element('xdr:to', nest: () {
              builder.element('xdr:col', nest: (picture.lastColumn - 1));
              builder.element('xdr:colOff',
                  nest: picture.lastColOffset.round());
              builder.element('xdr:row', nest: (picture.lastRow - 1));
              builder.element('xdr:rowOff',
                  nest: picture.lastRowOffset.round());
            });

            builder.element('xdr:pic', nest: () {
              builder.attribute('macro', '');
              builder.element('xdr:nvPicPr', nest: () {
                builder.element('xdr:cNvPr', nest: () {
                  builder.attribute('id', imgId);
                  builder.attribute('name', 'Picture' + imgId.toString());
                  if (picture._isHyperlink) {
                    builder.element('a:hlinkClick', nest: () {
                      builder.attribute('xmlns:r',
                          'http://schemas.openxmlformats.org/officeDocument/2006/relationships');
                      int id = idIndex + imgId + idHyperlink;
                      String rId = 'rId' + id.toString();
                      if (idRelation.contains(rId)) {
                        id = id + 1;
                        rId = 'rId' + id.toString();
                      }
                      builder.attribute('r:id', rId);
                      idRelation.add(rId);
                      sheet._hyperlinkRelationId.add(rId);
                      idHyperlink++;
                      if (picture._link.screenTip != null) {
                        builder.attribute('tooltip', picture._link.screenTip);
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
                  if (idRelation == null) {
                    id = idIndex + imgId + hyperlinkCount;
                    rId = 'rId' + id.toString();
                    builder.attribute('r:embed', rId);
                    idRelation.add(rId);
                  } else {
                    id = idIndex + imgId + hyperlinkCount;
                    rId = 'rId' + id.toString();
                    if (idRelation.contains(rId)) {
                      id = id + 1;
                      rId = 'rId' + id.toString();
                      if (idRelation.contains(rId)) {
                        id = id + 1;
                        rId = 'rId' + id.toString();
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
                    builder.attribute('rot', (picture.rotation * 60000));
                  }
                  if (picture.verticalFlip) {
                    builder.attribute('flipV', '1');
                  }
                  if (picture.horizontalFlip) {
                    builder.attribute('flipH', '1');
                  }
                });

                builder.element('a:prstGeom', nest: () {
                  builder.attribute('prst', 'rect');
                  builder.element('a:avLst', nest: () {});
                });
              });
            });
            builder.element('xdr:clientData', nest: () {});
          });
          final imageData = picture.imageData;
          _workbook._imageCount += 1;
          String imgPath;
          if (Picture.isJpeg(imageData)) {
            imgPath =
                'xl/media/image' + _workbook._imageCount.toString() + '.jpeg';
            if (!_workbook._defaultContentTypes.containsKey('jpeg')) {
              _workbook._defaultContentTypes['jpeg'] = 'image/jpeg';
            }
          } else {
            imgPath =
                'xl/media/image' + _workbook._imageCount.toString() + '.png';
            if (!_workbook._defaultContentTypes.containsKey('png')) {
              _workbook._defaultContentTypes['png'] = 'image/png';
            }
          }
          _addToArchive(imageData, imgPath);
        }
      }
    });
    _saveDrawingRelations(sheet);
    final stringXml = builder.buildDocument().copy().toString();
    final bytes = utf8.encode(stringXml);
    _addToArchive(bytes,
        'xl/drawings/drawing' + (_workbook._drawingCount).toString() + '.xml');
  }

  /// Serialize drawing relations.
  void _saveDrawingRelations(Worksheet sheet) {
    int idIndex = 0;
    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0"');
    builder.element('Relationships', nest: () {
      builder.namespace(
          'http://schemas.openxmlformats.org/package/2006/relationships');
      if (sheet.chartCount != 0) {
        final length = sheet.chartCount;
        for (int i = 1; i <= length; i++) {
          builder.element('Relationship', nest: () {
            builder.attribute('Id', 'rId' + ((idIndex + i)).toString());
            builder.attribute('Type',
                'http://schemas.openxmlformats.org/officeDocument/2006/relationships/chart');
            builder.attribute(
                'Target',
                '/xl/charts/chart' +
                    (sheet.workbook.chartCount + i).toString() +
                    '.xml');
          });
        }
        idIndex = length;
      }
      if (sheet.hyperlinks != null && sheet.hyperlinks.count > 0) {
        final length = sheet.hyperlinks.count;
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
                address = address.startsWith('#') ? address : '#' + address;
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
        final length = sheet.pictures.count;
        int id = _workbook._imageCount - sheet.pictures.count;
        int idHyperlink = 0;
        for (int i = 1; i <= length; i++) {
          id++;
          builder.element('Relationship', nest: () {
            String imgPath;
            if (Picture.isPng(sheet.pictures[i - 1].imageData)) {
              imgPath = '/xl/media/image' + id.toString() + '.png';
            } else {
              imgPath = '/xl/media/image' + id.toString() + '.jpeg';
            }
            if (sheet.pictures[i - 1]._isHyperlink) {
              builder.attribute(
                  'Id', 'rId' + (idIndex + i + idHyperlink).toString());
              builder.attribute('Type',
                  'http://schemas.openxmlformats.org/officeDocument/2006/relationships/image');
              builder.attribute('Target', imgPath);
              idHyperlink++;
            } else {
              builder.attribute(
                  'Id', 'rId' + (idIndex + i + idHyperlink).toString());
              builder.attribute('Type',
                  'http://schemas.openxmlformats.org/officeDocument/2006/relationships/image');
              builder.attribute('Target', imgPath);
            }
          });
        }
      }
    });

    final stringXml = builder.buildDocument().copy().toString();
    final bytes = utf8.encode(stringXml);
    _addToArchive(
        bytes,
        'xl/drawings/_rels/drawing' +
            (_workbook._drawingCount).toString() +
            '.xml.rels');
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
        iRowHeight = _convertToPixels((sheet.rows[iCurRow].height == null ||
                sheet.rows[iCurRow].height == 0)
            ? 15
            : sheet.rows[iCurRow].height);
      } else {
        iRowHeight = _convertToPixels(15);
      }
      final iSpaceInCell = iRowHeight - ((iCurOffset * iRowHeight) / 256);

      if (iSpaceInCell > iCurHeight) {
        picture.lastRow = iCurRow;
        picture.lastRowOffset = (iCurOffset + (iCurHeight * 256 / iRowHeight));
        double rowHiddenHeight;
        if (sheet.rows.count != 0 &&
            iCurRow < sheet.rows.count &&
            sheet.rows[iCurRow] != null) {
          rowHiddenHeight = _convertToPixels(
              (sheet.rows[iCurRow].height == null ||
                      sheet.rows[iCurRow].height == 0)
                  ? 15
                  : sheet.rows[iCurRow].height);
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
      if (sheet.columns != null &&
          sheet.columns.count != 0 &&
          iCurCol - 1 < sheet.columns.count &&
          sheet.columns[iCurCol - 1] != null) {
        iColWidth = _columnWidthToPixels(sheet.columns[iCurCol - 1].width == 0
            ? 8.43
            : sheet.columns[iCurCol - 1].width);
      } else {
        iColWidth = _columnWidthToPixels(8.43);
      }
      final iSpaceInCell = iColWidth - (iCurOffset * iColWidth / 1024);

      if (iSpaceInCell > iCurWidth) {
        picture.lastColumn = iCurCol;
        picture.lastColOffset = iCurOffset + (iCurWidth * 1024 / iColWidth);
        double colHiddenWidth;
        if (sheet.columns != null &&
            sheet.columns.count != 0 &&
            iCurCol - 1 < sheet.columns.count &&
            sheet.columns[iCurCol - 1] != null) {
          colHiddenWidth = _columnWidthToPixels(
              sheet.columns[iCurCol - 1].width == 0
                  ? 8.43
                  : sheet.columns[iCurCol - 1].width);
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
    final dDigitWidth = 7;
    final fileWidth = (val > 1)
        ? ((val * dDigitWidth + 5) / dDigitWidth * 256.0) / 256.0
        : (val * (dDigitWidth + 5) / dDigitWidth * 256.0) / 256.0;
    return _trunc(
        ((256 * fileWidth + _trunc(128 / dDigitWidth)) / 256) * dDigitWidth);
  }

  /// Trucates the given value.
  static double _trunc(double x) {
    final n = x - x % 1;
    return n == 0 && (x < 0 || (x == 0)) ? -0 : n;
  }

  /// Serialize sheet relations.
  List<int> _saveSheetRelations(Worksheet sheet) {
    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0"');
    builder.element('Relationships', nest: () {
      builder.namespace(
          'http://schemas.openxmlformats.org/package/2006/relationships');

      if (sheet.hyperlinks != null && sheet.hyperlinks.count > 0) {
        for (final Hyperlink link in sheet.hyperlinks.innerList) {
          if (link._attachedType == ExcelHyperlinkAttachedType.range &&
              link.type != HyperlinkType.workbook) {
            builder.element('Relationship', nest: () {
              builder.attribute('Id', 'rId' + link._rId.toString());
              builder.attribute('Type',
                  'http://schemas.openxmlformats.org/officeDocument/2006/relationships/hyperlink');
              builder.attribute('Target', link.address);
              builder.attribute('TargetMode', 'External');
            });
          }
        }
      }
      if (sheet.pictures != null && sheet.pictures.count > 0) {
        builder.element('Relationship', nest: () {
          int id = 1;
          final String rId = 'rId1';
          if (_relationId != null) {
            if (sheet.hyperlinks.count > 0) {
              for (int i = 0; i < sheet.hyperlinks.count; i++) {
                if (sheet.hyperlinks[i]._attachedType ==
                        ExcelHyperlinkAttachedType.range &&
                    sheet.hyperlinks[i].type != HyperlinkType.workbook) {
                  id++;
                }
              }
            }
            builder.attribute('Id', 'rId' + id.toString());
          } else {
            builder.attribute('Id', rId);
          }
          builder.attribute('Type',
              'http://schemas.openxmlformats.org/officeDocument/2006/relationships/drawing');
          builder.attribute(
              'Target',
              '../drawings/drawing' +
                  _workbook._drawingCount.toString() +
                  '.xml');
        });
      } else if (sheet.charts != null && sheet.chartCount > 0) {
        builder.element('Relationship', nest: () {
          int id = 1;
          final String rId = 'rId1';
          if (_relationId != null) {
            if (sheet.hyperlinks.count > 0) {
              for (int i = 0; i < sheet.hyperlinks.count; i++) {
                if (sheet.hyperlinks[i]._attachedType ==
                        ExcelHyperlinkAttachedType.range &&
                    sheet.hyperlinks[i].type != HyperlinkType.workbook) {
                  id++;
                }
              }
            }
            builder.attribute('Id', 'rId' + id.toString());
          } else {
            builder.attribute('Id', rId);
          }
          builder.attribute('Type',
              'http://schemas.openxmlformats.org/officeDocument/2006/relationships/drawing');
          builder.attribute(
              'Target',
              '../drawings/drawing' +
                  _workbook._drawingCount.toString() +
                  '.xml');
        });
      }
    });
    final stringXml = builder.buildDocument().copy().toString();
    return utf8.encode(stringXml);
  }

  /// Serialize sheet view.
  static void _saveSheetView(Worksheet sheet, XmlBuilder builder) {
    builder.element('sheetViews', nest: () {
      builder.element('sheetView', nest: () {
        builder.attribute('workbookViewId', '0');
        if (!sheet.showGridlines) {
          builder.attribute('showGridLines', '0');
        }
      });
    });
  }

  /// Serialize workbook shared string.
  void _saveSharedString() {
    final builder = XmlBuilder();
    final length = _workbook._sharedStrings.length;
    if (_workbook._sharedStrings != null && length > 0) {
      builder.processing('xml', 'version="1.0"');
      builder.element('sst', nest: () {
        builder.attribute('xmlns',
            'http://schemas.openxmlformats.org/spreadsheetml/2006/main');
        builder.attribute('uniqueCount', length.toString());
        builder.attribute('count', _workbook._sharedStringCount.toString());
        _workbook._sharedStrings.forEach((key, value) {
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
      final stringXml = builder.buildDocument().copy().toString();
      final bytes = utf8.encode(stringXml);
      _addToArchive(bytes, 'xl/sharedStrings.xml');
    }
  }

  /// Serialize app properties
  void _saveApp(BuiltInProperties builtInProperties) {
    final builder = XmlBuilder();

    builder.processing('xml', 'version="1.0"');
    builder.element('Properties', nest: () {
      builder.attribute('xmlns',
          'http://schemas.openxmlformats.org/officeDocument/2006/extended-properties');
      builder.element('Application', nest: 'Essential XlsIO');

      if (builtInProperties != null) {
        if (builtInProperties.manager != null) {
          builder.element('Manager', nest: builtInProperties.manager);
        }

        if (builtInProperties.company != null) {
          builder.element('Company', nest: builtInProperties.company);
        }
      }
    });
    final stringXml = builder.buildDocument().copy().toString();
    final bytes = utf8.encode(stringXml);
    _addToArchive(bytes, 'docProps/app.xml');
  }

  /// Serialize core properties
  void _saveCore(BuiltInProperties builtInProperties) {
    final builder = XmlBuilder();

    builder.processing('xml', 'version="1.0"');
    builder.element('cp:coreProperties', nest: () {
      builder.attribute('xmlns:cp',
          'http://schemas.openxmlformats.org/package/2006/metadata/core-properties');
      builder.attribute('xmlns:dc', 'http://purl.org/dc/elements/1.1/');
      builder.attribute('xmlns:dcterms', 'http://purl.org/dc/terms/');
      builder.attribute('xmlns:dcmitype', 'http://purl.org/dc/dcmitype/');
      builder.attribute(
          'xmlns:xsi', 'http://www.w3.org/2001/XMLSchema-instance');
      final createdDate = DateTime.now();
      if (builtInProperties != null) {
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
            builder.text(builtInProperties.createdDate.toIso8601String());
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
            builder.text(builtInProperties.modifiedDate.toIso8601String());
          });
        } else {
          builder.element('dcterms:modified', nest: () {
            builder.attribute('xsi:type', 'dcterms:W3CDTF');
            builder.text(createdDate.toIso8601String());
          });
        }
      } else {
        builder.element('dcterms:created', nest: () {
          builder.attribute('xsi:type', 'dcterms:W3CDTF');
          builder.text(createdDate.toIso8601String());
        });
        builder.element('dcterms:modified', nest: () {
          builder.attribute('xsi:type', 'dcterms:W3CDTF');
          builder.text(createdDate.toIso8601String());
        });
      }
    });
    final stringXml = builder.buildDocument().copy().toString();
    final bytes = utf8.encode(stringXml);
    _addToArchive(bytes, 'docProps/core.xml');
  }

  /// Serialize content type.
  void _saveContentType() {
    final builder = XmlBuilder();
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
      final length = _workbook.worksheets.count;
      int drawingIndex = 1;
      int chartIndex = 1;
      for (int i = 0; i < length; i++) {
        final index = i + 1;
        builder.element('Override', nest: () {
          builder.attribute(
              'PartName', '/xl/worksheets/sheet' + index.toString() + '.xml');
          builder.attribute('ContentType',
              'application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml');
        });
        if ((_workbook._imageCount > 0 &&
                _workbook.worksheets[i].pictures != null &&
                _workbook.worksheets[i].pictures.count > 0) ||
            _workbook.worksheets[i].charts != null &&
                _workbook.worksheets[i].chartCount > 0) {
          if (_workbook.worksheets[i].charts != null &&
              _workbook.worksheets[i].chartCount > 0) {
            final chartCount = _workbook.worksheets[i].chartCount;
            for (int index = 1; index <= chartCount; index++) {
              builder.element('Override', nest: () {
                builder.attribute('PartName',
                    '/xl/charts/chart' + chartIndex.toString() + '.xml');
                builder.attribute('ContentType',
                    'application/vnd.openxmlformats-officedocument.drawingml.chart+xml');
              });
              chartIndex++;
            }
          }
          builder.element('Override', nest: () {
            builder.attribute('PartName',
                '/xl/drawings/drawing' + drawingIndex.toString() + '.xml');
            builder.attribute('ContentType',
                'application/vnd.openxmlformats-officedocument.drawing+xml');
          });
          drawingIndex++;
        }
      }

      if (_workbook._imageCount > 0) {
        for (final key in _workbook._defaultContentType.keys) {
          builder.element('Default', nest: () {
            builder.attribute('Extension', key);
            builder.attribute(
                'ContentType', _workbook._defaultContentTypes[key]);
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
    final stringXml = builder.buildDocument().copy().toString();
    final bytes = utf8.encode(stringXml);
    _addToArchive(bytes, '[Content_Types].xml');
  }

  /// Serialize workbook releation.
  void _saveWorkbookRelation() {
    final builder = XmlBuilder();

    builder.processing('xml', 'version="1.0"');
    builder.element('Relationships', nest: () {
      builder.attribute('xmlns',
          'http://schemas.openxmlformats.org/package/2006/relationships');

      final length = _workbook.worksheets.count;
      int count = 0;
      int index;
      for (int i = 0; i < length; i++, count++) {
        builder.element('Relationship', nest: () {
          index = (i + 1);
          builder.attribute('Id', 'rId' + index.toString());
          builder.attribute('Type',
              'http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet');
          builder.attribute(
              'Target', 'worksheets/sheet' + index.toString() + '.xml');
        });
      }
      count = ++count;
      builder.element('Relationship', nest: () {
        builder.attribute('Id', 'rId' + count.toString());
        builder.attribute('Type',
            'http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles');
        builder.attribute('Target', 'styles.xml');
      });
      if (_workbook._sharedStringCount > 0) {
        count = ++count;
        builder.element('Relationship', nest: () {
          builder.attribute('Id', 'rId' + count.toString());
          builder.attribute('Type',
              'http://schemas.openxmlformats.org/officeDocument/2006/relationships/sharedStrings');
          builder.attribute('Target', 'sharedStrings.xml');
        });
      }
    });
    final stringXml = builder.buildDocument().copy().toString();
    final bytes = utf8.encode(stringXml);
    _addToArchive(bytes, 'xl/_rels/workbook.xml.rels');
  }

  /// Serialize top level releation.
  void _saveTopLevelRelation() {
    final builder = XmlBuilder();

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
    final stringXml = builder.buildDocument().copy().toString();
    final bytes = utf8.encode(stringXml);
    _addToArchive(bytes, '_rels/.rels');
  }

  /// Serialize content type.
  void _saveStyles() {
    _updateCellStyleXfs();
    final builder = XmlBuilder();
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
    });
    final stringXml = builder.buildDocument().copy().toString();
    final bytes = utf8.encode(stringXml);
    _addToArchive(bytes, 'xl/styles.xml');
  }

  /// Update the global style.
  void _updateGlobalStyles() {
    for (final CellStyle cellStyle in _workbook.styles.innerList) {
      if (cellStyle.isGlobalStyle) {
        if (cellStyle.name == null) {
          _workbook.styles.addStyle(cellStyle);
        }
        final globalStyle = _GlobalStyle();
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
      if (style.name == null) workbook.styles.addStyle(style);
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
    for (final CellStyle style in _workbook.styles.innerList) {
      CellStyleXfs cellXfs;
      if (style.isGlobalStyle) {
        cellXfs = CellXfs();
        if (_workbook._globalStyles.containsKey(style.name)) {
          (cellXfs as CellXfs)._xfId =
              _workbook._globalStyles[style.name]._xfId;
        }
      } else {
        cellXfs = CellXfs();
        (cellXfs as CellXfs)._xfId = 0;
      }
      final compareFontResult = _workbook._isNewFont(style);
      if (!compareFontResult._result) {
        final font = Font();
        font.bold = style.bold;
        font.italic = style.italic;
        font.name = style.fontName;
        font.size = style.fontSize;
        font.underline = style.underline;
        font.color = ('FF' + style.fontColor.replaceAll('#', ''));
        _workbook.fonts.add(font);
        cellXfs._fontId = _workbook.fonts.length - 1;
      } else {
        cellXfs._fontId = compareFontResult._index;
      }
      if (style.backColor != 'none') {
        final backColor = 'FF' + style.backColor.replaceAll('#', '');
        if (_workbook.fills.containsKey(backColor)) {
          final fillId = _workbook.fills[backColor];
          cellXfs._fillId = fillId;
        } else {
          final fillId = _workbook.fills.length + 2;
          _workbook.fills[backColor] = fillId;
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
          final format = _workbook.innerFormats[style.numberFormatIndex];
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
      cellXfs._alignment = Alignment();
      cellXfs._alignment.indent = style.indent;
      cellXfs._alignment.horizontal =
          style.hAlign.toString().split('.').toList().removeAt(1).toString();
      cellXfs._alignment.vertical =
          style.vAlign.toString().split('.').toList().removeAt(1).toString();
      cellXfs._alignment.wrapText = style.wrapText ? 1 : 0;
      cellXfs._alignment.rotation = style.rotation;

      // Add protection
      if (!style.locked) {
        cellXfs._locked = style.locked ? 1 : 0;
      }
      if (style.isGlobalStyle) {
        _workbook._cellStyleXfs.add(cellXfs);
        _workbook._cellXfs.add(cellXfs as CellXfs);
      } else {
        //Add cellxfs
        _workbook._cellXfs.add(cellXfs as CellXfs);
      }
    }
  }

  /// Serialize number formats.
  void _saveNumberFormats(final builder) {
    final arrFormats = _workbook.innerFormats._getUsedFormats();
    if (arrFormats.isNotEmpty) {
      builder.element('numFmts', nest: () {
        builder.attribute('count', arrFormats.length.toString());
        for (var i = 0; i < arrFormats.length; i++) {
          builder.element('numFmt', nest: () {
            builder.attribute('numFmtId', arrFormats[i]._index.toString());
            final String formatString =
                arrFormats[i]._formatString.replaceAll('\'', '\"');
            builder.attribute('formatCode', formatString.toString());
          });
        }
      });
    }
  }

  /// Serialize fonts.
  void _saveFonts(final builder) {
    builder.element('fonts', nest: () {
      builder.attribute('count', _workbook.fonts.length.toString());
      if (_workbook.fonts.isNotEmpty) {
        for (var i = 0; i < _workbook.fonts.length; i++) {
          final font = _workbook.fonts[i];
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

  /// Serialize fills.
  void _saveFills(final builder) {
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
        _workbook.fills.forEach((key, value) {
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

  /// Serialize borders.
  void _saveBorders(final builder) {
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

  /// serializeBorders collection.
  void _serializeBorders(Borders borders, final builder) {
    builder.element('border', nest: () {
      _serializeBorder(borders.left, builder, 'left');
      _serializeBorder(borders.right, builder, 'right');
      _serializeBorder(borders.top, builder, 'top');
      _serializeBorder(borders.bottom, builder, 'bottom');
    });
  }

  /// Serialize borders.
  void _serializeBorder(Border border, final builder, String borderType) {
    builder.element(borderType, nest: () {
      builder.attribute(
          'style',
          border.lineStyle
              .toString()
              .split('.')
              .toList()
              .removeAt(1)
              .toString()
              .toLowerCase());
      builder.element('color', nest: () {
        builder.attribute('rgb', 'FF' + border.color.replaceAll('#', ''));
      });
    });
  }

  /// Serialize cell styles xfs.
  void _saveCellStyleXfs(final builder) {
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
        for (final CellStyleXfs cellStyleXfs in _workbook._cellStyleXfs) {
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

  /// Serialize cell styles xfs.
  void _saveCellXfs(final builder) {
    builder.element('cellXfs', nest: () {
      builder.attribute('count', _workbook._cellXfs.length.toString());
      if (_workbook._cellXfs.isNotEmpty) {
        for (final CellXfs cellXf in _workbook._cellXfs) {
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

  ///Serialize Protection.
  void _saveProtection(CellStyleXfs cellXf, final builder) {
    builder.element('protection', nest: () {
      builder.attribute('locked', cellXf._locked.toString());
    });
  }

  /// Serialize alignment.
  void _saveAlignment(CellStyleXfs cellXf, final builder) {
    builder.element('alignment', nest: () {
      if (cellXf._alignment.horizontal != null) {
        builder.attribute(
            'horizontal', cellXf._alignment.horizontal.toLowerCase());
      }
      if (cellXf._alignment.indent != 0) {
        builder.attribute('indent', cellXf._alignment.indent.toString());
      } else if (cellXf._alignment.rotation != 0) {
        builder.attribute(
            'textRotation', cellXf._alignment.rotation.toString());
      }
      if (cellXf._alignment.vertical != null) {
        builder.attribute('vertical', cellXf._alignment.vertical.toLowerCase());
      }
      builder.attribute('wrapText', cellXf._alignment.wrapText.toString());
    });
  }

  /// Serialize cell styles.
  void _saveGlobalCellstyles(final builder) {
    final length = _workbook._globalStyles.length + 1;
    builder.element('cellStyles', nest: () {
      builder.attribute('count', length.toString());
      builder.element('cellStyle', nest: () {
        builder.attribute('name', 'Normal');
        builder.attribute('xfId', '0');
        builder.attribute('builtinId', '0');
      });
      _workbook._globalStyles.forEach((key, value) {
        builder.element('cellStyle', nest: () {
          if (key != null) {
            builder.attribute('name', key);
            builder.attribute(
                'xfId', _workbook._globalStyles[key]._xfId.toString());
            if (_workbook._globalStyles[key]._builtinId != 0) {
              builder.attribute('builtinId',
                  _workbook._globalStyles[key]._builtinId.toString());
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
      final mCell = MergeCell();
      mCell.x = cell._index;
      mCell.width = cell.columnSpan;
      mCell.y = rowIndex;
      mCell.height = cell.rowSpan;
      final startCell = Range._getCellName(mCell.y, mCell.x);
      final endCell = Range._getCellName(
          rowIndex + mCell.height, cell._index + mCell.width);
      mCell._reference = startCell + ':' + endCell;
      mergeCells.addCell(mCell);
      final start = _ExtendCell();
      start._x = mCell.x;
      start._y = mCell.y;
      final end = _ExtendCell();
      end._x = cell._index + mCell.width;
      end._y = rowIndex + mCell.height;
      _updatedMergedCellStyles(start, end, cell);
    }
    return mergeCells;
  }

  /// Update merged cell styles
  void _updatedMergedCellStyles(
      _ExtendCell sCell, _ExtendCell eCell, Range cell) {
    final workbook = cell.workbook;
    for (int x = sCell._x; x <= eCell._x; x++) {
      for (int y = sCell._y; y <= eCell._y; y++) {
        final extendStyle = _ExtendStyle();
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

  /// Add the workbook data with filename to ZipArchive.
  void _addToArchive(List<int> data, String fileName) {
    final item = ArchiveFile(fileName, data.length, data);
    _workbook.archive.addFile(item);
  }
}
