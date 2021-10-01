part of officechart;

/// Represent the chart serialize class
class ChartSerialization {
  /// Create an instances of [ChartSerialization] class.
  ChartSerialization(Workbook workbook) {
    _workbook = workbook;
  }

  /// Workbook to serialize.
  late Workbook _workbook;

  final Map _linePattern = {
    ExcelChartLinePattern.roundDot: 'sysDot',
    ExcelChartLinePattern.squareDot: 'sysDash',
    ExcelChartLinePattern.dash: 'dash',
    ExcelChartLinePattern.longDash: 'lgDash',
    ExcelChartLinePattern.dashDot: 'dashDot',
    ExcelChartLinePattern.longDashDot: 'lgDashDot',
    ExcelChartLinePattern.longDashDotDot: 'lgDashDotDot'
  };

  /// serializes charts from the worksheet.
  void _saveCharts(Worksheet sheet) {
    for (final Chart chart in (sheet.charts as ChartCollection).innerList) {
      sheet.workbook.chartCount++;
      final builder = XmlBuilder();
      builder.processing('xml', 'version="1.0"');
      builder.element('c:chartSpace', nest: () {
        builder.attribute(
            'xmlns:a', 'http://schemas.openxmlformats.org/drawingml/2006/main');
        builder.attribute('xmlns:r',
            'http://schemas.openxmlformats.org/officeDocument/2006/relationships');
        builder.attribute('xmlns:c',
            'http://schemas.openxmlformats.org/drawingml/2006/chart');

        if (chart._hasPlotArea) {
          builder.element('c:roundedCorners', nest: () {
            builder.attribute('val', 0);
          });
        }
        builder.element('c:chart', nest: () {
          if (chart.hasTitle) _serializeTitle(builder, chart.chartTitleArea);
          _serializePlotArea(builder, chart);
          if (chart.series.count > 0 && chart.hasLegend) {
            _serializeLegend(builder, chart.legend!);
          }
          builder.element('c:plotVisOnly', nest: () {
            builder.attribute('val', '1');
          });
          builder.element('c:dispBlanksAs', nest: () {
            builder.attribute('val', 'gap');
          });
        });
        _serializeFill(
            builder, chart.linePattern, chart.linePatternColor, false);
        _serializePrinterSettings(builder, chart);
      });
      final stringXml = builder.buildDocument().copy().toString();
      final List<int> bytes = utf8.encode(stringXml);
      _addToArchive(bytes,
          'xl/charts/chart' + sheet.workbook.chartCount.toString() + '.xml');
    }
  }

  /// serializes chart's legend.
  void _serializeLegend(XmlBuilder builder, ChartLegend chartLegend) {
    builder.element('c:legend', nest: () {
      builder.element('c:legendPos', nest: () {
        final ExcelLegendPosition legendPostion = chartLegend.position;
        final String positionStr = legendPostion == ExcelLegendPosition.bottom
            ? 'b'
            : legendPostion == ExcelLegendPosition.left
                ? 'l'
                : legendPostion == ExcelLegendPosition.right
                    ? 'r'
                    : legendPostion == ExcelLegendPosition.top
                        ? 't'
                        : 'r';
        builder.attribute('val', positionStr);
      });
      if (chartLegend._hasTextArea) {
        _serializeDefaultTextAreaProperties(builder, chartLegend.textArea);
      }
      builder.element('c:layout', nest: () {});
      builder.element('c:overlay', nest: () {
        builder.attribute('val', 0);
      });
      builder.element('c:spPr', nest: () {});
    });
  }

  /// serializes chart's drawing.
  void _serializeChartDrawing(XmlBuilder builder, Worksheet sheet) {
    for (final Chart chart in (sheet.charts as ChartCollection).innerList) {
      builder.element('xdr:twoCellAnchor', nest: () {
        builder.attribute('editAs', 'twoCell');
        builder.element('xdr:from', nest: () {
          builder.element('xdr:col',
              nest: (chart.leftColumn > 0 ? chart.leftColumn - 1 : 0));
          builder.element('xdr:colOff', nest: 0);
          builder.element('xdr:row',
              nest: (chart.topRow > 0 ? chart.topRow - 1 : 0));
          builder.element('xdr:rowOff', nest: 0);
        });

        builder.element('xdr:to', nest: () {
          builder.element('xdr:col',
              nest: (chart.rightColumn > 0
                  ? chart.rightColumn - 1
                  : chart.leftColumn + 7));
          builder.element('xdr:colOff', nest: 0);
          builder.element('xdr:row',
              nest: (chart.bottomRow > 0
                  ? chart.bottomRow - 1
                  : chart.topRow + 15));
          builder.element('xdr:rowOff', nest: 0);
        });

        builder.element('xdr:graphicFrame', nest: () {
          builder.attribute('macro', '');
          builder.element('xdr:nvGraphicFramePr', nest: () {
            builder.element('xdr:cNvPr', nest: () {
              builder.attribute(
                  'id', 1024 + sheet.workbook.chartCount + chart.index);
              builder.attribute(
                  'name',
                  'Chart ' +
                      (sheet.workbook.chartCount + chart.index).toString());
            });
            builder.element('xdr:cNvGraphicFramePr', nest: () {});
          });
          builder.element('xdr:xfrm', nest: () {
            builder.element('a:off', nest: () {
              builder.attribute('x', '0');
              builder.attribute('y', 0);
            });
            builder.element('a:ext', nest: () {
              builder.attribute('cx', '0');
              builder.attribute('cy', 0);
            });
          });
          builder.element('a:graphic', nest: () {
            builder.element('a:graphicData', nest: () {
              builder.attribute('uri',
                  'http://schemas.openxmlformats.org/drawingml/2006/chart');

              builder.element('c:chart', nest: () {
                builder.attribute('p7:id', 'rId' + chart.index.toString());
                builder.attribute('xmlns:p7',
                    'http://schemas.openxmlformats.org/officeDocument/2006/relationships');
                builder.attribute('xmlns:c',
                    'http://schemas.openxmlformats.org/drawingml/2006/chart');
              });
            });
          });
        });
        builder.element('xdr:clientData', nest: () {});
      });
    }
  }

  /// serialize default text area properties.
  void _serializeDefaultTextAreaProperties(
      XmlBuilder builder, ChartTextArea textArea) {
    builder.element('c:txPr', nest: () {
      builder.element('a:bodyPr ', nest: () {});
      builder.element('a:lstStyle ', nest: () {});
      builder.element('a:p', nest: () {
        builder.element('a:pPr', nest: () {
          builder.element('a:defRPr', nest: () {
            final double size = textArea.size * 100;
            builder.attribute('sz', size.toInt().toString());
            builder.attribute('b', textArea.bold ? '1' : '0');
            builder.attribute('i', textArea.italic ? '1' : '0');
            if (textArea.color != '' && textArea.color != 'FF000000') {
              builder.element('a:solidFill', nest: () {
                builder.element('a:srgbClr', nest: () {
                  builder.attribute('val', textArea.color.replaceAll('#', ''));
                });
              });
            }
            builder.element('a:latin', nest: () {
              builder.attribute('typeface', textArea.fontName);
            });
            builder.element('a:cs', nest: () {
              builder.attribute('typeface', textArea.fontName);
            });
          });
        });
        builder.element('a:endParaRPr', nest: () {
          builder.attribute('lang', 'en-US');
        });
      });
    });
  }

  /// serialize printer settings of charts
  void _serializePrinterSettings(XmlBuilder builder, Chart chart) {
    builder.element('c:printSettings', nest: () {
      builder.element('c:headerFooter', nest: () {
        builder.attribute('scaleWithDoc', '1');
        builder.attribute('alignWithMargins', '0');
        builder.attribute('differentFirst', '0');
        builder.attribute('differentOddEven', '0');
      });
      builder.element('c:pageMargins', nest: () {
        builder.attribute('l', '0.7');
        builder.attribute('r', '0.7');
        builder.attribute('t', '0.75');
        builder.attribute('b', '0.75');
        builder.attribute('header', '0.3');
        builder.attribute('footer', '0.3');
      });
    });
  }

  /// serialize chart title.
  void _serializeTitle(XmlBuilder builder, ChartTextArea chartTextArea) {
    builder.element('c:title', nest: () {
      if (chartTextArea._hasText) {
        builder.element('c:tx', nest: () {
          builder.element('c:rich', nest: () {
            builder.element('a:bodyPr ', nest: () {});
            builder.element('a:lstStyle', nest: () {});
            builder.element('a:p', nest: () {
              builder.element('a:pPr', nest: () {
                builder.attribute('algn', 'ctr');
                builder.element('a:defRPr', nest: () {});
              });
              builder.element('a:r', nest: () {
                _serializeParagraphRunProperties(builder, chartTextArea);
                builder.element('a:t', nest: () {
                  builder.text(chartTextArea.text!);
                });
              });
            });
          });
        });
      }
      builder.element('c:layout', nest: () {});
      builder.element('c:overlay', nest: () {
        builder.attribute('val', chartTextArea._overlay ? '1' : '0');
      });
      _serializeFill(builder, ExcelChartLinePattern.none, null, false);
    });
  }

  /// serialize paragraph run properties.
  void _serializeParagraphRunProperties(
      XmlBuilder builder, ChartTextArea textArea) {
    builder.element('a:rPr', nest: () {
      builder.attribute('lang', 'en-US');
      final double size = textArea.size * 100;
      builder.attribute('sz', size.toInt().toString());
      builder.attribute('b', textArea.bold ? '1' : '0');
      builder.attribute('i', textArea.italic ? '1' : '0');
      builder.attribute('baseline', '0');
      if (textArea.color != '' && textArea.color != 'FF000000') {
        builder.element('a:solidFill', nest: () {
          builder.element('a:srgbClr', nest: () {
            builder.attribute('val', textArea.color.replaceAll('#', ''));
          });
        });
      }
      builder.element('a:latin', nest: () {
        builder.attribute('typeface', textArea.fontName);
      });
      builder.element('a:ea', nest: () {
        builder.attribute('typeface', textArea.fontName);
      });
      builder.element('a:cs', nest: () {
        builder.attribute('typeface', textArea.fontName);
      });
    });
  }

  /// serialize plotarea of the chart
  void _serializePlotArea(XmlBuilder builder, Chart chart) {
    builder.element('c:plotArea', nest: () {
      builder.element('c:layout', nest: () {});
      if (chart._series.count > 0) {
        _serializeMainChartTypeTag(builder, chart);
      } else {
        _serializeEmptyChart(builder, chart);
        _serializeAxes(builder, chart);
      }
      _serializeFill(builder, chart.plotArea.linePattern,
          chart.plotArea.linePatternColor, false);
    });
  }

  /// serializes main chart tag.
  void _serializeMainChartTypeTag(XmlBuilder builder, Chart chart) {
    switch (chart.chartType) {
      case ExcelChartType.column:
      case ExcelChartType.columnStacked:
      case ExcelChartType.columnStacked100:
      case ExcelChartType.bar:
      case ExcelChartType.barStacked:
      case ExcelChartType.barStacked100:
        _serializeBarChart(builder, chart);
        break;

      case ExcelChartType.line:
      case ExcelChartType.lineStacked:
      case ExcelChartType.lineStacked100:
        _serializeLineChart(builder, chart);
        break;

      case ExcelChartType.area:
      case ExcelChartType.areaStacked:
      case ExcelChartType.areaStacked100:
        _serializeAreaChart(builder, chart);
        break;

      case ExcelChartType.pie:
        _serializePieChart(builder, chart);
        break;
    }
  }

  /// serializes Line chart.
  void _serializeLineChart(XmlBuilder builder, Chart chart) {
    builder.element('c:lineChart', nest: () {
      _serializeChartGrouping(builder, chart);
      builder.element('c:varyColors', nest: () {
        builder.attribute('val', 0);
      });
      for (int i = 0; i < chart.series.count; i++) {
        final ChartSerie firstSerie = chart.series[i];
        _serializeSerie(builder, firstSerie);
      }
      builder.element('c:axId', nest: () {
        builder.attribute('val', 59983360);
      });
      builder.element('c:axId', nest: () {
        builder.attribute('val', 57253888);
      });
    });
    _serializeAxes(builder, chart);
  }

  /// serializes Bar/ColumnClustered chart.
  void _serializeBarChart(XmlBuilder builder, Chart chart) {
    builder.element('c:barChart', nest: () {
      final String strDirection =
          chart.chartType.toString().contains('bar') ? 'bar' : 'col';
      builder.element('c:barDir', nest: () {
        builder.attribute('val', strDirection);
      });
      _serializeChartGrouping(builder, chart);
      builder.element('c:varyColors', nest: () {
        builder.attribute('val', 0);
      });
      for (int i = 0; i < chart.series.count; i++) {
        final ChartSerie firstSerie = chart.series[i];
        _serializeSerie(builder, firstSerie);
      }
      builder.element('c:gapWidth', nest: () {
        builder.attribute('val', 150);
      });
      if (chart._getIsStacked(chart.chartType) ||
          chart._getIs100(chart.chartType)) {
        builder.element('c:overlap', nest: () {
          builder.attribute('val', '100');
        });
      }
      builder.element('c:axId', nest: () {
        builder.attribute('val', 59983360);
      });
      builder.element('c:axId', nest: () {
        builder.attribute('val', 57253888);
      });
    });
    _serializeAxes(builder, chart);
  }

  /// serializes Area chart.
  void _serializeAreaChart(XmlBuilder builder, Chart chart) {
    builder.element('c:areaChart', nest: () {
      _serializeChartGrouping(builder, chart);
      builder.element('c:varyColors', nest: () {
        builder.attribute('val', 0);
      });
      for (int i = 0; i < chart.series.count; i++) {
        final ChartSerie firstSerie = chart.series[i];
        _serializeSerie(builder, firstSerie);
      }
      builder.element('c:axId', nest: () {
        builder.attribute('val', 59983360);
      });
      builder.element('c:axId', nest: () {
        builder.attribute('val', 57253888);
      });
    });
    _serializeAxes(builder, chart);
  }

  ///   serialize chart grouping.
  void _serializeChartGrouping(XmlBuilder builder, Chart chart) {
    String strGrouping;
    if (chart._getIsClustered(chart.chartType)) {
      strGrouping = 'clustered';
    } else if (chart._getIs100(chart.chartType)) {
      strGrouping = 'percentStacked';
    } else if (chart._getIsStacked(chart.chartType)) {
      strGrouping = 'stacked';
    } else {
      strGrouping = 'standard';
    }
    builder.element('c:grouping', nest: () {
      builder.attribute('val', strGrouping);
    });
  }

  /// serializes pie chart.
  void _serializePieChart(XmlBuilder builder, Chart chart) {
    builder.element('c:pieChart', nest: () {
      builder.element('c:varyColors', nest: () {
        builder.attribute('val', 1);
      });
      for (int i = 0; i < chart.series.count; i++) {
        final ChartSerie firstSerie = chart.series[i];
        _serializeSerie(builder, firstSerie);
      }
      builder.element('c:firstSliceAng', nest: () {
        builder.attribute('val', 0);
      });
    });
  }

  /// serializes series of chart.
  void _serializeSerie(XmlBuilder builder, ChartSerie firstSerie) {
    builder.element('c:ser', nest: () {
      builder.element('c:idx', nest: () {
        builder.attribute('val', firstSerie._index);
      });
      builder.element('c:order', nest: () {
        builder.attribute('val', firstSerie._index);
      });
      if (firstSerie._isDefaultName) {
        builder.element('c:tx', nest: () {
          final String strName = firstSerie._nameOrFormula;
          if (strName.isNotEmpty) {
            _serializeStringReference(
                builder, strName, firstSerie, 'text', null);
          }
        });
      }
      if (firstSerie.linePattern != ExcelChartLinePattern.none) {
        _serializeFill(
            builder, firstSerie.linePattern, firstSerie.linePatternColor, true);
      }
      if (firstSerie._serieType == ExcelChartType.line) {
        builder.element('c:marker', nest: () {
          builder.element('c:symbol', nest: () {
            builder.attribute('val', 'none');
          });
        });
      }
      if (firstSerie.dataLabels.isValue) {
        builder.element('c:dLbls', nest: () {
          if (firstSerie.dataLabels.numberFormat != null &&
              firstSerie.dataLabels.numberFormat != '' &&
              firstSerie.dataLabels.numberFormat != 'General') {
            builder.element('c:numFmt', nest: () {
              builder.attribute(
                  'formatCode', firstSerie.dataLabels.numberFormat!);
              builder.attribute('sourceLinked', '0');
            });
          }
          builder.element('c:spPr', nest: () {
            builder.element('a:noFill', nest: () {});
            builder.element('a:ln', nest: () {
              builder.element('a:noFill', nest: () {});
            });
            builder.element('a:effectLst', nest: () {});
          });
          final ChartTextArea textArea = firstSerie.dataLabels.textArea;
          _serializeChartTextArea(builder, textArea);
          builder.element('c:showLegendKey', nest: () {
            builder.attribute('val', 0);
          });
          builder.element('c:showVal', nest: () {
            builder.attribute('val', firstSerie.dataLabels.isValue ? 1 : 0);
          });
          builder.element('c:showCatName', nest: () {
            builder.attribute(
                'val', firstSerie.dataLabels.isCategoryName ? 1 : 0);
          });
          builder.element('c:showSerName', nest: () {
            builder.attribute(
                'val', firstSerie.dataLabels.isSeriesName ? 1 : 0);
          });
          builder.element('c:showPercent', nest: () {
            builder.attribute('val', 0);
          });
          builder.element('c:showBubbleSize', nest: () {
            builder.attribute('val', 0);
          });
          builder.element('c:showLeaderLines', nest: () {
            builder.attribute('val', 0);
          });
        });
      }
      if (firstSerie._categoryLabels != null) {
        final Range firstRange = firstSerie._chart._worksheet.getRangeByIndex(
            firstSerie._categoryLabels!.row,
            firstSerie._categoryLabels!.column);
        builder.element('c:cat', nest: () {
          Worksheet tempSheet = firstSerie._chart._worksheet;
          if (firstSerie._categoryLabels!.addressGlobal != '') {
            for (final Worksheet sheet
                in firstSerie._chart._worksheet.workbook.worksheets.innerList) {
              if (firstSerie._categoryLabels!.addressGlobal
                      .contains(RegExp(sheet.name + '!')) ||
                  firstSerie._categoryLabels!.addressGlobal
                      .contains(RegExp(sheet.name + "'" + '!'))) {
                tempSheet = sheet;
                break;
              }
            }
          }
          if (firstRange.text == null && firstRange.number != null) {
            builder.element('c:numRef', nest: () {
              builder.element('c:f',
                  nest: firstSerie._categoryLabels!.addressGlobal);
              final Range firstRange = firstSerie._chart._worksheet
                  .getRangeByIndex(firstSerie._categoryLabels!.row,
                      firstSerie._categoryLabels!.column);
              builder.element('c:numCache', nest: () {
                if (firstRange.numberFormat != null &&
                    firstRange.numberFormat != 'General') {
                  builder.element('c:formatCode',
                      nest: firstRange.numberFormat);
                }
                _serializeNumCacheValues(builder, firstSerie, tempSheet);
              });
            });
          } else {
            _serializeStringReference(
                builder,
                firstSerie._categoryLabels!.addressGlobal,
                firstSerie,
                'cat',
                tempSheet);
          }
        });
      }
      if (firstSerie._values != null) {
        builder.element('c:val', nest: () {
          builder.element('c:numRef', nest: () {
            builder.element('c:f', nest: firstSerie._values!.addressGlobal);
            final Range firstRange = firstSerie._chart._worksheet
                .getRangeByIndex(
                    firstSerie._values!.row, firstSerie._values!.column);
            Worksheet tempSheet = firstSerie._chart._worksheet;
            if (firstSerie._values!.addressGlobal != '') {
              for (final Worksheet sheet in firstSerie
                  ._chart._worksheet.workbook.worksheets.innerList) {
                if (firstSerie._values!.addressGlobal
                        .contains(RegExp(sheet.name + '!')) ||
                    firstSerie._values!.addressGlobal
                        .contains(RegExp(sheet.name + "'" + '!'))) {
                  tempSheet = sheet;
                  break;
                }
              }
            }
            builder.element('c:numCache', nest: () {
              if (firstRange.numberFormat != null &&
                  firstRange.numberFormat != 'General') {
                builder.element('c:formatCode', nest: firstRange.numberFormat);
              } else {
                builder.element('c:formatCode', nest: 'General');
              }
              _serializeNumCacheValues(builder, firstSerie, tempSheet);
            });
          });
        });
      }
      if (firstSerie._serieType == ExcelChartType.line) {
        builder.element('c:smooth', nest: () {
          builder.attribute('val', 0);
        });
      }
    });
  }

  /// serializes chart text area.
  void _serializeChartTextArea(XmlBuilder builder, ChartTextArea textArea) {
    builder.element('c:txPr', nest: () {
      builder.element('a:bodyPr ', nest: () {});
      builder.element('a:lstStyle', nest: () {});
      builder.element('a:p', nest: () {
        builder.element('a:pPr', nest: () {
          builder.element('a:defRPr', nest: () {
            final double size = textArea.size * 100;
            builder.attribute('sz', size.toInt().toString());
            builder.attribute('b', textArea.bold ? '1' : '0');
            builder.attribute('i', textArea.italic ? '1' : '0');
            builder.attribute('baseline', '0');
            if (textArea.color != '' && textArea.color != 'FF000000') {
              builder.element('a:solidFill', nest: () {
                builder.element('a:srgbClr', nest: () {
                  builder.attribute('val', textArea.color.replaceAll('#', ''));
                });
              });
            }
            builder.element('a:latin', nest: () {
              builder.attribute('typeface', textArea.fontName);
            });
            builder.element('a:ea', nest: () {
              builder.attribute('typeface', textArea.fontName);
            });
            builder.element('a:cs', nest: () {
              builder.attribute('typeface', textArea.fontName);
            });
          });
        });
      });
    });
  }

  /// serializes number cache values.
  void _serializeNumCacheValues(
      XmlBuilder builder, ChartSerie firstSerie, Worksheet dataSheet) {
    final Range? serieRange = firstSerie._values;
    if (serieRange != null) {
      final int count = serieRange.count;
      final int serieStartRow = serieRange.row;
      final int serieStartColumn = serieRange.column;
      builder.element('c:ptCount', nest: () {
        builder.attribute('val', count);
      });
      int index = 0;
      while (index < count) {
        final double? value = dataSheet
            .getRangeByIndex(serieStartRow + index, serieStartColumn)
            .number;
        if (value != null) {
          builder.element('c:pt', nest: () {
            builder.attribute('idx', index);
            builder.element('c:v', nest: value);
          });
        }
        index++;
      }
    }
  }

  /// serializes string cache reference.
  void _serializeStringReference(XmlBuilder builder, String range,
      ChartSerie firstSerie, String tagName, Worksheet? dataSheet) {
    builder.element('c:strRef', nest: () {
      builder.element('c:f', nest: range);
      builder.element('c:strCache', nest: () {
        if (tagName == 'cat') {
          _serializeCategoryTagCacheValues(builder, firstSerie, dataSheet);
        } else {
          _serializeTextTagCacheValues(builder, firstSerie);
        }
      });
    });
  }

  /// serializes catergory cache values.
  void _serializeCategoryTagCacheValues(
      XmlBuilder builder, ChartSerie firstSerie, Worksheet? dataSheet) {
    final Range? serieRange = firstSerie._categoryLabels;
    if (serieRange != null) {
      final int count = serieRange.count;
      final int serieStartRow = serieRange.row;
      final int serieStartColumn = serieRange.column;
      builder.element('c:ptCount', nest: () {
        builder.attribute('val', count);
      });
      int index = 0;
      while (index < count) {
        final String value = dataSheet != null
            ? dataSheet
                .getRangeByIndex(serieStartRow + index, serieStartColumn)
                .text!
            : '';

        builder.element('c:pt', nest: () {
          builder.attribute('idx', index);
          builder.element('c:v', nest: value);
        });
        index++;
      }
    }
  }

  /// serializes text cache values.
  void _serializeTextTagCacheValues(XmlBuilder builder, ChartSerie firstSerie) {
    builder.element('c:ptCount', nest: () {
      builder.attribute('val', 1);
    });
    builder.element('c:pt', nest: () {
      builder.attribute('idx', 0);
      if (firstSerie.name != null) {
        builder.element('c:v', nest: firstSerie.name);
      }
    });
  }

  /// serializes fill for the charts.
  void _serializeFill(XmlBuilder builder, ExcelChartLinePattern linePattern,
      String? lineColor, bool hasSerie) {
    builder.element('c:spPr', nest: () {
      if (lineColor == null) {
        builder.element('a:solidFill', nest: () {
          builder.element('a:srgbClr', nest: () {
            builder.attribute('val', 'FFFFFF');
          });
        });
      }
      builder.element('a:ln', nest: () {
        if (linePattern != ExcelChartLinePattern.none) {
          if (!hasSerie || lineColor != null) {
            builder.element('a:solidFill', nest: () {
              builder.element('a:srgbClr', nest: () {
                if (lineColor != null) {
                  builder.attribute('val', lineColor.replaceAll('#', ''));
                } else {
                  builder.attribute('val', '0070C0');
                }
              });
            });
          }
          if (linePattern != ExcelChartLinePattern.solid) {
            builder.element('a:prstDash', nest: () {
              builder.attribute('val', _linePattern[linePattern]);
            });
          }
        } else {
          builder.element('a:noFill', nest: () {});
        }
        builder.element('a:round', nest: () {});
      });
    });
  }

  /// serializes axies of the series.
  void _serializeAxes(XmlBuilder builder, Chart chart) {
    if (chart._isCategoryAxisAvail) {
      _serializeCategoryAxis(builder, chart.primaryCategoryAxis);
    }
    if (chart._isValueAxisAvail) {
      _serializeValueAxis(builder, chart.primaryValueAxis);
    }
  }

  /// serializes empty charts.
  void _serializeEmptyChart(XmlBuilder builder, Chart chart) {
    builder.element('c:barChart', nest: () {
      builder.element('c:barDir', nest: () {
        builder.attribute('val', 'col');
      });
      builder.element('c:grouping', nest: () {
        builder.attribute('val', 'clustered');
      });
      builder.element('c:varyColors', nest: () {
        builder.attribute('val', 0);
      });
      _serializeEmptyChartDataLabels(builder);
      builder.element('c:gapWidth', nest: () {
        builder.attribute('val', 150);
      });
      builder.element('c:axId', nest: () {
        builder.attribute('val', 59983360);
      });
      builder.element('c:axId', nest: () {
        builder.attribute('val', 57253888);
      });
    });
  }

  /// serializes category axis of the chart.
  void _serializeCategoryAxis(XmlBuilder builder, ChartCategoryAxis axis) {
    builder.element('c:catAx', nest: () {
      builder.element('c:axId', nest: () {
        builder.attribute('val', 59983360);
      });
      builder.element('c:scaling', nest: () {
        builder.element('c:orientation', nest: () {
          builder.attribute('val', 'minMax');
        });
      });
      builder.element('c:delete', nest: () {
        builder.attribute('val', 0);
      });
      builder.element('c:axPos', nest: () {
        builder.attribute('val', 'b');
      });
      if (axis._hasAxisTitle) {
        _serializeChartTextArea(builder, axis.titleArea);
      }
      if (axis.numberFormat != '' && axis.numberFormat != 'General') {
        builder.element('c:numFmt', nest: () {
          builder.attribute('formatCode', axis.numberFormat);
          builder.attribute('sourceLinked', '0');
        });
      }
      builder.element('c:majorTickMark', nest: () {
        builder.attribute('val', 'out');
      });
      builder.element('c:minorTickMark', nest: () {
        builder.attribute('val', 'none');
      });
      builder.element('c:tickLblPos', nest: () {
        builder.attribute('val', 'nextTo');
      });
      builder.element('c:spPr', nest: () {
        builder.element('a:ln', nest: () {});
      });
      builder.element('c:crossAx', nest: () {
        builder.attribute('val', 57253888);
      });
      builder.element('c:crosses', nest: () {
        builder.attribute('val', 'autoZero');
      });
      builder.element('c:auto', nest: () {
        builder.attribute('val', 1);
      });
      builder.element('c:lblAlgn', nest: () {
        builder.attribute('val', 'ctr');
      });
      builder.element('c:lblOffset', nest: () {
        builder.attribute('val', 100);
      });
      builder.element('c:noMultiLvlLbl', nest: () {
        builder.attribute('val', 0);
      });
      builder.element('c:tickMarkSkip', nest: () {
        builder.attribute('val', 1);
      });
    });
  }

  /// serializes Value axis of the chart.
  void _serializeValueAxis(XmlBuilder builder, ChartValueAxis axis) {
    builder.element('c:valAx', nest: () {
      builder.element('c:axId', nest: () {
        builder.attribute('val', 57253888);
      });
      builder.element('c:scaling', nest: () {
        builder.element('c:orientation', nest: () {
          builder.attribute('val', 'minMax');
        });
        if (!axis._isAutoMax) {
          builder.element('c:max', nest: () {
            builder.attribute('val', axis.maximumValue);
          });
        }
        if (axis._isAutoMin) {
          builder.element('c:min', nest: () {
            builder.attribute('val', axis.minimumValue);
          });
        }
      });
      builder.element('c:delete', nest: () {
        builder.attribute('val', '0');
      });
      builder.element('c:axPos', nest: () {
        builder.attribute('val', 'l');
      });
      if (axis._hasAxisTitle) {
        _serializeChartTextArea(builder, axis.titleArea);
      }
      if (axis.numberFormat != '' && axis.numberFormat != 'General') {
        builder.element('c:numFmt', nest: () {
          builder.attribute('formatCode', axis.numberFormat);
          builder.attribute('sourceLinked', '0');
        });
      }
      if (axis.hasMajorGridLines) {
        builder.element('c:majorGridlines', nest: () {});
      }
      builder.element('c:majorTickMark', nest: () {
        builder.attribute('val', 'out');
      });
      builder.element('c:minorTickMark', nest: () {
        builder.attribute('val', 'none');
      });
      builder.element('c:tickLblPos', nest: () {
        builder.attribute('val', 'nextTo');
      });
      builder.element('c:spPr', nest: () {
        builder.element('a:ln', nest: () {});
      });
      builder.element('c:crossAx', nest: () {
        builder.attribute('val', 59983360);
      });
      builder.element('c:crosses', nest: () {
        builder.attribute('val', 'autoZero');
      });
      final Chart chart = axis._parentChart;
      final String strCrossBetween =
          chart.primaryCategoryAxis._isBetween ? 'between' : 'midCat';
      builder.element('c:crossBetween', nest: () {
        builder.attribute('val', strCrossBetween);
      });
    });
  }

  /// serializes empty chart's datalabels.
  void _serializeEmptyChartDataLabels(XmlBuilder builder) {
    builder.element('c:dLbls', nest: () {
      builder.element('c:showLegendKey', nest: () {
        builder.attribute('val', 0);
      });
      builder.element('c:showVal', nest: () {
        builder.attribute('val', 0);
      });
      builder.element('c:showCatName', nest: () {
        builder.attribute('val', 0);
      });
      builder.element('c:showSerName', nest: () {
        builder.attribute('val', 0);
      });
      builder.element('c:showPercent', nest: () {
        builder.attribute('val', 0);
      });
      builder.element('c:showBubbleSize', nest: () {
        builder.attribute('val', 0);
      });
    });
  }

  /// Add the workbook data with filename to ZipArchive.
  void _addToArchive(List<int> data, String fileName) {
    final ArchiveFile item = ArchiveFile(fileName, data.length, data);
    _workbook.archive.addFile(item);
  }
}
