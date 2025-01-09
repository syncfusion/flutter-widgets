import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../../../calendar.dart';
import '../common/calendar_view_helper.dart';

/// Used to hold the resource view on all timeline views.
class ResourceViewWidget extends StatefulWidget {
  /// Constructor to create the resource view widget to holds resource view on
  /// all timeline views.
  const ResourceViewWidget(
      this.resources,
      this.resourceViewSettings,
      this.resourceItemHeight,
      this.cellBorderColor,
      this.calendarTheme,
      this.themeData,
      this.notifier,
      this.isRTL,
      this.textScaleFactor,
      this.mouseHoverPosition,
      this.imagePainterCollection,
      this.width,
      this.panelHeight,
      this.resourceViewHeaderBuilder,
      {super.key});

  /// Holds the resources of the calendar.
  final List<CalendarResource>? resources;

  /// Defines the customization of resource views in calendar widget.
  final ResourceViewSettings resourceViewSettings;

  /// Defines the item height of the resource view.
  final double resourceItemHeight;

  /// Defines the border color of the resource cell.
  final Color? cellBorderColor;

  /// Hols the theme data of the calendar.
  final SfCalendarThemeData calendarTheme;

  /// Holds the framework theme data values.
  final ThemeData themeData;

  /// Used to trigger repaint while resource decoration image loaded.
  final ValueNotifier<bool> notifier;

  /// Defines the direction of the calendar widget is RTL or not.
  final bool isRTL;

  /// Defines the scale factor for the calendar widget.
  final double textScaleFactor;

  /// Collection of images painter to paint the image.
  final Map<Object, DecorationImagePainter> imagePainterCollection;

  /// Holds the mouse hovering position used to paint highlight.
  final Offset? mouseHoverPosition;

  /// Defines the width of the resource view widget.
  final double width;

  /// Defines the height of the resource view widget.
  final double panelHeight;

  /// Used to build the widget that replaces the resource view header.
  final ResourceViewHeaderBuilder? resourceViewHeaderBuilder;

  @override
  // ignore: library_private_types_in_public_api
  _ResourceViewWidgetState createState() => _ResourceViewWidgetState();
}

class _ResourceViewWidgetState extends State<ResourceViewWidget> {
  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];
    if (widget.resourceViewHeaderBuilder != null) {
      double yPosition = 0;
      final int resourceLength = widget.resources!.length;
      for (int i = 0; i < resourceLength; i++) {
        final CalendarResource currentResource = widget.resources![i];
        final Widget child = widget.resourceViewHeaderBuilder!(
            context,
            ResourceViewHeaderDetails(
                currentResource,
                Rect.fromLTWH(
                    0, yPosition, widget.width, widget.resourceItemHeight)));
        children.add(RepaintBoundary(child: child));
        yPosition += widget.resourceItemHeight;
      }
    }

    return _ResourceViewRenderObjectWidget(
      widget.resources,
      widget.resourceViewSettings,
      widget.resourceItemHeight,
      widget.cellBorderColor,
      widget.calendarTheme,
      widget.themeData,
      widget.notifier,
      widget.isRTL,
      widget.textScaleFactor,
      widget.mouseHoverPosition,
      widget.imagePainterCollection,
      widget.width,
      widget.panelHeight,
      children: children,
    );
  }
}

class _ResourceViewRenderObjectWidget extends MultiChildRenderObjectWidget {
  const _ResourceViewRenderObjectWidget(
      this.resources,
      this.resourceViewSettings,
      this.resourceItemHeight,
      this.cellBorderColor,
      this.calendarTheme,
      this.themeData,
      this.notifier,
      this.isRTL,
      this.textScaleFactor,
      this.mouseHoverPosition,
      this.imagePainterCollection,
      this.width,
      this.panelHeight,
      {List<Widget> children = const <Widget>[]})
      : super(children: children);

  final List<CalendarResource>? resources;
  final ResourceViewSettings resourceViewSettings;
  final double resourceItemHeight;
  final Color? cellBorderColor;
  final SfCalendarThemeData calendarTheme;
  final ThemeData themeData;
  final ValueNotifier<bool> notifier;
  final bool isRTL;
  final double textScaleFactor;
  final Offset? mouseHoverPosition;
  final Map<Object, DecorationImagePainter> imagePainterCollection;
  final double width;
  final double panelHeight;

  @override
  _ResourceViewRenderObject createRenderObject(BuildContext context) {
    return _ResourceViewRenderObject(
        resources,
        resourceViewSettings,
        resourceItemHeight,
        cellBorderColor,
        calendarTheme,
        themeData,
        notifier,
        isRTL,
        textScaleFactor,
        mouseHoverPosition,
        imagePainterCollection,
        width,
        panelHeight);
  }

  @override
  void updateRenderObject(
      BuildContext context, _ResourceViewRenderObject renderObject) {
    renderObject
      ..resources = resources
      ..resourceViewSettings = resourceViewSettings
      ..resourceItemHeight = resourceItemHeight
      ..cellBorderColor = cellBorderColor
      ..calendarTheme = calendarTheme
      ..themeData = themeData
      ..notifier = notifier
      ..isRTL = isRTL
      ..textScaleFactor = textScaleFactor
      ..mouseHoverPosition = mouseHoverPosition
      ..imagePainterCollection = imagePainterCollection
      ..width = width
      ..panelHeight = panelHeight;
  }
}

class _ResourceViewRenderObject extends CustomCalendarRenderObject {
  _ResourceViewRenderObject(
      this._resources,
      this._resourceViewSettings,
      this._resourceItemHeight,
      this._cellBorderColor,
      this._calendarTheme,
      this._themeData,
      this._notifier,
      this._isRTL,
      this._textScaleFactor,
      this._mouseHoverPosition,
      this._imagePainterCollection,
      this._width,
      this._panelHeight);

  List<CalendarResource>? _resources;

  List<CalendarResource>? get resources => _resources;

  set resources(List<CalendarResource>? value) {
    if (_resources == value) {
      return;
    }

    _resources = value;
    if (childCount == 0) {
      markNeedsPaint();
    } else {
      markNeedsLayout();
    }
  }

  ResourceViewSettings _resourceViewSettings;

  ResourceViewSettings get resourceViewSettings => _resourceViewSettings;

  set resourceViewSettings(ResourceViewSettings value) {
    if (_resourceViewSettings == value) {
      return;
    }

    _resourceViewSettings = value;
    markNeedsPaint();
  }

  double _resourceItemHeight;

  double get resourceItemHeight => _resourceItemHeight;

  set resourceItemHeight(double value) {
    if (_resourceItemHeight == value) {
      return;
    }

    _resourceItemHeight = value;
    if (childCount == 0) {
      markNeedsPaint();
    } else {
      markNeedsLayout();
    }
  }

  Color? _cellBorderColor;

  Color? get cellBorderColor => _cellBorderColor;

  set cellBorderColor(Color? value) {
    if (_cellBorderColor == value) {
      return;
    }

    _cellBorderColor = value;
    if (childCount != 0) {
      return;
    }

    markNeedsPaint();
  }

  SfCalendarThemeData _calendarTheme;

  SfCalendarThemeData get calendarTheme => _calendarTheme;

  set calendarTheme(SfCalendarThemeData value) {
    if (_calendarTheme == value) {
      return;
    }

    _calendarTheme = value;
    if (childCount != 0) {
      return;
    }

    markNeedsPaint();
  }

  ThemeData _themeData;

  ThemeData get themeData => _themeData;

  set themeData(ThemeData value) {
    if (_themeData == value) {
      return;
    }

    _themeData = value;
  }

  ValueNotifier<bool> _notifier;

  ValueNotifier<bool> get notifier => _notifier;

  set notifier(ValueNotifier<bool> value) {
    if (_notifier == value) {
      return;
    }

    _notifier.removeListener(markNeedsPaint);
    _notifier = value;
    _notifier.addListener(markNeedsPaint);
  }

  bool _isRTL;

  bool get isRTL => _isRTL;

  set isRTL(bool value) {
    if (_isRTL == value) {
      return;
    }

    _isRTL = value;
    if (childCount == 0) {
      markNeedsPaint();
    } else {
      markNeedsLayout();
    }
  }

  double _textScaleFactor;

  double get textScaleFactor => _textScaleFactor;

  set textScaleFactor(double value) {
    if (_textScaleFactor == value) {
      return;
    }

    _textScaleFactor = value;
    if (childCount != 0) {
      return;
    }
    markNeedsPaint();
  }

  Offset? _mouseHoverPosition;

  Offset? get mouseHoverPosition => _mouseHoverPosition;

  set mouseHoverPosition(Offset? value) {
    if (_mouseHoverPosition == value) {
      return;
    }

    _mouseHoverPosition = value;
    if (childCount == 0) {
      markNeedsPaint();
    } else {
      markNeedsLayout();
    }
  }

  Map<Object, DecorationImagePainter> _imagePainterCollection;

  Map<Object, DecorationImagePainter> get imagePainterCollection =>
      _imagePainterCollection;

  set imagePainterCollection(Map<Object, DecorationImagePainter> value) {
    if (_imagePainterCollection == value) {
      return;
    }

    _imagePainterCollection = value;
    if (childCount != 0) {
      return;
    }
    markNeedsPaint();
  }

  double _width;

  double get width => _width;

  set width(double value) {
    if (_width == value) {
      return;
    }

    _width = value;
    if (childCount == 0) {
      markNeedsPaint();
    } else {
      markNeedsLayout();
    }
  }

  double _panelHeight;

  double get panelHeight => _panelHeight;

  set panelHeight(double value) {
    if (_panelHeight == value) {
      return;
    }

    _panelHeight = value;
    markNeedsLayout();
    markNeedsPaint();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _notifier.addListener(markNeedsPaint);
  }

  @override
  void detach() {
    _notifier.removeListener(markNeedsPaint);
    super.detach();
  }

  @override
  void performLayout() {
    final Size widgetSize = constraints.biggest;
    size = Size(widgetSize.width.isInfinite ? width : widgetSize.width,
        widgetSize.height.isInfinite ? panelHeight : widgetSize.height);

    for (dynamic child = firstChild; child != null; child = childAfter(child)) {
      child.layout(constraints.copyWith(
          minWidth: width,
          minHeight: resourceItemHeight,
          maxWidth: width,
          maxHeight: resourceItemHeight));
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final bool isNeedCustomPaint = childCount != 0;

    if (!isNeedCustomPaint) {
      _resourceViewHeader(context.canvas, size);
    } else {
      double yPosition = 0;
      RenderBox? child = firstChild;
      final int resourceLength = resources!.length;
      for (int i = 0; i < resourceLength; i++) {
        context.paintChild(child!, Offset(0, yPosition));
        child = childAfter(child);

        if (mouseHoverPosition != null) {
          final Color resourceHoveringColor =
              (themeData.brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black87)
                  .withValues(alpha: 0.04);
          _addHovering(context.canvas, size, yPosition, resourceHoveringColor);
        }

        yPosition += resourceItemHeight;
      }
    }
  }

  final Paint _circlePainter = Paint();
  final TextPainter _namePainter = TextPainter();
  final double _borderThickness = 5;

  void _resourceViewHeader(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    /// The circle width.
    final double actualItemWidth = size.width * 0.80;

    /// The circle height.
    final double actualItemHeight = resourceItemHeight * 0.80;
    double yPosition = 0;
    _circlePainter.isAntiAlias = true;
    final double radius = actualItemHeight < actualItemWidth
        ? actualItemHeight / 2
        : actualItemWidth / 2;
    final Color resourceCellBorderColor =
        cellBorderColor ?? calendarTheme.cellBorderColor!;
    final Color resourceHoveringColor = (themeData.brightness == Brightness.dark
            ? Colors.white
            : Colors.black87)
        .withValues(alpha: 0.04);
    final TextStyle displayNameTextStyle = calendarTheme.displayNameTextStyle!;
    _circlePainter.color = resourceCellBorderColor;
    _circlePainter.strokeWidth = 0.5;
    _circlePainter.style = PaintingStyle.stroke;
    final double lineXPosition = isRTL ? 0.5 : size.width - 0.5;
    canvas.drawLine(Offset(lineXPosition, 0),
        Offset(lineXPosition, size.height), _circlePainter);
    final int count = resources!.length;
    if (resourceViewSettings.showAvatar) {
      for (int i = 0; i < count; i++) {
        canvas.save();
        final CalendarResource resource = resources![i];
        _drawResourceBorder(
            resource, canvas, size, actualItemHeight, yPosition, radius);
        _drawDisplayName(resource, displayNameTextStyle, canvas, size,
            yPosition, actualItemHeight, radius);
        _circlePainter.style = PaintingStyle.fill;
        _drawInnerCircle(resource, canvas, size, actualItemWidth,
            actualItemHeight, yPosition);
        _circlePainter.color = resourceCellBorderColor;
        _circlePainter.strokeWidth = 0.5;
        _circlePainter.style = PaintingStyle.stroke;
        canvas.drawLine(Offset(0, yPosition), Offset(size.width, yPosition),
            _circlePainter);

        if (mouseHoverPosition != null) {
          _addHovering(canvas, size, yPosition, resourceHoveringColor);
        }

        yPosition += resourceItemHeight;
        canvas.restore();
      }
    } else {
      for (int i = 0; i < count; i++) {
        final CalendarResource resource = resources![i];
        _drawResourceBackground(canvas, size, resource, yPosition);
        _drawDisplayName(resource, displayNameTextStyle, canvas, size,
            yPosition, actualItemHeight, radius);
        _addHovering(canvas, size, yPosition, resourceHoveringColor);
        yPosition += resourceItemHeight;
      }
    }
  }

  void _addHovering(
      Canvas canvas, Size size, double yPosition, Color resourceHoveringColor) {
    if (mouseHoverPosition != null &&
        mouseHoverPosition!.dy > yPosition &&
        mouseHoverPosition!.dy < (yPosition + resourceItemHeight)) {
      _circlePainter.style = PaintingStyle.fill;
      _circlePainter.color = resourceHoveringColor;
      const double padding = 0.5;
      canvas.drawRect(
          Rect.fromLTWH(0, yPosition, size.width, resourceItemHeight - padding),
          _circlePainter);
    }
  }

  void _drawResourceBackground(
      Canvas canvas, Size size, CalendarResource resource, double yPosition) {
    const double padding = 0.5;
    _circlePainter.color = resource.color;
    _circlePainter.style = PaintingStyle.fill;
    canvas.drawRect(
        Rect.fromLTWH(0, yPosition, size.width, resourceItemHeight - padding),
        _circlePainter);
  }

  /// Updates the text painter with the passed span.
  void _updateNamePainter(TextSpan span) {
    _namePainter.text = span;
    _namePainter.textDirection = TextDirection.ltr;
    _namePainter.maxLines = 1;
    _namePainter.textWidthBasis = TextWidthBasis.longestLine;
    _namePainter.textScaler = TextScaler.linear(textScaleFactor);
  }

  /// Draws the outer circle border for the resource view.
  void _drawResourceBorder(CalendarResource resource, Canvas canvas, Size size,
      double actualItemHeight, double yPosition, double radius) {
    /// When the large text size given, the text must be cliped instead of
    /// overflow into next resource view, hence cliped the canvas.
    canvas
        .clipRect(Rect.fromLTWH(0, yPosition, size.width, resourceItemHeight));
    _circlePainter.color = resource.color;
    _circlePainter.strokeWidth = _borderThickness;
    _circlePainter.style = PaintingStyle.stroke;
    final double startXPosition = size.width / 2;
    final double startYPosition =
        (_borderThickness / 2) + yPosition + actualItemHeight / 2;
    canvas.drawCircle(
        Offset(startXPosition, startYPosition), radius, _circlePainter);
  }

  /// Draws the display name of the resource under the circle.
  void _drawDisplayName(
      CalendarResource resource,
      TextStyle displayNameTextStyle,
      Canvas canvas,
      Size size,
      double yPosition,
      double actualItemHeight,
      double radius) {
    final TextSpan span =
        TextSpan(text: resource.displayName, style: displayNameTextStyle);
    _updateNamePainter(span);
    _namePainter.layout(maxWidth: size.width);
    final double startXPosition = (size.width - _namePainter.width) / 2;
    final double startYPosition = resourceViewSettings.showAvatar
        ? (yPosition + (actualItemHeight / 2)) +
            _borderThickness +
            radius +
            (_borderThickness / 2)
        : yPosition + ((resourceItemHeight - _namePainter.height) / 2);
    _namePainter.paint(canvas, Offset(startXPosition, startYPosition));
  }

  /// Draws the image assigned to the resource, in the inside circle.
  void _drawImage(
      Canvas canvas,
      Size size,
      CalendarResource resource,
      double innerCircleYPosition,
      double innerCircleXPosition,
      double innerCircleWidth,
      double innerCircleHeight) {
    final Offset offset = Offset(innerCircleXPosition, innerCircleYPosition);
    final Size size = Size(innerCircleWidth, innerCircleHeight);
    final ImageConfiguration configuration = ImageConfiguration(size: size);
    final Rect rect = offset & size;

    /// To render the image as circle.
    final Rect square =
        Rect.fromCircle(center: rect.center, radius: rect.shortestSide / 2.0);
    final Path clipPath = Path()..addOval(square);
    final DecorationImagePainter? imagePainter = _getImagePainter(resource);
    if (imagePainter == null) {
      return;
    }
    imagePainter.paint(canvas, rect, clipPath, configuration);
    imagePainterCollection[resource.id] = imagePainter;
  }

  DecorationImagePainter? _getImagePainter(CalendarResource resource) {
    if (imagePainterCollection.isEmpty ||
        !imagePainterCollection.containsKey(resource.id)) {
      return DecorationImage(image: resource.image!)
          .createPainter(_onPainterChanged);
    } else if (imagePainterCollection.containsKey(resource.id) &&
        !imagePainterCollection[resource.id]
            .toString()
            .contains(resource.image.toString())) {
      imagePainterCollection[resource.id]!.dispose();
      return DecorationImage(image: resource.image!)
          .createPainter(_onPainterChanged);
    }

    return imagePainterCollection[resource.id];
  }

  /// To draw an image we must use the onChanged callback, to repaint
  /// the image, when drawing an image the image must be loaded before
  /// the paint starts, if the image doesn't loaded we must repaint the
  /// image, hence to handle this we have used this callback, and
  /// repainted the image if the image doesn't load initially.
  ///
  /// Refer: [BoxPainter.onChanged].
  void _onPainterChanged() {
    notifier.value = !notifier.value;
  }

  /// Draws the inner circle for the resource with the short term of the
  /// display name, and fills the resources color in background.
  void _drawInnerCircle(CalendarResource resource, Canvas canvas, Size size,
      double actualItemWidth, double actualItemHeight, double yPosition) {
    const double padding = 0.3;
    final double innerCircleWidth =
        actualItemWidth - (_borderThickness * 2) - (padding * 2);
    final double innerCircleHeight =
        actualItemHeight - (_borderThickness * 2) - (padding * 2);
    final double innerRadius = innerCircleWidth > innerCircleHeight
        ? innerCircleHeight / 2
        : innerCircleWidth / 2;
    final double innerCircleXPosition =
        (size.width - actualItemWidth) / 2 + _borderThickness + padding;
    final double innerCircleYPosition =
        (_borderThickness / 2) + yPosition + _borderThickness + padding;
    if (resource.image != null) {
      _drawImage(canvas, size, resource, innerCircleYPosition,
          innerCircleXPosition, innerCircleWidth, innerCircleHeight);
      return;
    }

    double startXPosition = innerCircleXPosition + (innerCircleWidth / 2);
    double startYPosition = innerCircleYPosition + (innerCircleHeight / 2);
    canvas.drawCircle(
        Offset(startXPosition, startYPosition), innerRadius, _circlePainter);
    final List<String> splitName = resource.displayName.split(' ');
    final String shortName = splitName.length > 1
        ? splitName[0].substring(0, 1) + splitName[1].substring(0, 1)
        : splitName[0].substring(0, 1);
    final TextSpan span = TextSpan(
        text: shortName,
        style: themeData.textTheme.bodyLarge!.copyWith(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500));
    _updateNamePainter(span);
    _namePainter.layout(maxWidth: innerCircleWidth);
    startXPosition =
        innerCircleXPosition + ((innerCircleWidth - _namePainter.width) / 2);
    startYPosition =
        innerCircleYPosition + ((innerCircleHeight - _namePainter.height) / 2);
    _namePainter.paint(canvas, Offset(startXPosition, startYPosition));
  }

  List<CustomPainterSemantics> _getSemanticsBuilder(Size size) {
    final List<CustomPainterSemantics> semanticsBuilder =
        <CustomPainterSemantics>[];
    if (resources == null) {
      return semanticsBuilder;
    }
    double top = 0;
    for (int j = 0; j < resources!.length; j++) {
      final CalendarResource resource = resources![j];
      semanticsBuilder.add(CustomPainterSemantics(
        rect: Rect.fromLTWH(0, top, size.width, resourceItemHeight),
        properties: SemanticsProperties(
          label: resource.displayName + resource.id.toString(),
          textDirection: TextDirection.ltr,
        ),
      ));
      top += resourceItemHeight;
    }

    return semanticsBuilder;
  }

  /// overrides this property to build the semantics information which uses to
  /// return the required information for accessibility, need to return the list
  /// of custom painter semantics which contains the rect area and the semantics
  /// properties for accessibility
  @override
  SemanticsBuilderCallback get semanticsBuilder {
    return (Size size) {
      return _getSemanticsBuilder(size);
    };
  }
}
