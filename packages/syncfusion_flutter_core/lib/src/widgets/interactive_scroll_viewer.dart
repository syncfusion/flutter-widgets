part of interactive_scroll_viewer_internal;

/// Triggers when double tap zoom invoked.
typedef _DoubleTapZoomInvokedCallback = Offset Function(
    Offset value, Offset tapPosition);

/// [InteractiveScrollViewer] enables pan and zoom interactions with its child.
@immutable
class InteractiveScrollViewer extends StatefulWidget {
  /// Constructor for InteractiveScrollable.
  const InteractiveScrollViewer(this.child,
      {Key? key,
      this.clipBehavior = Clip.hardEdge,
      this.onDoubleTapZoomInvoked,
      this.alignPanAxis = false,
      this.boundaryMargin = EdgeInsets.zero,
      // These default scale values were eyeballed as reasonable
      //limits for common use cases.
      this.maxScale = 3,
      this.minScale = 1,
      this.onInteractionStart,
      this.onInteractionUpdate,
      this.onInteractionEnd,
      this.panEnabled = true,
      this.scaleEnabled = true,
      this.constrained = true,
      this.enableDoubleTapZooming = true,
      this.transformationController})
      : super(key: key);

  /// Whether the normal size constraints at this point in the widget tree are
  /// applied to the child.
  ///
  /// If set to false, then the child will be given infinite constraints.
  /// This is often useful,
  /// when a child should be bigger than the InteractiveScrollable.
  final bool constrained;

  /// If set to [Clip.none],the child may extend
  /// beyond the size of the InteractiveScrollable,
  /// but it will not receive gestures in these areas.
  /// Be sure that the InteractiveScrollable is
  /// the desired size when using [Clip.none].
  ///
  /// Defaults to [Clip.hardEdge].
  final Clip clipBehavior;

  /// If true, panning is only allowed in the direction of the horizontal axis
  /// or the vertical axis.
  ///
  /// In other words, when this is true, diagonal panning is not allowed. A
  /// single gesture begun along one axis cannot also cause panning along the
  /// other axis without stopping and beginning a new gesture. This is a common
  /// pattern in tables where data is displayed in columns and rows.
  ///
  /// See also:
  ///  * [constrained], which has an example of creating a table that uses
  ///    alignPanAxis.
  final bool alignPanAxis;

  /// A margin for the visible boundaries of the child.
  ///
  /// Any transformation that results in the viewport being able to view outside
  /// of the boundaries will be stopped at the boundary. The boundaries do not
  /// rotate with the rest of the scene, so they are always aligned with the
  /// viewport.
  ///
  /// To produce no boundaries at all, pass infinite [EdgeInsets], such as
  /// `EdgeInsets.all(double.infinity)`.
  ///
  /// No edge can be NaN.
  ///
  /// Defaults to [EdgeInsets.zero], which results in boundaries that are the
  /// exact same size and position as the [child].
  final EdgeInsets boundaryMargin;

  /// The Widget to perform the transformations on.
  ///
  /// Cannot be null.
  final Widget child;

  /// If false, the user will be prevented from panning.
  ///
  /// Defaults to true.
  ///
  /// See also:
  ///
  ///   * [scaleEnabled], which is similar but for scale.
  final bool panEnabled;

  /// If false, the user will be prevented from scaling.
  ///
  /// Defaults to true.
  ///
  /// See also:
  ///
  ///   * [panEnabled], which is similar but for panning.
  final bool scaleEnabled;

  /// The maximum allowed scale.
  ///
  /// The scale will be clamped between this and [minScale] inclusively.
  ///
  /// Defaults to 3.
  ///
  /// Cannot be null, and must be greater than zero and greater than minScale.
  final double maxScale;

  /// The minimum allowed scale.
  ///
  /// The scale will be clamped between this and [maxScale] inclusively.
  ///
  /// Scale is also affected by [boundaryMargin]. If the scale would result in
  /// viewing beyond the boundary, then it will not be allowed. By default,
  /// boundaryMargin is EdgeInsets.zero, so scaling below 1.0 will not be
  /// allowed in most cases without first increasing the boundaryMargin.
  ///
  /// Defaults to 1.
  ///
  /// Cannot be null, and must be a finite number greater than zero and less
  /// than maxScale.
  final double minScale;

  /// Called when the user begins a pan or scale gesture on the widget.
  final GestureScaleStartCallback? onInteractionStart;

  /// Called when the user updates a pan or scale gesture on the widget.
  final GestureScaleUpdateCallback? onInteractionUpdate;

  /// Called when the user ends a pan or scale gesture on the widget.
  final GestureScaleEndCallback? onInteractionEnd;

  /// A [TransformationController] for the transformation performed on the
  /// child.
  final TransformationController? transformationController;

  /// If true, double tap zooming is enabled.
  final bool enableDoubleTapZooming;

  /// Triggers when double tap
  ///
  /// Default to null
  ///
  // ignore: library_private_types_in_public_api
  final _DoubleTapZoomInvokedCallback? onDoubleTapZoomInvoked;

  @override
  InteractiveScrollViewerState createState() => InteractiveScrollViewerState();
}

/// State for [InteractiveScrollViewer].
class InteractiveScrollViewerState extends State<InteractiveScrollViewer> {
  Offset _tapPosition = Offset.zero;

  /// Scrolls to the specified offset
  /// ``` dart
  ///final GlobalKey<InteractiveScrollViewerState> _interactiveViewerKey =
  ///GlobalKey();
  ///TransformationController transformationController=
  ///TransformationController();
  ///@override
  ///Widget build(BuildContext context) {
  ///  return Scaffold(
  ///      appBar: AppBar(
  ///        title: const Text('InteractiveScrollViewer'),
  ///        actions: <Widget>[
  ///          IconButton(
  ///            icon: const Icon(
  ///              Icons.arrow_circle_down,
  ///              color: Colors.white,
  ///            ),
  ///            onPressed: () {
  ///            _interactiveViewerKey.currentState?.scrollTo(Offset(150,2000));
  ///            },
  ///          ),
  ///        ],
  ///      ),
  ///      body: InteractiveScrollViewer(
  ///        Image.network('https://picsum.photos/250?image=9'),
  ///        key: _interactiveViewerKey,
  ///        transformationController: transformationController,
  ///      ));
  /// }
  /// ```
  void scrollTo(Offset offset) {
    if (widget.transformationController != null) {
      final Offset previousOffset =
          widget.transformationController!.toScene(Offset.zero);
      widget.transformationController?.value =
          widget.transformationController!.value.clone()
            ..translate(
                previousOffset.dx - offset.dx, previousOffset.dy - offset.dy);
    }
  }

  /// Scales the child to the specified scale value
  /// ``` dart
  ///final GlobalKey<InteractiveScrollViewerState> _interactiveViewerKey =
  ///GlobalKey();
  ///TransformationController transformationController=
  ///TransformationController();
  ///@override
  ///Widget build(BuildContext context) {
  ///  return Scaffold(
  ///      appBar: AppBar(
  ///        title: const Text('InteractiveScrollViewer'),
  ///        actions: <Widget>[
  ///          IconButton(
  ///            icon: const Icon(
  ///              Icons.arrow_circle_down,
  ///              color: Colors.white,
  ///            ),
  ///            onPressed: () {
  ///              _interactiveViewerKey.currentState?.scaleTo(2);
  ///            },
  ///          ),
  ///        ],
  ///      ),
  ///      body: InteractiveScrollViewer(
  ///        Image.network('https://picsum.photos/250?image=9'),
  ///        key: _interactiveViewerKey,
  ///        transformationController: transformationController,
  ///      ));
  /// }
  /// ```
  void scaleTo(double scale) {
    if (widget.transformationController != null) {
      scale = scale.clamp(widget.minScale, widget.maxScale);
      final double zoomLevel =
          widget.transformationController!.value.getMaxScaleOnAxis();
      final Offset previousOffset =
          widget.transformationController!.toScene(Offset.zero);
      widget.transformationController?.value =
          widget.transformationController!.value.clone()
            ..scale(scale / zoomLevel, scale / zoomLevel);
      scrollTo(previousOffset);
    }
  }

  /// This method used to get the tap positions
  void _handleDoubleTapDown(TapDownDetails details) {
    _tapPosition = details.localPosition;
  }

  /// Handles the double tap behavior.
  void _handleDoubleTap() {
    if (widget.transformationController != null) {
      const double minimumZoomLevel = 1;
      const double maximumZoomLevel = 2;
      final double zoomLevel =
          widget.transformationController!.value.getMaxScaleOnAxis();
      Offset normalizedOffset;
      Offset offset;
      if (zoomLevel <= minimumZoomLevel) {
        normalizedOffset = (-_tapPosition -
                widget.transformationController!.toScene(Offset.zero) *
                    zoomLevel) /
            zoomLevel;
        scaleTo(maximumZoomLevel);
        offset = (-_tapPosition - normalizedOffset * maximumZoomLevel) /
            maximumZoomLevel;
        // Triggered when double tap
        if (widget.onDoubleTapZoomInvoked != null) {
          offset = widget.onDoubleTapZoomInvoked!(offset, _tapPosition);
        }
        scrollTo(offset);
      } else {
        normalizedOffset = (-_tapPosition -
                widget.transformationController!.toScene(Offset.zero) *
                    zoomLevel) /
            zoomLevel;
        scaleTo(minimumZoomLevel);
        offset = (-_tapPosition - normalizedOffset * minimumZoomLevel) /
            minimumZoomLevel;
        // Triggered when double tap
        if (widget.onDoubleTapZoomInvoked != null) {
          offset = widget.onDoubleTapZoomInvoked!(offset, _tapPosition);
        }
        scrollTo(offset);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTapDown:
          widget.enableDoubleTapZooming ? _handleDoubleTapDown : null,
      onDoubleTap: widget.enableDoubleTapZooming ? _handleDoubleTap : null,
      child: InteractiveViewer(
        minScale: widget.minScale,
        maxScale: widget.maxScale,
        constrained: widget.constrained,
        onInteractionStart: widget.onInteractionStart,
        onInteractionUpdate: widget.onInteractionUpdate,
        onInteractionEnd: widget.onInteractionEnd,
        scaleEnabled: widget.scaleEnabled,
        panEnabled: widget.panEnabled,
        alignPanAxis: widget.alignPanAxis,
        transformationController: widget.transformationController,
        boundaryMargin: widget.boundaryMargin,
        clipBehavior: widget.clipBehavior,
        child: widget.child,
      ),
    );
  }
}
