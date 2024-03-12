import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import '../../../datagrid.dart';
import '../helper/datagrid_configuration.dart';
import '../sfdatagrid.dart';

/// Represents a grouping of records in the data grid.
class Group extends DataRowEntry {
  /// Creates a new instance of the [Group] class.
  Group() {
    hasGroups = true;
    rows = <DataGridRow>[];
    subGroups = <Group>[];
    groups = <GroupPopulate>[];
  }

  /// The key used for sorting and grouping.
  dynamic key;

  /// Contains list of grouping and DataGridRows.
  DataRowEntry? displayElements;

  /// List of groups within this grouping.
  late List<GroupPopulate> groups;

  /// List of rows associated with this grouping.
  late List<DataGridRow> rows;

  /// List of subgroups within this grouping.
  late List<Group> subGroups;

  /// The top-level group to which this grouping belongs.
  TopLevelGroup? topLevelGroup;

  /// Refreshes the top-level group for the DataGridSource.
  void refreshTopLevelGroup(DataGridConfiguration dataGridConfiguration,
      List<String> groupedColumn, bool autoExpandGroup) {
    if (hasGroups) {
      initializeTopLevelGroup(dataGridConfiguration, autoExpandGroup);
    } else {
      if (topLevelGroup != null) {
        topLevelGroup = null;
      }
      dataGridConfiguration.group = null;
    }
  }

  /// used to initalize the grouping.
  void initializeTopLevelGroup(
      DataGridConfiguration dataGridConfiguration, bool autoExpandGroup) {
    final List<String> groupedColumn = <String>[];
    for (final ColumnGroup columnGroupDescription
        in dataGridConfiguration.source.groupedColumns) {
      groupedColumn.add(columnGroupDescription.name);
    }

    /// Creates top level group.
    topLevelGroup = TopLevelGroup(this);

    if (groupedColumn.isNotEmpty) {
      final List<Group> result = _performGroupBy(
          effectiveRows(dataGridConfiguration.source),
          groupedColumn,
          dataGridConfiguration.source);
      topLevelGroup?._populate(result, autoExpandGroup);
    }
    dataGridConfiguration.group = topLevelGroup;
  }

  List<Group> _performGroupBy(List<DataGridRow> rows, List<dynamic> columnNames,
      DataGridSource? source) {
    final Map<dynamic, dynamic> groupedData = <dynamic, dynamic>{};

    for (final DataGridRow row in rows) {
      final dynamic key = performGrouping(source, columnNames[0], row);

      if (columnNames.length <= 1) {
        if (groupedData.containsKey(key)) {
          groupedData[key].add(row);
        } else {
          groupedData[key] = <DataGridRow>[row];
        }
      } else {
        dynamic currentGroup =
            groupedData.putIfAbsent(key, () => <dynamic, dynamic>{});

        for (int i = 1; i < columnNames.length; i++) {
          final dynamic innerKey = performGrouping(source, columnNames[i], row);

          if (i != columnNames.length - 1) {
            currentGroup =
                currentGroup.putIfAbsent(innerKey, () => <dynamic, dynamic>{});
          } else {
            currentGroup.putIfAbsent(innerKey, () => <dynamic>[]).add(row);
          }
        }
      }
    }

    final List<Group> groupResults = <Group>[];

    for (final MapEntry<dynamic, dynamic> entry in groupedData.entries) {
      final Group groupResult = Group()..key = entry.key;

      final Group innerGroupResult =
          _createGroupResult(entry: entry, groupResult: groupResult);
      groupResult.rows = innerGroupResult.rows;
      groupResults.add(groupResult);
    }

    return groupResults;
  }

  dynamic _createGroupResult(
      {MapEntry<dynamic, dynamic>? entry, Group? groupResult}) {
    if (entry!.value is List) {
      entry.value.forEach((dynamic item) {
        groupResult!.rows.add(item);
      });

      return groupResult;
    } else {
      entry.value.entries.forEach((dynamic newEntry) {
        Group newGroupResult = Group()
          ..key = newEntry.key
          ..length = newEntry.value.length;

        newGroupResult =
            _createGroupResult(entry: newEntry, groupResult: newGroupResult);
        groupResult!.rows.addAll(newGroupResult.rows);

        groupResult.subGroups.add(newGroupResult);
        groupResult.length = groupResult.rows.length;
      });
      return groupResult;
    }
  }

  /// Expands all the groups in SfDataGrid.
  Group? expandAll(Group? newGrouping) {
    bool expand = false;
    Group groupsToPopulate;
    final Group newGroup = Group();
    newGroup.displayElements = DataRowEntry();

    for (final dynamic group in newGrouping!.displayElements!.grouped) {
      if (group is Group) {
        if (group.level == 1) {
          expand = true;
          groupsToPopulate = group;
          _expandAndCollapseGroup(groupsToPopulate, expand, newGroup);
        }
      }
    }

    newGrouping.displayElements = newGroup.displayElements;
    newGrouping.displayElements?.length =
        newGroup.displayElements!.grouped.length;
    newGrouping.autoExpandGroup = true;
    return newGrouping;
  }

  /// Collapses all the groups in SfDataGrid.
  Group? collapseAll(Group? newGrouping) {
    bool expand = false;
    Group groupsToPopulate;
    final Group newGroup = Group();
    newGroup.displayElements = DataRowEntry();

    for (final dynamic group in newGrouping!.displayElements!.grouped) {
      if (group is Group) {
        if (group.level == 1) {
          expand = false;
        }

        groupsToPopulate = group;
        _expandAndCollapseGroup(groupsToPopulate, expand, newGroup);
      }
    }

    newGrouping.displayElements = newGroup.displayElements;
    newGrouping.displayElements?.length =
        newGroup.displayElements!.grouped.length;
    newGrouping.autoExpandGroup = false;
    return newGrouping;
  }

  /// Initialize newGroup with a new instance of Grouping.
  Group? clear(Group? newGroup) {
    newGroup = null;
    return newGroup;
  }

  /// Used to reset the display elements in grouping.
  void resetDisplayElements() {
    displayElements = DataRowEntry();
  }

  /// clear the display elements.
  void clearDisplayElements(DataGridConfiguration dataGridConfiguration) {
    dataGridConfiguration.group!.displayElements = null;
  }

  Group? _expandAndCollapseGroup(
      Group groupsToPopulate, bool expand, Group? newGroup) {
    final Group group = groupsToPopulate;

    if (group.subGroups.isEmpty) {
      if (expand || (!expand && groupsToPopulate.level == 1)) {
        group.isExpanded = false;
        newGroup?.displayElements?.grouped.add(group);
      }
      if (expand) {
        group.isExpanded = true;
        newGroup?.displayElements?.grouped.addAll(group.rows);
      }
    } else {
      if (expand || (!expand && groupsToPopulate.level == 1)) {
        newGroup?.displayElements?.grouped.add(group);
      }
      for (final Group subGroups in group.subGroups) {
        group.isExpanded = expand;
        _expandAndCollapseGroup(subGroups, expand, newGroup);
      }
    }
    return newGroup;
  }

  /// Expands a specific group in SfDataGrid.
  Group? expandGroups(dynamic individualGroup, Group? newGrouping, int index) {
    if (individualGroup is DataGridRow || individualGroup.isExpanded) {
      return newGrouping;
    }
    newGrouping!.displayElements!.grouped[index].isExpanded = true;
    index = _addSubGroups(individualGroup, newGrouping, index);

    return newGrouping;
  }

  int _addSubGroups(
      dynamic individualGroup, Group? newGrouping, int startIndex) {
    int groupIndex = startIndex + 1;

    if (individualGroup.subGroups.isNotEmpty) {
      for (final Group nestedSubGroup in individualGroup.subGroups) {
        newGrouping!.displayElements!.grouped
            .insert(groupIndex, nestedSubGroup);
        if (nestedSubGroup.isExpanded) {
          nestedSubGroup.isExpanded = true;
          groupIndex = _addSubGroups(nestedSubGroup, newGrouping, groupIndex);
        } else {
          groupIndex++;
        }
      }
    } else if (individualGroup.isExpanded) {
      for (final DataGridRow row in individualGroup.rows) {
        newGrouping!.displayElements!.grouped.insert(groupIndex, row);
        groupIndex++;
      }
    }

    return groupIndex;
  }

  /// Collapses a specific group in SfDataGrid.
  Group? collapseGroups(
      dynamic individualGroup, Group? newGrouping, int groupIndex) {
    if (individualGroup is DataGridRow || !individualGroup.isExpanded) {
      return newGrouping;
    }
    final int subGroupCount = _countSubGroups(individualGroup);
    newGrouping!.displayElements!.grouped[groupIndex].isExpanded = false;
    final int startIndex = groupIndex + 1;
    final int endIndex = subGroupCount + groupIndex;
    newGrouping.displayElements!.grouped.removeRange(startIndex, endIndex);
    return newGrouping;
  }

  int _countSubGroups(dynamic individualGroup) {
    int subgroupCount = 1;

    if (individualGroup.subGroups.isNotEmpty) {
      for (final Group nestedSubGroup in individualGroup.subGroups) {
        subgroupCount +=
            nestedSubGroup.isExpanded ? _countSubGroups(nestedSubGroup) : 1;
      }
    } else if (individualGroup.isExpanded) {
      subgroupCount += individualGroup.rows.length as int;
    }

    return subgroupCount;
  }

  /// Collapses the groups based on the respective level.
  Group? collapseGroupAtLevel(int level, Group? newGrouping) {
    final List<dynamic> newGroups = <dynamic>[];
    for (final dynamic group in newGrouping!.displayElements!.grouped) {
      if (group is Group && group.level <= level) {
        if (group.level == level) {
          group.isExpanded = false;
        }
        newGroups.add(group);
      }
    }
    newGrouping.displayElements!.grouped = newGroups;
    return newGrouping;
  }

  /// Expands the groups based on the respective level.
  Group? expandGroupsAtLevel(int level, Group? newGrouping) {
    final List<dynamic> newGroups = <dynamic>[];
    for (final dynamic group in newGrouping!.displayElements!.grouped) {
      if (group is Group && group.level <= level) {
        if (group.level == level) {
          group.isExpanded = true;
          newGroups.add(group);
          _addSubGroupsAtLevel(newGroups, group);
        } else {
          newGroups.add(group);
        }
      }
    }
    newGrouping.displayElements!.grouped = newGroups;
    return newGrouping;
  }

  dynamic _addSubGroupsAtLevel(List<dynamic> newGroups, dynamic group) {
    if (group.subGroups.isNotEmpty) {
      for (final Group nestedSubGroup in group.subGroups) {
        newGroups.add(nestedSubGroup);
        if (nestedSubGroup.isExpanded) {
          nestedSubGroup.isExpanded = true;
          newGroups = _addSubGroupsAtLevel(newGroups, nestedSubGroup);
        }
      }
    } else if (group.isExpanded) {
      group.rows.forEach((DataGridRow row) {
        newGroups.add(row);
      });
    }
    return newGroups;
  }

  /// Called when the sorting is applied to the column.
  @protected
  void performSorting(
      DataGridConfiguration dataGridConfiguration, List<String> sortedColumn) {
    bool expand = false;
    Group groupsToPopulate;
    final Group newGroup = Group();
    newGroup.displayElements = DataRowEntry();

    for (final dynamic group
        in dataGridConfiguration.group!.displayElements!.grouped) {
      if (group is Group) {
        if (group.level == 1) {
          expand = true;
          groupsToPopulate = group;
          _sortGroupedRows(dataGridConfiguration, groupsToPopulate, expand,
              newGroup, sortedColumn);
        }
      }
    }

    displayElements = newGroup.displayElements;
    displayElements?.length = newGroup.displayElements!.grouped.length;
    autoExpandGroup = true;
  }

  Group? _sortGroupedRows(
      DataGridConfiguration dataGridConfiguration,
      Group groupsToPopulate,
      bool expand,
      Group? newGroup,
      List<String> sortedColumn) {
    final Group group = groupsToPopulate;

    if (group.subGroups.isEmpty) {
      if (expand || (!expand && groupsToPopulate.level == 1)) {
        group.isExpanded = false;
        newGroup?.displayElements?.grouped.add(group);
      }
      if (expand) {
        group.isExpanded = true;
        _performSorting(group.rows, sortedColumn);
        newGroup?.displayElements?.grouped.addAll(group.rows);
      }
    } else {
      if (expand || (!expand && groupsToPopulate.level == 1)) {
        newGroup?.displayElements?.grouped.add(group);
      }

      for (final Group subGroups in group.subGroups) {
        group.isExpanded = expand;
        _sortGroupedRows(
            dataGridConfiguration, subGroups, expand, newGroup, sortedColumn);
      }
    }
    return newGroup;
  }

  void _performSorting(List<DataGridRow> rows, List<String> sortedColumns) {
    if (sortedColumns.isEmpty) {
      return;
    }
    rows.sort((DataGridRow a, DataGridRow b) {
      return _compareValues(sortedColumns, a, b);
    });
  }

  int _compareValues(List<String> sortedColumns, DataGridRow a, DataGridRow b) {
    if (sortedColumns.length > 1) {
      for (final int i = 0; i < sortedColumns.length;) {
        final String sortColumn = sortedColumns[i];
        final int compareResult = _compare(a, b, sortColumn);
        if (compareResult == 0) {
          return compareResult;
        } else {
          final List<String> remainingSortColumns =
              sortedColumns.sublist(i + 1);
          return _compareValues(remainingSortColumns, a, b);
        }
      }
    }
    final String sortColumn = sortedColumns.last;
    return _compare(a, b, sortColumn);
  }

  int _compare(DataGridRow? a, DataGridRow? b, String sortColumn) {
    final Object? valueA = _getCellValue(a?.getCells(), sortColumn);
    final Object? valueB = _getCellValue(b?.getCells(), sortColumn);
    return _compareTo(valueA, valueB);
  }

  int _compareTo(dynamic value1, dynamic value2) {
    if (value1 == null) {
      return -1;
    } else if (value2 == null) {
      return 1;
    }
    return value1.toString().compareTo(value2.toString());
  }

  Object? _getCellValue(List<DataGridCell>? cells, String columnName) {
    return cells
        ?.firstWhereOrNull(
            (DataGridCell element) => element.columnName == columnName)
        ?.value;
  }
}

/// Maintain the property for the grouping.
class GroupPopulate extends Group {
  /// Constructs a [GroupPopulate] instance with the specified [level].
  ///
  /// The [level] parameter indicates the grouping level.
  GroupPopulate({required int level}) {
    isBottomLevel = false;
    displayElements?.level = level;
  }

  /// Constructs a [GroupPopulate] instance from a list of [source] data grid rows.
  ///
  /// This constructor initializes the [dataGridRows] property with the provided
  /// list of data grid rows.
  GroupPopulate.fromRows(List<DataGridRow> source) : super() {
    dataGridRows = source;
  }

  ///
  late Group details;

  /// List of data grid rows associated with this grouping.
  List<DataGridRow>? dataGridRows;

  /// Number of rows in the cache.
  int rowsCacheCount = -1;

  /// Indicates whether this is a top-level group.
  bool isTopLevelGroup = false;

  /// Indicates whether this is a bottom-level group.
  bool isBottomLevel = false;

  @override
  List<GroupPopulate> get groups {
    if (details.hasGroups) {
      return details.groups;
    }
    return <GroupPopulate>[];
  }

  int _getRowsCacheCount() {
    return rowsCacheCount;
  }

  /// Holds the list of dataGrid rows.
  List<DataGridRow>? get source {
    return (details as GroupPopulate).dataGridRows;
  }

  int _populate(List<Group>? groupsToPopulate, bool autoExpandGroups) {
    displayElements = DataRowEntry();
    autoExpandGroup = autoExpandGroups;
    hasGroups = true;

    if (groupsToPopulate != null) {
      rowsCacheCount =
          _populateGroup(groupsToPopulate, groups, this, level + 1);
      displayElements?.length = rowsCacheCount;
    }
    return rowsCacheCount;
  }

  int _populateGroup(List<Group> groupsToPopulate,
      List<GroupPopulate> groupPopulates, GroupPopulate parent, int level) {
    int parentCounter = 0;
    final List<Group> groups = groupsToPopulate.asMap().values.toList();

    for (final Group newGroup in groups) {
      newGroup.level = level;
      final Group groupResult = newGroup;
      final GroupPopulate group = GroupPopulate(level: level);
      group.level = level;
      int counter = 1;
      groupPopulates.add(group);

      if (newGroup.subGroups.isEmpty) {
        if (autoExpandGroup || (!autoExpandGroup && level == 1)) {
          if (autoExpandGroup) {
            newGroup.isExpanded = false;
          }
          displayElements?.grouped.add(newGroup);
        }
        group._createDetailsForRows(groupResult.rows, level);
        counter += group.source!.length;
        if (autoExpandGroup) {
          newGroup.isExpanded = true;
          displayElements?.grouped.addAll(newGroup.rows);
        }
        group._getRowsCacheCount();
        parentCounter += counter;
      } else {
        group.details = Group();
        if (autoExpandGroup || (!autoExpandGroup && level == 1)) {
          newGroup.isExpanded = autoExpandGroup;
          displayElements?.grouped.add(newGroup);
        }
        counter += _populateGroup(
            groupResult.subGroups, group.groups, group, level + 1);
        group._getRowsCacheCount();
        parentCounter += counter;
        counter = 0;
      }

      final TopLevelGroup topLevelGroup = TopLevelGroup(this);
      if (isTopLevelGroup) {
        if (topLevelGroup.group.autoExpandGroup &&
            topLevelGroup.group.hasGroups) {
          group.isExpanded = true;
        }
      } else {
        if (topLevelGroup.group.autoExpandGroup) {
          group.isExpanded = true;
        }
      }
    }
    return parentCounter;
  }

  void _createDetailsForRows(List<DataGridRow> source, int level) {
    isBottomLevel = true;
    details = GroupPopulate.fromRows(source);
  }
}

/// This class represents a top-level group.
class TopLevelGroup extends GroupPopulate {
  /// Constructor for the [TopLevelGroup] class.
  ///
  /// [group] is the grouping associated with this top-level group.
  TopLevelGroup(this.group) : super(level: 0) {
    isTopLevelGroup = true;
    details = Group();
  }

  /// Hold details of the grouping.
  late Group group;
}

/// This class represents a record entry.
class DataRowEntry {
  /// List of dynamic elements grouped together.
  List<dynamic> grouped = <dynamic>[];

  /// The length of the record entry.
  int length = 0;

  /// Flag indicating whether to auto-expand the group.
  bool autoExpandGroup = false;

  /// Flag indicating whether there are groups.
  bool hasGroups = true;

  /// Flag indicating whether the group is expanded.
  bool isExpanded = false;

  /// The level of the record entry.
  int level = 0;
}
