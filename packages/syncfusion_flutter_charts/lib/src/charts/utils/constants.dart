import 'package:flutter/material.dart';

const String primaryXAxisDefaultName = 'primaryXAxis';
const String primaryYAxisDefaultName = 'primaryYAxis';

const int angle90Degree = -90;
const int angle45Degree = -45;

// Multilevel label text padding.
const double textPadding = 6;

// Multilevel label curly brace text padding.
const double textPaddingOfCurlyBrace = 10;

// Data label padding between the data point value.
const double dataLabelPadding = 5;

// Trackball tooltip padding.
const double trackballPadding = 10;

// Tooltip padding for smooth touch.
const double tooltipPadding = 15;

// Hilo and HiloOpenClose series padding.
const double hiloPadding = 3;

// Distance for nearest point.
double pointDistance = 10;

// Specifies the padding value for group all display mode.
const double groupAllPadding = 10.0;

// Full angle for circular series.
const double fullAngle = 359.999;

// Default date-time value (Jan 31st, 1970) converted into milliseconds.
const int defaultTimeStamp = 2592000000;

/// Specifies the tooltip marker size.
const double tooltipMarkerSize = 10.0;

/// Specifies the tooltip marker padding.
const EdgeInsets tooltipMarkerPadding = EdgeInsets.all(2.0);

const EdgeInsetsDirectional tooltipItemSpacing =
    EdgeInsetsDirectional.only(end: 3.0);

const EdgeInsets tooltipInnerPadding = EdgeInsets.all(6.0);

const defaultLegendSizeFactor = 0.3;

// Crosshair tooltip padding.
const double crosshairPadding = 10;

// Indicator upper line text.
const String trackballUpperLineText = 'UpperLine';

// Indicator ceter line text.
const String trackballCenterText = 'CenterLine';

// Indicator lower line text.
const String trackballLowerLineText = 'LowerLine';

// Indicator period line text.
const String trackballPeriodLineText = 'PeriodLine';

// Indicator MACD line text.
const String trackballMACDLineText = 'MacdLine';

// Indicator histogram text.
const String trackballHistogramText = 'Histogram';

// Specifies for trackball tooltip marker size.
const double trackballTooltipMarkerSize = 20;

// Specifies for trackball tooltip padding .
const double trackballTooltipPadding = 17;

// Specifies for trackball text, tooltip marker padding.
const double defaultTrackballPadding = 5;

// Specifies for default trackball tooltip width.
const double defaultTooltipWidth = 10;

// Specifies the tooltip event is touch or mouse.
bool isHover = false;
