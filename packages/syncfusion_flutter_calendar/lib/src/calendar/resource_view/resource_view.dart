part of calendar;

class _ResourceContainer extends CustomPainter {
  _ResourceContainer(
      this.resources,
      this.resourceViewSettings,
      this.resourceItemHeight,
      this.cellBorderColor,
      this.calendarTheme,
      this.notifier,
      this.isRTL,
      this.textScaleFactor,
      this.mouseHoverPosition)
      : super(repaint: notifier);

  final List<CalendarResource> resources;
  final ResourceViewSettings resourceViewSettings;
  final double resourceItemHeight;
  final Color cellBorderColor;
  final SfCalendarThemeData calendarTheme;
  final ValueNotifier<bool> notifier;
  final bool isRTL;
  final double textScaleFactor;
  final Offset mouseHoverPosition;
  Paint _circlePainter;
  TextPainter _namePainter;
  final double _borderThickness = 5;
  bool _isImageLoaded = false;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    /// The circle width.
    final double actualItemWidth = size.width * 0.80;

    /// The circle height.
    final double actualItemHeight = resourceItemHeight * 0.80;
    double yPosition = 0;
    _circlePainter ??= Paint();
    _namePainter ??= TextPainter();
    _circlePainter.isAntiAlias = true;
    final double radius = actualItemHeight < actualItemWidth
        ? actualItemHeight / 2
        : actualItemWidth / 2;
    _circlePainter.color = cellBorderColor ?? calendarTheme.cellBorderColor;
    _circlePainter.strokeWidth = 0.5;
    _circlePainter.style = PaintingStyle.stroke;
    final double lineXPosition = isRTL ? 0.5 : size.width - 0.5;
    canvas.drawLine(Offset(lineXPosition, 0),
        Offset(lineXPosition, size.height), _circlePainter);
    final int count = resources.length;
    if (resourceViewSettings.showAvatar) {
      for (int i = 0; i < count; i++) {
        canvas.save();
        final CalendarResource resource = resources[i];
        _drawResourceBorder(
            resource, canvas, size, actualItemHeight, yPosition, radius);
        _drawDisplayName(
            resource, canvas, size, yPosition, actualItemHeight, radius);
        _circlePainter.style = PaintingStyle.fill;
        _drawInnerCircle(resource, canvas, size, actualItemWidth,
            actualItemHeight, yPosition);
        _circlePainter.color = cellBorderColor ?? calendarTheme.cellBorderColor;
        _circlePainter.strokeWidth = 0.5;
        _circlePainter.style = PaintingStyle.stroke;
        canvas.drawLine(Offset(0, yPosition), Offset(size.width, yPosition),
            _circlePainter);

        if (mouseHoverPosition != null) {
          _addHovering(canvas, size, yPosition);
        }

        yPosition += resourceItemHeight;
        canvas.restore();
      }
    } else {
      for (int i = 0; i < count; i++) {
        final CalendarResource resource = resources[i];
        _drawResourceBackground(canvas, size, resource, yPosition);
        _drawDisplayName(
            resource, canvas, size, yPosition, actualItemHeight, radius);
        if (mouseHoverPosition != null) {
          _addHovering(canvas, size, yPosition);
        }
        yPosition += resourceItemHeight;
      }
    }
  }

  void _addHovering(Canvas canvas, Size size, double yPosition) {
    _circlePainter ??= Paint();
    if (mouseHoverPosition.dy > yPosition &&
        mouseHoverPosition.dy < (yPosition + resourceItemHeight)) {
      _circlePainter.style = PaintingStyle.fill;
      _circlePainter.color = (calendarTheme.brightness != null &&
                  calendarTheme.brightness == Brightness.dark
              ? Colors.white
              : Colors.black87)
          .withOpacity(0.04);
      final double padding = 0.5;
      canvas.drawRect(
          Rect.fromLTWH(0, yPosition, size.width, resourceItemHeight - padding),
          _circlePainter);
    }
  }

  void _drawResourceBackground(
      Canvas canvas, Size size, CalendarResource resource, double yPosition) {
    final double padding = 0.5;
    _circlePainter.color = resource.color;
    _circlePainter.style = PaintingStyle.fill;
    canvas.drawRect(
        Rect.fromLTWH(0, yPosition, size.width, resourceItemHeight - padding),
        _circlePainter);
  }

  /// Updates the text painter with the passed span.
  void _updateNamePainter(TextSpan span) {
    _namePainter.text = span;
    _namePainter.textDirection = TextDirection.rtl;
    _namePainter.maxLines = 1;
    _namePainter.textWidthBasis = TextWidthBasis.longestLine;
    _namePainter.textScaleFactor = textScaleFactor;
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
  void _drawDisplayName(CalendarResource resource, Canvas canvas, Size size,
      double yPosition, double actualItemHeight, double radius) {
    final TextStyle displayNameTextStyle =
        resourceViewSettings.displayNameTextStyle ??
            calendarTheme.displayNameTextStyle;
    final TextSpan span =
        TextSpan(text: resource.displayName, style: displayNameTextStyle);
    _updateNamePainter(span);
    _namePainter.layout(minWidth: 0, maxWidth: size.width);
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
    final DecorationImage decorationImage =
        DecorationImage(image: resource.image);
    final Offset offset = Offset(innerCircleXPosition, innerCircleYPosition);
    final ImageConfiguration configuration =
        ImageConfiguration(size: Size(innerCircleWidth, innerCircleHeight));
    final Rect rect = offset & configuration.size;

    /// To render the image as circle.
    final Path clipPath = Path()..addOval(rect);
    final DecorationImagePainter imagePainter =
        decorationImage.createPainter(() {
      /// To draw an image we must use the onChanged callback, to repaint
      /// the image, when drawing an image the image must be loaded before
      /// the paint starts, if the image doesn't loaded we must repaint the
      /// image, hence to handle this we have used this callback, and
      /// repainted the image if the image doesn't load initially.
      ///
      /// Refer: [BoxPainter.onChanged].
      if (_isImageLoaded) {
        return;
      }

      _isImageLoaded = true;
      notifier.value = !notifier.value;
    });
    imagePainter.paint(canvas, rect, clipPath, configuration);

    /// To ensured that the image is painter or not, if the image painted the
    /// image property of [DecorationImage] must not be null, and since the
    /// property is private, we have handled like this.
    _isImageLoaded = !imagePainter.toString().contains('image: null');
  }

  /// Draws the inner circle for the resource with the short term of the
  /// display name, and fills the resources color in background.
  void _drawInnerCircle(CalendarResource resource, Canvas canvas, Size size,
      double actualItemWidth, double actualItemHeight, double yPosition) {
    final double padding = 0.3;
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
        style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
            fontFamily: 'Roboto'));
    _updateNamePainter(span);
    _namePainter.layout(minWidth: 0, maxWidth: innerCircleWidth);
    startXPosition =
        innerCircleXPosition + ((innerCircleWidth - _namePainter.width) / 2);
    startYPosition =
        innerCircleYPosition + ((innerCircleHeight - _namePainter.height) / 2);
    _namePainter.paint(canvas, Offset(startXPosition, startYPosition));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    final _ResourceContainer oldWidget = oldDelegate;
    return oldWidget.resourceItemHeight != resourceItemHeight ||
        oldWidget.resources != resources ||
        oldWidget.resourceViewSettings != resourceViewSettings ||
        oldWidget._isImageLoaded != _isImageLoaded ||
        oldWidget.mouseHoverPosition != mouseHoverPosition;
  }

  List<CustomPainterSemantics> _getSemanticsBuilder(Size size) {
    final List<CustomPainterSemantics> semanticsBuilder =
        <CustomPainterSemantics>[];
    double top = 0;
    for (int j = 0; j < resources.length; j++) {
      final CalendarResource resource = resources[j];
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

  @override
  bool shouldRebuildSemantics(CustomPainter oldDelegate) {
    final _ResourceContainer oldWidget = oldDelegate;
    return oldWidget.resourceItemHeight != resourceItemHeight ||
        oldWidget.resources != resources ||
        oldWidget.resourceViewSettings != resourceViewSettings ||
        oldWidget._isImageLoaded != _isImageLoaded;
  }
}
