import 'package:flutter/material.dart';
import '../../../charts.dart';
import '../chart_series/series.dart';
import '../chart_series/series_renderer_properties.dart';
import '../chart_series/xy_data_series.dart';
import '../common/common.dart';
import '../common/renderer.dart';
import '../common/segment_properties.dart';
import '../utils/helper.dart';
import 'chart_segment.dart';

/// Creates the segments for box and whisker series.
///
/// Generates the box and whisker series points and has the [calculateSegmentPoints] override method
/// used to customize the box and whisker series segment point calculation.
///
/// Gets the path and fill color from the `series` to render the box and whisker segment.
class BoxAndWhiskerSegment extends ChartSegment {
  late double _maxY,
      _lowerY,
      _upperY,
      _centerMax,
      _centerMin,
      _minY,
      _centersY,
      _topLineY,
      _bottomLineY,
      _medianX,
      _medianY;

  late Paint _meanPaint;

  late bool _isTransposed;

  late ChartLocation _centerMinPoint, _centerMaxPoint;

  late BoxAndWhiskerSeries<dynamic, dynamic> _boxAndWhiskerSeries;

  late SegmentProperties _segmentProperties;

  bool _isInitialize = false;

  /// Gets the color of the series.
  @override
  Paint getFillPaint() {
    _setSegmentProperties();

    /// Get and set the paint options for box and whisker series.
    if (_segmentProperties.series.gradient == null) {
      fillPaint = Paint()
        ..color = (_segmentProperties.currentPoint!.isEmpty ?? false)
            ? _segmentProperties.series.emptyPointSettings.color
            : (_segmentProperties.currentPoint!.pointColorMapper ??
                _segmentProperties.color!)
        ..style = PaintingStyle.fill;
    } else {
      fillPaint = getLinearGradientPaint(
          _segmentProperties.series.gradient!,
          _segmentProperties.currentPoint!.region!,
          SeriesHelper.getSeriesRendererDetails(
                  _segmentProperties.seriesRenderer)
              .stateProperties
              .requireInvertedAxis);
    }
    assert(_segmentProperties.series.opacity >= 0 == true,
        'The opacity value of the box plot series should be greater than or equal to 0.');
    assert(_segmentProperties.series.opacity <= 1 == true,
        'The opacity value of the box plot series should be less than or equal to 1.');
    fillPaint!.color = (_segmentProperties.series.opacity < 1 == true &&
            fillPaint!.color != Colors.transparent)
        ? fillPaint!.color.withOpacity(_segmentProperties.series.opacity)
        : fillPaint!.color;
    _segmentProperties.defaultFillColor = fillPaint;
    setShader(_segmentProperties, fillPaint!);
    return fillPaint!;
  }

  /// Gets the border color of the series.
  @override
  Paint getStrokePaint() {
    _setSegmentProperties();
    strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = (_segmentProperties.currentPoint!.isEmpty ?? false)
          ? _segmentProperties.series.emptyPointSettings.borderWidth
          : _segmentProperties.strokeWidth!;
    _meanPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = (_segmentProperties.currentPoint!.isEmpty ?? false)
          ? _segmentProperties.series.emptyPointSettings.borderWidth
          : _segmentProperties.strokeWidth!;
    if (_segmentProperties.series.borderGradient != null) {
      strokePaint!.shader = _segmentProperties.series.borderGradient!
          .createShader(_segmentProperties.currentPoint!.region!);
      _meanPaint.shader = _segmentProperties.series.borderGradient!
          .createShader(_segmentProperties.currentPoint!.region!);
    } else {
      strokePaint!.color = (_segmentProperties.currentPoint!.isEmpty ?? false)
          ? _segmentProperties.series.emptyPointSettings.borderColor
          : _segmentProperties.strokeColor!;
      _meanPaint.color = (_segmentProperties.currentPoint!.isEmpty ?? false)
          ? _segmentProperties.series.emptyPointSettings.borderColor
          : _segmentProperties.strokeColor!;
    }
    _segmentProperties.series.borderWidth == 0
        ? strokePaint!.color = Colors.transparent
        : strokePaint!.color;
    _segmentProperties.defaultStrokeColor = strokePaint;
    return strokePaint!;
  }

  /// Calculates the rendering bounds of a segment.
  @override
  void calculateSegmentPoints() {
    _setSegmentProperties();
    _boxAndWhiskerSeries =
        _segmentProperties.series as BoxAndWhiskerSeries<dynamic, dynamic>;
    _segmentProperties.x = _segmentProperties.max = double.nan;
    _isTransposed =
        SeriesHelper.getSeriesRendererDetails(_segmentProperties.seriesRenderer)
            .stateProperties
            .requireInvertedAxis;
    _segmentProperties.minPoint =
        _segmentProperties.currentPoint!.minimumPoint!;
    _segmentProperties.maxPoint =
        _segmentProperties.currentPoint!.maximumPoint!;
    _centerMinPoint = _segmentProperties.currentPoint!.centerMinimumPoint!;
    _centerMaxPoint = _segmentProperties.currentPoint!.centerMaximumPoint!;
    _segmentProperties.x = _segmentProperties.minPoint.x;
    _segmentProperties.min = _segmentProperties.minPoint.y;
    _segmentProperties.max = _segmentProperties.maxPoint.y;
    _centerMax = _centerMaxPoint.x;
    _maxY = _centerMaxPoint.y;
    _centerMin = _centerMinPoint.x;
    _minY = _centerMinPoint.y;
    _segmentProperties.lowerX =
        _segmentProperties.currentPoint!.lowerQuartilePoint!.x;
    _lowerY = _segmentProperties.currentPoint!.lowerQuartilePoint!.y;
    _segmentProperties.upperX =
        _segmentProperties.currentPoint!.upperQuartilePoint!.x;
    _upperY = _segmentProperties.currentPoint!.upperQuartilePoint!.y;
    _medianX = _segmentProperties.currentPoint!.medianPoint!.x;
    _medianY = _segmentProperties.currentPoint!.medianPoint!.y;

    _centersY = (_lowerY > _upperY)
        ? (_upperY + ((_upperY - _lowerY).abs() / 2))
        : (_lowerY + ((_lowerY - _upperY).abs() / 2));

    _segmentProperties.topRectY = _centersY - ((_centersY - _upperY).abs() * 1);
    _segmentProperties.bottomRectY =
        _centersY + ((_centersY - _lowerY).abs() * 1);
  }

  /// To draw rect path of box and whisker segments.
  void _drawRectPath() {
    _segmentProperties.path.moveTo(
        !_isTransposed
            ? _segmentProperties.lowerX
            : _segmentProperties.topRectY,
        !_isTransposed ? _segmentProperties.topRectY : _upperY);
    _segmentProperties.path.lineTo(
        !_isTransposed
            ? _segmentProperties.upperX
            : _segmentProperties.topRectY,
        !_isTransposed ? _segmentProperties.topRectY : _lowerY);
    _segmentProperties.path.lineTo(
        !_isTransposed
            ? _segmentProperties.upperX
            : _segmentProperties.bottomRectY,
        !_isTransposed ? _segmentProperties.bottomRectY : _lowerY);
    _segmentProperties.path.lineTo(
        !_isTransposed
            ? _segmentProperties.lowerX
            : _segmentProperties.bottomRectY,
        !_isTransposed ? _segmentProperties.bottomRectY : _upperY);
    _segmentProperties.path.lineTo(
        !_isTransposed
            ? _segmentProperties.lowerX
            : _segmentProperties.topRectY,
        !_isTransposed ? _segmentProperties.topRectY : _upperY);
    _segmentProperties.path.close();
  }

  /// To draw line path of box and whisker segments.
  void _drawLine(Canvas canvas) {
    canvas.drawLine(Offset(_segmentProperties.lowerX, _topLineY),
        Offset(_segmentProperties.upperX, _topLineY), strokePaint!);
    canvas.drawLine(Offset(_centerMax, _segmentProperties.topRectY),
        Offset(_centerMax, _topLineY), strokePaint!);
    canvas.drawLine(Offset(_segmentProperties.lowerX, _medianY),
        Offset(_segmentProperties.upperX, _medianY), strokePaint!);
    canvas.drawLine(Offset(_centerMax, _segmentProperties.bottomRectY),
        Offset(_centerMax, _bottomLineY), strokePaint!);
    canvas.drawLine(Offset(_segmentProperties.lowerX, _bottomLineY),
        Offset(_segmentProperties.upperX, _bottomLineY), strokePaint!);
  }

  /// To draw mean line path of box and whisker segments.
  void _drawMeanLine(
      Canvas canvas, Offset position, Size size, bool isTransposed) {
    final double x = !isTransposed ? position.dx : position.dy;
    final double y = !isTransposed ? position.dy : position.dx;
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(
            _segmentProperties.seriesRenderer);
    if (_segmentProperties.series.animationDuration <= 0 == true ||
        animationFactor >=
            seriesRendererDetails.stateProperties.seriesDurationFactor) {
      /// `0.15` is animation duration of mean point value, as like marker.
      final double opacity = (animationFactor -
              seriesRendererDetails.stateProperties.seriesDurationFactor) *
          (1 / 0.15);
      _meanPaint.color = Color.fromRGBO(_meanPaint.color.red,
          _meanPaint.color.green, _meanPaint.color.blue, opacity);
      canvas.drawLine(Offset(x + size.width / 2, y - size.height / 2),
          Offset(x - size.width / 2, y + size.height / 2), _meanPaint);
      canvas.drawLine(Offset(x + size.width / 2, y + size.height / 2),
          Offset(x - size.width / 2, y - size.height / 2), _meanPaint);
    }
  }

  /// To draw line path of box and whisker segments.
  void _drawFillLine(Canvas canvas) {
    final bool isOpen = _segmentProperties.currentPoint!.lowerQuartile! >
        _segmentProperties.currentPoint!.upperQuartile!;
    canvas.drawLine(
        Offset(_segmentProperties.topRectY, _maxY),
        Offset(
            _segmentProperties.topRectY +
                ((isOpen
                            ? (_segmentProperties.lowerX - _centerMax)
                            : (_segmentProperties.upperX - _centerMax))
                        .abs() *
                    animationFactor),
            _maxY),
        strokePaint!);
    canvas.drawLine(
        Offset(_segmentProperties.bottomRectY, _maxY),
        Offset(
            _segmentProperties.bottomRectY -
                ((isOpen
                            ? (_segmentProperties.upperX - _centerMin)
                            : (_segmentProperties.lowerX - _centerMin))
                        .abs() *
                    animationFactor),
            _maxY),
        strokePaint!);
  }

  /// Draws segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    _setSegmentProperties();
    final SeriesRendererDetails seriesRendererDetails =
        SeriesHelper.getSeriesRendererDetails(
            _segmentProperties.seriesRenderer);
    if (fillPaint != null && seriesRendererDetails.reAnimate == true ||
        (!(seriesRendererDetails
                    .stateProperties.renderingDetails.widgetNeedUpdate ==
                true &&
            _segmentProperties.oldSeriesRenderer != null &&
            seriesRendererDetails
                    .stateProperties.renderingDetails.isLegendToggled ==
                false))) {
      _segmentProperties.path = Path();
      if (!_isTransposed &&
          _segmentProperties.currentPoint!.lowerQuartile! >
                  _segmentProperties.currentPoint!.upperQuartile! ==
              true) {
        final double temp = _upperY;
        _upperY = _lowerY;
        _lowerY = temp;
      }

      if (seriesRendererDetails
              .stateProperties.renderingDetails.isLegendToggled ==
          true) {
        animationFactor = 1;
      }
      if (_lowerY > _upperY) {
        _centersY = _upperY + ((_upperY - _lowerY).abs() / 2);
        _segmentProperties.topRectY =
            _centersY - ((_centersY - _upperY).abs() * animationFactor);
        _segmentProperties.bottomRectY =
            _centersY + ((_centersY - _lowerY).abs() * animationFactor);
      } else {
        _centersY = _lowerY + ((_lowerY - _upperY).abs() / 2);
        _segmentProperties.topRectY =
            _centersY - ((_centersY - _upperY).abs() * animationFactor);
        _segmentProperties.bottomRectY =
            _centersY + ((_centersY - _lowerY).abs() * animationFactor);
      }
      _topLineY = _segmentProperties.topRectY -
          ((_segmentProperties.topRectY - _maxY).abs() * animationFactor);
      _bottomLineY = _segmentProperties.bottomRectY +
          ((_segmentProperties.bottomRectY - _minY).abs() * animationFactor);

      _bottomLineY = _minY < _lowerY
          ? _segmentProperties.bottomRectY +
              ((_upperY - _maxY).abs() * animationFactor)
          : _bottomLineY;

      _topLineY = _maxY > _upperY
          ? _segmentProperties.topRectY -
              ((_lowerY - _minY).abs() * animationFactor)
          : _topLineY;

      if (_isTransposed) {
        if (_segmentProperties.lowerX > _segmentProperties.upperX == true) {
          _centersY = _segmentProperties.upperX +
              ((_segmentProperties.lowerX - _segmentProperties.upperX).abs() /
                  2);
          _segmentProperties.topRectY = _centersY +
              ((_centersY - _segmentProperties.lowerX).abs() * animationFactor);
          _segmentProperties.bottomRectY = _centersY -
              ((_centersY - _segmentProperties.upperX).abs() * animationFactor);
        } else {
          _centersY = _segmentProperties.lowerX +
              (_segmentProperties.upperX - _segmentProperties.lowerX).abs() / 2;
          _segmentProperties.topRectY = _centersY +
              ((_centersY - _segmentProperties.upperX).abs() * animationFactor);
          _segmentProperties.bottomRectY = _centersY -
              ((_centersY - _segmentProperties.lowerX).abs() * animationFactor);
        }
        _segmentProperties.path.moveTo(_centerMax, _upperY);
        _segmentProperties.path.lineTo(_centerMax, _lowerY);
        if (_centerMax < _segmentProperties.upperX) {
          _segmentProperties.path.moveTo(_segmentProperties.bottomRectY, _maxY);
          _segmentProperties.path.lineTo(
              _segmentProperties.topRectY -
                  ((_segmentProperties.lowerX - _centerMax).abs() *
                      animationFactor),
              _maxY);
        } else {
          _segmentProperties.path.moveTo(_segmentProperties.topRectY, _maxY);
          _segmentProperties.path.lineTo(
              _segmentProperties.topRectY +
                  ((_segmentProperties.upperX - _centerMax).abs() *
                      animationFactor),
              _maxY);
        }
        _segmentProperties.path.moveTo(_medianX, _upperY);
        _segmentProperties.path.lineTo(_medianX, _lowerY);
        if (_centerMin > _segmentProperties.lowerX) {
          _segmentProperties.path.moveTo(_segmentProperties.topRectY, _maxY);
          _segmentProperties.path.lineTo(
              _segmentProperties.bottomRectY +
                  ((_segmentProperties.upperX - _centerMin).abs() *
                      animationFactor),
              _maxY);
        } else {
          _segmentProperties.path.moveTo(_segmentProperties.bottomRectY, _maxY);
          _segmentProperties.path.lineTo(
              _segmentProperties.bottomRectY -
                  ((_segmentProperties.lowerX - _centerMin).abs() *
                      animationFactor),
              _maxY);
        }
        _segmentProperties.path.moveTo(_centerMin, _upperY);
        _segmentProperties.path.lineTo(_centerMin, _lowerY);
        if (_boxAndWhiskerSeries.showMean) {
          _drawMeanLine(
              canvas,
              Offset(_segmentProperties.currentPoint!.centerMeanPoint!.y,
                  _segmentProperties.currentPoint!.centerMeanPoint!.x),
              Size(_segmentProperties.series.markerSettings.width,
                  _segmentProperties.series.markerSettings.height),
              _isTransposed);
        }

        _segmentProperties.lowerX == _segmentProperties.upperX
            ? canvas.drawLine(Offset(_segmentProperties.lowerX, _lowerY),
                Offset(_segmentProperties.upperX, _upperY), fillPaint!)
            : _drawRectPath();
      } else {
        if (_segmentProperties.currentPoint!.lowerQuartile! >
                _segmentProperties.currentPoint!.upperQuartile! ==
            true) {
          final double temp = _upperY;
          _upperY = _lowerY;
          _lowerY = temp;
        }
        _drawLine(canvas);
        if (_boxAndWhiskerSeries.showMean) {
          _drawMeanLine(
              canvas,
              Offset(_segmentProperties.currentPoint!.centerMeanPoint!.x,
                  _segmentProperties.currentPoint!.centerMeanPoint!.y),
              Size(_segmentProperties.series.markerSettings.width,
                  _segmentProperties.series.markerSettings.height),
              _isTransposed);
        }
        _lowerY == _upperY
            ? canvas.drawLine(Offset(_segmentProperties.lowerX, _lowerY),
                Offset(_segmentProperties.upperX, _upperY), fillPaint!)
            : _drawRectPath();
      }

      if (seriesRendererDetails.dashArray![0] != 0 &&
          seriesRendererDetails.dashArray![1] != 0 &&
          _segmentProperties.series.animationDuration <= 0 == true) {
        canvas.drawPath(_segmentProperties.path, fillPaint!);
        drawDashedLine(canvas, seriesRendererDetails.dashArray!, strokePaint!,
            _segmentProperties.path);
      } else {
        canvas.drawPath(_segmentProperties.path, fillPaint!);
        canvas.drawPath(_segmentProperties.path, strokePaint!);
      }
      if (fillPaint!.style == PaintingStyle.fill) {
        if (_isTransposed) {
          if (_segmentProperties.currentPoint!.lowerQuartile! >
                  _segmentProperties.currentPoint!.upperQuartile! ==
              true) {
            _drawFillLine(canvas);
          }
          if (_boxAndWhiskerSeries.showMean) {
            _drawMeanLine(
                canvas,
                Offset(_segmentProperties.currentPoint!.centerMeanPoint!.y,
                    _segmentProperties.currentPoint!.centerMeanPoint!.x),
                Size(_segmentProperties.series.markerSettings.width,
                    _segmentProperties.series.markerSettings.height),
                _isTransposed);
          }
        } else {
          _drawLine(canvas);
          if (_boxAndWhiskerSeries.showMean) {
            _drawMeanLine(
                canvas,
                Offset(_segmentProperties.currentPoint!.centerMeanPoint!.x,
                    _segmentProperties.currentPoint!.centerMeanPoint!.y),
                Size(_segmentProperties.series.markerSettings.width,
                    _segmentProperties.series.markerSettings.height),
                _isTransposed);
          }
        }
      }
    } else if (seriesRendererDetails
            .stateProperties.renderingDetails.isLegendToggled ==
        false) {
      final BoxAndWhiskerSegment currentSegment = seriesRendererDetails
          .segments[currentSegmentIndex!] as BoxAndWhiskerSegment;
      final SegmentProperties chartSegmentPropeties =
          SegmentHelper.getSegmentProperties(currentSegment);
      final SeriesRendererDetails oldSeriesRendererDetails =
          SeriesHelper.getSeriesRendererDetails(
              chartSegmentPropeties.oldSeriesRenderer!);
      final BoxAndWhiskerSegment? oldSegment =
          (oldSeriesRendererDetails.segments.isNotEmpty == true &&
                  oldSeriesRendererDetails.segments[0]
                      is BoxAndWhiskerSegment &&
                  oldSeriesRendererDetails.segments.length - 1 >=
                          currentSegmentIndex! ==
                      true)
              ? oldSeriesRendererDetails.segments[currentSegmentIndex!]
                  as BoxAndWhiskerSegment?
              : null;
      SegmentProperties? oldSegmentProperties;
      if (oldSegment != null) {
        oldSegmentProperties = SegmentHelper.getSegmentProperties(oldSegment);
      }

      animateBoxSeries(
          _boxAndWhiskerSeries.showMean,
          Offset(_segmentProperties.currentPoint!.centerMeanPoint!.x,
              _segmentProperties.currentPoint!.centerMeanPoint!.y),
          Offset(_segmentProperties.currentPoint!.centerMeanPoint!.y,
              _segmentProperties.currentPoint!.centerMeanPoint!.x),
          Size(_segmentProperties.series.markerSettings.width,
              _segmentProperties.series.markerSettings.height),
          _segmentProperties.max,
          _isTransposed,
          _segmentProperties.currentPoint!.lowerQuartile!,
          _segmentProperties.currentPoint!.upperQuartile!,
          _minY,
          _maxY,
          oldSegment?._minY,
          oldSegment?._maxY,
          _segmentProperties.lowerX,
          _lowerY,
          _segmentProperties.upperX,
          _upperY,
          _centerMin,
          _centerMax,
          oldSegmentProperties?.lowerX,
          oldSegment?._lowerY,
          oldSegmentProperties?.upperX,
          oldSegment?._upperY,
          oldSegment?._centerMin,
          oldSegment?._centerMax,
          _medianX,
          _medianY,
          animationFactor,
          fillPaint!,
          strokePaint!,
          canvas,
          SeriesHelper.getSeriesRendererDetails(
              _segmentProperties.seriesRenderer));
    }
  }

  /// Method to set segment properties.
  void _setSegmentProperties() {
    if (!_isInitialize) {
      _segmentProperties = SegmentHelper.getSegmentProperties(this);
      _isInitialize = true;
    }
  }
}
