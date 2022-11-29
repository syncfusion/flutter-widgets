import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import '../../grid_common/row_column_index.dart';
import '../../grid_common/scroll_axis.dart';
import '../../grid_common/visible_line_info.dart';
import '../helper/callbackargs.dart';
import '../helper/datagrid_configuration.dart';
import '../helper/datagrid_helper.dart';
import '../helper/datagrid_helper.dart' as grid_helper;
import '../helper/enums.dart';
import '../runtime/generator.dart';
import '../sfdatagrid.dart';
import 'scrollview_widget.dart';

/// A class [VisualContainerRenderObjectWidget] that configure the
/// [RenderVisualContainer] subclass that layout the list of rows of the [SfDataGrid].
class VisualContainerRenderObjectWidget extends MultiChildRenderObjectWidget {
  /// Creates a [VisualContainerRenderObjectWidget] for the [RenderVisualContainer].
  VisualContainerRenderObjectWidget({
    required Key? key,
    required this.containerSize,
    required this.isDirty,
    required this.dataGridStateDetails,
    required this.children,
  }) : super(
            key: key,
            children: RepaintBoundary.wrapAll(List<Widget>.from(children)));

  @override
  final List<Widget> children;

  /// The constraints of a current data grid view.
  final Size containerSize;

  /// Checks whether the data grid rows are dirty from the previous or not to
  /// refresh the views when rebuilding.
  final bool isDirty;

  /// Holds the [DataGridStateDetails].
  final DataGridStateDetails dataGridStateDetails;

  @override
  RenderVisualContainer createRenderObject(BuildContext context) =>
      RenderVisualContainer(
          containerSize: containerSize,
          isDirty: isDirty,
          dataGridStateDetails: dataGridStateDetails);

  @override
  void updateRenderObject(
      BuildContext context, RenderVisualContainer renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject
      ..containerSize = containerSize
      ..isDirty = isDirty;
  }
}

class _VisualContainerParentData extends ContainerBoxParentData<RenderBox> {
  _VisualContainerParentData();

  double width = 0.0;
  double height = 0.0;
  Rect? rowClipRect;

  void reset() {
    width = 0.0;
    height = 0.0;
    offset = Offset.zero;
    rowClipRect = null;
  }
}

/// A render object [RenderVisualContainer] that rendering the data grid's
/// visual container.
class RenderVisualContainer extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _VisualContainerParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _VisualContainerParentData> {
  /// Creates a [RenderVisualContainer] for `SfDataGrid`.
  RenderVisualContainer(
      {List<RenderBox>? children,
      required Size containerSize,
      required bool isDirty,
      required DataGridStateDetails? dataGridStateDetails})
      : _containerSize = containerSize,
        _isDirty = isDirty,
        _dataGridStateDetails = dataGridStateDetails! {
    addAll(children);
    _gestureArenaTeam = GestureArenaTeam();
    _panGestureRecognizer = PanGestureRecognizer()
      ..team = _gestureArenaTeam
      ..onStart = ((DragStartDetails details) {})
      ..dragStartBehavior = DragStartBehavior.down;
    _gestureArenaTeam.captain = _panGestureRecognizer;
  }

  /// Decides whether the visual container needs to be refreshed or not.
  bool get isDirty => _isDirty;
  bool _isDirty = false;

  set isDirty(bool newValue) {
    _isDirty = newValue;
    if (_isDirty) {
      markNeedsLayout();
      markNeedsPaint();
    }
  }

  /// Defines the size of a visual container.
  Size get containerSize => _containerSize;
  Size _containerSize = Size.zero;

  set containerSize(Size newContainerSize) {
    if (_containerSize == newContainerSize) {
      return;
    }
    _containerSize = newContainerSize;
    markNeedsLayout();
    markNeedsPaint();
  }

  RenderVirtualizingCellsWidget? _swipeWholeRowElement;

  final DataGridStateDetails _dataGridStateDetails;

  late PanGestureRecognizer _panGestureRecognizer;
  late GestureArenaTeam _gestureArenaTeam;

  @override
  bool get isRepaintBoundary => true;

  @override
  void setupParentData(RenderObject child) {
    super.setupParentData(child);
    if (child.parentData is! _VisualContainerParentData) {
      child.parentData = _VisualContainerParentData();
    }
  }

  // Issue:
  // FLUT-6822 - ScrollView is scrolled at sample level when swiping the row in DataGrid.
  //
  // Fix:
  // An issue occurred because the Datagrid could not handle the drag gesture
  // while swiping since we set `NeverScrollableScrollPhysics` to the Datagrid.
  // So, that is handled by the parent widget which is added to the Datagrid and
  // it scrolls the Datagrid while swiping. Now we controlled the drag gesture to the parent
  // by using the `_panGestureRecognizer` and `_gestureArenaTeam`. By setting
  // `_gestureArenaTeam.captain` as `_panGestureRecognizer` to handling the onDragStart.
  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    super.handleEvent(event, entry);
    final DataGridConfiguration dataGridConfiguration = _dataGridStateDetails();
    if (dataGridConfiguration.allowSwiping && event is PointerDownEvent) {
      _panGestureRecognizer.addPointer(event);
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    RenderBox? child = lastChild;
    while (child != null) {
      final _VisualContainerParentData childParentData =
          child.parentData! as _VisualContainerParentData;
      final bool isHit = result.addWithPaintOffset(
        offset: childParentData.offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          // Need to ensure whether the child type is _RenderVirtualizingCellsWidget
          // or not before accessing it. Because swiping widget's render object won't be
          // _RenderVirtualizingCellsWidget.
          final RenderBox? wholeRowElement = child;
          if (wholeRowElement != null &&
              wholeRowElement is RenderVirtualizingCellsWidget &&
              wholeRowElement._rowClipRect != null &&
              !wholeRowElement._rowClipRect!.contains(transformed)) {
            return false;
          }
          return child!.hitTest(result, position: transformed);
        },
      );

      if (isHit) {
        return true;
      }
      child = childParentData.previousSibling;
    }
    return false;
  }

  Offset _getSwipingChildOffset(Rect swipeRowRect) {
    final DataGridConfiguration dataGridConfiguration = _dataGridStateDetails();
    double dxPosition = 0.0;
    final double viewWidth = dataGridConfiguration.viewWidth;
    final double maxSwipeOffset = getSwipeMaxOffset(dataGridConfiguration);
    final double extentWidth = dataGridConfiguration.container.extentWidth;

    if (dataGridConfiguration.textDirection == TextDirection.rtl &&
        viewWidth > extentWidth) {
      dxPosition = (dataGridConfiguration.swipingOffset >= 0)
          ? viewWidth - extentWidth
          : viewWidth - maxSwipeOffset;
    } else {
      dxPosition = (dataGridConfiguration.swipingOffset >= 0)
          ? 0.0
          : extentWidth - maxSwipeOffset;
    }

    return Offset(dxPosition, swipeRowRect.top);
  }

  // Provides the `Rect` to clip outside bounds of a swipe widget.
  Rect _getSwipeWidgetClipRect() {
    final DataGridConfiguration dataGridConfiguration = _dataGridStateDetails();
    final Rect swipeRowRect =
        _swipeWholeRowElement!._measureRowRect(size.width);
    final double swipeValue = dataGridConfiguration.swipingAnimation!.value;
    final VisibleLineInfo? lineInfo = _swipeWholeRowElement!._dataRow
        .getRowVisibleLineInfo(_swipeWholeRowElement!._dataRow.rowIndex);
    double top = 0.0, height = swipeRowRect.height;

    /// Clipping the outside bounds of the top and bottom sides when the given
    /// swiped row is clipped by the frozen rows.
    if (lineInfo != null && lineInfo.isClippedBody) {
      if (lineInfo.isClippedOrigin) {
        top =
            lineInfo.size - lineInfo.clippedSize - lineInfo.clippedCornerExtent;
      }
      if (lineInfo.isClippedCorner) {
        height = lineInfo.clippedSize;
      }
    }

    if (dataGridConfiguration.swipingOffset.isNegative) {
      final double maxOffset = getSwipeMaxOffset(dataGridConfiguration);
      return Rect.fromLTWH(
          maxOffset - swipeValue.abs(), top, maxOffset, height);
    } else {
      return Rect.fromLTWH(0.0, top, swipeValue, height);
    }
  }

  @override
  void performLayout() {
    size =
        constraints.constrain(Size(containerSize.width, containerSize.height));

    void layout(
        {required RenderBox child,
        required double width,
        required double height}) {
      child.layout(BoxConstraints.tightFor(width: width, height: height),
          parentUsesSize: true);
    }

    RenderBox? child = firstChild;
    while (child != null) {
      final _VisualContainerParentData parentData =
          child.parentData! as _VisualContainerParentData;
      final DataGridConfiguration dataGridConfiguration =
          _dataGridStateDetails();
      // Need to ensure whether the child type is _RenderVirtualizingCellsWidget
      // or not before accessing it. Because swiping widget's render object won't be
      // _RenderVirtualizingCellsWidget.
      final RenderBox wholeRowElement = child;
      if (wholeRowElement is RenderVirtualizingCellsWidget) {
        if (wholeRowElement.dataRow.isVisible) {
          final Rect rowRect = wholeRowElement._measureRowRect(size.width);

          parentData
            ..width = rowRect.width
            ..height = rowRect.height
            ..rowClipRect = wholeRowElement._rowClipRect
            ..offset = Offset(
                (wholeRowElement.dataRow.isSwipingRow &&
                        dataGridConfiguration.swipingOffset != 0.0 &&
                        dataGridConfiguration.swipingAnimation != null)
                    ? rowRect.left +
                        dataGridConfiguration.swipingAnimation!.value
                    : rowRect.left,
                rowRect.top);

          if (wholeRowElement.dataRow.isSwipingRow &&
              dataGridConfiguration.swipingOffset.abs() > 0.0) {
            _swipeWholeRowElement = wholeRowElement;
          }

          layout(
              child: child, width: parentData.width, height: parentData.height);
        } else {
          child.layout(const BoxConstraints.tightFor(width: 0.0, height: 0.0));
          parentData.reset();
        }
      } else {
        // We added the swiping widget to the last position of children collection.
        // So, we can get it directly from lastChild property.
        final RenderBox? swipingWidget = lastChild;
        if (swipingWidget != null && _swipeWholeRowElement != null) {
          final Rect swipeRowRect =
              _swipeWholeRowElement!._measureRowRect(size.width);

          parentData
            ..width = getSwipeMaxOffset(dataGridConfiguration)
            ..height = swipeRowRect.height
            ..offset = _getSwipingChildOffset(swipeRowRect);

          layout(
              child: swipingWidget,
              width: parentData.width,
              height: parentData.height);
        }
      }

      child = parentData.nextSibling;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    RenderBox? child = firstChild;
    while (child != null) {
      final _VisualContainerParentData childParentData =
          child.parentData! as _VisualContainerParentData;
      final DataGridConfiguration dataGridConfiguration =
          _dataGridStateDetails();
      final RenderBox wholeRowElement = child;
      if (wholeRowElement is RenderVirtualizingCellsWidget) {
        if (childParentData.width != 0.0 && childParentData.height != 0.0) {
          if (childParentData.rowClipRect != null) {
            if (wholeRowElement.dataRow.isSwipingRow &&
                dataGridConfiguration.swipingOffset.abs() > 0.0) {
              // We added the swiping widget to the last position of children collection.
              // So, we can get it directly from lastChild property.
              final RenderBox? swipeWidget = lastChild;
              if (swipeWidget != null) {
                final _VisualContainerParentData childParentData =
                    swipeWidget.parentData! as _VisualContainerParentData;
                context.pushClipRect(needsCompositing,
                    childParentData.offset + offset, _getSwipeWidgetClipRect(),
                    (PaintingContext context, Offset offset) {
                  context.paintChild(swipeWidget, offset);
                });
              }
            }

            context.pushClipRect(
              needsCompositing,
              childParentData.offset + offset,
              childParentData.rowClipRect!,
              (PaintingContext context, Offset offset) {
                context.paintChild(child!, offset);
              },
              clipBehavior: Clip.antiAlias,
            );
          } else {
            context.paintChild(child, childParentData.offset + offset);
          }
        }
      }
      child = childParentData.nextSibling;
    }
  }
}

/// A class [VirtualizingCellsRenderObjectWidget] that configure the
/// [RenderVirtualizingCellsWidget] subclass that layout the list of cells of a row.
class VirtualizingCellsRenderObjectWidget extends MultiChildRenderObjectWidget {
  /// Creates the [VirtualizingCellsRenderObjectWidget] for the
  /// [RenderVirtualizingCellsWidget].
  VirtualizingCellsRenderObjectWidget(
      {required Key key,
      required this.dataRow,
      required this.isDirty,
      required this.children,
      required this.dataGridStateDetails})
      : super(
            key: key,
            children: RepaintBoundary.wrapAll(List<Widget>.from(children)));

  @override
  final List<Widget> children;

  /// The data grid row that contains list of visible columns.
  final DataRowBase dataRow;

  /// Checks whether the data grid row is dirty from the previous or not to
  /// refresh the row when rebuilding.
  final bool isDirty;

  /// Holds the [DataGridStateDetails].
  final DataGridStateDetails dataGridStateDetails;

  @override
  RenderVirtualizingCellsWidget createRenderObject(BuildContext context) =>
      RenderVirtualizingCellsWidget(
          dataRow: dataRow,
          isDirty: isDirty,
          dataGridStateDetails: dataGridStateDetails);

  @override
  void updateRenderObject(
      BuildContext context, RenderVirtualizingCellsWidget renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject
      ..dataRow = dataRow
      ..isDirty = isDirty;
  }
}

class _VirtualizingCellWidgetParentData
    extends ContainerBoxParentData<RenderBox> {
  _VirtualizingCellWidgetParentData();

  double width = 0.0;
  double height = 0.0;
  Rect? cellClipRect;

  void reset() {
    width = 0.0;
    height = 0.0;
    offset = Offset.zero;
    cellClipRect = null;
  }
}

/// A render object [RenderVirtualizingCellsWidget] that rendering the
/// virtualizing cells in the data grid.
class RenderVirtualizingCellsWidget extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox,
            _VirtualizingCellWidgetParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox,
            _VirtualizingCellWidgetParentData>
    implements
        MouseTrackerAnnotation {
  /// Creates a [RenderVirtualizingCellsWidget] for `SfDataGrid`.
  RenderVirtualizingCellsWidget({
    List<RenderBox>? children,
    required DataRowBase dataRow,
    required bool isDirty,
    required DataGridStateDetails? dataGridStateDetails,
  })  : _dataRow = dataRow,
        _isDirty = isDirty,
        _dataGridStateDetails = dataGridStateDetails! {
    addAll(children);
    // Provides the `postAcceptSlopTolerance` to restrict the call of
    // long press event from the framework when executing the PointerMoveEvent.
    _onLongPressGesture =
        LongPressGestureRecognizer(postAcceptSlopTolerance: 10.0)
          ..onLongPressStart = _onLongPressStart
          ..onLongPressEnd = _onLongPressEnd
          ..onLongPress = _onLongPress;
  }

  /// Decides whether the current virtualizing cells need to be refreshed.
  bool get isDirty => _isDirty;
  bool _isDirty = false;

  //Need to restrict swiping when `onSwipeStart` callback returns false
  bool _canStartSwiping = true;

  set isDirty(bool newValue) {
    _isDirty = newValue;
    if (_isDirty) {
      markNeedsLayout();
      markNeedsPaint();
    }

    dataRow.isDirty = false;
  }

  /// An instance of a [DataRowBase].
  DataRowBase get dataRow => _dataRow;
  DataRowBase _dataRow;

  set dataRow(DataRowBase newValue) {
    if (_dataRow == newValue) {
      return;
    }

    _dataRow = newValue;
    markNeedsLayout();
    markNeedsPaint();
  }

  Rect _rowRect = Rect.zero;

  Rect? _rowClipRect;

  DataGridRowSwipeDirection? _swipeDirection;

  LongPressStartDetails? _longPressStartDetails;

  DataCellBase? _dataCellBase;

  /// Handles the long press events.
  late LongPressGestureRecognizer _onLongPressGesture;

  /// It's helps to find the difference of dy action between on [PointerDownEvent]
  /// and [PointerMoveEvent] event.
  double dy = 0.0;

  /// Holds the [DataGridStateDetails].
  final DataGridStateDetails _dataGridStateDetails;

  Rect _measureRowRect(double width) {
    if (dataRow.isVisible) {
      final DataGridConfiguration dataGridConfiguration =
          _dataGridStateDetails();
      final VisualContainerHelper container = dataGridConfiguration.container;

      final VisibleLineInfo? lineInfo =
          container.scrollRows.getVisibleLineAtLineIndex(dataRow.rowIndex);

      final double lineSize = lineInfo != null ? lineInfo.size : 0.0;
      double origin = (lineInfo != null) ? lineInfo.origin : 0.0;

      origin += container.verticalOffset;

      if (dataRow.rowIndex >
          grid_helper.getHeaderIndex(dataGridConfiguration)) {
        final double headerRowsHeight = container.scrollRows
            .rangeToRegionPoints(
                0, grid_helper.getHeaderIndex(dataGridConfiguration), true)[1]
            .length;
        origin -= headerRowsHeight;
      }

      _rowClipRect = _getRowClipRect(lineInfo, lineSize, width);

      _rowRect = Rect.fromLTWH(0, origin, width, lineSize);
      return _rowRect;
    } else {
      return Rect.zero;
    }
  }

  Rect? _getRowClipRect(
      VisibleLineInfo? lineInfo, double lineHeight, double width) {
    final DataGridConfiguration dataGridConfiguration = _dataGridStateDetails();

    // Clipping the row when the frozen rows are applied.
    if (lineInfo != null && lineInfo.isClippedBody) {
      double top = 0.0, height = lineHeight;
      if (lineInfo.isClippedOrigin) {
        top =
            lineInfo.size - lineInfo.clippedSize - lineInfo.clippedCornerExtent;
      }
      if (lineInfo.isClippedCorner) {
        height = lineInfo.clippedSize;
      }

      if (dataGridConfiguration.allowSwiping && dataRow.isSwipingRow) {
        return _getSwipingRowClipRect(
            top: top,
            height: height,
            dataGridConfiguration: dataGridConfiguration);
      } else {
        return Rect.fromLTWH(0.0, top, width, height);
      }
    } else if (dataGridConfiguration.allowSwiping && dataRow.isSwipingRow) {
      return _getSwipingRowClipRect(
          top: 0.0,
          height: lineHeight,
          dataGridConfiguration: dataGridConfiguration);
    } else {
      return null;
    }
  }

  Rect? _getSwipingRowClipRect(
      {required DataGridConfiguration dataGridConfiguration,
      required double top,
      required double height}) {
    if (dataGridConfiguration.swipingAnimation == null) {
      return null;
    }
    double leftPosition = 0.0;
    final double viewWidth = dataGridConfiguration.viewWidth;
    final double extentWidth = dataGridConfiguration.container.extentWidth;
    final double swipingDelta = dataGridConfiguration.swipingOffset >= 0
        ? dataGridConfiguration.swipingAnimation!.value
        : -dataGridConfiguration.swipingAnimation!.value;

    if (dataGridConfiguration.textDirection == TextDirection.rtl &&
        viewWidth > extentWidth) {
      leftPosition = dataGridConfiguration.swipingOffset >= 0
          ? viewWidth - extentWidth
          : (viewWidth - extentWidth) + swipingDelta;
    } else {
      leftPosition =
          dataGridConfiguration.swipingOffset >= 0 ? 0 : swipingDelta;
    }
    return Rect.fromLTWH(leftPosition, top, extentWidth - swipingDelta, height);
  }

  Rect _getRowRect(DataGridConfiguration dataGridConfiguration, Offset offset,
      {bool isHoveredLayer = false}) {
    bool needToSetMaxConstraint() =>
        dataGridConfiguration.container.extentWidth <
            dataGridConfiguration.viewWidth &&
        dataGridConfiguration.textDirection == TextDirection.rtl;

    if (dataRow.rowType == RowType.footerRow) {
      return Rect.fromLTWH(
          offset.dx + dataGridConfiguration.container.horizontalOffset,
          offset.dy,
          dataGridConfiguration.viewWidth,
          dataGridConfiguration.footerHeight);
    } else {
      return Rect.fromLTWH(
          needToSetMaxConstraint()
              ? constraints.maxWidth -
                  min(dataGridConfiguration.container.extentWidth,
                      dataGridConfiguration.viewWidth) -
                  (offset.dx + dataGridConfiguration.container.horizontalOffset)
              : offset.dx + dataGridConfiguration.container.horizontalOffset,
          offset.dy,
          needToSetMaxConstraint()
              ? constraints.maxWidth
              : min(dataGridConfiguration.container.extentWidth,
                  dataGridConfiguration.viewWidth),
          (isHoveredLayer &&
                  dataRow.isHoveredRow &&
                  (dataGridConfiguration.gridLinesVisibility ==
                          GridLinesVisibility.horizontal ||
                      dataGridConfiguration.gridLinesVisibility ==
                          GridLinesVisibility.both))
              ? constraints.maxHeight -
                  dataGridConfiguration.dataGridThemeHelper!.gridLineStrokeWidth
              : constraints.maxHeight);
    }
  }

  void _drawRowBackground(DataGridConfiguration dataGridConfiguration,
      PaintingContext context, Offset offset) {
    final Rect rect = _getRowRect(dataGridConfiguration, offset);
    Color? backgroundColor;

    Color getDefaultRowBackgroundColor() {
      return Colors.transparent.withOpacity(0.0001);
    }

    void drawSpannedRowBackgroundColor(Color backgroundColor) {
      final bool isRowSpanned = dataRow.visibleColumns
          .any((DataCellBase dataCell) => dataCell.rowSpan > 0);
      final DataGridConfiguration dataGridConfiguration =
          _dataGridStateDetails();

      if (isRowSpanned) {
        RenderBox? child = lastChild;
        while (child != null && child is RenderGridCell) {
          final _VirtualizingCellWidgetParentData childParentData =
              child.parentData! as _VirtualizingCellWidgetParentData;
          final DataCellBase dataCell = child.dataCell;
          final VisibleLineInfo? lineInfo =
              dataRow.getColumnVisibleLineInfo(dataCell.columnIndex);
          if (dataCell.rowSpan > 0 && lineInfo != null) {
            final Rect? columnRect = child._columnRect;
            final Rect? cellClipRect = child._cellClipRect;
            final double height = dataRow.getRowHeight(
                dataCell.rowIndex - dataCell.rowSpan, dataCell.rowIndex);
            Rect cellRect = Rect.zero;
            if (cellClipRect != null) {
              double left = columnRect!.left;
              double width = cellClipRect.width;
              if (cellClipRect.left > 0 && columnRect.width <= width) {
                left += cellClipRect.left;
                width = columnRect.width - cellClipRect.left;
              } else if (cellClipRect.left > 0 && width < columnRect.width) {
                left += cellClipRect.left;
              }

              cellRect = Rect.fromLTWH(left, columnRect.top, width, height);
            } else {
              cellRect = Rect.fromLTWH(
                  columnRect!.left, columnRect.top, columnRect.width, height);
            }
            dataGridConfiguration.gridPaint?.color = backgroundColor;
            context.canvas.drawRect(cellRect, dataGridConfiguration.gridPaint!);
          }
          child = childParentData.previousSibling;
        }
      }
    }

    if (dataGridConfiguration.gridPaint != null) {
      dataGridConfiguration.gridPaint!.style = PaintingStyle.fill;

      if (dataRow.rowRegion == RowRegion.header &&
              dataRow.rowType == RowType.headerRow ||
          dataRow.rowType == RowType.stackedHeaderRow) {
        backgroundColor =
            dataGridConfiguration.dataGridThemeHelper!.headerColor;
        drawSpannedRowBackgroundColor(backgroundColor);
      } else if (dataRow.rowType == RowType.footerRow) {
        backgroundColor = getDefaultRowBackgroundColor();
      } else if (dataRow.rowType == RowType.tableSummaryRow ||
          dataRow.rowType == RowType.tableSummaryCoveredRow) {
        backgroundColor = dataRow.tableSummaryRow?.color;
      } else {
        /// Need to check the rowStyle Please look the previous version and
        /// selection preference
        backgroundColor = dataRow.isSelectedRow
            ? dataGridConfiguration.dataGridThemeHelper!.selectionColor
            : dataRow.dataGridRowAdapter!.color;
      }

      // Default theme color are common for both the HeaderBackgroundColor and
      // CellBackgroundColor, so we have checked commonly at outside of the
      // condition
      backgroundColor ??= getDefaultRowBackgroundColor();

      dataGridConfiguration.gridPaint?.color = backgroundColor;
      context.canvas.drawRect(rect, dataGridConfiguration.gridPaint!);
    }
  }

  void _drawCurrentRowBorder(PaintingContext context, Offset offset) {
    final DataGridConfiguration dataGridConfiguration = _dataGridStateDetails();

    if (dataGridConfiguration.boxPainter != null &&
        dataGridConfiguration.selectionMode == SelectionMode.multiple &&
        dataGridConfiguration.navigationMode == GridNavigationMode.row &&
        dataGridConfiguration.currentCell.rowIndex == dataRow.rowIndex) {
      bool needToSetMaxConstraint() =>
          dataGridConfiguration.container.extentWidth <
              dataGridConfiguration.viewWidth &&
          dataGridConfiguration.textDirection == TextDirection.rtl;

      const double stokeWidth = 1;
      final int origin = (stokeWidth / 2 +
              dataGridConfiguration.dataGridThemeHelper!.gridLineStrokeWidth)
          .ceil();

      final Rect rowRect = _getRowRect(dataGridConfiguration, offset);
      final double maxWidth = needToSetMaxConstraint()
          ? rowRect.width - rowRect.left
          : rowRect.right - rowRect.left;

      final bool isHorizontalGridLinesEnabled =
          dataGridConfiguration.gridLinesVisibility ==
                  GridLinesVisibility.both ||
              dataGridConfiguration.gridLinesVisibility ==
                  GridLinesVisibility.horizontal;

      dataGridConfiguration.boxPainter!.paint(
          context.canvas,
          Offset(rowRect.left + origin, rowRect.top + (origin / 2)),
          dataGridConfiguration.configuration!.copyWith(
              size: Size(
                  maxWidth - (origin * 2),
                  constraints.maxHeight -
                      (origin * (isHorizontalGridLinesEnabled ? 1.5 : 1)))));
    }
  }

  @override
  void setupParentData(RenderObject child) {
    super.setupParentData(child);
    if (child.parentData != null &&
        child.parentData != _VirtualizingCellWidgetParentData()) {
      child.parentData = _VirtualizingCellWidgetParentData();
    }
  }

  void _handleSwipingListener() {
    final DataGridConfiguration dataGridConfiguration = _dataGridStateDetails();
    notifyDataGridPropertyChangeListeners(dataGridConfiguration.source,
        propertyName: 'Swiping');
  }

  @override
  void attach(PipelineOwner owner) {
    final DataGridConfiguration dataGridConfiguration = _dataGridStateDetails();
    dataGridConfiguration.swipingAnimationController
        ?.addListener(_handleSwipingListener);
    super.attach(owner);
  }

  @override
  void detach() {
    final DataGridConfiguration dataGridConfiguration = _dataGridStateDetails();
    dataGridConfiguration.swipingAnimationController
        ?.removeListener(_handleSwipingListener);

    super.detach();
  }

  @override
  bool get isRepaintBoundary => true;

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    RenderBox? child = lastChild;
    while (child != null) {
      final _VirtualizingCellWidgetParentData childParentData =
          child.parentData! as _VirtualizingCellWidgetParentData;
      final bool isHit = result.addWithPaintOffset(
        offset: childParentData.offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          if (child is RenderGridCell &&
              child._cellClipRect != null &&
              !child._cellClipRect!.contains(transformed)) {
            return false;
          }

          return child!.hitTest(result, position: transformed);
        },
      );

      if (isHit) {
        return true;
      }
      child = childParentData.previousSibling;
    }
    return false;
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    final bool isRowSpanned = dataRow.visibleColumns
        .any((DataCellBase dataCell) => dataCell.rowSpan > 0);

    if (isRowSpanned) {
      RenderBox? child = lastChild;
      while (child != null) {
        final _VirtualizingCellWidgetParentData childParentData =
            child.parentData! as _VirtualizingCellWidgetParentData;
        if (child is RenderGridCell &&
            child._columnRect != null &&
            child._columnRect!.contains(position)) {
          // Need to resolve the position when dataCell has row span.
          if (child.dataCell.rowSpan > 0) {
            // Send the position manually to the `hitTestChildren` to avoid the
            // restriction of spanned row hit test from the framework side.
            // Because the spanned row `dy` position starts from the negative value.
            if (hitTestChildren(result, position: position)) {
              // If the position exists in the any child, add the position to the
              // result object like the flutter framework.
              result.add(BoxHitTestEntry(this, position));
              return true;
            }
            return false;
          }
          return super.hitTest(result, position: position);
        }
        child = childParentData.previousSibling;
      }
    }

    return super.hitTest(result, position: position);
  }

  void _updateSwipingAnimation(
      DataGridConfiguration dataGridConfiguration, double swipeMaxOffset) {
    dataGridConfiguration.swipingAnimation = Tween<double>(
            begin: 0.0,
            end: dataGridConfiguration.swipingOffset.sign >= 0
                ? swipeMaxOffset
                : -swipeMaxOffset)
        .animate(dataGridConfiguration.swipingAnimationController!);
  }

  void _handleSwipeStart(
      PointerDownEvent event, DataGridConfiguration dataGridConfiguration) {
    // Need to reset the swiping and scrolling state to default when pointer
    // up and touch again
    dataGridConfiguration.isSwipingApplied = false;
    dataGridConfiguration.scrollingState = ScrollDirection.idle;
    _swipeDirection = null;

    // Need to check whether tap action placed on another [DataGridRow]
    // instead of swiped [DataGridRow].
    //
    // If its tapped on the same swiped [DataGridRow], we don't do anything.
    // If it's tapped on different [DataGridRow] or scrolled, we need to end
    // the swiping.
    final DataRowBase? swipedRow = dataGridConfiguration.rowGenerator.items
        .firstWhereOrNull((DataRowBase row) =>
            row.isSwipingRow && dataGridConfiguration.swipingOffset.abs() > 0);

    if (swipedRow != null && swipedRow.rowIndex != dataRow.rowIndex) {
      dataGridConfiguration.container
          .resetSwipeOffset(swipedRow: swipedRow, canUpdate: true);
      dataGridConfiguration.swipingOffset = event.localDelta.dx;
      dy = event.localDelta.dy;
    }
  }

  void _handleSwipeUpdate(
      PointerMoveEvent event, DataGridConfiguration dataGridConfiguration) {
    bool canUpdateSwiping = true;
    void onSwipeStart(int rowIndex) {
      if (_swipeDirection != null &&
          dataGridConfiguration.onSwipeStart != null) {
        final DataGridSwipeStartDetails swipeStartDetails =
            DataGridSwipeStartDetails(
                rowIndex: rowIndex, swipeDirection: _swipeDirection!);
        setSwipeOffsetInDataGridSwipeStartDetailsArgs(
            dataGridConfiguration, swipeStartDetails);
        dataGridConfiguration.effectiveSwipeMaxOffset = null;
        _canStartSwiping =
            dataGridConfiguration.onSwipeStart!(swipeStartDetails);
      }
    }

    final double currentSwipingDelta =
        dataGridConfiguration.swipingOffset + event.localDelta.dx;
    dy = dy - event.localDelta.dy;
    // If it's fling or scrolled, we have to ignore the swiping action
    if (!dataGridConfiguration.isSwipingApplied &&
        (dataGridConfiguration.scrollingState == ScrollDirection.forward ||
            dy.abs() > 3)) {
      dataGridConfiguration.isSwipingApplied = false;
      return;
    }
    final ScrollController horizontalController =
        dataGridConfiguration.horizontalScrollController!;
    final int rowIndex = grid_helper.resolveToRecordIndex(
        dataGridConfiguration, dataRow.rowIndex);

    // Sets `swipeDirection` to null when the swipe offset is changed the
    // dragging direction to update the `swipeDirection` property.
    if (currentSwipingDelta.sign != dataGridConfiguration.swipingOffset.sign) {
      _swipeDirection = null;
    }

    /// Swipe must to happen when it's reach the max and min scroll extend.
    if (currentSwipingDelta > 2) {
      if (dataGridConfiguration.container.horizontalOffset ==
              horizontalController.position.minScrollExtent &&
          _swipeDirection == null) {
        _swipeDirection = grid_helper.getSwipeDirection(
            dataGridConfiguration, currentSwipingDelta);
        onSwipeStart(rowIndex);
      }
    } else if (currentSwipingDelta < -2) {
      if (dataGridConfiguration.container.horizontalOffset ==
              horizontalController.position.maxScrollExtent &&
          _swipeDirection == null) {
        _swipeDirection = grid_helper.getSwipeDirection(
            dataGridConfiguration, currentSwipingDelta);
        onSwipeStart(rowIndex);
      }
    }
    if (_swipeDirection != null &&
        grid_helper.canSwipeRow(
            dataGridConfiguration, _swipeDirection!, currentSwipingDelta)) {
      final double oldSwipingDelta = dataGridConfiguration.swipingOffset;
      if (_canStartSwiping) {
        dataGridConfiguration.isSwipingApplied = true;
        if (dataGridConfiguration.onSwipeUpdate != null) {
          final DataGridSwipeUpdateDetails swipeUpdateDetails =
              DataGridSwipeUpdateDetails(
                  rowIndex: rowIndex,
                  swipeDirection: _swipeDirection!,
                  swipeOffset: currentSwipingDelta);
          canUpdateSwiping =
              dataGridConfiguration.onSwipeUpdate!(swipeUpdateDetails);
        }

        if (!canUpdateSwiping ||
            dataGridConfiguration.swipingAnimationController!.isAnimating) {
          return;
        }

        final double swipeMaxOffset = getSwipeMaxOffset(dataGridConfiguration);
        // Sets the `swipeMaxOffset` if the swipe offset reaches the maximum limit.
        if (currentSwipingDelta.abs() >= swipeMaxOffset) {
          if (dataGridConfiguration.swipingOffset.isNegative) {
            dataGridConfiguration.swipingOffset = -swipeMaxOffset;
          } else {
            dataGridConfiguration.swipingOffset = swipeMaxOffset;
          }
        } else {
          dataGridConfiguration.swipingOffset += event.localDelta.dx;
        }
        dataRow.isSwipingRow = true;
        if (oldSwipingDelta.sign != currentSwipingDelta.sign) {
          _updateSwipingAnimation(dataGridConfiguration, swipeMaxOffset);
        }
        if (!dataGridConfiguration.swipingAnimationController!.isAnimating) {
          dataGridConfiguration.swipingAnimationController!.value =
              dataGridConfiguration.swipingOffset.abs() / swipeMaxOffset;
        }
      } else {
        dataGridConfiguration.container.resetSwipeOffset(canUpdate: true);
      }
    }
  }

  void _handleSwipeEnd(
      PointerUpEvent event, DataGridConfiguration dataGridConfiguration) {
    void onSwipeEnd() {
      if (dataGridConfiguration.onSwipeEnd != null) {
        final int rowIndex = grid_helper.resolveToRecordIndex(
            dataGridConfiguration, dataRow.rowIndex);
        final DataGridRowSwipeDirection swipeDirection =
            grid_helper.getSwipeDirection(
                dataGridConfiguration, dataGridConfiguration.swipingOffset);
        final DataGridSwipeEndDetails swipeEndDetails = DataGridSwipeEndDetails(
            rowIndex: rowIndex, swipeDirection: swipeDirection);
        dataGridConfiguration.onSwipeEnd!(swipeEndDetails);
      }
    }

    if (dataRow.isSwipingRow) {
      if (dataGridConfiguration.swipingAnimationController!.isAnimating) {
        return;
      }

      dataGridConfiguration.isSwipingApplied = false;
      final double maxOffset = getSwipeMaxOffset(dataGridConfiguration);
      if (dataGridConfiguration.swipingOffset.abs() > maxOffset / 2) {
        dataGridConfiguration.swipingOffset =
            dataGridConfiguration.swipingOffset >= 0 ? maxOffset : -maxOffset;
        dataGridConfiguration.swipingAnimationController!
            .forward()
            .then((_) => onSwipeEnd());
      } else {
        dataGridConfiguration.swipingAnimationController!.reverse().then((_) {
          onSwipeEnd();
          dataGridConfiguration.container.resetSwipeOffset(swipedRow: dataRow);
        });
      }
    }

    dy = 0.0;
    dataGridConfiguration.scrollingState = ScrollDirection.idle;
    _canStartSwiping = true;
  }

  void _handleSwiping(PointerEvent event) {
    final DataGridConfiguration dataGridConfiguration = _dataGridStateDetails();
    if (dataGridConfiguration.allowSwiping &&
        dataRow.rowType == RowType.dataRow) {
      if (event is PointerDownEvent) {
        _handleSwipeStart(event, dataGridConfiguration);
      }
      if (event is PointerMoveEvent) {
        _handleSwipeUpdate(event, dataGridConfiguration);
      }
      if (event is PointerUpEvent) {
        _handleSwipeEnd(event, dataGridConfiguration);
      }
    }
  }

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    super.handleEvent(event, entry);
    _handleSwiping(event);

    _handleColumnResizing(event);

    // Handles the all the datagrid long press events here commonly.
    if (event is PointerDownEvent) {
      _onLongPressGesture.addPointer(event);
    }
  }

  void _handleColumnResizing(PointerEvent event) {
    final DataGridConfiguration dataGridConfiguration = _dataGridStateDetails();
    if (dataGridConfiguration.allowColumnsResizing) {
      if (event is PointerHoverEvent) {
        dataGridConfiguration.columnResizeController
            .onPointerHover(event, dataRow);
      }
      if (event is PointerDownEvent) {
        dataGridConfiguration.columnResizeController
            .onPointerDown(event, dataRow);
      }
      if (event is PointerMoveEvent) {
        dataGridConfiguration.columnResizeController
            .onPointerMove(event, dataRow);
      }
      if (event is PointerUpEvent) {
        dataGridConfiguration.columnResizeController
            .onPointerUp(event, dataRow);
      }
    }
  }

  @override
  void performLayout() {
    void layout(
        {required RenderBox child,
        required double width,
        required double height}) {
      child.layout(BoxConstraints.tightFor(width: width, height: height),
          parentUsesSize: true);
    }

    RenderBox? child = firstChild;
    while (child != null) {
      final _VirtualizingCellWidgetParentData parentData =
          child.parentData! as _VirtualizingCellWidgetParentData;
      if (dataRow.isVisible &&
          child is RenderGridCell &&
          child.dataCell.isVisible) {
        final Rect columnRect =
            child._measureColumnRect(constraints.maxHeight)!;
        size = constraints.constrain(Size(columnRect.width, columnRect.height));
        parentData
          ..width = columnRect.width
          ..height = columnRect.height
          ..cellClipRect = child._cellClipRect;
        layout(
            child: child, width: parentData.width, height: parentData.height);
        parentData.offset = Offset(columnRect.left, columnRect.top);
      } else {
        if (dataRow.rowType == RowType.footerRow) {
          final DataGridConfiguration dataGridConfiguration =
              _dataGridStateDetails();
          final Rect cellRect = Rect.fromLTWH(
              dataGridConfiguration.container.horizontalOffset,
              0.0,
              dataGridConfiguration.viewWidth,
              dataGridConfiguration.footerHeight);

          size = constraints.constrain(Size(cellRect.width, cellRect.height));
          parentData
            ..width = cellRect.width
            ..height = cellRect.height
            ..offset = Offset(cellRect.left, cellRect.top);
          layout(
              child: child, width: parentData.width, height: parentData.height);
        } else {
          size = constraints.constrain(Size.zero);
          child.layout(const BoxConstraints.tightFor(width: 0, height: 0));
          parentData.reset();
        }
      }
      child = parentData.nextSibling;
    }
  }

  void _drawRowHoverBackground(DataGridConfiguration dataGridConfiguration,
      PaintingContext context, Offset offset) {
    if (dataGridConfiguration.isDesktop &&
        dataGridConfiguration.highlightRowOnHover &&
        dataRow.isHoveredRow) {
      dataGridConfiguration.gridPaint?.color =
          dataGridConfiguration.dataGridThemeHelper!.rowHoverColor;
      context.canvas.drawRect(
          _getRowRect(dataGridConfiguration, offset, isHoveredLayer: true),
          dataGridConfiguration.gridPaint!);
    }
  }

  void _drawTableSummaryRowBorder(DataGridConfiguration dataGridConfiguration,
      PaintingContext context, Offset offset) {
    Rect getRowRect() {
      final double extentWidth = dataGridConfiguration.container.extentWidth;
      final Rect rect = _getRowRect(dataGridConfiguration, offset);

      if (dataRow.rowType == RowType.tableSummaryRow) {
        final double left = (extentWidth < dataGridConfiguration.viewWidth &&
                dataGridConfiguration.textDirection == TextDirection.rtl)
            ? constraints.maxWidth -
                min(extentWidth, dataGridConfiguration.viewWidth) -
                offset.dx
            : offset.dx;
        return Rect.fromLTWH(left, rect.top, extentWidth, rect.height);
      } else {
        return Rect.fromLTWH(rect.left, rect.top,
            min(extentWidth, dataGridConfiguration.viewWidth), rect.height);
      }
    }

    if (dataGridConfiguration.gridLinesVisibility == GridLinesVisibility.none ||
        dataGridConfiguration.gridLinesVisibility ==
            GridLinesVisibility.horizontal) {
      return;
    }

    if (dataRow.rowType == RowType.tableSummaryRow ||
        dataRow.rowType == RowType.tableSummaryCoveredRow) {
      final BorderSide border = BorderSide(
          width: dataGridConfiguration.dataGridThemeHelper!.gridLineStrokeWidth,
          color: dataGridConfiguration.dataGridThemeHelper!.gridLineColor);

      if (dataGridConfiguration.textDirection == TextDirection.ltr) {
        paintBorder(context.canvas, getRowRect(), right: border);
      } else {
        paintBorder(context.canvas, getRowRect(), left: border);
      }
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final DataGridConfiguration dataGridConfiguration = _dataGridStateDetails();

    // Remove the below method if the mentioned report has resolved
    // form framework side
    // https://github.com/flutter/flutter/issues/29702
    _drawRowBackground(dataGridConfiguration, context, offset);

    _drawRowHoverBackground(dataGridConfiguration, context, offset);

    RenderBox? child = firstChild;
    while (child != null) {
      final _VirtualizingCellWidgetParentData childParentData =
          child.parentData! as _VirtualizingCellWidgetParentData;
      if (childParentData.width != 0.0 && childParentData.height != 0.0) {
        if (childParentData.cellClipRect != null) {
          context.pushClipRect(
            needsCompositing,
            childParentData.offset + offset,
            childParentData.cellClipRect!,
            (PaintingContext context, Offset offset) {
              context.paintChild(child!, offset);
            },
            clipBehavior: Clip.antiAlias,
          );
        } else {
          context.paintChild(child, childParentData.offset + offset);
        }
      }
      child = childParentData.nextSibling;
    }

    // To draw the right border to the table summary row.
    _drawTableSummaryRowBorder(dataGridConfiguration, context, offset);

    if (dataGridConfiguration.isDesktop) {
      _drawCurrentRowBorder(context, offset);
    }
  }

  @override
  MouseCursor get cursor {
    final DataGridConfiguration dataGridConfiguration = _dataGridStateDetails();
    return dataGridConfiguration
            .columnResizeController.canSwitchResizeColumnCursor
        ? SystemMouseCursors.resizeColumn
        : SystemMouseCursors.basic;
  }

  @override
  PointerEnterEventListener? get onEnter => _onPointerEnter;

  @override
  PointerExitEventListener? get onExit => _onPointerExit;

  @override
  bool get validForMouseTracker {
    final DataGridConfiguration dataGridConfiguration = _dataGridStateDetails();
    return (dataGridConfiguration.highlightRowOnHover &&
            dataRow.rowType == RowType.dataRow) ||
        (dataGridConfiguration.allowColumnsResizing &&
            (dataRow.rowType == RowType.stackedHeaderRow ||
                dataRow.rowType == RowType.headerRow));
  }

  DataCellBase? _getDataCellBase(
    DataRowBase dataRow,
    dynamic details,
  ) {
    final DataGridConfiguration dataGridConfiguration = _dataGridStateDetails();
    DataCellBase? dataCell;

    // Issue:
    // FLUT-6105 - Null check operator exception is thrown when long press the
    // table summary rows.
    //
    // Fix:
    // An issue occurred because of disallowing the table summary rows in the
    // long-press event. So, the data cell field had been null to the table
    // summary rows. Now, We have fixed it by allowing long-press events for all
    // the row types except for the `footer` row type since it's not required.
    if (dataRow.rowType != RowType.footerRow) {
      final double position = dataGridConfiguration.columnResizeController
          .getXPosition(dataGridConfiguration, details.localPosition.dx);
      final VisibleLineInfo? resizingLine =
          dataGridConfiguration.container.scrollColumns.getVisibleLineAtPoint(
              position,
              false,
              dataGridConfiguration.textDirection == TextDirection.rtl);

      if (dataRow.rowType == RowType.stackedHeaderRow ||
          dataRow.rowType == RowType.tableSummaryRow ||
          dataRow.rowType == RowType.tableSummaryCoveredRow) {
        dataCell =
            dataRow.visibleColumns.firstWhereOrNull((DataCellBase dataCell) {
          final int cellLeft = dataCell.columnIndex;
          final int cellRight = dataCell.columnIndex + dataCell.columnSpan;

          return cellLeft == resizingLine!.lineIndex ||
              cellRight == resizingLine.lineIndex ||
              (resizingLine.lineIndex > cellLeft &&
                  resizingLine.lineIndex < cellRight);
        });
      } else {
        dataCell = dataRow.visibleColumns.firstWhereOrNull(
            (DataCellBase element) =>
                element.columnIndex == resizingLine!.lineIndex);
      }
    }
    return dataCell;
  }

  void _onLongPress() {
    final DataGridConfiguration dataGridConfiguration = _dataGridStateDetails();
    if (_dataCellBase != null &&
        _longPressStartDetails != null &&
        dataGridConfiguration.onCellLongPress != null) {
      final DataGridCellLongPressDetails longPressDetails =
          DataGridCellLongPressDetails(
              rowColumnIndex: RowColumnIndex(
                  _dataCellBase!.rowIndex, _dataCellBase!.columnIndex),
              column: _dataCellBase!.gridColumn!,
              globalPosition: _longPressStartDetails!.globalPosition,
              localPosition: _longPressStartDetails!.localPosition);
      dataGridConfiguration.onCellLongPress!(longPressDetails);
    }
  }

  // To handle long press start event.
  void _onLongPressStart(LongPressStartDetails details) {
    final DataGridConfiguration dataGridConfiguration = _dataGridStateDetails();
    DataCellBase? dataCell;
    dataCell = _getDataCellBase(dataRow, details);

    _dataCellBase = dataCell;
    _longPressStartDetails = details;

    dataGridConfiguration.columnResizeController
        .onLongPressStart(details, dataRow);
  }

  // To handle long press end event.
  void _onLongPressEnd(LongPressEndDetails details) {
    final DataGridConfiguration dataGridConfiguration = _dataGridStateDetails();
    DataCellBase? dataCell;
    dataCell = _getDataCellBase(dataRow, details);

    if (dataGridConfiguration.currentCell.isEditing && dataCell != null) {
      if (dataCell.cellType == CellType.headerCell) {
        // Clear editing when tap on the header cell
        dataGridConfiguration.currentCell.onCellSubmit(dataGridConfiguration);
      } else if (dataCell.cellType == CellType.gridCell) {
        // Clear editing when tap on the grid cell
        if (dataGridConfiguration.currentCell
            .canSubmitCell(dataGridConfiguration)) {
          dataGridConfiguration.currentCell
              .onCellSubmit(dataGridConfiguration, cancelCanSubmitCell: true);
        }
      }
    }
  }

  void _onPointerEnter(PointerEnterEvent event) {
    final DataGridConfiguration dataGridConfiguration = _dataGridStateDetails();

    if (dataGridConfiguration.allowColumnsResizing) {
      dataGridConfiguration.columnResizeController
          .onPointerEnter(event, dataRow);
    }

    // Restricts the row hovering when resizing the column.
    if (dataGridConfiguration.columnResizeController.isResizeIndicatorVisible) {
      return;
    }

    if (dataGridConfiguration.highlightRowOnHover &&
        dataGridConfiguration.isDesktop &&
        dataRow.rowType == RowType.dataRow) {
      dataRow.isHoveredRow = true;

      final TextStyle rowStyle = TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color:
              dataGridConfiguration.colorScheme!.onSurface.withOpacity(0.87));
      if (dataGridConfiguration.dataGridThemeHelper!.rowHoverTextStyle !=
          rowStyle) {
        dataRow.rowIndexChanged();
        notifyDataGridPropertyChangeListeners(dataGridConfiguration.source,
            propertyName: 'hoverOnCell');
      }

      /// FLUT-5777 Invoke markNeedsPaint only the widget is attached in the
      /// current widget tree. The `owner` property will be null if it is unattached.
      if (owner != null) {
        markNeedsPaint();
      }
    }
  }

  void _onPointerExit(PointerExitEvent event) {
    final DataGridConfiguration dataGridConfiguration = _dataGridStateDetails();

    if (dataGridConfiguration.allowColumnsResizing) {
      dataGridConfiguration.columnResizeController
          .onPointerExit(event, dataRow);
    }

    if (dataRow.isHoveredRow &&
        dataGridConfiguration.highlightRowOnHover &&
        dataGridConfiguration.isDesktop &&
        dataRow.rowType == RowType.dataRow) {
      dataRow.isHoveredRow = false;

      final TextStyle rowStyle = TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color:
              dataGridConfiguration.colorScheme!.onSurface.withOpacity(0.87));
      if (dataGridConfiguration.dataGridThemeHelper!.rowHoverTextStyle !=
          rowStyle) {
        dataRow.rowIndexChanged();
        notifyDataGridPropertyChangeListeners(dataGridConfiguration.source,
            propertyName: 'hoverOnCell');
      }

      /// FLUT-5777 Invoke markNeedsPaint only the widget is attached in the
      /// current widget tree. The `owner` property will be null if it is unattached.
      if (owner != null) {
        markNeedsPaint();
      }
    }
  }
}

/// A class [GridCellRenderObjectWidget] that configure the [RenderGridCell]
/// that layout a data grid cell.
class GridCellRenderObjectWidget extends SingleChildRenderObjectWidget {
  /// Creates the [GridCellRenderObjectWidget] for the [RenderGridCell].
  GridCellRenderObjectWidget({
    required Key? key,
    required this.dataCell,
    required this.isDirty,
    required this.child,
    required this.dataGridStateDetails,
  }) : super(key: key, child: RepaintBoundary.wrap(child, 0));

  @override
  final Widget child;

  /// The data grid cell that contains a cell details.
  final DataCellBase dataCell;

  /// Checks whether the data grid cell is dirty from the previous or not to
  /// refresh the cell when rebuilding.
  final bool isDirty;

  /// Holds the [DataGridStateDetails].
  final DataGridStateDetails dataGridStateDetails;

  @override
  RenderGridCell createRenderObject(BuildContext context) => RenderGridCell(
      dataCell: dataCell,
      isDirty: isDirty,
      dataGridStateDetails: dataGridStateDetails);

  @override
  void updateRenderObject(BuildContext context, RenderGridCell renderObject) {
    super.updateRenderObject(context, renderObject);
    renderObject
      ..isDirty = isDirty
      ..dataCell = dataCell;
  }
}

/// A render object [RenderGridCell] that rendering the grid cell in the
/// `SfDataGrid`.
class RenderGridCell extends RenderBox
    with RenderObjectWithChildMixin<RenderBox>
    implements MouseTrackerAnnotation {
  /// Creates a [RenderGridCell] for `SfDataGrid`.
  RenderGridCell(
      {RenderBox? child,
      required DataCellBase dataCell,
      required bool isDirty,
      required DataGridStateDetails dataGridStateDetails})
      : _dataCell = dataCell,
        _isDirty = isDirty,
        _dataGridStateDetails = dataGridStateDetails {
    this.child = child;
  }

  /// An instance of a [DataCellBase].
  DataCellBase get dataCell => _dataCell;
  DataCellBase _dataCell;

  set dataCell(DataCellBase newDataColumn) {
    if (_dataCell == newDataColumn) {
      return;
    }

    _dataCell = newDataColumn;
    markNeedsLayout();
    markNeedsPaint();
  }

  /// Decides whether the grid cell needs to be refreshed or not.
  bool get isDirty => _isDirty;
  bool _isDirty = false;

  set isDirty(bool newValue) {
    _isDirty = newValue;
    if (_isDirty) {
      markNeedsLayout();
      markNeedsPaint();
    }

    dataCell.isDirty = false;
  }

  Rect? _columnRect = Rect.zero;

  Rect? _cellClipRect;

  bool _isHovered = false;

  final DataGridStateDetails _dataGridStateDetails;

  Rect? _measureColumnRect(double rowHeight) {
    if (dataCell.dataRow != null &&
        dataCell.dataRow!.isVisible &&
        dataCell.isVisible) {
      final DataRowBase dataRow = dataCell.dataRow!;
      final DataGridConfiguration dataGridConfiguration =
          _dataGridStateDetails();
      final double lineWidth = dataRow.getColumnWidth(
          dataCell.columnIndex, dataCell.columnIndex + dataCell.columnSpan);
      final double lineHeight = dataRow.getRowHeight(
          dataCell.rowIndex - dataCell.rowSpan, dataCell.rowIndex);

      if (dataRow.rowType == RowType.stackedHeaderRow) {
        _columnRect = _getStackedHeaderCellRect(
            dataGridConfiguration, lineWidth, lineHeight);
      } else if (dataRow.tableSummaryRow != null &&
          (dataRow.rowType == RowType.tableSummaryRow ||
              dataRow.rowType == RowType.tableSummaryCoveredRow)) {
        _columnRect = _getTableSummaryCellRect(
            dataGridConfiguration, lineWidth, lineHeight);
      } else {
        final VisibleLineInfo? lineInfo =
            dataRow.getColumnVisibleLineInfo(dataCell.columnIndex);
        final double origin = lineInfo != null ? lineInfo.origin : 0.0;
        _columnRect = _getCellRect(
            dataGridConfiguration, lineInfo, origin, lineWidth, lineHeight);
      }
    } else {
      _columnRect = Rect.zero;
    }

    return _columnRect;
  }

  Rect? _getCellRect(
      DataGridConfiguration dataGridConfiguration,
      VisibleLineInfo? lineInfo,
      double origin,
      double lineWidth,
      double lineHeight) {
    final DataRowBase dataRow = dataCell.dataRow!;
    final int rowIndex = dataCell.rowIndex;
    final int rowSpan = dataCell.rowSpan;

    origin += dataGridConfiguration.container.horizontalOffset;

    // To overcome grid common RightToLeft clipping line creation problem
    // instead of handling in grid common source.
    if (dataGridConfiguration.textDirection == TextDirection.rtl &&
        lineInfo != null &&
        lineInfo.visibleIndex ==
            grid_helper
                .getVisibleLines(dataGridConfiguration)
                .firstBodyVisibleIndex) {
      origin += lineInfo.scrollOffset;
    }

    if (dataCell.cellType != CellType.stackedHeaderCell) {
      // Clipping the column when frozen column applied
      _cellClipRect =
          _getCellClipRect(dataGridConfiguration, lineInfo, lineHeight);
    }

    final double topPosition = (rowSpan > 0)
        ? -dataRow.getRowHeight(rowIndex - rowSpan, rowIndex - 1)
        : 0.0;

    _columnRect = Rect.fromLTWH(origin, topPosition, lineWidth, lineHeight);
    return _columnRect;
  }

  double _getCellClippedOrigin(DataGridConfiguration dataGridConfiguration,
      int startIndex, int endIndex) {
    double origin = 0.0;
    final ScrollAxisBase scrollColumns =
        dataGridConfiguration.container.scrollColumns;

    bool updateOrigin(int index, bool isRTL) {
      final VisibleLineInfo? newLine =
          scrollColumns.getVisibleLineAtLineIndex(index, isRightToLeft: true);

      if (newLine != null) {
        // Set origin to zero when scrolling is disabled in RTL.
        if (isRTL &&
            scrollColumns.footerExtent >= dataGridConfiguration.viewWidth) {
          origin = 0.0;
          return false;
        }
        // Set origin only if the line is not footer.
        if (!newLine.isFooter) {
          origin += isRTL && newLine.isClippedCorner
              ? newLine.clippedSize
              : newLine.size - newLine.clippedCorner;
          return false;
        }
      } else {
        origin +=
            dataCell.dataRow!.getColumnWidth(index, index, lineNull: true);
      }
      return true;
    }

    if (dataGridConfiguration.textDirection == TextDirection.rtl) {
      for (int index = endIndex; index >= startIndex; index--) {
        if (!updateOrigin(index, true)) {
          break;
        }
      }
    } else {
      for (int index = startIndex; index <= endIndex; index++) {
        if (!updateOrigin(index, false)) {
          break;
        }
      }
    }
    return origin;
  }

  double _getCellClippedSize(DataGridConfiguration dataGridConfiguration,
      int startIndex, int endIndex) {
    double clippedSize = 0;
    final bool isRTL = dataGridConfiguration.textDirection == TextDirection.rtl;

    for (int index = startIndex; index <= endIndex; index++) {
      final VisibleLineInfo? newLine = dataGridConfiguration
          .container.scrollColumns
          .getVisibleLineAtLineIndex(index, isRightToLeft: isRTL);

      if (newLine != null) {
        clippedSize += isRTL && newLine.isClippedCorner
            ? newLine.clippedCornerExtent
            : newLine.clippedSize;
      }
    }
    return clippedSize;
  }

  void _setClipRect(VisibleLineInfo line, double lineHeight) {
    final DataGridConfiguration dataGridConfiguration = _dataGridStateDetails();
    // Provides the clippedRect to the spanned summary column when
    // frozen column is applied.
    if (dataGridConfiguration.frozenColumnsCount > 0 ||
        dataGridConfiguration.footerFrozenColumnsCount > 0) {
      if (!line.isHeader && dataCell.columnSpan > 0) {
        final int endIndex = dataCell.columnIndex + dataCell.columnSpan;
        final double lineSize = _getCellClippedSize(
            dataGridConfiguration, line.lineIndex, endIndex);
        final double clipOrigin = _getCellClippedOrigin(
            dataGridConfiguration, dataCell.columnIndex, endIndex);
        _cellClipRect = Rect.fromLTWH(clipOrigin, 0.0, lineSize, lineHeight);
      } else {
        _cellClipRect =
            _getCellClipRect(dataGridConfiguration, line, lineHeight);
      }
    }
  }

  Rect _getTableSummaryCellRect(DataGridConfiguration dataGridConfiguration,
      double lineWidth, double lineHeight) {
    if (dataCell.dataRow!.rowType == RowType.tableSummaryCoveredRow) {
      lineWidth = min(dataGridConfiguration.viewWidth,
          dataGridConfiguration.container.extentWidth);
      double offset = dataGridConfiguration.container.horizontalOffset;
      if (dataGridConfiguration.textDirection == TextDirection.rtl &&
          dataGridConfiguration.viewWidth >
              dataGridConfiguration.container.extentWidth) {
        offset += dataGridConfiguration.viewWidth -
            dataGridConfiguration.container.extentWidth;
      }
      return Rect.fromLTWH(offset, 0.0, lineWidth, lineHeight);
    } else {
      double origin = 0.0, clippedWidth = 0.0;
      void setOrigin(VisibleLineInfo line) {
        origin = line.origin;
        if (dataGridConfiguration.textDirection == TextDirection.rtl) {
          origin += line.scrollOffset;
          clippedWidth += line.size;
        }
      }

      VisibleLineInfo? getVisibleLineInfo(int index) =>
          dataCell.dataRow!.getColumnVisibleLineInfo(index);
      final VisibleLineInfo? line = getVisibleLineInfo(dataCell.columnIndex);

      if (line == null) {
        // Gets the origin for the first visible line in the spanned cell and
        // calculates the clipped size.
        for (int index = dataCell.columnIndex;
            index <= dataCell.columnIndex + dataCell.columnSpan;
            index++) {
          final VisibleLineInfo? newLine = getVisibleLineInfo(index);
          if (newLine != null) {
            setOrigin(newLine);
            _setClipRect(newLine, lineHeight);
            break;
          } else {
            clippedWidth +=
                dataCell.dataRow!.getColumnWidth(index, index, lineNull: true);
          }
        }
      } else {
        setOrigin(line);
        _setClipRect(line, lineHeight);
      }

      origin += dataGridConfiguration.container.horizontalOffset;

      origin = dataGridConfiguration.textDirection == TextDirection.rtl
          ? (origin + clippedWidth) - lineWidth
          : origin - clippedWidth;

      return Rect.fromLTWH(origin, 0.0, lineWidth, lineHeight);
    }
  }

  Rect? _getStackedHeaderCellRect(DataGridConfiguration dataGridConfiguration,
      double lineWidth, double lineHeight) {
    final DataRowBase dataRow = dataCell.dataRow!;
    final int cellStartIndex = dataCell.columnIndex;
    final int columnSpan = dataCell.columnSpan;
    final int cellEndIndex = cellStartIndex + columnSpan;
    final int frozenColumns = dataGridConfiguration.container.frozenColumns;
    final int frozenColumnsCount = dataGridConfiguration.frozenColumnsCount;
    final int footerFrozenColumns =
        dataGridConfiguration.container.footerFrozenColumns;
    final int footerFrozenColumnsCount =
        dataGridConfiguration.footerFrozenColumnsCount;
    final int columnsLength = dataGridConfiguration.columns.length;
    final ScrollAxisBase scrollColumns =
        dataGridConfiguration.container.scrollColumns;
    Rect? columnRect = Rect.zero;
    double? origin;
    VisibleLineInfo? lineInfo;

    if (frozenColumns > cellStartIndex && frozenColumns <= cellEndIndex) {
      if (dataGridConfiguration.textDirection == TextDirection.ltr) {
        for (int index = cellEndIndex;
            index >= frozenColumnsCount - 1;
            index--) {
          lineInfo = scrollColumns.getVisibleLineAtLineIndex(index);
          if (lineInfo != null) {
            final VisibleLineInfo? startLineInfo =
                scrollColumns.getVisibleLineAtLineIndex(cellStartIndex);
            origin = startLineInfo?.origin;
            lineWidth = _getClippedWidth(
                dataGridConfiguration, cellStartIndex, cellEndIndex);
            break;
          }
        }
      } else {
        for (int index = cellEndIndex; index >= cellStartIndex; index--) {
          lineInfo = scrollColumns.getVisibleLineAtLineIndex(index);
          if (lineInfo != null) {
            origin = lineInfo.origin < 0 ? 0.0 : lineInfo.origin;
            lineWidth = _getClippedWidth(
                dataGridConfiguration, cellStartIndex, cellEndIndex);
            if (lineInfo.origin < 0) {
              lineWidth += lineInfo.origin;
            }
            break;
          }
        }
      }
    } else if (footerFrozenColumns > 0 &&
        columnsLength - footerFrozenColumnsCount <= cellEndIndex) {
      int span = 0;
      if (dataGridConfiguration.textDirection == TextDirection.ltr) {
        for (int index = cellStartIndex; index <= cellEndIndex; index++) {
          lineInfo = scrollColumns.getVisibleLineAtLineIndex(index);
          if (lineInfo != null) {
            if (index == columnsLength - footerFrozenColumns) {
              origin = lineInfo.origin;
              lineWidth =
                  dataRow.getColumnWidth(cellStartIndex + span, cellEndIndex);
              break;
            } else {
              origin = lineInfo.clippedOrigin;
              lineWidth = _getClippedWidth(
                  dataGridConfiguration, cellStartIndex, cellEndIndex);
              break;
            }
          }
          span += 1;
        }
      } else {
        int span = 0;
        for (int index = cellStartIndex; index <= cellEndIndex; index++) {
          lineInfo = scrollColumns.getVisibleLineAtLineIndex(index);
          if (lineInfo != null) {
            final VisibleLineInfo? line =
                scrollColumns.getVisibleLineAtLineIndex(cellEndIndex);
            if (line != null) {
              if (index == columnsLength - footerFrozenColumnsCount) {
                origin = line.origin;
                lineWidth =
                    dataRow.getColumnWidth(cellStartIndex + span, cellEndIndex);
                break;
              } else {
                origin = line.clippedOrigin - lineInfo.scrollOffset;
                lineWidth = _getClippedWidth(
                    dataGridConfiguration, cellStartIndex, cellEndIndex);
                break;
              }
            }
          }
          span += 1;
        }
      }
    } else {
      int span = dataCell.columnSpan;
      if (dataGridConfiguration.textDirection == TextDirection.ltr) {
        for (int index = cellStartIndex; index <= cellEndIndex; index++) {
          lineInfo = dataRow.getColumnVisibleLineInfo(index);
          if (lineInfo != null) {
            origin = lineInfo.origin +
                dataRow.getColumnWidth(index, index + span) -
                dataRow.getColumnWidth(cellStartIndex, cellEndIndex);

            _cellClipRect = _getSpannedCellClipRect(dataGridConfiguration,
                dataRow, dataCell, lineHeight, lineWidth);
            break;
          }
          span -= 1;
        }
      } else {
        for (int index = cellEndIndex; index >= cellStartIndex; index--) {
          lineInfo = dataRow.getColumnVisibleLineInfo(index);
          if (lineInfo != null) {
            origin = lineInfo.origin +
                dataRow.getColumnWidth(index - span, index) -
                dataRow.getColumnWidth(cellStartIndex, cellEndIndex);

            _cellClipRect = _getSpannedCellClipRect(dataGridConfiguration,
                dataRow, dataCell, lineHeight, lineWidth);
            break;
          }
          span -= 1;
        }
      }
    }

    if (lineInfo != null) {
      // If resizing a column to 0 width the origin value is return null
      // So We need to set origin value as 0.0
      columnRect = _getCellRect(dataGridConfiguration, lineInfo, origin ?? 0.0,
          lineWidth, lineHeight);
    }
    return columnRect;
  }

  double _getClippedWidth(DataGridConfiguration dataGridConfiguration,
      int startIndex, int endIndex) {
    double clippedWidth = 0;
    for (int index = startIndex; index <= endIndex; index++) {
      final VisibleLineInfo? newline =
          dataCell.dataRow!.getColumnVisibleLineInfo(index);
      if (newline != null) {
        if (dataGridConfiguration.textDirection == TextDirection.ltr) {
          clippedWidth +=
              newline.isClipped ? newline.clippedSize : newline.size;
        } else {
          clippedWidth += newline.isClipped
              ? newline.clippedCornerExtent > 0
                  ? newline.clippedCornerExtent
                  : newline.clippedSize
              : newline.size;
        }
      }
    }
    return clippedWidth;
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    final DataGridConfiguration dataGridConfiguration = _dataGridStateDetails();
    // To set the current interacted data cell to the column resizing's data cell.
    dataGridConfiguration.columnResizeController.setDataCell(dataCell);
    // Resets the header cell hovering when resizing the column.
    if (dataGridConfiguration.columnResizeController.isResizeIndicatorVisible) {
      if (_isHovered) {
        _isHovered = false;

        /// FLUT-5777 Invoke markNeedsPaint only the widget is attached in the
        /// current widget tree. The `owner` property will be null if it is unattached.
        if (owner != null) {
          markNeedsPaint();
        }
      }
    }

    return super.hitTest(result, position: position);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    if (child == null) {
      return false;
    }

    final BoxParentData childParentData = child!.parentData! as BoxParentData;
    final bool isHit = result.addWithPaintOffset(
        offset: childParentData.offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) =>
            child!.hitTest(result, position: transformed));
    if (isHit) {
      return true;
    } else {
      return false;
    }
  }

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  bool get isRepaintBoundary => true;

  @override
  void performLayout() {
    size = constraints
        .constrain(Size(constraints.maxWidth, constraints.maxHeight));

    if (child != null) {
      child!.layout(
          BoxConstraints.tightFor(
              width: constraints.maxWidth, height: constraints.maxHeight),
          parentUsesSize: true);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      // Paints the cell hover color.
      _paintHoverColor(context);

      context.paintChild(child!, offset);
    }

    super.paint(context, offset);
  }

  @override
  MouseCursor get cursor {
    final DataGridConfiguration dataGridConfiguration = _dataGridStateDetails();
    return dataGridConfiguration
            .columnResizeController.canSwitchResizeColumnCursor
        ? SystemMouseCursors.resizeColumn
        : SystemMouseCursors.basic;
  }

  @override
  PointerEnterEventListener? get onEnter => _onPointerEnter;

  @override
  PointerExitEventListener? get onExit => _onPointerExit;

  void _onPointerEnter(PointerEnterEvent event) {
    // Restricts the header cell hovering when resizing the column.
    if (_dataGridStateDetails()
        .columnResizeController
        .isResizeIndicatorVisible) {
      return;
    }

    _isHovered = true;

    /// FLUT-5777 Invoke markNeedsPaint only the widget is attached in the
    /// current widget tree. The `owner` property will be null if it is unattached.
    if (owner != null) {
      markNeedsPaint();
    }
  }

  void _onPointerExit(PointerExitEvent event) {
    if (_isHovered) {
      _isHovered = false;

      /// FLUT-5777 Invoke markNeedsPaint only the widget is attached in the
      /// current widget tree. The `owner` property will be null if it is unattached.
      if (owner != null) {
        markNeedsPaint();
      }
    }
  }

  void _paintHoverColor(PaintingContext context) {
    if (dataCell.cellType == CellType.headerCell && _isHovered) {
      final DataGridConfiguration dataGridConfiguration =
          _dataGridStateDetails();
      dataGridConfiguration.gridPaint!.color =
          dataGridConfiguration.dataGridThemeHelper!.headerHoverColor;
      final Rect cellRect =
          Rect.fromLTRB(0, 0, constraints.maxWidth, constraints.maxHeight);

      context.canvas.drawRect(cellRect, dataGridConfiguration.gridPaint!);
    }
  }

  // Tracking only to the header cell for apply hovering color.
  @override
  bool get validForMouseTracker => dataCell.cellType == CellType.headerCell;
}

Rect? _getCellClipRect(DataGridConfiguration dataGridConfiguration,
    VisibleLineInfo? lineInfo, double rowHeight) {
  // FLUT-1971 Need to check whether the lineInfo is null or not. Because it
  // will be null when load empty to the columns collection.
  if (lineInfo == null) {
    return null;
  }
  if (lineInfo.isClippedBody &&
      lineInfo.isClippedOrigin &&
      lineInfo.isClippedCorner) {
    final double left = dataGridConfiguration.textDirection == TextDirection.ltr
        ? lineInfo.size - lineInfo.clippedSize - lineInfo.clippedCornerExtent
        : lineInfo.clippedSize;
    final double right =
        dataGridConfiguration.textDirection == TextDirection.ltr
            ? lineInfo.clippedSize
            : lineInfo.clippedCornerExtent;

    return Rect.fromLTWH(left, 0.0, right, rowHeight);
  } else if (lineInfo.isClippedBody && lineInfo.isClippedOrigin) {
    final double left = dataGridConfiguration.textDirection == TextDirection.ltr
        ? lineInfo.size - lineInfo.clippedSize - lineInfo.clippedCornerExtent
        : 0.0;
    final double right =
        dataGridConfiguration.textDirection == TextDirection.ltr
            ? lineInfo.size
            : lineInfo.size - lineInfo.scrollOffset;

    return Rect.fromLTWH(left, 0.0, right, rowHeight);
  } else if (lineInfo.isClippedBody && lineInfo.isClippedCorner) {
    final double left = dataGridConfiguration.textDirection == TextDirection.ltr
        ? 0.0
        : lineInfo.size - (lineInfo.size - lineInfo.clippedSize);
    final double right =
        dataGridConfiguration.textDirection == TextDirection.ltr
            ? lineInfo.clippedSize
            : lineInfo.size;

    return Rect.fromLTWH(left, 0.0, right, rowHeight);
  } else {
    return null;
  }
}

Rect? _getSpannedCellClipRect(
    DataGridConfiguration dataGridConfiguration,
    DataRowBase dataRow,
    DataCellBase dataCell,
    double cellHeight,
    double cellWidth) {
  Rect? clipRect;
  int firstVisibleStackedColumnIndex = dataCell.columnIndex;
  double lastCellClippedSize = 0.0;
  bool isLastCellClippedCorner = false;
  bool isLastCellClippedBody = false;

  double getClippedWidth(DataCellBase dataCell, DataRowBase dataRow,
      {bool columnsNotInViewWidth = false, bool allCellsClippedWidth = false}) {
    final int startIndex = dataCell.columnIndex;
    final int endIndex = dataCell.columnIndex + dataCell.columnSpan;
    double clippedWidth = 0;
    for (int index = startIndex; index <= endIndex; index++) {
      final VisibleLineInfo? newline = dataRow.getColumnVisibleLineInfo(index);
      if (columnsNotInViewWidth) {
        if (newline == null) {
          clippedWidth +=
              dataGridConfiguration.container.scrollColumns.getLineSize(index);
        } else {
          firstVisibleStackedColumnIndex = index;
          break;
        }
      }
      if (allCellsClippedWidth) {
        if (newline != null) {
          if (dataGridConfiguration.textDirection == TextDirection.ltr) {
            clippedWidth +=
                newline.isClipped ? newline.clippedSize : newline.size;
          } else {
            clippedWidth += newline.isClipped
                ? newline.clippedCornerExtent > 0
                    ? newline.clippedCornerExtent
                    : newline.clippedSize
                : newline.size;
          }
          lastCellClippedSize = newline.clippedSize;
          isLastCellClippedCorner = newline.isClippedCorner;
          isLastCellClippedBody = newline.isClippedBody;
        }
      }
    }
    return clippedWidth;
  }

  if (dataGridConfiguration.frozenColumnsCount < 0 ||
      dataGridConfiguration.footerFrozenColumnsCount < 0) {
    return null;
  }

  if (dataCell.renderer != null) {
    final double columnsNotInViewWidth =
        getClippedWidth(dataCell, dataRow, columnsNotInViewWidth: true);
    final double clippedWidth =
        getClippedWidth(dataCell, dataRow, allCellsClippedWidth: true);
    final VisibleLineInfo? visibleLineInfo =
        dataRow.getColumnVisibleLineInfo(firstVisibleStackedColumnIndex);

    if (visibleLineInfo != null) {
      if (visibleLineInfo.isClippedOrigin && visibleLineInfo.isClippedCorner) {
        final double clippedOrigin = columnsNotInViewWidth +
            visibleLineInfo.size -
            (visibleLineInfo.clippedSize + visibleLineInfo.clippedCornerExtent);

        final double left =
            dataGridConfiguration.textDirection == TextDirection.ltr
                ? clippedOrigin
                : visibleLineInfo.clippedSize;
        final double right =
            dataGridConfiguration.textDirection == TextDirection.ltr
                ? clippedWidth
                : visibleLineInfo.clippedCornerExtent;

        clipRect = Rect.fromLTWH(left, 0.0, right, cellHeight);
      } else if (visibleLineInfo.isClippedOrigin) {
        final double clippedOriginLTR = columnsNotInViewWidth +
            visibleLineInfo.size -
            visibleLineInfo.clippedSize;
        final double clippedOriginRTL =
            (isLastCellClippedCorner && isLastCellClippedBody)
                ? lastCellClippedSize
                : 0.0;

        final double left =
            dataGridConfiguration.textDirection == TextDirection.ltr
                ? clippedOriginLTR
                : clippedOriginRTL;
        final double right =
            dataGridConfiguration.textDirection == TextDirection.ltr
                ? clippedWidth
                : cellWidth -
                    (columnsNotInViewWidth + visibleLineInfo.scrollOffset);

        clipRect = Rect.fromLTWH(left, 0.0, right, cellHeight);
      } else if (isLastCellClippedCorner && isLastCellClippedBody) {
        final double left =
            dataGridConfiguration.textDirection == TextDirection.ltr
                ? columnsNotInViewWidth
                : dataCell.columnIndex < firstVisibleStackedColumnIndex
                    ? 0.0
                    : cellWidth - clippedWidth;
        final double right =
            dataGridConfiguration.textDirection == TextDirection.ltr
                ? clippedWidth
                : cellWidth;

        clipRect = Rect.fromLTWH(left, 0.0, right, cellHeight);
      } else {
        if (clippedWidth < cellWidth) {
          double left;
          if (dataCell.columnIndex < firstVisibleStackedColumnIndex) {
            left = dataGridConfiguration.textDirection == TextDirection.ltr
                ? cellWidth - clippedWidth
                : 0.0;
          } else {
            left = dataGridConfiguration.textDirection == TextDirection.ltr
                ? 0.0
                : cellWidth - clippedWidth;
          }

          clipRect = Rect.fromLTWH(left, 0.0, clippedWidth, cellHeight);
        } else if (clipRect != null) {
          clipRect = null;
        }
      }
    }
  }
  return clipRect;
}
