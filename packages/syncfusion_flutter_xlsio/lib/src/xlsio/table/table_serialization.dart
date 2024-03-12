part of xlsio;

/// Represents the table serialize class.
class _TableSerialization {
  /// Initializes new instance of the class.
  _TableSerialization(Workbook workbook) {
    _workbook = workbook;
  }

  /// Workbook to serialize.
  late Workbook _workbook;

  /// Serialize Tables
  void _serializeTables(XmlBuilder builder, Worksheet sheet) {
    final ExcelTableCollection tableCollection = sheet.tableCollection;
    int rid;
    int id = 1;
    if (tableCollection._count > 0) {
      if (sheet.hyperlinks.count > 0) {
        for (int hyperlinkIndex = 0;
            hyperlinkIndex < sheet.hyperlinks.count;
            hyperlinkIndex++) {
          if (sheet.hyperlinks[hyperlinkIndex]._attachedType ==
                  ExcelHyperlinkAttachedType.range &&
              sheet.hyperlinks[hyperlinkIndex].type != HyperlinkType.workbook) {
            id++;
          }
        }
      }
      if (sheet.pictures.count > 0) {
        for (int imageIndex = 0;
            imageIndex < sheet.pictures.count;
            imageIndex++) {
          id++;
        }
      }
      if (sheet.chartCount > 0) {
        for (int chartIndex = 0; chartIndex < sheet.chartCount; chartIndex++) {
          id++;
        }
      }
      builder.element('tableParts', nest: () {
        builder.attribute('count', tableCollection._count);
        for (int tableCount = 0;
            tableCount < tableCollection._count;
            tableCount++) {
          rid = id++;
          final ExcelTable table = tableCollection[tableCount];
          _serializeTable(table, tableCount + 1, sheet);
          builder.element('tablePart', nest: () {
            builder.attribute('r:id', 'rId$rid');
          });
        }
      });
    }
  }

  /// Serializes attribute if it differs from default value.
  void _serializeAttributeBool(
      XmlBuilder builder, String attributeName, bool value, bool defaultValue) {
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

  /// Serializes attribute if it differs from default value.
  void _serializeAttributeString(XmlBuilder builder, String attributeName,
      String value, String defaultValue) {
    if (value != defaultValue) {
      builder.attribute(attributeName, value);
    }
  }

  /// Serialize Table
  void _serializeTable(ExcelTable table, int index, Worksheet sheet) {
    final XmlBuilder builder = XmlBuilder();
    _workbook._tableCount++;
    builder.element('table', nest: () {
      builder.attribute('id', (table as _ExcelTableImpl)._tableIndex);
      builder.attribute('name', table._tableName);
      builder.attribute('displayName', table.displayName);
      builder.attribute('ref', table.dataRange.addressLocal);
      if (!table.totalsRowShown) {
        _serializeAttributeBool(builder, 'totalsRowShown', false, true);
      } else {
        _serializeAttributeInt(
            builder, 'totalsRowCount', table.totalRowCount, 0);
      }
      builder.namespace(
          'http://schemas.openxmlformats.org/spreadsheetml/2006/main');

      final _ExcelTableImpl typedTable = table;
      if (!typedTable.showHeaderRow) {
        builder.attribute('headerRowCount', '0');
      }
      if (_isTableAutoFlter(sheet)) {
        builder.element('autoFilter', nest: () {
          builder.attribute('ref', sheet.autoFilters.filterRange.addressLocal);
          // ignore: always_specify_types
          for (int i = 0; i < sheet.autoFilters.count; i++) {
            final _AutoFilterImpl autoFilter =
                sheet.autoFilters[i] as _AutoFilterImpl;

            if (autoFilter._isFiltered) {
              final SerializeWorkbook serializeWorkbook =
                  SerializeWorkbook(sheet.workbook);
              serializeWorkbook._serializeFilterColumn(builder, autoFilter);
            }
          }
        });
      }
      _serializeTableColumns(builder, table.columns);

      _serializeTableStyle(builder, table);

      _serializeTableExtensionList(builder, table);
    });
    final String stringXml = builder.buildDocument().toString();
    final List<int> bytes = utf8.encode(stringXml);
    _addToArchive(bytes, 'xl/tables/table${_workbook._tableCount}.xml');
  }

  ///Check is Table AutoFlter
  bool _isTableAutoFlter(Worksheet sheet) {
    for (int i = 0; i < sheet.tableCollection._count; i++) {
      if ((sheet.autoFilters.count != 0) &&
          (sheet.tableCollection[i].dataRange.addressLocal ==
              sheet.autoFilters.filterRange.addressLocal)) {
        return true;
      }
    }
    return false;
  }

  /// Add the workbook data with filename to ZipArchive.
  void _addToArchive(List<int> data, String fileName) {
    final ArchiveFile item = ArchiveFile(fileName, data.length, data);
    _workbook.archive.addFile(item);
  }

  /// Serialize Columns
  void _serializeTableColumns(
      XmlBuilder builder, List<ExcelTableColumn> columns) {
    builder.element('tableColumns', nest: () {
      for (int columnCount = 0; columnCount < columns.length; columnCount++) {
        final ExcelTableColumn column = columns[columnCount];
        _serializeTableColumn(builder, column);
      }
    });
  }

  /// Serialize Column.
  void _serializeTableColumn(XmlBuilder builder, ExcelTableColumn column) {
    builder.element('tableColumn', nest: () {
      builder.attribute('id', (column as _ExcelTableColumnImpl)._columnId);
      builder.attribute('name', column.columnName);
      _serializeAttributeString(
          builder, 'totalsRowLabel', column.totalRowLabel, '');
      if (column.totalFormula != ExcelTableTotalFormula.none) {
        builder.attribute(
            'totalsRowFunction', _getTotalsCalculation(column.totalFormula));
      }
    });
  }

  /// Serialize Table Style.
  void _serializeTableStyle(XmlBuilder builder, ExcelTable table) {
    final ExcelTableBuiltInStyle style = table.builtInTableStyle;
    builder.element('tableStyleInfo', nest: () {
      builder.attribute('name', _getTableStyles(style));

      builder.attribute(
          'showFirstColumn', (table.showFirstColumn ? 1 : 0).toString());
      builder.attribute(
          'showLastColumn', (table.showLastColumn ? 1 : 0).toString());
      builder.attribute(
          'showRowStripes', (table.showBandedRows ? 1 : 0).toString());
      builder.attribute(
          'showColumnStripes', (table.showBandedColumns ? 1 : 0).toString());
    });
  }

  /// Serializes the table extension list.
  void _serializeTableExtensionList(XmlBuilder builder, ExcelTable table) {
    if (table.altTextTitle.isNotEmpty || table.altTextSummary.isNotEmpty) {
      builder.element('extLst', nest: () {
        builder.element('ext', nest: () {
          builder.attribute('uri', '{504A1905-F514-4f6f-8877-14C23A59335A}');
          builder.attribute('xmlns:x14',
              'http://schemas.microsoft.com/office/spreadsheetml/2009/9/main');
          builder.element('x14:table', nest: () {
            if (table.altTextTitle.isNotEmpty) {
              builder.attribute('altText', table.altTextTitle);
            }
            if (table.altTextSummary.isNotEmpty) {
              builder.attribute('altTextSummary', table.altTextSummary);
            }
          });
        });
      });
    }
  }

  /// Returns the table style.
  String _getTableStyles(ExcelTableBuiltInStyle tableBuiltinStyles) {
    switch (tableBuiltinStyles) {
      case ExcelTableBuiltInStyle.tableStyleMedium1:
        return 'TableStyleMedium1';

      case ExcelTableBuiltInStyle.tableStyleMedium2:
        return 'TableStyleMedium2';

      case ExcelTableBuiltInStyle.tableStyleMedium3:
        return 'TableStyleMedium3';

      case ExcelTableBuiltInStyle.tableStyleMedium4:
        return 'TableStyleMedium4';

      case ExcelTableBuiltInStyle.tableStyleMedium5:
        return 'TableStyleMedium5';

      case ExcelTableBuiltInStyle.tableStyleMedium6:
        return 'TableStyleMedium6';

      case ExcelTableBuiltInStyle.tableStyleMedium7:
        return 'TableStyleMedium7';

      case ExcelTableBuiltInStyle.tableStyleMedium8:
        return 'TableStyleMedium8';

      case ExcelTableBuiltInStyle.tableStyleMedium9:
        return 'TableStyleMedium9';

      case ExcelTableBuiltInStyle.tableStyleMedium10:
        return 'TableStyleMedium10';

      case ExcelTableBuiltInStyle.tableStyleMedium11:
        return 'TableStyleMedium11';

      case ExcelTableBuiltInStyle.tableStyleMedium12:
        return 'TableStyleMedium12';

      case ExcelTableBuiltInStyle.tableStyleMedium13:
        return 'TableStyleMedium13';

      case ExcelTableBuiltInStyle.tableStyleMedium14:
        return 'TableStyleMedium14';

      case ExcelTableBuiltInStyle.tableStyleMedium15:
        return 'TableStyleMedium15';

      case ExcelTableBuiltInStyle.tableStyleMedium16:
        return 'TableStyleMedium16';

      case ExcelTableBuiltInStyle.tableStyleMedium17:
        return 'TableStyleMedium17';

      case ExcelTableBuiltInStyle.tableStyleMedium18:
        return 'TableStyleMedium18';

      case ExcelTableBuiltInStyle.tableStyleMedium19:
        return 'TableStyleMedium19';

      case ExcelTableBuiltInStyle.tableStyleMedium20:
        return 'TableStyleMedium20';

      case ExcelTableBuiltInStyle.tableStyleMedium21:
        return 'TableStyleMedium21';

      case ExcelTableBuiltInStyle.tableStyleMedium22:
        return 'TableStyleMedium22';

      case ExcelTableBuiltInStyle.tableStyleMedium23:
        return 'TableStyleMedium23';

      case ExcelTableBuiltInStyle.tableStyleMedium24:
        return 'TableStyleMedium24';

      case ExcelTableBuiltInStyle.tableStyleMedium25:
        return 'TableStyleMedium25';

      case ExcelTableBuiltInStyle.tableStyleMedium26:
        return 'TableStyleMedium26';

      case ExcelTableBuiltInStyle.tableStyleMedium27:
        return 'TableStyleMedium27';

      case ExcelTableBuiltInStyle.tableStyleMedium28:
        return 'TableStyleMedium28';

      case ExcelTableBuiltInStyle.tableStyleLight1:
        return 'TableStyleLight1';

      case ExcelTableBuiltInStyle.tableStyleLight2:
        return 'TableStyleLight2';

      case ExcelTableBuiltInStyle.tableStyleLight3:
        return 'TableStyleLight3';

      case ExcelTableBuiltInStyle.tableStyleLight4:
        return 'TableStyleLight4';

      case ExcelTableBuiltInStyle.tableStyleLight5:
        return 'TableStyleLight5';

      case ExcelTableBuiltInStyle.tableStyleLight6:
        return 'TableStyleLight6';

      case ExcelTableBuiltInStyle.tableStyleLight7:
        return 'TableStyleLight7';

      case ExcelTableBuiltInStyle.tableStyleLight8:
        return 'TableStyleLight8';

      case ExcelTableBuiltInStyle.tableStyleLight9:
        return 'TableStyleLight9';

      case ExcelTableBuiltInStyle.tableStyleLight10:
        return 'TableStyleLight10';

      case ExcelTableBuiltInStyle.tableStyleLight11:
        return 'TableStyleLight11';

      case ExcelTableBuiltInStyle.tableStyleLight12:
        return 'TableStyleLight12';

      case ExcelTableBuiltInStyle.tableStyleLight13:
        return 'TableStyleLight13';

      case ExcelTableBuiltInStyle.tableStyleLight14:
        return 'TableStyleLight14';

      case ExcelTableBuiltInStyle.tableStyleLight15:
        return 'TableStyleLight15';

      case ExcelTableBuiltInStyle.tableStyleLight16:
        return 'TableStyleLight16';

      case ExcelTableBuiltInStyle.tableStyleLight17:
        return 'TableStyleLight17';

      case ExcelTableBuiltInStyle.tableStyleLight18:
        return 'TableStyleLight18';

      case ExcelTableBuiltInStyle.tableStyleLight19:
        return 'TableStyleLight19';

      case ExcelTableBuiltInStyle.tableStyleLight20:
        return 'TableStyleLight20';

      case ExcelTableBuiltInStyle.tableStyleLight21:
        return 'TableStyleLight21';

      case ExcelTableBuiltInStyle.tableStyleDark1:
        return 'TableStyleDark1';

      case ExcelTableBuiltInStyle.tableStyleDark2:
        return 'TableStyleDark2';

      case ExcelTableBuiltInStyle.tableStyleDark3:
        return 'TableStyleDark3';

      case ExcelTableBuiltInStyle.tableStyleDark4:
        return 'TableStyleDark4';

      case ExcelTableBuiltInStyle.tableStyleDark5:
        return 'TableStyleDark5';

      case ExcelTableBuiltInStyle.tableStyleDark6:
        return 'TableStyleDark6';

      case ExcelTableBuiltInStyle.tableStyleDark7:
        return 'TableStyleDark7';

      case ExcelTableBuiltInStyle.tableStyleDark8:
        return 'TableStyleDark8';

      case ExcelTableBuiltInStyle.tableStyleDark9:
        return 'TableStyleDark9';

      case ExcelTableBuiltInStyle.tableStyleDark10:
        return 'TableStyleDark10';

      case ExcelTableBuiltInStyle.tableStyleDark11:
        return 'TableStyleDark11';

      case ExcelTableBuiltInStyle.None:
        return 'None';
    }
  }

  /// Returns the formula requied for Totals Calculation.
  String _getTotalsCalculation(ExcelTableTotalFormula totalsCalcution) {
    switch (totalsCalcution) {
      case ExcelTableTotalFormula.sum:
        return 'sum';

      case ExcelTableTotalFormula.variable:
        return 'var';

      case ExcelTableTotalFormula.average:
        return 'average';

      case ExcelTableTotalFormula.min:
        return 'min';

      case ExcelTableTotalFormula.max:
        return 'max';

      case ExcelTableTotalFormula.countNums:
        return 'countNums';

      case ExcelTableTotalFormula.stdDev:
        return 'stdDev';

      case ExcelTableTotalFormula.custom:
        return 'custom';

      case ExcelTableTotalFormula.count:
        return 'count';

      case ExcelTableTotalFormula.none:
        return 'none';
    }
  }

  /// Serialize Tables
  Future<void> _serializeTablesAsync(
      XmlBuilder builder, Worksheet sheet) async {
    final ExcelTableCollection tableCollection = sheet.tableCollection;
    int rid;
    int id = 1;
    if (tableCollection._count > 0) {
      if (sheet.hyperlinks.count > 0) {
        for (int hyperlinkIndex = 0;
            hyperlinkIndex < sheet.hyperlinks.count;
            hyperlinkIndex++) {
          if (sheet.hyperlinks[hyperlinkIndex]._attachedType ==
                  ExcelHyperlinkAttachedType.range &&
              sheet.hyperlinks[hyperlinkIndex].type != HyperlinkType.workbook) {
            id++;
          }
        }
      }
      if (sheet.pictures.count > 0) {
        for (int imageIndex = 0;
            imageIndex < sheet.pictures.count;
            imageIndex++) {
          id++;
        }
      }
      builder.element('tableParts', nest: () async {
        builder.attribute('count', tableCollection._count);
        for (int tableCount = 0;
            tableCount < tableCollection._count;
            tableCount++) {
          rid = id++;
          final ExcelTable table = tableCollection[tableCount];
          _serializeTableAsync(table, tableCount + 1);
          builder.element('tablePart', nest: () {
            builder.attribute('r:id', 'rId$rid');
          });
        }
      });
    }
  }

  /// Serializes attribute if it differs from default value.
  Future<void> _serializeAttributeBoolAsync(XmlBuilder builder,
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
  Future<void> _serializeAttributeIntAsync(XmlBuilder builder,
      String attributeName, int value, int defaultValue) async {
    if (value != defaultValue) {
      final String strValue = value.toString();
      builder.attribute(attributeName, strValue);
    }
  }

  /// Serializes attribute if it differs from default value.
  Future<void> _serializeAttributeStringAsync(XmlBuilder builder,
      String attributeName, String value, String defaultValue) async {
    if (value != defaultValue) {
      builder.attribute(attributeName, value);
    }
  }

  /// Serialize Table
  Future<void> _serializeTableAsync(ExcelTable table, int index) async {
    final XmlBuilder builder = XmlBuilder();
    _workbook._tableCount++;
    builder.element('table', nest: () async {
      builder.attribute('id', (table as _ExcelTableImpl)._tableIndex);
      builder.attribute('name', table._tableName);
      builder.attribute('displayName', table.displayName);
      builder.attribute('ref', table.dataRange.addressLocal);
      if (!table.totalsRowShown) {
        _serializeAttributeBoolAsync(builder, 'totalsRowShown', false, true);
      } else {
        _serializeAttributeIntAsync(
            builder, 'totalsRowCount', table.totalRowCount, 0);
      }
      builder.namespace(
          'http://schemas.openxmlformats.org/spreadsheetml/2006/main');

      final _ExcelTableImpl typedTable = table;
      if (!typedTable.showHeaderRow) {
        builder.attribute('headerRowCount', '0');
      }

      _serializeTableColumnsAsync(builder, table.columns);
      _serializeTableStyleAsync(builder, table);
      _serializeTableExtensionListAsync(builder, table);
    });
    final String stringXml = builder.buildDocument().toString();
    final List<int> bytes = utf8.encode(stringXml);
    _addToArchiveAsync(bytes, 'xl/tables/table${_workbook._tableCount}.xml');
  }

  /// Add the workbook data with filename to ZipArchive.
  Future<void> _addToArchiveAsync(List<int> data, String fileName) async {
    final ArchiveFile item = ArchiveFile(fileName, data.length, data);
    _workbook.archive.addFile(item);
  }

  /// Serialize Columns
  Future<void> _serializeTableColumnsAsync(
      XmlBuilder builder, List<ExcelTableColumn> columns) async {
    builder.element('tableColumns', nest: () async {
      for (int columnCount = 0; columnCount < columns.length; columnCount++) {
        final ExcelTableColumn column = columns[columnCount];
        _serializeTableColumnAsync(builder, column);
      }
    });
  }

  /// Serialize Column.
  Future<void> _serializeTableColumnAsync(
      XmlBuilder builder, ExcelTableColumn column) async {
    builder.element('tableColumn', nest: () async {
      builder.attribute('id', (column as _ExcelTableColumnImpl)._columnId);
      builder.attribute('name', column.columnName);
      _serializeAttributeStringAsync(
          builder, 'totalsRowLabel', column.totalRowLabel, '');
      if (column.totalFormula != ExcelTableTotalFormula.none) {
        builder.attribute(
            'totalsRowFunction', _getTotalsCalculation(column.totalFormula));
      }
    });
  }

  /// Serialize Table Style.
  Future<void> _serializeTableStyleAsync(
      XmlBuilder builder, ExcelTable table) async {
    final ExcelTableBuiltInStyle style = table.builtInTableStyle;
    builder.element('tableStyleInfo', nest: () async {
      builder.attribute('name', _getTableStyles(style));
      builder.attribute(
          'showFirstColumn', (table.showFirstColumn ? 1 : 0).toString());
      builder.attribute(
          'showLastColumn', (table.showLastColumn ? 1 : 0).toString());
      builder.attribute(
          'showRowStripes', (table.showBandedRows ? 1 : 0).toString());
      builder.attribute(
          'showColumnStripes', (table.showBandedColumns ? 1 : 0).toString());
    });
  }

  /// Serializes the table extension list.
  Future<void> _serializeTableExtensionListAsync(
      XmlBuilder builder, ExcelTable table) async {
    if (table.altTextTitle.isNotEmpty || table.altTextSummary.isNotEmpty) {
      builder.element('extLst', nest: () {
        builder.element('ext', nest: () {
          builder.attribute('uri', '{504A1905-F514-4f6f-8877-14C23A59335A}');
          builder.attribute('xmlns:x14',
              'http://schemas.microsoft.com/office/spreadsheetml/2009/9/main');
          builder.element('x14:table', nest: () {
            if (table.altTextTitle.isNotEmpty) {
              builder.attribute('altText', table.altTextTitle);
            }
            if (table.altTextSummary.isNotEmpty) {
              builder.attribute('altTextSummary', table.altTextSummary);
            }
          });
        });
      });
    }
  }
}
