library signaturepad;

import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/gestures.dart'
    show
        DeviceGestureSettings,
        DragStartBehavior,
        GestureArenaTeam,
        HorizontalDragGestureRecognizer,
        PanGestureRecognizer,
        TapGestureRecognizer,
        VerticalDragGestureRecognizer;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

const double _kMinimumStrokeWidth = 0.8;
const double _kMaximumStrokeWidth = 5.0;
const double _kDefaultHeight = 250.0;
const double _kDefaultWidth = 250.0;

/// Signature used by [SfSignaturePad] for [SfSignaturePad.onDraw] callback.
typedef SignatureDrawCallback = void Function(Offset offset, DateTime time);

/// Signature used by [SfSignaturePad] for [SfSignaturePad.onDrawStart]
/// callback.
typedef SignatureOnDrawStartCallback = bool Function();

/// The Signature Pad widget allows you to capture smooth and more realistic
/// signatures through drawing gestures. The widget allows you to save
/// the signature as an image, which can be further synchronized with your
/// devices and documents that need the signature.
///
/// You can customize the [SfSignaturePad] with below options.
/// * The width of the signature stroke can be customized by setting the
/// [minimumStrokeWidth] and [maximumStrokeWidth] properties.
/// * The [minimumStrokeWidth] defines the minimum thickness of the signature
/// stroke and the [maximumStrokeWidth] defines the maximum thickness of the
/// signature stroke.
/// * The signature stroke width will be calculated based on the speed of the
/// gesture, within the minimum and maximum stroke width ranges. So that the
/// drawn signature will be more realistic.
/// * The stroke color of the [SfSignaturePad] can be customized using the
/// [strokeColor] property.
/// * The background color of the [SfSignaturePad] can be customized using the
/// [backgroundColor] property.
///
/// The [onDrawStart], [onDraw] and [onDrawEnd] allows you to handle the
/// gestures in [SfSignaturePad]
///
/// The [SfSignaturePadState.toImage] allows you to export the signature in
/// [SfSignaturePad] to an image.
/// The [SfSignaturePadState.clear] allows you to clear all the signature
/// strokes in [SfSignaturePad].
/// The [SfSignaturePadState.renderToContext2D] allows you to export the
/// signature in [SfSignaturePad] to a html canvas.
/// [SfSignaturePadState.renderToContext2D] is used to export the signature as
/// an image in web platform.
///
/// Note - Since the [SfSignaturePadState.toImage], [SfSignaturePadState.clear]
/// and [SfSignaturePadState.renderToContext2D] are defined in state object of
/// [SfSignaturePad], you have to use a global key assigned to the
/// [SfSignaturePad] instance to call these methods.
///
/// ## Example
///
/// This snippet shows how to use a [SfSignaturePad].
///
/// * Create a global key for [SfSignaturePadState].
/// ```dart
/// final GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();
/// ```
/// * Create the [SfSignaturePad] and set the properties and global key.
/// ```dart
/// SfSignaturePad(
///   minimumStrokeWidth: 3.0,
///   maximumStrokeWidth: 6.0,
///   backgroundColor: Colors.white,
///   strokeColor: Colors.green,
///   key: _signaturePadKey,
///  );
///  ```
/// * Handle the start, ondraw and completion of signature gestures in
/// [SfSignaturePad] from [onDrawStart], [onDraw] and [onDrawEnd].
/// ```dart
/// SfSignaturePad(
///   onDrawStart: () {
///     return false;
///   },
///   onDraw: (offset, time) {
///     Offset offsetValue = offset;
///     DateTime dateTime = time;
///   },
///   onDrawEnd: () {
///      print("Signature has been completed in Signature Pad");
///   });
/// ```
/// * Call [SfSignaturePadState.clear] using state object to clear all the drawn
/// strokes in the [SfSignaturePad].
/// ```dart
/// _signaturePadKey.currentState!.clear();
/// ```
/// * Call [SfSignaturePadState.toImage] using state object to convert the
/// signature to an image representation.
/// ```dart
/// ui.Image image = await _signaturePadKey.currentState!.toImage();
/// ```
class SfSignaturePad extends StatefulWidget {
  /// Constructor that creates a new instance of [SfSignaturePad].
  ///
  /// The below snippet shows how to use a [SfSignaturePad].
  ///
  /// * Create a global key.
  /// ```dart
  /// final GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();
  ///```
  /// * Create a [SfSignaturePad] and set the properties and global key.
  /// ```dart
  /// SfSignaturePad(
  ///   minimumStrokeWidth: 3.0,
  ///   maximumStrokeWidth: 6.0,
  ///   backgroundColor: Colors.white,
  ///   strokeColor: Colors.green,
  ///   key: _signaturePadKey,
  ///  );
  /// ```
  ///
  /// * Call [SfSignaturePadState.clear] using state object to clear all the
  /// drawn strokes in the [SfSignaturePad].
  /// ```dart
  /// _signaturePadKey.currentState.clear();
  ///```
  ///
  /// * Call [SfSignaturePadState.toImage] using state object to convert the
  /// signature to an image representation.
  /// ```dart
  /// ui.Image image = await _signaturePadKey.currentState.toImage();
  /// ```
  /// * Handle the start of signature gestures in [SfSignaturePad] from
  /// [onDrawStart].
  /// ```dart
  /// SfSignaturePad(
  ///   onDrawStart: () {
  ///     return false;
  ///   });
  /// ```
  /// * Handle the ondraw of signature gestures in [SfSignaturePad] from
  /// [onDraw].
  /// ```dart
  /// SfSignaturePad(
  ///   onDraw: (offset, time) {
  ///     Offset offsetValue = offset;
  ///     DateTime dateTime = time;
  ///   });
  /// ```
  /// * Handle the end of signature gestures in [SfSignaturePad] from
  /// [onDrawEnd].
  /// ```dart
  ///  SfSignaturePad(
  ///    onDrawEnd: ()=> {
  ///      print("Signature has been completed in Signature Pad");
  ///    });
  /// ```
  const SfSignaturePad(
      {Key? key,
      this.minimumStrokeWidth = _kMinimumStrokeWidth,
      this.maximumStrokeWidth = _kMaximumStrokeWidth,
      this.backgroundColor,
      this.strokeColor,
      this.onDrawStart,
      this.onDraw,
      this.onDrawEnd})
      : super(key: key);

  /// The minimum width of the signature stroke.
  ///
  /// Default value is 0.8.
  ///
  /// The width of the signature stroke can be customized by setting the
  /// [minimumStrokeWidth] and [maximumStrokeWidth] properties.
  ///
  /// The [minimumStrokeWidth] defines the minimum thickness of
  /// the stroke and the [maximumStrokeWidth] defines the maximum thickness of
  /// the signature stroke.
  ///
  /// The stroke will be drawn in [SfSignaturePad] based on the speed of the
  /// stroke gesture within its minimum and maximum stroke width ranges.
  /// So that the signature will be more realistic.
  ///
  /// This snippet shows how to set stroke width in [SfSignaturePad].
  ///
  /// ```dart
  /// SfSignaturePad(
  ///   minimumStrokeWidth: 3.0,
  ///   maximumStrokeWidth: 6.0,
  ///  );
  ///  ```
  ///
  final double minimumStrokeWidth;

  /// The maximum width of the signature stroke.
  ///
  /// Default value is 5.0.
  ///
  /// The width of the signature stroke can be customized by setting the
  /// [minimumStrokeWidth] and [maximumStrokeWidth] properties.
  ///
  /// The [minimumStrokeWidth] defines the minimum thickness of
  /// the stroke and the [maximumStrokeWidth] defines the maximum thickness of
  /// the signature stroke.
  ///
  /// The stroke will be drawn in [SfSignaturePad] based on the speed of the
  /// stroke gesture within its minimum and maximum stroke width ranges.
  /// So that the signature will be more realistic.
  ///
  /// This snippet shows how to set the stroke width in [SfSignaturePad].
  ///
  /// ```dart
  /// SfSignaturePad(
  ///   minimumStrokeWidth: 3.0,
  ///   maximumStrokeWidth: 6.0,
  ///  );
  /// ```
  final double maximumStrokeWidth;

  /// Color applied to the background of [SfSignaturePad].
  ///
  /// The default [backgroundColor] is `Colors.transparent`.
  ///
  /// This snippet shows how to set a background color for [SfSignaturePad].
  ///
  /// ```dart
  /// SfSignaturePad(
  ///   backgroundColor: Colors.white,
  ///  );
  ///  ```
  ///
  final Color? backgroundColor;

  /// Color applied to the signature stroke.
  ///
  /// Default [strokeColor] will change based on the theme.
  ///
  /// The default stroke color for the dark theme is `Colors.white` and the
  /// default color for the light theme is `Colors.black`.
  ///
  /// This snippet shows how to set the stroke color for [SfSignaturePad].
  ///
  /// ```dart
  ///
  /// SfSignaturePad(
  ///   strokeColor: Colors.green,
  ///  );
  /// ```
  ///
  final Color? strokeColor;

  /// Called when the user starts signing on [SfSignaturePad].
  ///
  /// This snippet shows how to set [onDrawStart] callback in [SfSignaturePad].
  ///
  /// ```dart
  /// SfSignaturePad(
  ///   onDrawStart: () {
  ///     return false;
  ///   },
  ///  );
  ///  ```
  final SignatureOnDrawStartCallback? onDrawStart;

  /// Called when a stroke is updated on the [SfSignaturePad].
  ///
  /// This snippet shows how to set [onDraw] callback in [SfSignaturePad].
  ///
  /// ```dart
  /// SfSignaturePad(
  ///   onDraw: (offset, time) {
  ///     Offset offsetValue = offset;
  ///     DateTime dateTime = time;
  ///   },
  ///  );
  ///  ```
  final SignatureDrawCallback? onDraw;

  /// Called when the user completes signing on [SfSignaturePad].
  ///
  /// This snippet shows how to set [onDrawEnd] callback in [SfSignaturePad].
  ///
  /// ```dart
  ///
  /// SfSignaturePad(
  ///   onDrawEnd: ()=> {
  ///     print("Signature has been completed in Signature Pad");
  ///   },
  ///  );
  /// ```
  final VoidCallback? onDrawEnd;

  @override
  SfSignaturePadState createState() => SfSignaturePadState();
}

/// This class maintains the state of the [SfSignaturePad] widget.
class SfSignaturePadState extends State<SfSignaturePad> {
  /// Creates an unmodifiable ui.Path collection which represents the strokes in
  /// the [SfSignaturePad].
  ///
  /// Since this method is defined in the state object of [SfSignaturePad],
  /// you have to use a global key assigned to the [SfSignaturePad] to call this
  /// method.
  /// This snippet shows how to use [toPathList] in [SfSignaturePadState].
  ///
  ///
  /// * Create a global key.
  /// ```dart
  /// final GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();
  ///```
  /// * Create a [SfSignaturePad] instance and assign the global key to it.
  /// ```dart
  /// SfSignaturePad(
  ///   key: _signaturePadKey,
  ///  );
  ///```
  /// * Call [toPathList] using the state object to expose the path collection.
  /// ```dart
  /// List<Path> paths = signatureGlobalKey.currentState!.toPathList();
  ///  ```
  List<Path> toPathList() {
    final RenderObject? signatureRenderBox = context.findRenderObject();
    List<Path> paths = <Path>[];

    if (signatureRenderBox is RenderSignaturePad) {
      paths = List<Path>.unmodifiable(signatureRenderBox._pathCollection);
    }

    return paths;
  }

  /// Saves the signature as an image.
  /// Returns the [ui.Image].
  ///
  /// Since this method is defined in the state object of [SfSignaturePad],
  /// you have to use a global key assigned to the [SfSignaturePad] instance
  /// to call this method.
  ///
  /// This snippet shows how to use [toImage] in [SfSignaturePadState].
  ///
  ///
  /// * Create a global key.
  /// ```dart
  /// final GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();
  ///```
  /// * Create a [SfSignaturePad] and assign the global key to it.
  /// ```dart
  /// SfSignaturePad(
  ///   key: _signaturePadKey,
  ///  );
  ///```
  ///
  /// * Call [toImage] using state object to convert the signature to an image.
  /// representation.
  /// ```dart
  ///  ui.Image image = await _signaturePadKey.currentState!.toImage();
  ///  ```
  ///See also:
  ///
  /// * [renderToContext2D], renders the signature to a HTML canvas.
  Future<ui.Image> toImage({double pixelRatio = 1.0}) {
    final RenderObject? signatureRenderBox = context.findRenderObject();
    // ignore: avoid_as
    return (signatureRenderBox! as RenderSignaturePad)
        .toImage(pixelRatio: pixelRatio);
  }

  /// Clears all the signature strokes in the [SfSignaturePad].
  ///
  /// Since this method is defined in the state object of [SfSignaturePad],
  /// you have to use a global key assigned to the [SfSignaturePad] to call this
  /// method.
  /// This snippet shows how to use [clear] in [SfSignaturePadState].
  ///
  ///
  /// * Create a global key.
  /// ```dart
  /// final GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();
  ///```
  /// * Create a [SfSignaturePad] instance and assign the global key to it.
  /// ```dart
  /// SfSignaturePad(
  ///   key: _signaturePadKey,
  ///  );
  ///```
  /// * Call [clear] using the state object to clear the all signature strokes.
  /// ```dart
  /// _signaturePadKey.currentState!.clear();
  ///  ```
  void clear() {
    final RenderObject? signatureRenderBox = context.findRenderObject();

    if (signatureRenderBox is RenderSignaturePad) {
      signatureRenderBox.clear();
    }
  }

  /// Renders the signature to a HTML canvas.
  ///
  /// Since this method is defined in the state object  of [SfSignaturePad],
  /// you have to use a global key assigned to the [SfSignaturePad] instance
  /// to call this method.
  /// This snippet shows how to use [renderToContext2D] in
  /// [SfSignaturePadState].
  ///
  /// Note: It requires `dart:html` import.
  ///
  ///
  /// * Create a global key.
  /// ```dart
  /// final GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();
  ///```
  /// * Create a [SfSignaturePad] and assign the global key to it.
  /// ```dart
  /// SfSignaturePad(
  ///   key: _signaturePadKey,
  ///  );
  ///```
  /// * Call the [renderToContext2D] using the state object to export the
  /// signature into
  /// html canvas in web platform.
  /// ```dart
  /// final canvas = html.CanvasElement(
  ///        width: 500,
  ///        height: 500);
  /// final context = canvas.context2D;
  /// _signaturePadKey.currentState!.renderToContext2D(context);
  /// final blob = await canvas.toBlob('image/jpeg', 1.0);
  /// final completer = Completer<Uint8List>();
  /// final reader = html.FileReader();
  /// reader.readAsArrayBuffer(blob);
  /// reader.onLoad.listen((_) => completer.complete(reader.result));
  /// Uint8List imageData = await completer.future;
  ///  ```
  void renderToContext2D(dynamic context2D) {
    final RenderObject? signatureRenderBox = context.findRenderObject();

    if (signatureRenderBox is RenderSignaturePad) {
      signatureRenderBox.renderToContext2D(context2D);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDarkTheme = theme.brightness == Brightness.dark;
    final Color backgroundColor = widget.backgroundColor ?? Colors.transparent;
    final Color strokeColor =
        widget.strokeColor ?? (isDarkTheme ? Colors.white : Colors.black);

    return _SfSignaturePadRenderObjectWidget(
        minimumStrokeWidth: widget.minimumStrokeWidth,
        maximumStrokeWidth: widget.maximumStrokeWidth,
        backgroundColor: backgroundColor,
        strokeColor: strokeColor,
        onDrawStart: widget.onDrawStart,
        onDraw: widget.onDraw,
        onDrawEnd: widget.onDrawEnd);
  }
}

/// A super class to create or update the RenderSignaturePad class.
class _SfSignaturePadRenderObjectWidget extends LeafRenderObjectWidget {
  const _SfSignaturePadRenderObjectWidget({
    required this.minimumStrokeWidth,
    required this.maximumStrokeWidth,
    required this.backgroundColor,
    required this.strokeColor,
    this.onDrawStart,
    this.onDraw,
    this.onDrawEnd,
  });

  final double minimumStrokeWidth;
  final double maximumStrokeWidth;
  final Color backgroundColor;
  final Color strokeColor;
  final SignatureOnDrawStartCallback? onDrawStart;
  final SignatureDrawCallback? onDraw;
  final VoidCallback? onDrawEnd;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderSignaturePad(
        minimumStrokeWidth: minimumStrokeWidth,
        maximumStrokeWidth: maximumStrokeWidth,
        backgroundColor: backgroundColor,
        strokeColor: strokeColor,
        onDrawEnd: onDrawEnd,
        onDraw: onDraw,
        onDrawStart: onDrawStart,
        gestureSettings: MediaQuery.of(context).gestureSettings);
  }

  @override
  void updateRenderObject(
      BuildContext context, RenderSignaturePad renderObject) {
    renderObject
      ..minimumStrokeWidth = minimumStrokeWidth
      ..maximumStrokeWidth = maximumStrokeWidth
      ..backgroundColor = backgroundColor
      ..strokeColor = strokeColor
      ..onDrawEnd = onDrawEnd
      ..onDraw = onDraw
      ..onDrawStart = onDrawStart;
  }
}

/// A render object for [SfSignaturePad] widget.
class RenderSignaturePad extends RenderBox {
  /// Creates a new instance of [RenderSignaturePad].
  RenderSignaturePad(
      {required double minimumStrokeWidth,
      required double maximumStrokeWidth,
      required Color backgroundColor,
      required Color strokeColor,
      required DeviceGestureSettings gestureSettings,
      SignatureOnDrawStartCallback? onDrawStart,
      SignatureDrawCallback? onDraw,
      VoidCallback? onDrawEnd})
      : _minimumStrokeWidth = minimumStrokeWidth,
        _maximumStrokeWidth = maximumStrokeWidth,
        _backgroundColor = backgroundColor,
        _strokeColor = strokeColor,
        _onDrawStart = onDrawStart,
        _onDraw = onDraw,
        _gestureArenaTeam = GestureArenaTeam(),
        _onDrawEnd = onDrawEnd {
    _panGestureRecognizer = PanGestureRecognizer()
      ..team = _gestureArenaTeam
      ..onStart = _handleDragStart
      ..onUpdate = _handleDragUpdate
      ..onEnd = _handleDragEnd
      ..gestureSettings = gestureSettings
      ..dragStartBehavior = DragStartBehavior.down;

    _verticalDragGestureRecognizer = VerticalDragGestureRecognizer()
      ..team = _gestureArenaTeam
      ..gestureSettings = gestureSettings
      ..onStart = _dragStart;

    _horizontalDragGestureRecognizer = HorizontalDragGestureRecognizer()
      ..team = _gestureArenaTeam
      ..gestureSettings = gestureSettings
      ..onStart = _dragStart;

    _tapGestureRecognizer = TapGestureRecognizer()..onTapUp = _handleTapUp;

    _gestureArenaTeam.captain = _panGestureRecognizer;

    _paintStrokeStyle = Paint()
      ..color = _strokeColor
      ..strokeWidth = _kMaximumStrokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    _paintBackgroundStyle = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    _restrictBezierPathCalculation = _minimumStrokeWidth == _maximumStrokeWidth;
    _data = <List<_TouchPoint>>[];
    _bezierPoints = <_CachePoint>[];
    _lastPoints = <_TouchPoint>[];
    _dotPoints = <Offset>[];
    _pathCollection = <Path>[];
    _currentPath = Path();
    _reset();
  }

  final GestureArenaTeam _gestureArenaTeam;

  int _touchGestureFinder = 0;
  bool _restrictBezierPathCalculation = false;
  final double _velocityFilterWeight = 0.2;

  late TapGestureRecognizer _tapGestureRecognizer;
  late VerticalDragGestureRecognizer _verticalDragGestureRecognizer;
  late HorizontalDragGestureRecognizer _horizontalDragGestureRecognizer;
  late PanGestureRecognizer _panGestureRecognizer;

  late Paint _paintStrokeStyle;
  late Paint _paintBackgroundStyle;

  late List<_TouchPoint> _lastPoints;
  late List<List<_TouchPoint>> _data;
  late List<Offset> _dotPoints;
  late List<_CachePoint> _bezierPoints;
  late List<Path> _pathCollection;

  late double _lastVelocity;
  late double _lastWidth;

  late Path _currentPath;

  double _minimumStrokeWidth;

  /// Gets the minimum signature stroke width assigned to [RenderSignaturePad].
  ///
  /// Default value is 0.8.
  ///
  double get minimumStrokeWidth => _minimumStrokeWidth;

  /// Sets the minimum signature stroke width for [RenderSignaturePad].
  ///
  /// Default value is 0.8
  ///
  /// The width of the signature stroke can be customized by setting the
  /// [minimumStrokeWidth] and [maximumStrokeWidth] properties.
  ///
  /// The [minimumStrokeWidth] defines the minimum thickness of
  /// the stroke and the [maximumStrokeWidth] defines the maximum thickness of
  /// the signature stroke.
  ///
  /// The stroke will be drawn in [RenderSignaturePad] based on the speed of the
  /// stroke gesture within its minimum and maximum stroke width ranges.
  /// So that the signature will be more realistic.
  ///
  set minimumStrokeWidth(double value) {
    if (_minimumStrokeWidth == value) {
      return;
    }
    _minimumStrokeWidth = value;
    _strokeWidthChanged();
    markNeedsPaint();
  }

  double _maximumStrokeWidth;

  /// Gets the maximum stroke width assigned to [RenderSignaturePad].
  ///
  /// Default value is 5.0.
  ///
  double get maximumStrokeWidth => _maximumStrokeWidth;

  /// Sets the maximum stroke width for [RenderSignaturePad].
  ///
  /// Default value is 5.0.
  /// The width of the signature stroke can be customized by setting the
  /// [minimumStrokeWidth] and [maximumStrokeWidth] properties.
  ///
  /// The [minimumStrokeWidth] defines the minimum thickness of
  /// the stroke and the [maximumStrokeWidth] defines the maximum thickness of
  /// the signature stroke.
  ///
  /// The stroke will be drawn in [RenderSignaturePad] based on the speed of the
  /// stroke gesture within its minimum and maximum stroke width ranges.
  /// So that the signature will be more realistic.
  ///
  set maximumStrokeWidth(double value) {
    if (_maximumStrokeWidth == value) {
      return;
    }
    _maximumStrokeWidth = value;
    _strokeWidthChanged();
    markNeedsPaint();
  }

  Color _strokeColor;

  /// Gets the applied stroke color of [RenderSignaturePad].
  ///
  /// Default [strokeColor] will change based on the theme.
  ///
  /// The default stroke color for the dark theme is `Colors.white` and the
  /// default color for the light theme is `Colors.black`.
  ///
  Color get strokeColor => _strokeColor;

  /// Sets the stroke color for [RenderSignaturePad].
  ///
  /// Default [strokeColor] will change based on the theme.
  ///
  /// The default stroke color for the dark theme is `Colors.white` and the
  /// default color for the light theme is `Colors.black`.
  ///
  set strokeColor(Color value) {
    if (_strokeColor == value) {
      return;
    }
    _strokeColor = value;
    _paintStrokeStyle.color = value;
    markNeedsPaint();
  }

  Color _backgroundColor;

  /// Gets the color applied to the background of [RenderSignaturePad].
  ///
  /// The default [backgroundColor] is `Colors.transparent`.
  ///
  Color get backgroundColor => _backgroundColor;

  /// Sets the background color for [RenderSignaturePad].
  ///
  /// The default [backgroundColor] is `Colors.transparent`.
  ///
  set backgroundColor(Color value) {
    if (_backgroundColor == value) {
      return;
    }
    _backgroundColor = value;
    _paintBackgroundStyle.color = value;
    markNeedsPaint();
  }

  VoidCallback? _onDrawEnd;

  /// Gets the [onDrawEnd] callback.
  ///
  /// Called when the user completes the signature in [RenderSignaturePad].
  VoidCallback? get onDrawEnd => _onDrawEnd;

  /// Sets the [onDrawEnd] callback.
  ///
  /// Called when the user completes the signature in [RenderSignaturePad].
  set onDrawEnd(VoidCallback? value) {
    if (_onDrawEnd == value) {
      return;
    }
    _onDrawEnd = value;
  }

  SignatureDrawCallback? _onDraw;

  /// Gets the [onDraw] callback.
  ///
  /// Called when the user signing on the [RenderSignaturePad].
  SignatureDrawCallback? get onDraw => _onDraw;

  /// Sets the [onDraw] callback.
  ///
  /// Called when the user signing on the [RenderSignaturePad].
  set onDraw(SignatureDrawCallback? value) {
    if (_onDraw == value) {
      return;
    }
    _onDraw = value;
  }

  SignatureOnDrawStartCallback? _onDrawStart;

  ///Gets the [onDrawStart] callback.
  ///
  ///Called when the user starts signing on the [RenderSignaturePad].
  SignatureOnDrawStartCallback? get onDrawStart => _onDrawStart;

  /// Sets the [onDrawStart] callback.
  ///
  /// Called when the user starts signing on the [RenderSignaturePad].
  set onDrawStart(SignatureOnDrawStartCallback? value) {
    if (_onDrawStart == value) {
      return;
    }
    _onDrawStart = value;
  }

  @override
  bool get isRepaintBoundary => true;

  @override
  void performLayout() {
    double width =
        constraints.hasBoundedWidth ? constraints.maxWidth : _kDefaultWidth;

    if (constraints.minWidth > _kDefaultWidth) {
      width = constraints.minWidth;
    }

    double height =
        constraints.hasBoundedHeight ? constraints.maxHeight : _kDefaultHeight;

    if (constraints.minHeight > _kDefaultHeight) {
      height = constraints.minHeight;
    }

    size = Size(width, height);
  }

  void _handleDragStart(DragStartDetails details) {
    _begin(details.localPosition);
  }

  ///Added this method to enable draw support in draggable containers like
  ///TabView.
  void _dragStart(DragStartDetails details) {}

  void _handleDragUpdate(DragUpdateDetails details) {
    if (onDrawStart != null && onDrawStart!()) {
      return;
    }

    _update(details.localPosition);
  }

  void _handleDragEnd(DragEndDetails details) {
    if (onDrawEnd != null) {
      onDrawEnd!();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    final _TouchPoint touchPoint =
        _TouchPoint(x: details.localPosition.dx, y: details.localPosition.dy);
    final List<_TouchPoint> newPointGroup = <_TouchPoint>[touchPoint];
    if (onDrawStart != null && onDrawStart!()) {
      return;
    }

    _data.add(newPointGroup);
    _drawTappedPoint(touchPoint);
    if (onDrawEnd != null) {
      onDrawEnd!();
    }
  }

  @override
  bool hitTestSelf(Offset position) {
    return true;
  }

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    assert(debugHandleEvent(event, entry));
    if (event is PointerDownEvent && _touchGestureFinder == 0) {
      _touchGestureFinder = event.pointer;
      _panGestureRecognizer.addPointer(event);
      _verticalDragGestureRecognizer.addPointer(event);
      _horizontalDragGestureRecognizer.addPointer(event);
      _tapGestureRecognizer.addPointer(event);
    } else if (event is PointerUpEvent &&
        _touchGestureFinder == event.pointer) {
      _touchGestureFinder = 0;
    } else if (event is PointerCancelEvent) {
      _touchGestureFinder = 0;
    }
  }

  void _begin(Offset touchOffset) {
    final List<_TouchPoint> newPointGroup = <_TouchPoint>[];
    if (onDrawStart != null && onDrawStart!()) {
      return;
    }

    _data.add(newPointGroup);
    _currentPath = Path();
    _pathCollection.add(_currentPath);
    _reset();
    _update(touchOffset);
  }

  void _update(Offset touchOffset) {
    if (_data.isEmpty) {
      _begin(touchOffset);
      return;
    }

    if (onDraw != null) {
      onDraw!(touchOffset, DateTime.now());
    }

    final double x = touchOffset.dx;
    final double y = touchOffset.dy;
    final _TouchPoint point =
        _TouchPoint(x: x, y: y, time: DateTime.now().millisecondsSinceEpoch);
    final List<_TouchPoint> lastPoints = _data[_data.length - 1];
    final double distance = lastPoints.isNotEmpty
        ? _distance(lastPoints[lastPoints.length - 1], point)
        : 1;
    if (distance > 0) {
      if (!_restrictBezierPathCalculation) {
        final _Bezier? curve = _calculateBezierPath(point);
        if (curve != null) {
          _drawSignatureCurve(curve);
        }
      }

      lastPoints.add(point);
      markNeedsPaint();
    }
  }

  void _drawTappedPoint(_TouchPoint touchPoint) {
    _reset();
    _dotPoints.add(Offset(touchPoint.x, touchPoint.y));
    markNeedsPaint();
  }

  _Bezier? _calculateBezierPath(_TouchPoint point) {
    _lastPoints.add(point);

    if (_lastPoints.length > 2) {
      if (_lastPoints.length == 3) {
        _lastPoints.insert(0, _lastPoints[0]);
      }

      final _TouchPoint startPoint = _lastPoints[1];
      final _TouchPoint endPoint = _lastPoints[2];
      final double velocity =
          _velocityFilterWeight * _velocity(startPoint, endPoint) +
              (1 - _velocityFilterWeight) * _lastVelocity;
      final double newWidth =
          max(_maximumStrokeWidth / (velocity + 1), _minimumStrokeWidth);

      final _Bezier curve = _Bezier.fromPoints(
          points: _lastPoints, start: _lastWidth, end: newWidth);
      _lastPoints.removeAt(0);
      _lastVelocity = velocity;
      _lastWidth = newWidth;
      return curve;
    }

    return null;
  }

  void _drawSignatureCurve(_Bezier curve) {
    final double widthDelta = curve.endWidth - curve.startWidth;
    int drawSteps = curve.length().floor() * 2;
    drawSteps = (drawSteps == 0) ? 1 : drawSteps;
    for (int i = 0; i < drawSteps; i++) {
      final double t = i / drawSteps;
      final double tt = t * t;
      final double ttt = tt * t;
      final double u = 1 - t;
      final double uu = u * u;
      final double uuu = uu * u;
      double x = uuu * curve.startPoint.x;
      x += 3 * uu * t * curve.control1.x;
      x += 3 * u * tt * curve.control2.x;
      x += ttt * curve.endPoint.x;

      double y = uuu * curve.startPoint.y;
      y += 3 * uu * t * curve.control1.y;
      y += 3 * u * tt * curve.control2.y;
      y += ttt * curve.endPoint.y;

      final double width =
          min(curve.startWidth + ttt * widthDelta, _maximumStrokeWidth);

      _bezierPoints.add(_CachePoint(x: x, y: y, width: width));
      _currentPath.addArc(Rect.fromLTWH(x, y, width, width), 0, 180);
    }
  }

  double _distance(_TouchPoint start, _TouchPoint end) {
    return sqrt(pow(end.x - start.x, 2) + pow(end.y - start.y, 2));
  }

  double _velocity(_TouchPoint start, _TouchPoint end) {
    double velocity = _distance(start, end) / (end.time! - start.time!);
    velocity = end.time == start.time ? 0 : velocity;
    return velocity;
  }

  /// Converts the signature to image format.
  /// Returns the [Future<ui.Image>].
  /// Optionally you can set the pixel ratio of the image as a
  /// parameter. The higher the high quality image.
  /// See also:
  ///
  ///  * [renderToContext2D], renders the signature to a HTML canvas.
  Future<ui.Image> toImage({double pixelRatio = 1.0}) async {
    // ignore: avoid_as
    return (layer! as OffsetLayer)
        .toImage(Offset.zero & size, pixelRatio: pixelRatio);
  }

  /// Clears the signature strokes in [RenderSignaturePad].
  void clear() {
    _data.clear();
    _dotPoints.clear();
    _bezierPoints.clear();
    _pathCollection.clear();
    _reset();
    _currentPath = Path();
    markNeedsPaint();
  }

  void _strokeWidthChanged() {
    _restrictBezierPathCalculation = _maximumStrokeWidth == _minimumStrokeWidth;
    _dotPoints.clear();
    _bezierPoints.clear();
    _pathCollection.clear();
    _currentPath = Path();
    _recalculateBezierPoints();
    markNeedsPaint();
  }

  void _recalculateBezierPoints() {
    for (final List<_TouchPoint> points in _data) {
      if (points.length > 1) {
        for (int i = 0; i < points.length; i++) {
          final _TouchPoint basicPoint = points[i];
          final _TouchPoint point = _TouchPoint(
              x: basicPoint.x, y: basicPoint.y, time: basicPoint.time);
          if (i == 0) {
            _reset();
            _currentPath = Path();
            _pathCollection.add(_currentPath);
          }

          final _Bezier? curve = _calculateBezierPath(point);
          if (curve != null) {
            _drawSignatureCurve(curve);
          }
        }
      } else {
        _drawTappedPoint(points[0]);
      }
    }
  }

  void _reset() {
    _lastPoints.clear();
    _lastWidth = (_minimumStrokeWidth + _maximumStrokeWidth) / 2;
    _lastVelocity = 0;
  }

  /// Exports the signature to html canvas.
  void renderToContext2D(dynamic context2D) {
    final String strokePenColor =
        '${strokeColor.red},${strokeColor.green},${strokeColor.blue},${strokeColor.opacity.toStringAsFixed(2)}';

    final String backgroundFillColor =
        '${backgroundColor.red},${backgroundColor.green},${backgroundColor.blue},${backgroundColor.opacity.toStringAsFixed(2)}';

    //Drawing the background of the SignaturePad
    context2D.fillStyle = 'rgba($backgroundFillColor)';
    context2D.fillRect(0, 0, size.width, size.height);
    context2D.fill();

    context2D.beginPath();

    if (!_restrictBezierPathCalculation) {
      for (int i = 0; i < _dotPoints.length; i++) {
        final Offset point = _dotPoints[i];
        context2D.moveTo(point.dx, point.dy);
        context2D.arc(point.dx, point.dy,
            (_minimumStrokeWidth + _maximumStrokeWidth) / 2, 0, pi * 2, true);
      }

      for (int i = 0; i < _bezierPoints.length; i++) {
        context2D.moveTo(_bezierPoints[i].x, _bezierPoints[i].y);
        context2D.arc(_bezierPoints[i].x, _bezierPoints[i].y,
            _bezierPoints[i].width / 2, 0, 2 * pi, false);
      }

      context2D.fillStyle = 'rgba($strokePenColor)';
      context2D.fill();
    } else {
      for (int i = 0; i < _data.length; i++) {
        if (_data[i].length == 1) {
          final _TouchPoint point = _data[i][0];
          context2D.moveTo(point.x, point.y);
          context2D.arc(point.x, point.y,
              (_minimumStrokeWidth + _maximumStrokeWidth) / 2, 0, pi * 2, true);
          context2D.fillStyle = 'rgba($strokePenColor)';
          context2D.fill();
        } else {
          final List<_TouchPoint> drawPath = _data[i];
          for (int i = 0; i < drawPath.length; i++) {
            if (i < drawPath.length - 1) {
              context2D.moveTo(drawPath[i].x, drawPath[i].y);
              context2D.lineTo(drawPath[i + 1].x, drawPath[i + 1].y);
            }
          }

          context2D.lineWidth = _maximumStrokeWidth;
          context2D.strokeStyle = 'rgba($strokePenColor)';
          context2D.lineCap = 'round';
          context2D.stroke();
        }
      }
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    context.pushClipRect(
        needsCompositing, offset, Rect.fromLTWH(0, 0, size.width, size.height),
        (PaintingContext context, Offset offset) {
      final Canvas canvas = context.canvas;

      //Drawing the background of the SignaturePad
      canvas.drawRect(
          Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height),
          _paintBackgroundStyle);

      if (_restrictBezierPathCalculation) {
        _paintStrokeStyle.strokeWidth = _minimumStrokeWidth;
        for (int i = 0; i < _data.length; i++) {
          if (_data[i].length == 1) {
            final _TouchPoint point = _data[i][0];
            canvas.drawCircle(
                Offset(point.x, point.y),
                (_minimumStrokeWidth + _maximumStrokeWidth) / 2,
                _paintStrokeStyle);
          } else {
            final List<_TouchPoint> path = _data[i];
            for (int i = 0; i < path.length; i++) {
              if (i < path.length - 1) {
                canvas.drawLine(
                  Offset(path[i].x, path[i].y),
                  Offset(path[i + 1].x, path[i + 1].y),
                  _paintStrokeStyle,
                );
              }
            }
          }
        }
      } else {
        if (_dotPoints.isNotEmpty) {
          _paintStrokeStyle.strokeWidth =
              (_minimumStrokeWidth + _maximumStrokeWidth) / 2;
          canvas.drawPoints(ui.PointMode.points, _dotPoints, _paintStrokeStyle);
        }

        if (_pathCollection.isNotEmpty) {
          _paintStrokeStyle.strokeWidth = _maximumStrokeWidth;
          for (int i = 0; i < _pathCollection.length; i++) {
            canvas.drawPath(_pathCollection[i], _paintStrokeStyle);
          }
        }
      }
    });
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);
    config.isFocusable = true;
  }
}

class _Bezier {
  _Bezier(this.startPoint, this.control2, this.control1, this.endPoint,
      this.startWidth, this.endWidth);

  final _TouchPoint startPoint;
  final _TouchPoint control2;
  final _TouchPoint control1;
  final _TouchPoint endPoint;
  final double startWidth;
  final double endWidth;

  static _Bezier fromPoints(
      {required List<_TouchPoint> points,
      required double start,
      required double end}) {
    final _TouchPoint c2 =
        calculateControlPoints(points[0], points[1], points[2])[1];
    final _TouchPoint c3 =
        calculateControlPoints(points[1], points[2], points[3])[0];
    return _Bezier(points[1], c2, c3, points[2], start, end);
  }

  static List<_TouchPoint> calculateControlPoints(
      _TouchPoint s1, _TouchPoint s2, _TouchPoint s3) {
    final double dx1 = s1.x - s2.x;
    final double dy1 = s1.y - s2.y;
    final double dx2 = s2.x - s3.x;
    final double dy2 = s2.y - s3.y;

    final Point<double> m1 =
        Point<double>((s1.x + s2.x) / 2.0, (s1.y + s2.y) / 2.0);
    final Point<double> m2 =
        Point<double>((s2.x + s3.x) / 2.0, (s2.y + s3.y) / 2.0);

    final double l1 = sqrt(dx1 * dx1 + dy1 * dy1);
    final double l2 = sqrt(dx2 * dx2 + dy2 * dy2);

    final double dxm = m1.x - m2.x;
    final double dym = m1.y - m2.y;

    double k = l2 / (l1 + l2);
    if (k.isNaN) {
      k = 0;
    }

    final Point<double> cm = Point<double>(m2.x + dxm * k, m2.y + dym * k);

    final double tx = s2.x - cm.x;
    final double ty = s2.y - cm.y;

    final List<_TouchPoint> points = <_TouchPoint>[];
    points.add(_TouchPoint(x: m1.x + tx, y: m1.y + ty));
    points.add(_TouchPoint(x: m2.x + tx, y: m2.y + ty));
    return points;
  }

  double length() {
    const double steps = 10;
    double length = 0;
    double px = 0;
    double py = 0;

    for (int i = 0; i <= steps; i += 1) {
      final double t = i / steps;
      final double cx =
          point(t, startPoint.x, control1.x, control2.x, endPoint.x);
      final double cy =
          point(t, startPoint.y, control1.y, control2.y, endPoint.y);

      if (i > 0) {
        final double xDiff = cx - px;
        final double yDiff = cy - py;
        length += sqrt(xDiff * xDiff + yDiff * yDiff);
      }

      px = cx;
      py = cy;
    }

    if (length.isNaN || length.isInfinite) {
      return 0;
    }

    return length;
  }

  double point(double t, double start, double c1, double c2, double end) {
    return (start * (1.0 - t) * (1.0 - t) * (1.0 - t)) +
        (3.0 * c1 * (1.0 - t) * (1.0 - t) * t) +
        (3.0 * c2 * (1.0 - t) * t * t) +
        (end * t * t * t);
  }
}

class _CachePoint {
  const _CachePoint({required this.x, required this.y, required this.width});

  final double x;
  final double y;
  final double width;
}

///This class holds the touch point related data.
class _TouchPoint {
  /// Creates a new instance of [TouchPoint].
  const _TouchPoint({required this.x, required this.y, this.time});

  ///Touch x point.
  final double x;

  ///Touch Y point.
  final double y;

  ///Time in millisecondsSinceEpoch format.
  final int? time;
}
