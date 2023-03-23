part of officechart;

/// Represent the chart serialize class
class ChartSerialization {
  /// Create an instances of [ChartSerialization] class.
  ChartSerialization(Workbook workbook) {
    _workbook = workbook;
  }

  /// Workbook to serialize.
  late Workbook _workbook;

  final Map<dynamic, dynamic> _linePattern = <dynamic, dynamic>{
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
    for (final Chart chart in (sheet.charts! as ChartCollection).innerList) {
      sheet.workbook.chartCount++;
      final XmlBuilder builder = XmlBuilder();
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
          if (chart.hasTitle) {
            _serializeTitle(builder, chart.chartTitleArea);
          }
          if (chart._is3DChart) {
            _serializeView3D(builder, chart);
          }
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
      final String stringXml = builder.buildDocument().copy().toString();
      final List<int> bytes = utf8.encode(stringXml);
      _addToArchive(bytes, 'xl/charts/chart${sheet.workbook.chartCount}.xml');
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
    for (final Chart chart in (sheet.charts! as ChartCollection).innerList) {
      builder.element('xdr:twoCellAnchor', nest: () {
        builder.attribute('editAs', 'twoCell');
        builder.element('xdr:from', nest: () {
          builder.element('xdr:col',
              nest: chart.leftColumn > 0 ? chart.leftColumn - 1 : 0);
          builder.element('xdr:colOff', nest: 0);
          builder.element('xdr:row',
              nest: chart.topRow > 0 ? chart.topRow - 1 : 0);
          builder.element('xdr:rowOff', nest: 0);
        });

        builder.element('xdr:to', nest: () {
          builder.element('xdr:col',
              nest: chart.rightColumn > 0
                  ? chart.rightColumn - 1
                  : chart.leftColumn + 7);
          builder.element('xdr:colOff', nest: 0);
          builder.element('xdr:row',
              nest: chart.bottomRow > 0
                  ? chart.bottomRow - 1
                  : chart.topRow + 15);
          builder.element('xdr:rowOff', nest: 0);
        });

        builder.element('xdr:graphicFrame', nest: () {
          builder.attribute('macro', '');
          builder.element('xdr:nvGraphicFramePr', nest: () {
            builder.element('xdr:cNvPr', nest: () {
              builder.attribute(
                  'id', 1024 + sheet.workbook.chartCount + chart.index);
              builder.attribute(
                  'name', 'Chart ${sheet.workbook.chartCount + chart.index}');
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
                builder.attribute('p7:id', 'rId${chart.index}');
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
      case ExcelChartType.lineMarkers:
      case ExcelChartType.lineStacked100:
      case ExcelChartType.lineMarkersStacked:
      case ExcelChartType.lineMarkersStacked100:
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

      case ExcelChartType.pieBar:
      case ExcelChartType.pieOfPie:
        _serializeOfPieChart(builder, chart);
        break;
      case ExcelChartType.pie3D:
        _serializeOfPie3DChart(builder, chart);
        break;
      case ExcelChartType.line3D:
        _serializeLine3DChart(builder, chart);
        break;
      case ExcelChartType.barStacked1003D:
      case ExcelChartType.barStacked3D:
      case ExcelChartType.barClustered3D:
      case ExcelChartType.columnClustered3D:
      case ExcelChartType.columnStacked3D:
      case ExcelChartType.columnStacked1003D:
      case ExcelChartType.column3D:
        _serializeBar3DChart(builder, chart);
        break;

      case ExcelChartType.stockHighLowClose:
      case ExcelChartType.stockOpenHighLowClose:
      case ExcelChartType.stockVolumeHighLowClose:
      case ExcelChartType.stockVolumeOpenHighLowClose:
        _serializeStockChart(builder, chart);
        break;
      case ExcelChartType.doughnut:
      case ExcelChartType.doughnutExploded:
        _serializedoughnutchart(builder, chart);
        break;
    }
  }

  /// serializes Line chart.
  void _serializeLineChart(XmlBuilder builder, Chart chart) {
    final ExcelChartType type = chart.series[0]._serieType;
    builder.element('c:lineChart', nest: () {
      _serializeChartGrouping(builder, chart);
      builder.element('c:varyColors', nest: () {
        builder.attribute('val', 0);
      });
      for (int i = 0; i < chart.series.count; i++) {
        final ChartSerie firstSerie = chart.series[i];
        _serializeSerie(builder, firstSerie);
      }
      if (type == ExcelChartType.lineMarkers ||
          type == ExcelChartType.lineMarkersStacked ||
          type == ExcelChartType.lineMarkersStacked100) {
        builder.element('c:marker', nest: () {
          builder.attribute('val', 1);
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

  /// serializes Bar/ColumnClustered chart.
  void _serializeBarChart(XmlBuilder builder, Chart chart) {
    late int gapwidth;
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
        gapwidth = firstSerie.serieFormat.commonSerieOptions.gapWidth;
      }
      builder.element('c:gapWidth', nest: () {
        builder.attribute('val', gapwidth);
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
    final ExcelChartType type = firstSerie._serieType;
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

      if (firstSerie.serieFormat.pieExplosionPercent != 0 ||
          (type == ExcelChartType.doughnutExploded &&
              firstSerie._chart.series.count == 1)) {
        builder.element('c:explosion', nest: () {
          builder.attribute('val', firstSerie.serieFormat.pieExplosionPercent);
        });
      }
      if (type == ExcelChartType.stockOpenHighLowClose ||
          type == ExcelChartType.stockVolumeHighLowClose ||
          type == ExcelChartType.stockVolumeOpenHighLowClose) {
        builder.element('c:spPr', nest: () {
          builder.element('a:ln', nest: () {
            builder.element('a:noFill', nest: () {});
          });
        });
      } else if (type == ExcelChartType.stockHighLowClose) {
        if (firstSerie._index == 2) {
          builder.element('c:spPr', nest: () {
            builder.element('a:ln', nest: () {
              builder.attribute('w', '3175');
              builder.element('a:solidFill', nest: () {
                builder.element('a:srgbClr', nest: () {
                  builder.attribute('val', '000000');
                });
              });
              builder.element('a:prstDash', nest: () {
                builder.attribute('val', 'solid');
              });
            });
          });
        } else {
          builder.element('c:spPr', nest: () {
            builder.element('a:ln', nest: () {
              builder.element('a:noFill', nest: () {});
            });
          });
        }
      }
      if (firstSerie.linePattern != ExcelChartLinePattern.none) {
        _serializeFill(
            builder, firstSerie.linePattern, firstSerie.linePatternColor, true);
      }

      _serializeMarker(builder, firstSerie);

      if (firstSerie.dataLabels.isValue) {
        builder.element('c:dLbls', nest: () {
          if (firstSerie.dataLabels.numberFormat != null &&
              firstSerie.dataLabels.numberFormat != '' &&
              firstSerie.dataLabels.numberFormat != 'General') {
            builder.element('c:numFmt', nest: () {
              builder.attribute(
                  'formatCode',
                  // ignore: unnecessary_null_checks
                  firstSerie.dataLabels.numberFormat!);
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
                      .contains(RegExp('${sheet.name}!')) ||
                  firstSerie._categoryLabels!.addressGlobal
                      .contains(RegExp("${sheet.name}'!"))) {
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
                        .contains(RegExp('${sheet.name}!')) ||
                    firstSerie._values!.addressGlobal
                        .contains(RegExp("${sheet.name}'!"))) {
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
      if (firstSerie._serieType.toString().contains('line') ||
          firstSerie._serieType.toString().contains('stock')) {
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
        final String? value = dataSheet != null
            ? dataSheet
                .getRangeByIndex(serieStartRow + index, serieStartColumn)
                .text
            : '';
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

  /// Serialize line 3D Chart.
  void _serializeLine3DChart(XmlBuilder builder, Chart chart) {
    late int gapdepth;
    builder.element('c:line3DChart', nest: () {
      _serializeChartGrouping(builder, chart);
      builder.element('c:varyColors', nest: () {
        builder.attribute('val', 0);
      });
      for (int i = 0; i < chart.series.count; i++) {
        final ChartSerie firstSerie = chart.series[i];
        _serializeSerie(builder, firstSerie);
        gapdepth = firstSerie.serieFormat.commonSerieOptions.gapDepth;
      }
      builder.element('c:gapDepth', nest: () {
        builder.attribute('val', gapdepth);
      });
      builder.element('c:axId', nest: () {
        builder.attribute('val', 59983360);
      });
      builder.element('c:axId', nest: () {
        builder.attribute('val', 57253888);
      });
      builder.element('c:axId', nest: () {
        builder.attribute('val', 63149376);
      });
    });
    _serializeAxes(builder, chart);
  }

  ///Serialize view 3D
  void _serializeView3D(XmlBuilder builder, Chart chart) {
    final ChartSeriesCollection firstSerie = chart.series;

    builder.element('c:view3D', nest: () {
      if (!chart._isdefaultElevation) {
        builder.element('c:rotX', nest: () {
          builder.attribute('val', chart.elevation);
        });
      }
      if (firstSerie._innerList[0]._serieType == ExcelChartType.pie3D) {
        for (int i = 0; i < chart.series.count; i++) {
          chart.rotation =
              chart.series[i].serieFormat.commonSerieOptions.firstSliceAngle;
        }
      }
      if (!chart._isDefaultRotation) {
        builder.element('c:rotY', nest: () {
          builder.attribute('val', chart.rotation);
        });
      }
      builder.element('c:depthPercent', nest: () {
        builder.attribute('val', chart.depthPercent);
      });
      builder.element('c:rAngAx', nest: () {
        int defaultValue = 0;

        if (chart.rightAngleAxes || chart._isColumnOrBar) {
          defaultValue = 1;
        }

        builder.attribute('val', defaultValue);
      });
      builder.element('perspective', nest: () {
        builder.attribute('val', chart.perspective * 2);
      });
    });
  }

  /// Serialize bar3D chart.
  void _serializeBar3DChart(XmlBuilder builder, Chart chart) {
    late int gapdepth;
    late int gapwidth;
    builder.element('c:bar3DChart', nest: () {
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
        gapdepth = firstSerie.serieFormat.commonSerieOptions.gapDepth;
        gapwidth = firstSerie.serieFormat.commonSerieOptions.gapWidth;
      }

      builder.element('c:gapWidth', nest: () {
        builder.attribute('val', gapwidth);
      });
      builder.element('c:gapDepth', nest: () {
        builder.attribute('val', gapdepth);
      });
      builder.element('c:axId', nest: () {
        builder.attribute('val', 59983360);
      });
      builder.element('c:axId', nest: () {
        builder.attribute('val', 57253888);
      });
    });
    _serializeAxes(builder, chart);
  }

  // Serializes pie of pie or pie of bar chart.
  void _serializeOfPieChart(XmlBuilder builder, Chart chart) {
    late int gapwidth;
    late int pieSecondSize;
    final ExcelChartType type = chart.series[0]._serieType;
    late String isPieOrBar;
    if (type == ExcelChartType.pieOfPie) {
      isPieOrBar = 'pie';
    } else if (type == ExcelChartType.pieBar) {
      isPieOrBar = 'bar';
    }
    builder.element('c:ofPieChart', nest: () {
      builder.element('c:ofPieType', nest: () {
        builder.attribute('val', isPieOrBar);
      });
      builder.element('c:varyColors', nest: () {
        builder.attribute('val', 1);
      });

      for (int i = 0; i < chart.series.count; i++) {
        final ChartSerie firstSerie = chart.series[i];
        _serializeSerie(builder, firstSerie);
        pieSecondSize = firstSerie.serieFormat.commonSerieOptions.pieSecondSize;
        gapwidth = firstSerie.serieFormat.commonSerieOptions.gapWidth;
      }

      builder.element('c:gapWidth', nest: () {
        builder.attribute('val', gapwidth);
      });
      builder.element('c:secondPieSize', nest: () {
        builder.attribute('val', pieSecondSize);
      });
      builder.element('c:serLines', nest: () {
        builder.element('c:spPr', nest: () {
          builder.element('a:ln', nest: () {});
        });
      });
    });
  }

  ///Serialize pie 3D chart.
  void _serializeOfPie3DChart(XmlBuilder builder, Chart chart) {
    builder.element('c:pie3DChart', nest: () {
      builder.element('c:varyColors', nest: () {
        builder.attribute('val', 1);
      });
      for (int i = 0; i < chart.series.count; i++) {
        final ChartSerie firstSerie = chart.series[i];
        _serializeSerie(builder, firstSerie);
      }
    });
  }

  /// Serializes stock chart.
  void _serializeStockChart(XmlBuilder builder, Chart chart) {
    final ExcelChartType type = chart.series.innerList[0]._serieType;
    if (type == ExcelChartType.stockVolumeOpenHighLowClose ||
        type == ExcelChartType.stockVolumeHighLowClose) {
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

        final ChartSerie firstSerie = chart.series[0];
        _serializeSerie(builder, firstSerie);

        builder.element('c:gapWidth', nest: () {
          builder.attribute(
              'val', firstSerie.serieFormat.commonSerieOptions.gapWidth);
        });
        builder.element('c:axId', nest: () {
          builder.attribute('val', 59983360);
        });
        builder.element('c:axId', nest: () {
          builder.attribute('val', 57253888);
        });
      });
    }
    builder.element('c:stockChart', nest: () {
      if (type == ExcelChartType.stockHighLowClose ||
          type == ExcelChartType.stockOpenHighLowClose) {
        for (int i = 0; i < chart.series.count; i++) {
          final ChartSerie firstSerie = chart.series[i];
          _serializeSerie(builder, firstSerie);
        }
      } else if (type == ExcelChartType.stockVolumeHighLowClose ||
          type == ExcelChartType.stockVolumeOpenHighLowClose) {
        for (int i = 0; i < chart.series.count; i++) {
          if ((type == ExcelChartType.stockVolumeOpenHighLowClose ||
                  type == ExcelChartType.stockVolumeHighLowClose) &&
              chart.series.innerList[0] != chart.series.innerList[i]) {
            final ChartSerie firstSerie = chart.series[i];
            _serializeSerie(builder, firstSerie);
          }
        }
      }

      builder.element('c:hiLowLines', nest: () {
        builder.element('c:spPr', nest: () {
          builder.element('a:ln', nest: () {
            builder.element('a:solidFill', nest: () {
              builder.element('a:srgbClr', nest: () {
                builder.attribute('val', '000000');
              });
            });
            builder.element('a:prstDash', nest: () {
              builder.attribute('val', 'solid');
            });
          });
        });
      });
      if (type == ExcelChartType.stockOpenHighLowClose ||
          type == ExcelChartType.stockVolumeOpenHighLowClose) {
        builder.element('c:upDownBars', nest: () {
          builder.element('c:gapWidth', nest: () {
            builder.attribute('val', '100');
          });
          builder.element('c:upBars', nest: () {
            builder.element('c:spPr', nest: () {
              builder.element('a:solidFill', nest: () {
                builder.element('a:srgbClr', nest: () {
                  builder.attribute('val', 'FFFFFF');
                });
              });
            });
          });
          builder.element('c:downBars', nest: () {
            builder.element('c:spPr', nest: () {
              builder.element('a:solidFill', nest: () {
                builder.element('a:srgbClr', nest: () {
                  builder.attribute('val', '000000');
                });
              });
            });
          });
        });
      }
      if (chart.series[0].serieFormat.markerStyle !=
          ExcelChartMarkerType.none) {
        builder.element('c:marker', nest: () {
          builder.attribute('val', 1);
        });
      }

      builder.element('c:axId', nest: () {
        builder.attribute('val', 62908672);
      });
      builder.element('c:axId', nest: () {
        builder.attribute('val', 61870848);
      });
    });
    if (type == ExcelChartType.stockVolumeOpenHighLowClose ||
        type == ExcelChartType.stockVolumeHighLowClose) {
      _serializeAxesforStockChart(builder, chart, 59983360, 57253888, true);
      _serializeAxesforStockChart(builder, chart, 62908672, 61870848, false);
    } else {
      _serializeAxesforStockChart(builder, chart, 62908672, 61870848, true);
    }
  }

  ///serialize stock axes
  void _serializeAxesforStockChart(
      XmlBuilder builder, Chart chart, int axisId, int crossAx, bool isBar) {
    if (chart._isCategoryAxisAvail) {
      _serializeCategoryAxisForStock(
          builder, chart.primaryCategoryAxis, axisId, crossAx, isBar);
    }
    if (chart._isValueAxisAvail) {
      _serializeValueAxisForStockchart(
          builder, chart.primaryCategoryAxis, axisId, crossAx, isBar);
    }
  }

  ///Serialize catogory axis for stock chart
  void _serializeCategoryAxisForStock(XmlBuilder builder,
      ChartCategoryAxis axis, int axisId, int crossAx, bool isBar) {
    builder.element('c:catAx', nest: () {
      builder.element('c:axId', nest: () {
        builder.attribute('val', axisId);
      });
      builder.element('c:scaling', nest: () {
        builder.element('c:orientation', nest: () {
          builder.attribute('val', 'minMax');
        });
      });
      int delete = 0;
      String axpos = 'b';
      if (!isBar) {
        delete = 1;
        axpos = 't';
      }
      builder.element('c:delete', nest: () {
        builder.attribute('val', delete);
      });
      builder.element('c:axPos', nest: () {
        builder.attribute('val', axpos);
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
        builder.element('a:ln', nest: () {
          if (!isBar) {
            builder.attribute('w', 12700);
          }
        });
      });
      builder.element('c:crossAx', nest: () {
        builder.attribute('val', crossAx);
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

  ///Serialize value axis for stock chart
  void _serializeValueAxisForStockchart(XmlBuilder builder,
      ChartCategoryAxis axis, int axisId, int crossAx, bool isBar) {
    builder.element('c:valAx', nest: () {
      builder.element('c:axId', nest: () {
        builder.attribute('val', crossAx);
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
      String axpos = 'l';

      if (!isBar) {
        axpos = 'r';
      }

      builder.element('c:axPos', nest: () {
        builder.attribute('val', axpos);
      });

      if (axpos == 'l') {
        builder.element('c:majorGridlines', nest: () {});
      }

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
        builder.attribute('val', axisId);
      });
      String crosses = 'autoZero';
      if (!isBar) {
        crosses = 'max';
      }
      builder.element('c:crosses', nest: () {
        builder.attribute('val', crosses);
      });
      final Chart chart = axis._parentChart;
      final String strCrossBetween =
          chart.primaryCategoryAxis._isBetween ? 'between' : 'midCat';
      builder.element('c:crossBetween', nest: () {
        builder.attribute('val', strCrossBetween);
      });
    });
  }

  ///Serialize doughnut/doughnut_exploded charts
  void _serializedoughnutchart(XmlBuilder builder, Chart chart) {
    late int doughnutHoleSize;
    late int firstSliceAngle;

    builder.element('c:doughnutChart', nest: () {
      builder.element('c:varyColors', nest: () {
        builder.attribute('val', 1);
      });

      for (int i = 0; i < chart.series.count; i++) {
        final ChartSerie firstSerie = chart.series[i];
        _serializeSerie(builder, firstSerie);
        firstSliceAngle =
            firstSerie.serieFormat.commonSerieOptions.firstSliceAngle;
        doughnutHoleSize =
            firstSerie.serieFormat.commonSerieOptions.holeSizePercent;
      }
      builder.element('c:firstSliceAng', nest: () {
        builder.attribute('val', firstSliceAngle);
      });
      builder.element('c:holeSize', nest: () {
        builder.attribute('val', doughnutHoleSize);
      });
    });
  }

  ///Serialize marker for stock and line charts
  void _serializeMarker(XmlBuilder builder, ChartSerie firstSerie) {
    final ExcelChartType type = firstSerie._serieType;

    if ((firstSerie.serieFormat.markerStyle == ExcelChartMarkerType.none) &&
        (type == ExcelChartType.line ||
            type == ExcelChartType.lineStacked ||
            type == ExcelChartType.lineStacked100 ||
            type == ExcelChartType.stockHighLowClose ||
            type == ExcelChartType.stockVolumeOpenHighLowClose ||
            type == ExcelChartType.stockVolumeHighLowClose ||
            type == ExcelChartType.stockOpenHighLowClose)) {
      builder.element('c:marker', nest: () {
        builder.element('c:symbol', nest: () {
          builder.attribute('val', 'none');
        });
      });
    } else if ((firstSerie.serieFormat.markerStyle ==
            ExcelChartMarkerType.none) &&
        (type == ExcelChartType.lineMarkers ||
            type == ExcelChartType.lineMarkersStacked ||
            type == ExcelChartType.lineMarkersStacked100)) {
      builder.element('c:marker', nest: () {
        builder.element('c:symbol', nest: () {
          builder.attribute('val', 'circle');
        });
        builder.element('c:size', nest: () {
          builder.attribute('val', '5');
        });
      });
    } else if (firstSerie.serieFormat.markerStyle !=
        ExcelChartMarkerType.none) {
      final String markerBackgroundColor =
          firstSerie.serieFormat.markerBackgroundColor.replaceAll('#', '');
      final String markerBorderColor =
          firstSerie.serieFormat.markerBorderColor.replaceAll('#', '');
      late String exclMarkertype;
      if (firstSerie.serieFormat.markerStyle == ExcelChartMarkerType.diamond) {
        exclMarkertype = 'diamond';
      } else if (firstSerie.serieFormat.markerStyle ==
          ExcelChartMarkerType.circle) {
        exclMarkertype = 'circle';
      } else if (firstSerie.serieFormat.markerStyle ==
          ExcelChartMarkerType.xSquare) {
        exclMarkertype = 'x';
      } else if (firstSerie.serieFormat.markerStyle ==
          ExcelChartMarkerType.dowJones) {
        exclMarkertype = 'dot';
      } else if (firstSerie.serieFormat.markerStyle ==
          ExcelChartMarkerType.square) {
        exclMarkertype = 'square';
      } else if (firstSerie.serieFormat.markerStyle ==
          ExcelChartMarkerType.plusSign) {
        exclMarkertype = 'plus';
      } else if (firstSerie.serieFormat.markerStyle ==
          ExcelChartMarkerType.standardDeviation) {
        exclMarkertype = 'triangle';
      } else if (firstSerie.serieFormat.markerStyle ==
          ExcelChartMarkerType.starSquare) {
        exclMarkertype = 'star';
      }

      builder.element('c:marker', nest: () {
        builder.element('c:symbol', nest: () {
          builder.attribute('val', exclMarkertype);
        });
        builder.element('c:size', nest: () {
          builder.attribute('val', '5');
        });
        builder.element('c:spPr', nest: () {
          builder.element('a:solidFill', nest: () {
            builder.element('a:srgbClr', nest: () {
              builder.attribute('val', markerBackgroundColor);
            });
          });
          builder.element('a:ln', nest: () {
            builder.element('a:solidFill', nest: () {
              builder.element('a:srgbClr', nest: () {
                builder.attribute('val', markerBorderColor);
              });
            });
          });
        });
      });
    }
  }

  /// serializes charts from the worksheet.
  Future<void> _saveChartsAsync(Worksheet sheet) async {
    for (final Chart chart in (sheet.charts! as ChartCollection).innerList) {
      sheet.workbook.chartCount++;
      final XmlBuilder builder = XmlBuilder();
      builder.processing('xml', 'version="1.0"');
      builder.element('c:chartSpace', nest: () async {
        builder.attribute(
            'xmlns:a', 'http://schemas.openxmlformats.org/drawingml/2006/main');
        builder.attribute('xmlns:r',
            'http://schemas.openxmlformats.org/officeDocument/2006/relationships');
        builder.attribute('xmlns:c',
            'http://schemas.openxmlformats.org/drawingml/2006/chart');

        if (chart._hasPlotArea) {
          builder.element('c:roundedCorners', nest: () async {
            builder.attribute('val', 0);
          });
        }
        builder.element('c:chart', nest: () async {
          if (chart.hasTitle) {
            _serializeTitleAsync(builder, chart.chartTitleArea);
          }
          if (chart._is3DChart) {
            _serializeView3DAsync(builder, chart);
          }
          _serializePlotAreaAsync(builder, chart);
          if (chart.series.count > 0 && chart.hasLegend) {
            _serializeLegendAsync(builder, chart.legend!);
          }
          builder.element('c:plotVisOnly', nest: () async {
            builder.attribute('val', '1');
          });
          builder.element('c:dispBlanksAs', nest: () async {
            builder.attribute('val', 'gap');
          });
        });
        _serializeFillAsync(
            builder, chart.linePattern, chart.linePatternColor, false);
        _serializePrinterSettingsAsync(builder, chart);
      });
      final String stringXml = builder.buildDocument().copy().toString();
      final List<int> bytes = utf8.encode(stringXml);
      _addToArchiveAsync(
          bytes, 'xl/charts/chart${sheet.workbook.chartCount}.xml');
    }
  }

  /// serializes chart's legend.
  Future<void> _serializeLegendAsync(
      XmlBuilder builder, ChartLegend chartLegend) async {
    builder.element('c:legend', nest: () async {
      builder.element('c:legendPos', nest: () async {
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
        _serializeDefaultTextAreaPropertiesAsync(builder, chartLegend.textArea);
      }
      builder.element('c:layout', nest: () async {});
      builder.element('c:overlay', nest: () async {
        builder.attribute('val', 0);
      });
      builder.element('c:spPr', nest: () async {});
    });
  }

  /// serializes chart's drawing.
  Future<void> _serializeChartDrawingAsync(
      XmlBuilder builder, Worksheet sheet) async {
    for (final Chart chart in (sheet.charts! as ChartCollection).innerList) {
      builder.element('xdr:twoCellAnchor', nest: () async {
        builder.attribute('editAs', 'twoCell');
        builder.element('xdr:from', nest: () async {
          builder.element('xdr:col',
              nest: chart.leftColumn > 0 ? chart.leftColumn - 1 : 0);
          builder.element('xdr:colOff', nest: 0);
          builder.element('xdr:row',
              nest: chart.topRow > 0 ? chart.topRow - 1 : 0);
          builder.element('xdr:rowOff', nest: 0);
        });

        builder.element('xdr:to', nest: () async {
          builder.element('xdr:col',
              nest: chart.rightColumn > 0
                  ? chart.rightColumn - 1
                  : chart.leftColumn + 7);
          builder.element('xdr:colOff', nest: 0);
          builder.element('xdr:row',
              nest: chart.bottomRow > 0
                  ? chart.bottomRow - 1
                  : chart.topRow + 15);
          builder.element('xdr:rowOff', nest: 0);
        });

        builder.element('xdr:graphicFrame', nest: () async {
          builder.attribute('macro', '');
          builder.element('xdr:nvGraphicFramePr', nest: () async {
            builder.element('xdr:cNvPr', nest: () async {
              builder.attribute(
                  'id', 1024 + sheet.workbook.chartCount + chart.index);
              builder.attribute(
                  'name', 'Chart ${sheet.workbook.chartCount + chart.index}');
            });
            builder.element('xdr:cNvGraphicFramePr', nest: () async {});
          });
          builder.element('xdr:xfrm', nest: () async {
            builder.element('a:off', nest: () async {
              builder.attribute('x', '0');
              builder.attribute('y', 0);
            });
            builder.element('a:ext', nest: () async {
              builder.attribute('cx', '0');
              builder.attribute('cy', 0);
            });
          });
          builder.element('a:graphic', nest: () async {
            builder.element('a:graphicData', nest: () async {
              builder.attribute('uri',
                  'http://schemas.openxmlformats.org/drawingml/2006/chart');

              builder.element('c:chart', nest: () async {
                builder.attribute('p7:id', 'rId${chart.index}');
                builder.attribute('xmlns:p7',
                    'http://schemas.openxmlformats.org/officeDocument/2006/relationships');
                builder.attribute('xmlns:c',
                    'http://schemas.openxmlformats.org/drawingml/2006/chart');
              });
            });
          });
        });
        builder.element('xdr:clientData', nest: () async {});
      });
    }
  }

  /// serialize default text area properties.
  Future<void> _serializeDefaultTextAreaPropertiesAsync(
      XmlBuilder builder, ChartTextArea textArea) async {
    builder.element('c:txPr', nest: () async {
      builder.element('a:bodyPr ', nest: () async {});
      builder.element('a:lstStyle ', nest: () async {});
      builder.element('a:p', nest: () async {
        builder.element('a:pPr', nest: () async {
          builder.element('a:defRPr', nest: () async {
            final double size = textArea.size * 100;
            builder.attribute('sz', size.toInt().toString());
            builder.attribute('b', textArea.bold ? '1' : '0');
            builder.attribute('i', textArea.italic ? '1' : '0');
            if (textArea.color != '' && textArea.color != 'FF000000') {
              builder.element('a:solidFill', nest: () async {
                builder.element('a:srgbClr', nest: () async {
                  builder.attribute('val', textArea.color.replaceAll('#', ''));
                });
              });
            }
            builder.element('a:latin', nest: () async {
              builder.attribute('typeface', textArea.fontName);
            });
            builder.element('a:cs', nest: () async {
              builder.attribute('typeface', textArea.fontName);
            });
          });
        });
        builder.element('a:endParaRPr', nest: () async {
          builder.attribute('lang', 'en-US');
        });
      });
    });
  }

  /// serialize printer settings of charts
  Future<void> _serializePrinterSettingsAsync(
      XmlBuilder builder, Chart chart) async {
    builder.element('c:printSettings', nest: () async {
      builder.element('c:headerFooter', nest: () async {
        builder.attribute('scaleWithDoc', '1');
        builder.attribute('alignWithMargins', '0');
        builder.attribute('differentFirst', '0');
        builder.attribute('differentOddEven', '0');
      });
      builder.element('c:pageMargins', nest: () async {
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
  Future<void> _serializeTitleAsync(
      XmlBuilder builder, ChartTextArea chartTextArea) async {
    builder.element('c:title', nest: () async {
      if (chartTextArea._hasText) {
        builder.element('c:tx', nest: () async {
          builder.element('c:rich', nest: () async {
            builder.element('a:bodyPr ', nest: () async {});
            builder.element('a:lstStyle', nest: () async {});
            builder.element('a:p', nest: () async {
              builder.element('a:pPr', nest: () async {
                builder.attribute('algn', 'ctr');
                builder.element('a:defRPr', nest: () async {});
              });
              builder.element('a:r', nest: () async {
                _serializeParagraphRunPropertiesAsync(builder, chartTextArea);
                builder.element('a:t', nest: () async {
                  builder.text(chartTextArea.text!);
                });
              });
            });
          });
        });
      }
      builder.element('c:layout', nest: () async {});
      builder.element('c:overlay', nest: () async {
        builder.attribute('val', chartTextArea._overlay ? '1' : '0');
      });
      _serializeFillAsync(builder, ExcelChartLinePattern.none, null, false);
    });
  }

  /// serialize paragraph run properties.
  Future<void> _serializeParagraphRunPropertiesAsync(
      XmlBuilder builder, ChartTextArea textArea) async {
    builder.element('a:rPr', nest: () async {
      builder.attribute('lang', 'en-US');
      final double size = textArea.size * 100;
      builder.attribute('sz', size.toInt().toString());
      builder.attribute('b', textArea.bold ? '1' : '0');
      builder.attribute('i', textArea.italic ? '1' : '0');
      builder.attribute('baseline', '0');
      if (textArea.color != '' && textArea.color != 'FF000000') {
        builder.element('a:solidFill', nest: () async {
          builder.element('a:srgbClr', nest: () async {
            builder.attribute('val', textArea.color.replaceAll('#', ''));
          });
        });
      }
      builder.element('a:latin', nest: () async {
        builder.attribute('typeface', textArea.fontName);
      });
      builder.element('a:ea', nest: () async {
        builder.attribute('typeface', textArea.fontName);
      });
      builder.element('a:cs', nest: () async {
        builder.attribute('typeface', textArea.fontName);
      });
    });
  }

  /// serialize plotarea of the chart
  Future<void> _serializePlotAreaAsync(XmlBuilder builder, Chart chart) async {
    builder.element('c:plotArea', nest: () async {
      builder.element('c:layout', nest: () async {});
      if (chart._series.count > 0) {
        _serializeMainChartTypeTagAsync(builder, chart);
      } else {
        _serializeEmptyChartAsync(builder, chart);
        _serializeAxesAsync(builder, chart);
      }
      _serializeFillAsync(builder, chart.plotArea.linePattern,
          chart.plotArea.linePatternColor, false);
    });
  }

  /// serializes main chart tag.
  Future<void> _serializeMainChartTypeTagAsync(
      XmlBuilder builder, Chart chart) async {
    switch (chart.chartType) {
      case ExcelChartType.column:
      case ExcelChartType.columnStacked:
      case ExcelChartType.columnStacked100:
      case ExcelChartType.bar:
      case ExcelChartType.barStacked:
      case ExcelChartType.barStacked100:
        _serializeBarChartAsync(builder, chart);
        break;

      case ExcelChartType.line:
      case ExcelChartType.lineStacked:
      case ExcelChartType.lineMarkers:
      case ExcelChartType.lineStacked100:
      case ExcelChartType.lineMarkersStacked:
      case ExcelChartType.lineMarkersStacked100:
        _serializeLineChartAsync(builder, chart);
        break;

      case ExcelChartType.area:
      case ExcelChartType.areaStacked:
      case ExcelChartType.areaStacked100:
        _serializeAreaChartAsync(builder, chart);
        break;

      case ExcelChartType.pie:
        _serializePieChartAsync(builder, chart);
        break;

      case ExcelChartType.pieBar:
      case ExcelChartType.pieOfPie:
        _serializeOfPieChartAsync(builder, chart);
        break;
      case ExcelChartType.pie3D:
        _serializeOfPie3DChartAsync(builder, chart);
        break;
      case ExcelChartType.line3D:
        _serializeLine3DChartAsync(builder, chart);
        break;
      case ExcelChartType.barStacked1003D:
      case ExcelChartType.barStacked3D:
      case ExcelChartType.barClustered3D:
      case ExcelChartType.columnClustered3D:
      case ExcelChartType.columnStacked3D:
      case ExcelChartType.columnStacked1003D:
      case ExcelChartType.column3D:
        _serializeBar3DChartAsync(builder, chart);
        break;

      case ExcelChartType.stockHighLowClose:
      case ExcelChartType.stockOpenHighLowClose:
      case ExcelChartType.stockVolumeHighLowClose:
      case ExcelChartType.stockVolumeOpenHighLowClose:
        _serializeStockChartAsync(builder, chart);
        break;
      case ExcelChartType.doughnut:
      case ExcelChartType.doughnutExploded:
        _serializedoughnutchartAsync(builder, chart);
        break;
    }
  }

  /// serializes Line chart.
  Future<void> _serializeLineChartAsync(XmlBuilder builder, Chart chart) async {
    final ExcelChartType type = chart.series[0]._serieType;
    builder.element('c:lineChart', nest: () async {
      _serializeChartGroupingAsync(builder, chart);
      builder.element('c:varyColors', nest: () async {
        builder.attribute('val', 0);
      });
      for (int i = 0; i < chart.series.count; i++) {
        final ChartSerie firstSerie = chart.series[i];
        _serializeSerieAsync(builder, firstSerie);
      }
      if (type == ExcelChartType.lineMarkers ||
          type == ExcelChartType.lineMarkersStacked ||
          type == ExcelChartType.lineMarkersStacked100) {
        builder.element('c:marker', nest: () async {
          builder.attribute('val', 1);
        });
      }
      builder.element('c:axId', nest: () async {
        builder.attribute('val', 59983360);
      });
      builder.element('c:axId', nest: () async {
        builder.attribute('val', 57253888);
      });
    });
    _serializeAxesAsync(builder, chart);
  }

  /// serializes Bar/ColumnClustered chart.
  Future<void> _serializeBarChartAsync(XmlBuilder builder, Chart chart) async {
    late int gapwidth;
    builder.element('c:barChart', nest: () async {
      final String strDirection =
          chart.chartType.toString().contains('bar') ? 'bar' : 'col';
      builder.element('c:barDir', nest: () async {
        builder.attribute('val', strDirection);
      });
      _serializeChartGroupingAsync(builder, chart);
      builder.element('c:varyColors', nest: () async {
        builder.attribute('val', 0);
      });
      for (int i = 0; i < chart.series.count; i++) {
        final ChartSerie firstSerie = chart.series[i];
        _serializeSerieAsync(builder, firstSerie);
        gapwidth = firstSerie.serieFormat.commonSerieOptions.gapWidth;
      }
      builder.element('c:gapWidth', nest: () async {
        builder.attribute('val', gapwidth);
      });
      if (chart._getIsStacked(chart.chartType) ||
          chart._getIs100(chart.chartType)) {
        builder.element('c:overlap', nest: () async {
          builder.attribute('val', '100');
        });
      }
      builder.element('c:axId', nest: () async {
        builder.attribute('val', 59983360);
      });
      builder.element('c:axId', nest: () async {
        builder.attribute('val', 57253888);
      });
    });
    _serializeAxesAsync(builder, chart);
  }

  /// serializes Area chart.
  Future<void> _serializeAreaChartAsync(XmlBuilder builder, Chart chart) async {
    builder.element('c:areaChart', nest: () async {
      _serializeChartGroupingAsync(builder, chart);
      builder.element('c:varyColors', nest: () async {
        builder.attribute('val', 0);
      });
      for (int i = 0; i < chart.series.count; i++) {
        final ChartSerie firstSerie = chart.series[i];
        _serializeSerieAsync(builder, firstSerie);
      }
      builder.element('c:axId', nest: () async {
        builder.attribute('val', 59983360);
      });
      builder.element('c:axId', nest: () async {
        builder.attribute('val', 57253888);
      });
    });
    _serializeAxesAsync(builder, chart);
  }

  ///   serialize chart grouping.
  Future<void> _serializeChartGroupingAsync(
      XmlBuilder builder, Chart chart) async {
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
    builder.element('c:grouping', nest: () async {
      builder.attribute('val', strGrouping);
    });
  }

  /// serializes pie chart.
  Future<void> _serializePieChartAsync(XmlBuilder builder, Chart chart) async {
    builder.element('c:pieChart', nest: () async {
      builder.element('c:varyColors', nest: () async {
        builder.attribute('val', 1);
      });
      for (int i = 0; i < chart.series.count; i++) {
        final ChartSerie firstSerie = chart.series[i];
        _serializeSerieAsync(builder, firstSerie);
      }
      builder.element('c:firstSliceAng', nest: () async {
        builder.attribute('val', 0);
      });
    });
  }

  /// serializes series of chart.
  Future<void> _serializeSerieAsync(
      XmlBuilder builder, ChartSerie firstSerie) async {
    final ExcelChartType type = firstSerie._serieType;
    builder.element('c:ser', nest: () async {
      builder.element('c:idx', nest: () async {
        builder.attribute('val', firstSerie._index);
      });
      builder.element('c:order', nest: () async {
        builder.attribute('val', firstSerie._index);
      });
      if (firstSerie._isDefaultName) {
        builder.element('c:tx', nest: () async {
          final String strName = firstSerie._nameOrFormula;
          if (strName.isNotEmpty) {
            _serializeStringReferenceAsync(
                builder, strName, firstSerie, 'text', null);
          }
        });
      }

      if (firstSerie.serieFormat.pieExplosionPercent != 0 ||
          (type == ExcelChartType.doughnutExploded &&
              firstSerie._chart.series.count == 1)) {
        builder.element('c:explosion', nest: () async {
          builder.attribute('val', firstSerie.serieFormat.pieExplosionPercent);
        });
      }
      if (type == ExcelChartType.stockOpenHighLowClose ||
          type == ExcelChartType.stockVolumeHighLowClose ||
          type == ExcelChartType.stockVolumeOpenHighLowClose) {
        builder.element('c:spPr', nest: () async {
          builder.element('a:ln', nest: () async {
            builder.element('a:noFill', nest: () async {});
          });
        });
      } else if (type == ExcelChartType.stockHighLowClose) {
        if (firstSerie._index == 2) {
          builder.element('c:spPr', nest: () async {
            builder.element('a:ln', nest: () async {
              builder.attribute('w', '3175');
              builder.element('a:solidFill', nest: () async {
                builder.element('a:srgbClr', nest: () async {
                  builder.attribute('val', '000000');
                });
              });
              builder.element('a:prstDash', nest: () async {
                builder.attribute('val', 'solid');
              });
            });
          });
        } else {
          builder.element('c:spPr', nest: () async {
            builder.element('a:ln', nest: () async {
              builder.element('a:noFill', nest: () async {});
            });
          });
        }
      }
      if (firstSerie.linePattern != ExcelChartLinePattern.none) {
        _serializeFillAsync(
            builder, firstSerie.linePattern, firstSerie.linePatternColor, true);
      }

      _serializeMarkerAsync(builder, firstSerie);

      if (firstSerie.dataLabels.isValue) {
        builder.element('c:dLbls', nest: () async {
          if (firstSerie.dataLabels.numberFormat != null &&
              firstSerie.dataLabels.numberFormat != '' &&
              firstSerie.dataLabels.numberFormat != 'General') {
            builder.element('c:numFmt', nest: () async {
              builder.attribute(
                  'formatCode', firstSerie.dataLabels.numberFormat);
              builder.attribute('sourceLinked', '0');
            });
          }
          builder.element('c:spPr', nest: () async {
            builder.element('a:noFill', nest: () async {});
            builder.element('a:ln', nest: () async {
              builder.element('a:noFill', nest: () async {});
            });
            builder.element('a:effectLst', nest: () async {});
          });
          final ChartTextArea textArea = firstSerie.dataLabels.textArea;
          _serializeChartTextAreaAsync(builder, textArea);
          builder.element('c:showLegendKey', nest: () async {
            builder.attribute('val', 0);
          });
          builder.element('c:showVal', nest: () async {
            builder.attribute('val', firstSerie.dataLabels.isValue ? 1 : 0);
          });
          builder.element('c:showCatName', nest: () async {
            builder.attribute(
                'val', firstSerie.dataLabels.isCategoryName ? 1 : 0);
          });
          builder.element('c:showSerName', nest: () async {
            builder.attribute(
                'val', firstSerie.dataLabels.isSeriesName ? 1 : 0);
          });
          builder.element('c:showPercent', nest: () async {
            builder.attribute('val', 0);
          });
          builder.element('c:showBubbleSize', nest: () async {
            builder.attribute('val', 0);
          });
          builder.element('c:showLeaderLines', nest: () async {
            builder.attribute('val', 0);
          });
        });
      }
      if (firstSerie._categoryLabels != null) {
        final Range firstRange = firstSerie._chart._worksheet.getRangeByIndex(
            firstSerie._categoryLabels!.row,
            firstSerie._categoryLabels!.column);
        builder.element('c:cat', nest: () async {
          Worksheet tempSheet = firstSerie._chart._worksheet;
          if (firstSerie._categoryLabels!.addressGlobal != '') {
            for (final Worksheet sheet
                in firstSerie._chart._worksheet.workbook.worksheets.innerList) {
              if (firstSerie._categoryLabels!.addressGlobal
                      .contains(RegExp('${sheet.name}!')) ||
                  firstSerie._categoryLabels!.addressGlobal
                      .contains(RegExp("${sheet.name}'!"))) {
                tempSheet = sheet;
                break;
              }
            }
          }
          if (firstRange.text == null && firstRange.number != null) {
            builder.element('c:numRef', nest: () async {
              builder.element('c:f',
                  nest: firstSerie._categoryLabels!.addressGlobal);
              final Range firstRange = firstSerie._chart._worksheet
                  .getRangeByIndex(firstSerie._categoryLabels!.row,
                      firstSerie._categoryLabels!.column);
              builder.element('c:numCache', nest: () async {
                if (firstRange.numberFormat != null &&
                    firstRange.numberFormat != 'General') {
                  builder.element('c:formatCode',
                      nest: firstRange.numberFormat);
                }
                _serializeNumCacheValuesAsync(builder, firstSerie, tempSheet);
              });
            });
          } else {
            _serializeStringReferenceAsync(
                builder,
                firstSerie._categoryLabels!.addressGlobal,
                firstSerie,
                'cat',
                tempSheet);
          }
        });
      }
      if (firstSerie._values != null) {
        builder.element('c:val', nest: () async {
          builder.element('c:numRef', nest: () async {
            builder.element('c:f', nest: firstSerie._values!.addressGlobal);
            final Range firstRange = firstSerie._chart._worksheet
                .getRangeByIndex(
                    firstSerie._values!.row, firstSerie._values!.column);
            Worksheet tempSheet = firstSerie._chart._worksheet;
            if (firstSerie._values!.addressGlobal != '') {
              for (final Worksheet sheet in firstSerie
                  ._chart._worksheet.workbook.worksheets.innerList) {
                if (firstSerie._values!.addressGlobal
                        .contains(RegExp('${sheet.name}!')) ||
                    firstSerie._values!.addressGlobal
                        .contains(RegExp("${sheet.name}'!"))) {
                  tempSheet = sheet;
                  break;
                }
              }
            }
            builder.element('c:numCache', nest: () async {
              if (firstRange.numberFormat != null &&
                  firstRange.numberFormat != 'General') {
                builder.element('c:formatCode', nest: firstRange.numberFormat);
              } else {
                builder.element('c:formatCode', nest: 'General');
              }
              _serializeNumCacheValuesAsync(builder, firstSerie, tempSheet);
            });
          });
        });
      }
      if (firstSerie._serieType.toString().contains('line') ||
          firstSerie._serieType.toString().contains('stock')) {
        builder.element('c:smooth', nest: () async {
          builder.attribute('val', 0);
        });
      }
    });
  }

  /// serializes chart text area.
  Future<void> _serializeChartTextAreaAsync(
      XmlBuilder builder, ChartTextArea textArea) async {
    builder.element('c:txPr', nest: () async {
      builder.element('a:bodyPr ', nest: () async {});
      builder.element('a:lstStyle', nest: () async {});
      builder.element('a:p', nest: () async {
        builder.element('a:pPr', nest: () async {
          builder.element('a:defRPr', nest: () async {
            final double size = textArea.size * 100;
            builder.attribute('sz', size.toInt().toString());
            builder.attribute('b', textArea.bold ? '1' : '0');
            builder.attribute('i', textArea.italic ? '1' : '0');
            builder.attribute('baseline', '0');
            if (textArea.color != '' && textArea.color != 'FF000000') {
              builder.element('a:solidFill', nest: () async {
                builder.element('a:srgbClr', nest: () async {
                  builder.attribute('val', textArea.color.replaceAll('#', ''));
                });
              });
            }
            builder.element('a:latin', nest: () async {
              builder.attribute('typeface', textArea.fontName);
            });
            builder.element('a:ea', nest: () async {
              builder.attribute('typeface', textArea.fontName);
            });
            builder.element('a:cs', nest: () async {
              builder.attribute('typeface', textArea.fontName);
            });
          });
        });
      });
    });
  }

  /// serializes number cache values.
  Future<void> _serializeNumCacheValuesAsync(
      XmlBuilder builder, ChartSerie firstSerie, Worksheet dataSheet) async {
    final Range? serieRange = firstSerie._values;
    if (serieRange != null) {
      final int count = serieRange.count;
      final int serieStartRow = serieRange.row;
      final int serieStartColumn = serieRange.column;
      builder.element('c:ptCount', nest: () async {
        builder.attribute('val', count);
      });
      int index = 0;
      while (index < count) {
        final double? value = dataSheet
            .getRangeByIndex(serieStartRow + index, serieStartColumn)
            .number;
        if (value != null) {
          builder.element('c:pt', nest: () async {
            builder.attribute('idx', index);
            builder.element('c:v', nest: value);
          });
        }
        index++;
      }
    }
  }

  /// serializes string cache reference.
  Future<void> _serializeStringReferenceAsync(XmlBuilder builder, String range,
      ChartSerie firstSerie, String tagName, Worksheet? dataSheet) async {
    builder.element('c:strRef', nest: () async {
      builder.element('c:f', nest: range);
      builder.element('c:strCache', nest: () async {
        if (tagName == 'cat') {
          _serializeCategoryTagCacheValuesAsync(builder, firstSerie, dataSheet);
        } else {
          _serializeTextTagCacheValuesAsync(builder, firstSerie);
        }
      });
    });
  }

  /// serializes catergory cache values.
  Future<void> _serializeCategoryTagCacheValuesAsync(
      XmlBuilder builder, ChartSerie firstSerie, Worksheet? dataSheet) async {
    final Range? serieRange = firstSerie._categoryLabels;
    if (serieRange != null) {
      final int count = serieRange.count;
      final int serieStartRow = serieRange.row;
      final int serieStartColumn = serieRange.column;
      builder.element('c:ptCount', nest: () async {
        builder.attribute('val', count);
      });
      int index = 0;
      while (index < count) {
        final String? value = dataSheet != null
            ? dataSheet
                .getRangeByIndex(serieStartRow + index, serieStartColumn)
                .text
            : '';
        if (value != null) {
          builder.element('c:pt', nest: () async {
            builder.attribute('idx', index);
            builder.element('c:v', nest: value);
          });
        }
        index++;
      }
    }
  }

  /// serializes text cache values.
  Future<void> _serializeTextTagCacheValuesAsync(
      XmlBuilder builder, ChartSerie firstSerie) async {
    builder.element('c:ptCount', nest: () async {
      builder.attribute('val', 1);
    });
    builder.element('c:pt', nest: () async {
      builder.attribute('idx', 0);
      if (firstSerie.name != null) {
        builder.element('c:v', nest: firstSerie.name);
      }
    });
  }

  /// serializes fill for the charts.
  Future<void> _serializeFillAsync(
      XmlBuilder builder,
      ExcelChartLinePattern linePattern,
      String? lineColor,
      bool hasSerie) async {
    builder.element('c:spPr', nest: () async {
      if (lineColor == null) {
        builder.element('a:solidFill', nest: () async {
          builder.element('a:srgbClr', nest: () async {
            builder.attribute('val', 'FFFFFF');
          });
        });
      }
      builder.element('a:ln', nest: () async {
        if (linePattern != ExcelChartLinePattern.none) {
          if (!hasSerie || lineColor != null) {
            builder.element('a:solidFill', nest: () async {
              builder.element('a:srgbClr', nest: () async {
                if (lineColor != null) {
                  builder.attribute('val', lineColor.replaceAll('#', ''));
                } else {
                  builder.attribute('val', '0070C0');
                }
              });
            });
          }
          if (linePattern != ExcelChartLinePattern.solid) {
            builder.element('a:prstDash', nest: () async {
              builder.attribute('val', _linePattern[linePattern]);
            });
          }
        } else {
          builder.element('a:noFill', nest: () async {});
        }
        builder.element('a:round', nest: () async {});
      });
    });
  }

  /// serializes axies of the series.
  Future<void> _serializeAxesAsync(XmlBuilder builder, Chart chart) async {
    if (chart._isCategoryAxisAvail) {
      _serializeCategoryAxisAsync(builder, chart.primaryCategoryAxis);
    }
    if (chart._isValueAxisAvail) {
      _serializeValueAxisAsync(builder, chart.primaryValueAxis);
    }
  }

  /// serializes empty charts.
  Future<void> _serializeEmptyChartAsync(
      XmlBuilder builder, Chart chart) async {
    builder.element('c:barChart', nest: () async {
      builder.element('c:barDir', nest: () async {
        builder.attribute('val', 'col');
      });
      builder.element('c:grouping', nest: () async {
        builder.attribute('val', 'clustered');
      });
      builder.element('c:varyColors', nest: () async {
        builder.attribute('val', 0);
      });
      _serializeEmptyChartDataLabelsAsync(builder);
      builder.element('c:gapWidth', nest: () async {
        builder.attribute('val', 150);
      });
      builder.element('c:axId', nest: () async {
        builder.attribute('val', 59983360);
      });
      builder.element('c:axId', nest: () async {
        builder.attribute('val', 57253888);
      });
    });
  }

  /// serializes category axis of the chart.
  Future<void> _serializeCategoryAxisAsync(
      XmlBuilder builder, ChartCategoryAxis axis) async {
    builder.element('c:catAx', nest: () async {
      builder.element('c:axId', nest: () async {
        builder.attribute('val', 59983360);
      });
      builder.element('c:scaling', nest: () async {
        builder.element('c:orientation', nest: () async {
          builder.attribute('val', 'minMax');
        });
      });
      builder.element('c:delete', nest: () async {
        builder.attribute('val', 0);
      });
      builder.element('c:axPos', nest: () async {
        builder.attribute('val', 'b');
      });
      if (axis._hasAxisTitle) {
        _serializeChartTextAreaAsync(builder, axis.titleArea);
      }
      if (axis.numberFormat != '' && axis.numberFormat != 'General') {
        builder.element('c:numFmt', nest: () async {
          builder.attribute('formatCode', axis.numberFormat);
          builder.attribute('sourceLinked', '0');
        });
      }
      builder.element('c:majorTickMark', nest: () async {
        builder.attribute('val', 'out');
      });
      builder.element('c:minorTickMark', nest: () async {
        builder.attribute('val', 'none');
      });
      builder.element('c:tickLblPos', nest: () async {
        builder.attribute('val', 'nextTo');
      });
      builder.element('c:spPr', nest: () async {
        builder.element('a:ln', nest: () async {});
      });
      builder.element('c:crossAx', nest: () async {
        builder.attribute('val', 57253888);
      });
      builder.element('c:crosses', nest: () async {
        builder.attribute('val', 'autoZero');
      });
      builder.element('c:auto', nest: () async {
        builder.attribute('val', 1);
      });
      builder.element('c:lblAlgn', nest: () async {
        builder.attribute('val', 'ctr');
      });
      builder.element('c:lblOffset', nest: () async {
        builder.attribute('val', 100);
      });
      builder.element('c:noMultiLvlLbl', nest: () async {
        builder.attribute('val', 0);
      });
      builder.element('c:tickMarkSkip', nest: () async {
        builder.attribute('val', 1);
      });
    });
  }

  /// serializes Value axis of the chart.
  Future<void> _serializeValueAxisAsync(
      XmlBuilder builder, ChartValueAxis axis) async {
    builder.element('c:valAx', nest: () async {
      builder.element('c:axId', nest: () async {
        builder.attribute('val', 57253888);
      });
      builder.element('c:scaling', nest: () async {
        builder.element('c:orientation', nest: () async {
          builder.attribute('val', 'minMax');
        });
        if (!axis._isAutoMax) {
          builder.element('c:max', nest: () async {
            builder.attribute('val', axis.maximumValue);
          });
        }
        if (axis._isAutoMin) {
          builder.element('c:min', nest: () async {
            builder.attribute('val', axis.minimumValue);
          });
        }
      });
      builder.element('c:delete', nest: () async {
        builder.attribute('val', '0');
      });
      builder.element('c:axPos', nest: () async {
        builder.attribute('val', 'l');
      });
      if (axis._hasAxisTitle) {
        _serializeChartTextAreaAsync(builder, axis.titleArea);
      }
      if (axis.numberFormat != '' && axis.numberFormat != 'General') {
        builder.element('c:numFmt', nest: () async {
          builder.attribute('formatCode', axis.numberFormat);
          builder.attribute('sourceLinked', '0');
        });
      }
      if (axis.hasMajorGridLines) {
        builder.element('c:majorGridlines', nest: () async {});
      }
      builder.element('c:majorTickMark', nest: () async {
        builder.attribute('val', 'out');
      });
      builder.element('c:minorTickMark', nest: () async {
        builder.attribute('val', 'none');
      });
      builder.element('c:tickLblPos', nest: () async {
        builder.attribute('val', 'nextTo');
      });
      builder.element('c:spPr', nest: () async {
        builder.element('a:ln', nest: () async {});
      });
      builder.element('c:crossAx', nest: () async {
        builder.attribute('val', 59983360);
      });
      builder.element('c:crosses', nest: () async {
        builder.attribute('val', 'autoZero');
      });
      final Chart chart = axis._parentChart;
      final String strCrossBetween =
          chart.primaryCategoryAxis._isBetween ? 'between' : 'midCat';
      builder.element('c:crossBetween', nest: () async {
        builder.attribute('val', strCrossBetween);
      });
    });
  }

  /// serializes empty chart's datalabels.
  Future<void> _serializeEmptyChartDataLabelsAsync(XmlBuilder builder) async {
    builder.element('c:dLbls', nest: () async {
      builder.element('c:showLegendKey', nest: () async {
        builder.attribute('val', 0);
      });
      builder.element('c:showVal', nest: () async {
        builder.attribute('val', 0);
      });
      builder.element('c:showCatName', nest: () async {
        builder.attribute('val', 0);
      });
      builder.element('c:showSerName', nest: () async {
        builder.attribute('val', 0);
      });
      builder.element('c:showPercent', nest: () async {
        builder.attribute('val', 0);
      });
      builder.element('c:showBubbleSize', nest: () async {
        builder.attribute('val', 0);
      });
    });
  }

  /// Add the workbook data with filename to ZipArchive.
  Future<void> _addToArchiveAsync(List<int> data, String fileName) async {
    final ArchiveFile item = ArchiveFile(fileName, data.length, data);
    _workbook.archive.addFile(item);
  }

  /// Serialize line 3D Chart.
  Future<void> _serializeLine3DChartAsync(
      XmlBuilder builder, Chart chart) async {
    late int gapdepth;
    builder.element('c:line3DChart', nest: () async {
      _serializeChartGroupingAsync(builder, chart);
      builder.element('c:varyColors', nest: () async {
        builder.attribute('val', 0);
      });
      for (int i = 0; i < chart.series.count; i++) {
        final ChartSerie firstSerie = chart.series[i];
        _serializeSerieAsync(builder, firstSerie);
        gapdepth = firstSerie.serieFormat.commonSerieOptions.gapDepth;
      }
      builder.element('c:gapDepth', nest: () async {
        builder.attribute('val', gapdepth);
      });
      builder.element('c:axId', nest: () async {
        builder.attribute('val', 59983360);
      });
      builder.element('c:axId', nest: () async {
        builder.attribute('val', 57253888);
      });
      builder.element('c:axId', nest: () async {
        builder.attribute('val', 63149376);
      });
    });
    _serializeAxesAsync(builder, chart);
  }

  ///Serialize view 3D
  Future<void> _serializeView3DAsync(XmlBuilder builder, Chart chart) async {
    final ChartSeriesCollection firstSerie = chart.series;

    builder.element('c:view3D', nest: () async {
      if (!chart._isdefaultElevation) {
        builder.element('c:rotX', nest: () async {
          builder.attribute('val', chart.elevation);
        });
      }
      if (firstSerie._innerList[0]._serieType == ExcelChartType.pie3D) {
        for (int i = 0; i < chart.series.count; i++) {
          chart.rotation =
              chart.series[i].serieFormat.commonSerieOptions.firstSliceAngle;
        }
      }
      if (!chart._isDefaultRotation) {
        builder.element('c:rotY', nest: () async {
          builder.attribute('val', chart.rotation);
        });
      }
      builder.element('c:depthPercent', nest: () async {
        builder.attribute('val', chart.depthPercent);
      });
      builder.element('c:rAngAx', nest: () async {
        int defaultValue = 0;

        if (chart.rightAngleAxes || chart._isColumnOrBar) {
          defaultValue = 1;
        }

        builder.attribute('val', defaultValue);
      });
      builder.element('perspective', nest: () async {
        builder.attribute('val', chart.perspective * 2);
      });
    });
  }

  /// Serialize bar3D chart.
  Future<void> _serializeBar3DChartAsync(
      XmlBuilder builder, Chart chart) async {
    late int gapdepth;
    late int gapwidth;
    builder.element('c:bar3DChart', nest: () async {
      final String strDirection =
          chart.chartType.toString().contains('bar') ? 'bar' : 'col';

      builder.element('c:barDir', nest: () async {
        builder.attribute('val', strDirection);
      });

      _serializeChartGroupingAsync(builder, chart);
      builder.element('c:varyColors', nest: () async {
        builder.attribute('val', 0);
      });
      for (int i = 0; i < chart.series.count; i++) {
        final ChartSerie firstSerie = chart.series[i];
        _serializeSerieAsync(builder, firstSerie);
        gapdepth = firstSerie.serieFormat.commonSerieOptions.gapDepth;
        gapwidth = firstSerie.serieFormat.commonSerieOptions.gapWidth;
      }

      builder.element('c:gapWidth', nest: () async {
        builder.attribute('val', gapwidth);
      });
      builder.element('c:gapDepth', nest: () async {
        builder.attribute('val', gapdepth);
      });
      builder.element('c:axId', nest: () async {
        builder.attribute('val', 59983360);
      });
      builder.element('c:axId', nest: () async {
        builder.attribute('val', 57253888);
      });
    });
    _serializeAxesAsync(builder, chart);
  }

  // Serializes pie of pie or pie of bar chart.
  Future<void> _serializeOfPieChartAsync(
      XmlBuilder builder, Chart chart) async {
    late int gapwidth;
    late int pieSecondSize;
    final ExcelChartType type = chart.series[0]._serieType;
    late String isPieOrBar;
    if (type == ExcelChartType.pieOfPie) {
      isPieOrBar = 'pie';
    } else if (type == ExcelChartType.pieBar) {
      isPieOrBar = 'bar';
    }
    builder.element('c:ofPieChart', nest: () async {
      builder.element('c:ofPieType', nest: () async {
        builder.attribute('val', isPieOrBar);
      });
      builder.element('c:varyColors', nest: () async {
        builder.attribute('val', 1);
      });

      for (int i = 0; i < chart.series.count; i++) {
        final ChartSerie firstSerie = chart.series[i];
        _serializeSerieAsync(builder, firstSerie);
        pieSecondSize = firstSerie.serieFormat.commonSerieOptions.pieSecondSize;
        gapwidth = firstSerie.serieFormat.commonSerieOptions.gapWidth;
      }

      builder.element('c:gapWidth', nest: () async {
        builder.attribute('val', gapwidth);
      });
      builder.element('c:secondPieSize', nest: () async {
        builder.attribute('val', pieSecondSize);
      });
      builder.element('c:serLines', nest: () async {
        builder.element('c:spPr', nest: () async {
          builder.element('a:ln', nest: () async {});
        });
      });
    });
  }

  ///Serialize pie 3D chart.
  Future<void> _serializeOfPie3DChartAsync(
      XmlBuilder builder, Chart chart) async {
    builder.element('c:pie3DChart', nest: () async {
      builder.element('c:varyColors', nest: () async {
        builder.attribute('val', 1);
      });
      for (int i = 0; i < chart.series.count; i++) {
        final ChartSerie firstSerie = chart.series[i];
        _serializeSerieAsync(builder, firstSerie);
      }
    });
  }

  /// Serializes stock chart.
  Future<void> _serializeStockChartAsync(
      XmlBuilder builder, Chart chart) async {
    final ExcelChartType type = chart.series.innerList[0]._serieType;
    if (type == ExcelChartType.stockVolumeOpenHighLowClose ||
        type == ExcelChartType.stockVolumeHighLowClose) {
      builder.element('c:barChart', nest: () async {
        builder.element('c:barDir', nest: () async {
          builder.attribute('val', 'col');
        });
        builder.element('c:grouping', nest: () async {
          builder.attribute('val', 'clustered');
        });

        builder.element('c:varyColors', nest: () async {
          builder.attribute('val', 0);
        });

        final ChartSerie firstSerie = chart.series[0];
        _serializeSerieAsync(builder, firstSerie);

        builder.element('c:gapWidth', nest: () async {
          builder.attribute(
              'val', firstSerie.serieFormat.commonSerieOptions.gapWidth);
        });
        builder.element('c:axId', nest: () async {
          builder.attribute('val', 59983360);
        });
        builder.element('c:axId', nest: () async {
          builder.attribute('val', 57253888);
        });
      });
    }
    builder.element('c:stockChart', nest: () async {
      if (type == ExcelChartType.stockHighLowClose ||
          type == ExcelChartType.stockOpenHighLowClose) {
        for (int i = 0; i < chart.series.count; i++) {
          final ChartSerie firstSerie = chart.series[i];
          _serializeSerieAsync(builder, firstSerie);
        }
      } else if (type == ExcelChartType.stockVolumeHighLowClose ||
          type == ExcelChartType.stockVolumeOpenHighLowClose) {
        for (int i = 0; i < chart.series.count; i++) {
          if ((type == ExcelChartType.stockVolumeOpenHighLowClose ||
                  type == ExcelChartType.stockVolumeHighLowClose) &&
              chart.series.innerList[0] != chart.series.innerList[i]) {
            final ChartSerie firstSerie = chart.series[i];
            _serializeSerieAsync(builder, firstSerie);
          }
        }
      }

      builder.element('c:hiLowLines', nest: () async {
        builder.element('c:spPr', nest: () async {
          builder.element('a:ln', nest: () async {
            builder.element('a:solidFill', nest: () async {
              builder.element('a:srgbClr', nest: () async {
                builder.attribute('val', '000000');
              });
            });
            builder.element('a:prstDash', nest: () async {
              builder.attribute('val', 'solid');
            });
          });
        });
      });
      if (type == ExcelChartType.stockOpenHighLowClose ||
          type == ExcelChartType.stockVolumeOpenHighLowClose) {
        builder.element('c:upDownBars', nest: () async {
          builder.element('c:gapWidth', nest: () async {
            builder.attribute('val', '100');
          });
          builder.element('c:upBars', nest: () async {
            builder.element('c:spPr', nest: () async {
              builder.element('a:solidFill', nest: () async {
                builder.element('a:srgbClr', nest: () async {
                  builder.attribute('val', 'FFFFFF');
                });
              });
            });
          });
          builder.element('c:downBars', nest: () async {
            builder.element('c:spPr', nest: () async {
              builder.element('a:solidFill', nest: () async {
                builder.element('a:srgbClr', nest: () async {
                  builder.attribute('val', '000000');
                });
              });
            });
          });
        });
      }
      if (chart.series[0].serieFormat.markerStyle !=
          ExcelChartMarkerType.none) {
        builder.element('c:marker', nest: () async {
          builder.attribute('val', 1);
        });
      }

      builder.element('c:axId', nest: () async {
        builder.attribute('val', 62908672);
      });
      builder.element('c:axId', nest: () async {
        builder.attribute('val', 61870848);
      });
    });
    if (type == ExcelChartType.stockVolumeOpenHighLowClose ||
        type == ExcelChartType.stockVolumeHighLowClose) {
      _serializeAxesforStockChartAsync(
          builder, chart, 59983360, 57253888, true);
      _serializeAxesforStockChartAsync(
          builder, chart, 62908672, 61870848, false);
    } else {
      _serializeAxesforStockChartAsync(
          builder, chart, 62908672, 61870848, true);
    }
  }

  ///serialize stock axes
  Future<void> _serializeAxesforStockChartAsync(XmlBuilder builder, Chart chart,
      int axisId, int crossAx, bool isBar) async {
    if (chart._isCategoryAxisAvail) {
      _serializeCategoryAxisForStockAsync(
          builder, chart.primaryCategoryAxis, axisId, crossAx, isBar);
    }
    if (chart._isValueAxisAvail) {
      _serializeValueAxisForStockchartAsync(
          builder, chart.primaryCategoryAxis, axisId, crossAx, isBar);
    }
  }

  ///Serialize catogory axis for stock chart
  Future<void> _serializeCategoryAxisForStockAsync(XmlBuilder builder,
      ChartCategoryAxis axis, int axisId, int crossAx, bool isBar) async {
    builder.element('c:catAx', nest: () async {
      builder.element('c:axId', nest: () async {
        builder.attribute('val', axisId);
      });
      builder.element('c:scaling', nest: () async {
        builder.element('c:orientation', nest: () async {
          builder.attribute('val', 'minMax');
        });
      });
      int delete = 0;
      String axpos = 'b';
      if (!isBar) {
        delete = 1;
        axpos = 't';
      }
      builder.element('c:delete', nest: () async {
        builder.attribute('val', delete);
      });
      builder.element('c:axPos', nest: () async {
        builder.attribute('val', axpos);
      });
      if (axis._hasAxisTitle) {
        _serializeChartTextAreaAsync(builder, axis.titleArea);
      }
      if (axis.numberFormat != '' && axis.numberFormat != 'General') {
        builder.element('c:numFmt', nest: () async {
          builder.attribute('formatCode', axis.numberFormat);
          builder.attribute('sourceLinked', '0');
        });
      }
      builder.element('c:majorTickMark', nest: () async {
        builder.attribute('val', 'out');
      });
      builder.element('c:minorTickMark', nest: () async {
        builder.attribute('val', 'none');
      });
      builder.element('c:tickLblPos', nest: () async {
        builder.attribute('val', 'nextTo');
      });
      builder.element('c:spPr', nest: () async {
        builder.element('a:ln', nest: () async {
          if (!isBar) {
            builder.attribute('w', 12700);
          }
        });
      });
      builder.element('c:crossAx', nest: () async {
        builder.attribute('val', crossAx);
      });
      builder.element('c:crosses', nest: () async {
        builder.attribute('val', 'autoZero');
      });
      builder.element('c:auto', nest: () async {
        builder.attribute('val', 1);
      });
      builder.element('c:lblAlgn', nest: () async {
        builder.attribute('val', 'ctr');
      });
      builder.element('c:lblOffset', nest: () async {
        builder.attribute('val', 100);
      });
      builder.element('c:noMultiLvlLbl', nest: () async {
        builder.attribute('val', 0);
      });
      builder.element('c:tickMarkSkip', nest: () async {
        builder.attribute('val', 1);
      });
    });
  }

  ///Serialize value axis for stock chart
  Future<void> _serializeValueAxisForStockchartAsync(XmlBuilder builder,
      ChartCategoryAxis axis, int axisId, int crossAx, bool isBar) async {
    builder.element('c:valAx', nest: () async {
      builder.element('c:axId', nest: () async {
        builder.attribute('val', crossAx);
      });
      builder.element('c:scaling', nest: () async {
        builder.element('c:orientation', nest: () async {
          builder.attribute('val', 'minMax');
        });
        if (!axis._isAutoMax) {
          builder.element('c:max', nest: () async {
            builder.attribute('val', axis.maximumValue);
          });
        }
        if (axis._isAutoMin) {
          builder.element('c:min', nest: () async {
            builder.attribute('val', axis.minimumValue);
          });
        }
      });
      builder.element('c:delete', nest: () async {
        builder.attribute('val', '0');
      });
      String axpos = 'l';

      if (!isBar) {
        axpos = 'r';
      }

      builder.element('c:axPos', nest: () async {
        builder.attribute('val', axpos);
      });

      if (axpos == 'l') {
        builder.element('c:majorGridlines', nest: () async {});
      }

      if (axis._hasAxisTitle) {
        _serializeChartTextAreaAsync(builder, axis.titleArea);
      }
      if (axis.numberFormat != '' && axis.numberFormat != 'General') {
        builder.element('c:numFmt', nest: () async {
          builder.attribute('formatCode', axis.numberFormat);
          builder.attribute('sourceLinked', '0');
        });
      }
      if (axis.hasMajorGridLines) {
        builder.element('c:majorGridlines', nest: () async {});
      }
      builder.element('c:majorTickMark', nest: () async {
        builder.attribute('val', 'out');
      });
      builder.element('c:minorTickMark', nest: () async {
        builder.attribute('val', 'none');
      });
      builder.element('c:tickLblPos', nest: () async {
        builder.attribute('val', 'nextTo');
      });
      builder.element('c:spPr', nest: () async {
        builder.element('a:ln', nest: () async {});
      });
      builder.element('c:crossAx', nest: () async {
        builder.attribute('val', axisId);
      });
      String crosses = 'autoZero';
      if (!isBar) {
        crosses = 'max';
      }
      builder.element('c:crosses', nest: () async {
        builder.attribute('val', crosses);
      });
      final Chart chart = axis._parentChart;
      final String strCrossBetween =
          chart.primaryCategoryAxis._isBetween ? 'between' : 'midCat';
      builder.element('c:crossBetween', nest: () async {
        builder.attribute('val', strCrossBetween);
      });
    });
  }

  ///Serialize doughnut/doughnut_exploded charts
  Future<void> _serializedoughnutchartAsync(
      XmlBuilder builder, Chart chart) async {
    late int doughnutHoleSize;
    late int firstSliceAngle;

    builder.element('c:doughnutChart', nest: () async {
      builder.element('c:varyColors', nest: () async {
        builder.attribute('val', 1);
      });

      for (int i = 0; i < chart.series.count; i++) {
        final ChartSerie firstSerie = chart.series[i];
        _serializeSerieAsync(builder, firstSerie);
        firstSliceAngle =
            firstSerie.serieFormat.commonSerieOptions.firstSliceAngle;
        doughnutHoleSize =
            firstSerie.serieFormat.commonSerieOptions.holeSizePercent;
      }
      builder.element('c:firstSliceAng', nest: () async {
        builder.attribute('val', firstSliceAngle);
      });
      builder.element('c:holeSize', nest: () async {
        builder.attribute('val', doughnutHoleSize);
      });
    });
  }

  ///Serialize marker for stock and line charts
  Future<void> _serializeMarkerAsync(
      XmlBuilder builder, ChartSerie firstSerie) async {
    final ExcelChartType type = firstSerie._serieType;

    if ((firstSerie.serieFormat.markerStyle == ExcelChartMarkerType.none) &&
        (type == ExcelChartType.line ||
            type == ExcelChartType.lineStacked ||
            type == ExcelChartType.lineStacked100 ||
            type == ExcelChartType.stockHighLowClose ||
            type == ExcelChartType.stockVolumeOpenHighLowClose ||
            type == ExcelChartType.stockVolumeHighLowClose ||
            type == ExcelChartType.stockOpenHighLowClose)) {
      builder.element('c:marker', nest: () async {
        builder.element('c:symbol', nest: () async {
          builder.attribute('val', 'none');
        });
      });
    } else if ((firstSerie.serieFormat.markerStyle ==
            ExcelChartMarkerType.none) &&
        (type == ExcelChartType.lineMarkers ||
            type == ExcelChartType.lineMarkersStacked ||
            type == ExcelChartType.lineMarkersStacked100)) {
      builder.element('c:marker', nest: () async {
        builder.element('c:symbol', nest: () async {
          builder.attribute('val', 'circle');
        });
        builder.element('c:size', nest: () async {
          builder.attribute('val', '5');
        });
      });
    } else if (firstSerie.serieFormat.markerStyle !=
        ExcelChartMarkerType.none) {
      final String markerBackgroundColor =
          firstSerie.serieFormat.markerBackgroundColor.replaceAll('#', '');
      final String markerBorderColor =
          firstSerie.serieFormat.markerBorderColor.replaceAll('#', '');
      late String exclMarkertype;
      if (firstSerie.serieFormat.markerStyle == ExcelChartMarkerType.diamond) {
        exclMarkertype = 'diamond';
      } else if (firstSerie.serieFormat.markerStyle ==
          ExcelChartMarkerType.circle) {
        exclMarkertype = 'circle';
      } else if (firstSerie.serieFormat.markerStyle ==
          ExcelChartMarkerType.xSquare) {
        exclMarkertype = 'x';
      } else if (firstSerie.serieFormat.markerStyle ==
          ExcelChartMarkerType.dowJones) {
        exclMarkertype = 'dot';
      } else if (firstSerie.serieFormat.markerStyle ==
          ExcelChartMarkerType.square) {
        exclMarkertype = 'square';
      } else if (firstSerie.serieFormat.markerStyle ==
          ExcelChartMarkerType.plusSign) {
        exclMarkertype = 'plus';
      } else if (firstSerie.serieFormat.markerStyle ==
          ExcelChartMarkerType.standardDeviation) {
        exclMarkertype = 'triangle';
      } else if (firstSerie.serieFormat.markerStyle ==
          ExcelChartMarkerType.starSquare) {
        exclMarkertype = 'star';
      }

      builder.element('c:marker', nest: () async {
        builder.element('c:symbol', nest: () async {
          builder.attribute('val', exclMarkertype);
        });
        builder.element('c:size', nest: () async {
          builder.attribute('val', '5');
        });
        builder.element('c:spPr', nest: () async {
          builder.element('a:solidFill', nest: () async {
            builder.element('a:srgbClr', nest: () async {
              builder.attribute('val', markerBackgroundColor);
            });
          });
          builder.element('a:ln', nest: () async {
            builder.element('a:solidFill', nest: () async {
              builder.element('a:srgbClr', nest: () async {
                builder.attribute('val', markerBorderColor);
              });
            });
          });
        });
      });
    }
  }
}
