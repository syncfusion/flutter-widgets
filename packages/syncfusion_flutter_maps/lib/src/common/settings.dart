part of maps;

/// Signature used by the [MapShapeLayer.loadingBuilder].
typedef MapLoadingBuilder = Widget Function(BuildContext context);

/// Signature to return the string values from the data source
/// based on the index.
typedef IndexedStringValueMapper = String Function(int index);

/// Signature to return the double values from the data source
/// based on the index.
typedef IndexedDoubleValueMapper = double Function(int index);

/// Signature to return the colors or other types from the data source based on
/// the index based on which colors will be applied.
typedef IndexedColorValueMapper = dynamic Function(int index);

/// Signature to return the [MapMarker].
typedef MapMarkerBuilder = MapMarker Function(BuildContext context, int index);

/// Signature for a [MapLayer.onWillZoom] callback which returns true or false
/// based on which current zooming completes.
typedef WillZoomCallback = bool Function(MapZoomDetails);

/// Signature for a [MapLayer.onWillPan]  callback which returns true or false
/// based on which current panning completes.
typedef WillPanCallback = bool Function(MapPanDetails);

/// The delegate that maps the data source with the shape file and provides
/// data for the elements of the [SfMaps] like data labels, bubbles, tooltip,
/// and shape colors.
///
/// The path of the .json file which contains the
/// GeoJSON data has to be set to the [MapShapeLayerDelegate.shapeFile].
///
/// The [MapShapeLayerDelegate.shapeDataField] property is used to
/// refer the unique field name in the .json file to identify each shapes and
/// map with the respective data in the data source.
///
/// By default, the value specified for the
/// [MapShapeLayerDelegate.shapeDataField] in the GeoJSON file will be used in
/// the elements like data labels, tooltip, and legend for their respective
/// shapes.
///
/// However, it is possible to keep a data source and customize these elements
/// based on the requirement. The value of the
/// [MapShapeLayerDelegate.shapeDataField] will be used to map with the
/// respective data returned in [MapShapeLayerDelegate.primaryValueMapper]
/// from the data source.
///
/// Once the above mapping is done, you can customize the elements using the
/// APIs like [MapShapeLayerDelegate.dataLabelMapper],
/// [MapShapeLayerDelegate.shapeColorMappers],
/// [MapShapeLayerDelegate.shapeTooltipTextMapper], etc.
///
/// ```dart
///   @override
///  Widget build(BuildContext context) {
///    return
///      SfMaps(
///        layers: [
///          MapShapeLayer(
///            delegate: MapShapeLayerDelegate(
///                shapeFile: "assets/world_map.json",
///                shapeDataField: "name",
///                dataCount: data.length,
///                primaryValueMapper: (index) {
///                  return data[index].country;
///                },
///                dataLabelMapper: (index) {
///                  return data[index].countryCode;
///                }),
///        )
///      ],
///    );
///  }
/// ```
/// See also:
/// * [MapShapeLayerDelegate.primaryValueMapper], to map the data of the data
/// source collection with the respective
/// [MapShapeLayerDelegate.shapeDataField] in .json file.
/// * [MapShapeLayerDelegate.bubbleSizeMapper], to customize the bubble size.
/// * [MapShapeLayerDelegate.dataLabelMapper], to customize the
/// data label's text.
/// * [MapShapeLayerDelegate.shapeTooltipTextMapper], to customize the
/// shape tooltip text.
/// * [MapShapeLayerDelegate.bubbleTooltipTextMapper], to customize the
/// bubble tooltip text.
/// * [MapShapeLayerDelegate.shapeColorValueMapper] and
/// [MapShapeLayerDelegate.shapeColorMappers], to customize the shape colors.
/// * [MapShapeLayerDelegate.bubbleColorValueMapper] and
/// [MapShapeLayerDelegate.bubbleColorMappers], to customize the
/// bubble colors.
class MapShapeLayerDelegate {
  /// Creates a [MapShapeLayerDelegate].
  const MapShapeLayerDelegate({
    @required this.shapeFile,
    this.shapeDataField,
    this.dataCount,
    this.primaryValueMapper,
    this.shapeColorMappers,
    this.bubbleColorMappers,
    this.dataLabelMapper,
    this.shapeTooltipTextMapper,
    this.bubbleTooltipTextMapper,
    this.bubbleSizeMapper,
    this.shapeColorValueMapper,
    this.bubbleColorValueMapper,
  })  : assert(shapeFile != null),
        assert(dataCount == null || dataCount > 0),
        assert(primaryValueMapper == null ||
            (primaryValueMapper != null && dataCount != null && dataCount > 0)),
        assert(shapeColorMappers == null ||
            (shapeColorMappers != null &&
                primaryValueMapper != null &&
                shapeColorValueMapper != null)),
        assert(bubbleColorMappers == null ||
            (bubbleColorMappers != null &&
                primaryValueMapper != null &&
                bubbleColorValueMapper != null));

  /// Path of the GeoJSON data file.
  final String shapeFile;

  /// Field name in the .json file to identify each shape.
  ///
  /// It is used to refer the field name in the .json file to identify
  /// each shape and map that shape with the respective data in
  /// the data source.
  final String shapeDataField;

  /// Length of the data source.
  final int dataCount;

  /// Collection of [MapColorMapper] which specifies shape's color based on the
  /// data.
  ///
  /// It provides option to set the shape color based on the specific
  /// [MapColorMapper.value] or the range of values which falls between
  /// [MapColorMapper.from] and [MapColorMapper.to].
  ///
  /// Based on the returned values, legend items will be rendered. The text of
  /// legend item will be [MapColorMapper.text] of the [MapColorMapper].
  ///
  /// The below code snippet represents how color can be applied to the shape
  /// based on the [MapColorMapper.value] property of [MapColorMapper].
  ///
  /// ```dart
  /// List<Model> data;
  ///
  ///  @override
  ///  void initState() {
  ///    super.initState();
  ///
  ///    data = <Model>[
  ///     Model('India', 280, "Low"),
  ///     Model('United States of America', 190, "High"),
  ///     Model('Pakistan', 37, "Low"),
  ///    ];
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          delegate: MapShapeLayerDelegate(
  ///              shapeFile: "assets/world_map.json",
  ///              shapeDataField: "name",
  ///              dataCount: data.length,
  ///              primaryValueMapper: (index) {
  ///                return data[index].country;
  ///              },
  ///              shapeColorValueMapper: (index) {
  ///                return data[index].storage;
  ///              },
  ///              shapeColorMappers: [
  ///                MapColorMapper(value: "Low", color: Colors.red),
  ///                MapColorMapper(value: "High", color: Colors.green)
  ///              ]),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  /// The below code snippet represents how color can be applied to the shape
  /// based on the range between [MapColorMapper.from] and [MapColorMapper.to]
  /// properties of [MapColorMapper].
  ///
  /// ```dart
  /// List<Model> data;
  ///
  ///  @override
  ///  void initState() {
  ///    super.initState();
  ///
  ///    data = <Model>[
  ///     Model('India', 100, "Low"),
  ///     Model('United States of America', 200, "High"),
  ///     Model('Pakistan', 75, "Low"),
  ///    ];
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          delegate: MapShapeLayerDelegate(
  ///              shapeFile: "assets/world_map.json",
  ///              shapeDataField: "name",
  ///              dataCount: data.length,
  ///              primaryValueMapper: (index) {
  ///                return data[index].country;
  ///              },
  ///              shapeColorValueMapper: (index) {
  ///                return data[index].count;
  ///              },
  ///              shapeColorMappers: [
  ///                MapColorMapper(from: 0, to:  100, color: Colors.red),
  ///                MapColorMapper(from: 101, to: 200, color: Colors.yellow)
  ///             ]),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  final List<MapColorMapper> shapeColorMappers;

  /// Collection of [MapColorMapper] which specifies bubble's color
  /// based on the data.
  ///
  /// It provides option to set the bubble color based on the specific
  /// [MapColorMapper.value] or the range of values which falls between
  /// [MapColorMapper.from] and [MapColorMapper.to].
  ///
  /// The below code snippet represents how color can be applied to the bubble
  /// based on the [MapColorMapper.value] property of [MapColorMapper].
  ///
  /// ```dart
  /// List<Model> data;
  ///
  ///  @override
  ///  void initState() {
  ///    super.initState();
  ///
  ///    data = <Model>[
  ///     Model('India', 280, "Low"),
  ///     Model('United States of America', 190, "High"),
  ///     Model('Pakistan', 37, "Low"),
  ///    ];
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          delegate: MapShapeLayerDelegate(
  ///              showBubbles: true,
  ///              shapeFile: "assets/world_map.json",
  ///              shapeDataField: "name",
  ///              dataCount: data.length,
  ///              primaryValueMapper: (index) {
  ///                return data[index].country;
  ///              },
  ///              bubbleColorValueMapper: (index) {
  ///                return data[index].usersCount;
  ///              },
  ///              bubbleSizeMapper: (index) {
  ///                return data[index].usersCount;
  ///              },
  ///              bubbleColorMappers: [
  ///                MapColorMapper(from: 0, to: 100, color: Colors.red),
  ///                MapColorMapper(from: 101, to: 200, color: Colors.yellow)
  ///              ]),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  /// The below code snippet represents how color can be applied to the bubble
  /// based on the range between [MapColorMapper.from] and [MapColorMapper.to]
  /// properties of [MapColorMapper].
  ///
  /// ```dart
  /// List<Model> data;
  ///
  ///  @override
  ///  void initState() {
  ///    super.initState();
  ///
  ///    data = <Model>[
  ///     Model('India', 280, "Low"),
  ///     Model('United States of America', 190, "High"),
  ///     Model('Pakistan', 37, "Low"),
  ///    ];
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          delegate: MapShapeLayerDelegate(
  ///              showBubbles: true,
  ///              shapeFile: "assets/world_map.json",
  ///              shapeDataField: "name",
  ///              dataCount: data.length,
  ///              primaryValueMapper: (index) {
  ///                return data[index].country;
  ///              },
  ///              bubbleColorValueMapper: (index) {
  ///                return data[index].storage;
  ///              },
  ///              bubbleSizeMapper: (index) {
  ///                return data[index].usersCount;
  ///              },
  ///              bubbleColorMappers: [
  ///               MapColorMapper(value: "Low", color: Colors.red),
  ///               MapColorMapper(value: "High", color: Colors.yellow)
  ///             ]),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  final List<MapColorMapper> bubbleColorMappers;

  /// Returns the the primary value for the every data in the data source
  /// collection.
  ///
  /// This primary value will be mapped with the [shapeDataField] value in the
  /// respective shape detail in the .json file. This mapping will then be used
  /// in the rendering of bubbles, data labels, shape colors, tooltip
  /// in their respective shape's coordinates.
  /// ```dart
  ///   @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          delegate: MapShapeLayerDelegate(
  ///              shapeFile: "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///              dataCount: bubbleData.length,
  ///              primaryValueMapper: (index) {
  ///                return bubbleData[index].country;
  ///              }
  ///           ),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  final IndexedStringValueMapper primaryValueMapper;

  /// Returns the data label text for each shape.
  ///
  /// ```dart
  ///   @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          showDataLabels: true,
  ///          delegate: MapShapeLayerDelegate(
  ///              shapeFile: "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///              dataCount: bubbleData.length,
  ///              primaryValueMapper: (index) {
  ///                return bubbleData[index].country;
  ///              },
  ///              dataLabelMapper: (index) {
  ///                return bubbleData[index].country;
  ///              }
  ///           ),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  final IndexedStringValueMapper dataLabelMapper;

  /// Returns the tooltip text for each shape.
  ///
  /// ```dart
  ///   @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          enableShapeTooltip: true,
  ///          delegate: MapShapeLayerDelegate(
  ///              shapeFile: "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///              dataCount: bubbleData.length,
  ///              primaryValueMapper: (index) {
  ///                return bubbleData[index].country;
  ///              },
  ///              shapeTooltipTextMapper: (index) {
  ///                return bubbleData[index].country;
  ///              }
  ///           ),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  final IndexedStringValueMapper shapeTooltipTextMapper;

  /// Returns the tooltip text for the bubble in the shape.
  ///
  /// ```dart
  ///   @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          showBubbles: true,
  ///          enableBubbleTooltip: true,
  ///          delegate: MapShapeLayerDelegate(
  ///              shapeFile: "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///              dataCount: bubbleData.length,
  ///              primaryValueMapper: (index) {
  ///                return bubbleData[index].country;
  ///              },
  ///              bubbleTooltipTextMapper: (index) {
  ///                return bubbleData[index].country;
  ///              }
  ///           ),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  final IndexedStringValueMapper bubbleTooltipTextMapper;

  /// Returns a value based on which bubble size will be calculated.
  ///
  /// The minimum and maximum size of the bubble can be customized using the
  /// [MapBubbleSettings.minRadius] and [MapBubbleSettings.maxRadius].
  ///
  /// ```dart
  ///   @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          showBubbles: true,
  ///          delegate: MapShapeLayerDelegate(
  ///              shapeFile: "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///              dataCount: bubbleData.length,
  ///              primaryValueMapper: (index) {
  ///                return bubbleData[index].country;
  ///              },
  ///              bubbleSizeMapper: (index) {
  ///                return bubbleData[index].usersCount;
  ///              }
  ///           ),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  final IndexedDoubleValueMapper bubbleSizeMapper;

  /// Returns a color or value based on which shape color will be updated.
  ///
  /// If this returns a color, then this color will be applied to the shape
  /// straightaway.
  ///
  /// If it returns a value other than the color, then you must set the
  /// [MapShapeLayerDelegate.shapeColorMappers] property.
  ///
  /// The value returned from the [shapeColorValueMapper] will be used for the
  /// comparison in the [MapColorMapper.value] or [MapColorMapper.from] and
  /// [MapColorMapper.to]. Then, the [MapColorMapper.color] will be applied to
  /// the respective shape.
  ///
  /// ```dart
  ///   @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          delegate: MapShapeLayerDelegate(
  ///              shapeFile: "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///              dataCount: bubbleData.length,
  ///              primaryValueMapper: (index) {
  ///                return bubbleData[index].country;
  ///              },
  ///              shapeColorValueMapper: (index) {
  ///                return bubbleData[index].country;
  ///              }
  ///           ),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  final IndexedColorValueMapper shapeColorValueMapper;

  /// Returns a color or value based on which bubble color will be updated.
  ///
  /// If this returns a color, then this color will be applied to the bubble
  /// straightaway.
  ///
  /// If it returns a value other than the color, then you must set the
  /// [MapShapeLayerDelegate.bubbleColorMappers] property.
  ///
  /// The value returned from the [bubbleColorValueMapper] will be used for the
  /// comparison in the [MapColorMapper.value] or [MapColorMapper.from] and
  /// [MapColorMapper.to]. Then, the [MapColorMapper.color] will be applied to
  /// the respective bubble.
  ///
  /// ```dart
  ///   @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          showBubbles: true,
  ///          delegate: MapShapeLayerDelegate(
  ///              shapeFile: "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///              dataCount: bubbleData.length,
  ///              primaryValueMapper: (index) {
  ///                return bubbleData[index].country;
  ///              },
  ///              bubbleColorValueMapper: (index) {
  ///                return bubbleData[index].country;
  ///              }
  ///           ),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  final IndexedColorValueMapper bubbleColorValueMapper;
}

/// Title for the [SfMaps].
///
/// [MapTitle] can define and customize the title for the [SfMaps]. The text
/// property of the [MapTitle] is used to set the text of the title.
//
/// It also provides option for customizing text style, alignment, decoration,
/// background color, margin and padding.
///
/// ```dart
///  @override
///  Widget build(BuildContext context) {
///    return SfMaps(
///      title: MapTitle(
///        text : 'World map'
///      ),
///    );
///  }
/// ```
class MapTitle {
  /// Creates a [MapTitle].
  const MapTitle({
    this.text,
    this.textStyle,
    this.alignment,
    this.decoration,
    this.color,
    this.margin,
    this.padding,
  });

  /// Specifies the text to be displayed as map title.
  ///
  /// See also:
  /// * [textStyle], to customize the text.
  /// * [alignment], to align the title.
  final String text;

  /// Customizes the style of the [text].
  ///
  /// See also:
  /// * [text], to set the text for the title.
  final TextStyle textStyle;

  /// Specifies the position of the title.
  ///
  /// Defaults to `center`.
  ///
  /// See also:
  /// * [text], to set the text for the title.
  final AlignmentGeometry alignment;

  /// Customize the appearance of the title.
  ///
  /// See also:
  /// * [Decoration], to set the decoration for the title.
  /// * [text], to set the text for the title.
  final Decoration decoration;

  /// Specifies the background color of the title.
  ///
  /// See also:
  /// * [text], to set the text for the title.
  final Color color;

  /// Customizes the margin of the title.
  ///
  /// See also:
  /// * [EdgeInsetsGeometry], to use the EdgeInsets values.
  /// * [text], to set the text for the title.
  final EdgeInsetsGeometry margin;

  /// Customize the space around the title [text].
  ///
  /// See also:
  /// * [EdgeInsetsGeometry], to use the EdgeInsets values.
  /// * [text], to set the text for the title.
  final EdgeInsetsGeometry padding;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is MapTitle &&
        other.text == text &&
        other.textStyle == textStyle &&
        other.alignment == alignment &&
        other.decoration == decoration &&
        other.color == color &&
        other.margin == margin &&
        other.padding == padding;
  }

  @override
  int get hashCode => hashValues(
      text, textStyle, alignment, decoration, color, margin, padding);
}

/// Customizes the shape or bubble color based on the data source and sets the
/// text and icon color for legend items.
///
/// [MapShapeLayerDelegate.shapeColorMappers] and
/// [MapShapeLayerDelegate.bubbleColorMappers] accepts collection of
/// [MapColorMapper].
///
/// [MapShapeLayerDelegate.shapeColorValueMapper] and
/// [MapShapeLayerDelegate.bubbleColorValueMapper] returns a color or value
/// based on which shape or bubble color will be updated.
///
/// If they return a color, then this color will be applied to the shapes or
/// bubbles straightaway.
///
/// If they return a value other than the color, then you must set the
/// [MapShapeLayerDelegate.shapeColorMappers] or
/// [MapShapeLayerDelegate.bubbleColorMappers] property.
///
/// The value returned from the [MapShapeLayerDelegate.shapeColorValueMapper]
/// and [MapShapeLayerDelegate.bubbleColorValueMapper] will be used for the
/// comparison in the [MapColorMapper.value] or [MapColorMapper.from] and
/// [MapColorMapper.to]. Then, the [MapColorMapper.color] will be applied to
/// the respective shape or bubble.
///
/// Legend icon's color and text will be taken from [MapColorMapper.color] or
/// [MapColorMapper.text] respectively.
///
/// The below code snippet represents how color can be applied to the shape
/// based on the [MapColorMapper.value] property of [MapColorMapper].
///
/// ```dart
/// List<Model> data;
///
///  @override
///  void initState() {
///    super.initState();
///
///    data = <Model>[
///     Model('India', 280, "Low"),
///     Model('United States of America', 190, "High"),
///     Model('Pakistan', 37, "Low"),
///    ];
///  }
///
///  @override
///  Widget build(BuildContext context) {
///    return SfMaps(
///      layers: [
///        MapShapeLayer(
///          delegate: MapShapeLayerDelegate(
///              shapeFile: "assets/world_map.json",
///              shapeDataField: "name",
///              dataCount: data.length,
///              primaryValueMapper: (index) {
///                return data[index].country;
///              },
///              shapeColorValueMapper: (index) {
///                return data[index].storage;
///              },
///              shapeColorMappers: [
///                MapColorMapper(value: "Low", color: Colors.red),
///                MapColorMapper(value: "High", color: Colors.green)
///              ]),
///        )
///      ],
///    );
///  }
/// ```
/// The below code snippet represents how color can be applied to the shape
/// based on the range between [MapColorMapper.from] and [MapColorMapper.to]
/// properties of [MapColorMapper].
///
/// ```dart
/// List<Model> data;
///
///  @override
///  void initState() {
///    super.initState();
///
///    data = <Model>[
///     Model('India', 100, "Low"),
///     Model('United States of America', 200, "High"),
///     Model('Pakistan', 75, "Low"),
///    ];
///  }
///
///  @override
///  Widget build(BuildContext context) {
///    return SfMaps(
///      layers: [
///        MapShapeLayer(
///          delegate: MapShapeLayerDelegate(
///              shapeFile: "assets/world_map.json",
///              shapeDataField: "name",
///              dataCount: data.length,
///              primaryValueMapper: (index) {
///                return data[index].country;
///              },
///              shapeColorValueMapper: (index) {
///                return data[index].count;
///              },
///              shapeColorMappers: [
///                MapColorMapper(from: 0, to:  100, color: Colors.red),
///                MapColorMapper(from: 101, to: 200, color: Colors.yellow)
///             ]),
///        )
///      ],
///    );
///  }
/// ```
///
/// See also:
/// * [MapShapeLayerDelegate.shapeColorValueMapper] and
/// [MapShapeLayerDelegate.shapeColorMappers], to customize the shape colors
/// based on the data.
/// * [MapShapeLayerDelegate.bubbleColorValueMapper] and
/// [MapShapeLayerDelegate.bubbleColorMappers], to customize the shape colors
/// based on the data.
class MapColorMapper {
  /// Creates a [MapColorMapper].
  const MapColorMapper({
    this.from,
    this.to,
    this.value,
    this.color,
    this.minOpacity,
    this.maxOpacity,
    this.text,
  })  : assert((from == null && to == null) ||
            (from != null && to != null && from < to && to > from)),
        assert(minOpacity == null || minOpacity != 0),
        assert(maxOpacity == null || maxOpacity != 0);

  /// Sets the range start for the color mapping.
  ///
  /// The shape or bubble will render in the specified [color] if the value
  /// returned in the [MapShapeLayerDelegate.shapeColorValueMapper] or
  /// [MapShapeLayerDelegate.bubbleColorValueMapper] falls between the [from]
  /// and [to] range.
  ///
  /// ```dart
  /// List<Model> data;
  ///
  ///  @override
  ///  void initState() {
  ///    super.initState();
  ///
  ///    data = <Model>[
  ///     Model('India', 100, "Low"),
  ///     Model('United States of America', 200, "High"),
  ///     Model('Pakistan', 75, "Low"),
  ///    ];
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          delegate: MapShapeLayerDelegate(
  ///              shapeFile: "assets/world_map.json",
  ///              shapeDataField: "name",
  ///              dataCount: data.length,
  ///              primaryValueMapper: (index) {
  ///                return data[index].country;
  ///              },
  ///              shapeColorValueMapper: (index) {
  ///                return data[index].count;
  ///              },
  ///              shapeColorMappers: [
  ///                MapColorMapper(from: 0, to:  100, color: Colors.red),
  ///                MapColorMapper(from: 101, to: 200, color: Colors.yellow)
  ///             ]),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  ///
  /// See also:
  /// * [to], to set the range end for the range color mapping.
  /// * [color], to set the color for the shape.
  /// * [MapShapeLayerDelegate.shapeColorMappers], to set the shape colors
  /// based on the specific
  /// value.
  /// * [MapShapeLayerDelegate.bubbleColorMappers], to set the bubble colors
  /// based on the specific
  ///  value.
  final double from;

  /// Sets the range end for the color mapping.
  ///
  /// The shape or bubble will render in the specified [color] if the value
  /// returned in the [MapShapeLayerDelegate.shapeColorValueMapper] or
  /// [MapShapeLayerDelegate.bubbleColorValueMapper] falls between the [from]
  /// and [to] range.
  ///
  /// ```dart
  /// List<Model> data;
  ///
  ///  @override
  ///  void initState() {
  ///    super.initState();
  ///
  ///    data = <Model>[
  ///     Model('India', 100, "Low"),
  ///     Model('United States of America', 200, "High"),
  ///     Model('Pakistan', 75, "Low"),
  ///    ];
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          delegate: MapShapeLayerDelegate(
  ///              shapeFile: "assets/world_map.json",
  ///              shapeDataField: "name",
  ///              dataCount: data.length,
  ///              primaryValueMapper: (index) {
  ///                return data[index].country;
  ///              },
  ///              shapeColorValueMapper: (index) {
  ///                return data[index].count;
  ///              },
  ///              shapeColorMappers: [
  ///                MapColorMapper(from: 0, to:  100, color: Colors.red),
  ///                MapColorMapper(from: 101, to: 200, color: Colors.yellow)
  ///             ]),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  ///
  /// See also:
  /// * [from], to set the range end for the range color mapping.
  /// * [color], to set the color for the shape.
  /// * [MapShapeLayerDelegate.shapeColorMappers], to set the shape colors based
  /// on the specific value.
  /// * [MapShapeLayerDelegate.bubbleColorMappers], to set the bubble colors
  /// based on the specific value.
  final double to;

  /// Sets the value for the color mapping.
  ///
  /// The shape or bubble will render in the specified [color] if the value
  /// returned in the [MapShapeLayerDelegate.shapeColorValueMapper] or
  /// [MapShapeLayerDelegate.bubbleColorValueMapper] is equal to this [value].
  ///
  /// ```dart
  /// List<Model> data;
  ///
  ///  @override
  ///  void initState() {
  ///    super.initState();
  ///
  ///    data = <Model>[
  ///     Model('India', 280, "Low"),
  ///     Model('United States of America', 190, "High"),
  ///     Model('Pakistan', 37, "Low"),
  ///    ];
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          delegate: MapShapeLayerDelegate(
  ///              shapeFile: "assets/world_map.json",
  ///              shapeDataField: "name",
  ///              dataCount: data.length,
  ///              primaryValueMapper: (index) {
  ///                return data[index].country;
  ///              },
  ///              shapeColorValueMapper: (index) {
  ///                return data[index].storage;
  ///              },
  ///              shapeColorMappers: [
  ///                MapColorMapper(value: "Low", color: Colors.red),
  ///                MapColorMapper(value: "High", color: Colors.green)
  ///              ]),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  ///
  /// See also:
  /// * [color], to set the color for the shape.
  /// * [MapShapeLayerDelegate.shapeColorMappers], to set the shape colors
  /// based on the specific value.
  /// * [MapShapeLayerDelegate.bubbleColorMappers], to set the bubble colors
  /// based on the specific value.
  final String value;

  /// Specifies the color applies to the shape or bubble based on the value.
  ///
  /// ```dart
  /// List<Model> data;
  ///
  ///  @override
  ///  void initState() {
  ///    super.initState();
  ///
  ///    data = <Model>[
  ///     Model('India', 280, "Low"),
  ///     Model('United States of America', 190, "High"),
  ///     Model('Pakistan', 37, "Low"),
  ///    ];
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          delegate: MapShapeLayerDelegate(
  ///              shapeFile: "assets/world_map.json",
  ///              shapeDataField: "name",
  ///              dataCount: data.length,
  ///              primaryValueMapper: (index) {
  ///                return data[index].country;
  ///              },
  ///              shapeColorValueMapper: (index) {
  ///                return data[index].storage;
  ///              },
  ///              shapeColorMappers: [
  ///                MapColorMapper(value: "Low", color: Colors.red),
  ///                MapColorMapper(value: "High", color: Colors.green)
  ///              ]),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  ///
  /// See also:
  /// * [from], to set the range end for the range color mapping.
  /// * [to], to set the range end for the range color mapping.
  /// * [value], to set the value for the equal color mapping.
  /// * [MapShapeLayerDelegate.shapeColorMappers], to set the shape colors
  /// based on the specific value.
  /// * [MapShapeLayerDelegate.bubbleColorMappers], to set the bubble colors
  /// based on the specific value.
  final Color color;

  /// Specifies the minimum opacity applies to the shape or bubble while using
  /// [from] and [to].
  ///
  /// The shapes or bubbles with lowest value which is [from] will be applied a
  /// [minOpacity] and the shapes or bubbles with highest value which is [to]
  /// will be applied a [maxOpacity]. The shapes or bubbles with values in-
  /// between the range will get a opacity based on their respective value.
  ///
  /// ```dart
  /// List<Model> data;
  ///
  ///  @override
  ///  void initState() {
  ///    super.initState();
  ///
  ///    data = <Model>[
  ///     Model('India', 100, "Low"),
  ///     Model('United States of America', 200, "High"),
  ///     Model('Pakistan', 75, "Low"),
  ///    ];
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          delegate: MapShapeLayerDelegate(
  ///              shapeFile: "assets/world_map.json",
  ///              shapeDataField: "name",
  ///              dataCount: data.length,
  ///              primaryValueMapper: (index) {
  ///                return data[index].country;
  ///              },
  ///              shapeColorValueMapper: (index) {
  ///                return data[index].count;
  ///              },
  ///              shapeColorMappers: [
  ///                MapColorMapper(from: 0, to:  100, color: Colors.yellow,
  ///                maxOpacity: 0.2, minOpacity: 0.5),
  ///                MapColorMapper(from: 101, to: 200, color: Colors.red,
  ///                maxOpacity: 0.6, minOpacity: 1)
  ///             ]),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  ///
  /// See also:
  /// * [MapShapeLayerDelegate.shapeColorMappers], to set the shape colors
  /// based on the specific value.
  /// * [MapShapeLayerDelegate.bubbleColorMappers], to set the bubble colors
  /// based on the specific value.
  final double minOpacity;

  /// Specifies the maximum opacity applies to the shape or bubble while using
  /// [from] and [to].
  ///
  /// The shapes or bubbles with lowest value which is [from] will be applied a
  /// [minOpacity] and the shapes or bubbles with highest value which is [to]
  /// will be applied a [maxOpacity]. The shapes or bubbles with values in-
  /// between the range will get a opacity based on their respective value.
  ///
  /// ```dart
  /// List<Model> data;
  ///
  ///  @override
  ///  void initState() {
  ///    super.initState();
  ///
  ///    data = <Model>[
  ///     Model('India', 100, "Low"),
  ///     Model('United States of America', 200, "High"),
  ///     Model('Pakistan', 75, "Low"),
  ///    ];
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          delegate: MapShapeLayerDelegate(
  ///              shapeFile: "assets/world_map.json",
  ///              shapeDataField: "name",
  ///              dataCount: data.length,
  ///              primaryValueMapper: (index) {
  ///                return data[index].country;
  ///              },
  ///              shapeColorValueMapper: (index) {
  ///                return data[index].count;
  ///              },
  ///              shapeColorMappers: [
  ///                MapColorMapper(from: 0, to:  100, color: Colors.yellow,
  ///                maxOpacity: 0.2, minOpacity: 0.5),
  ///                MapColorMapper(from: 101, to: 200, color: Colors.red,
  ///                maxOpacity: 0.6, minOpacity: 1)
  ///             ]),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  ///
  /// See also:
  /// * [MapShapeLayerDelegate.shapeColorMappers], to set the shape colors based
  /// on the specific value.
  /// * [MapShapeLayerDelegate.bubbleColorMappers], to set the bubble colors
  /// based on the specific value.
  final double maxOpacity;

  /// Specifies the text to be used for the legend item.
  ///
  /// By default, [MapColorMapper.from] and [MapColorMapper.to] or
  /// [MapColorMapper.value] will be used as the text of the legend item.
  ///
  /// ```dart
  /// List<Model> data;
  ///
  ///  @override
  ///  void initState() {
  ///    super.initState();
  ///
  ///    data = <Model>[
  ///     Model('India', 100, "Low"),
  ///     Model('United States of America', 200, "High"),
  ///     Model('Pakistan', 75, "Low"),
  ///    ];
  ///  }
  ///
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          delegate: MapShapeLayerDelegate(
  ///              shapeFile: "assets/world_map.json",
  ///              shapeDataField: "name",
  ///              dataCount: data.length,
  ///              primaryValueMapper: (index) {
  ///                return data[index].country;
  ///              },
  ///              shapeColorValueMapper: (index) {
  ///                return data[index].count;
  ///              },
  ///              shapeColorMappers: [
  ///                MapColorMapper(from: 0, to:  100, color: Colors.yellow,
  ///                maxOpacity: 0.2, minOpacity: 0.5, text: "low"),
  ///                MapColorMapper(from: 101, to: 200, color: Colors.red,
  ///                maxOpacity: 0.6, minOpacity: 1, text: "high")
  ///             ]),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  ///
  /// See also:
  /// * [MapShapeLayerDelegate.shapeColorMappers], to set the shape colors based
  /// on the specific value.
  final String text;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is MapColorMapper &&
        other.from == from &&
        other.to == to &&
        other.value == value &&
        other.color == color &&
        other.minOpacity == minOpacity &&
        other.maxOpacity == maxOpacity &&
        other.text == text;
  }

  @override
  int get hashCode =>
      hashValues(from, to, value, color, minOpacity, maxOpacity, text);
}

/// Customizes the legend's and legend item's position, appearance and toggling
/// behavior.
///
/// ```dart
///  @override
///  Widget build(BuildContext context) {
///    return SfMaps(
///      layers: [
///        MapShapeLayer(
///          showLegend: true,
///          legendSettings: MapLegendSettings(
///              padding: EdgeInsets.all(10)
///          ),
///          delegate: MapShapeLayerDelegate(
///              shapeFile: "assets/world_map.json",
///              shapeDataField: "continent",
///              dataCount: bubbleData.length,
///              primaryValueMapper: (index) {
///                return bubbleData[index].country;
///              }),
///        )
///      ],
///    );
///  }
/// ```
@immutable
class MapLegendSettings {
  /// Creates a [MapLegendSettings].
  const MapLegendSettings({
    this.direction,
    this.padding = const EdgeInsets.all(10.0),
    this.position = MapLegendPosition.top,
    this.offset,
    this.itemsSpacing = 10.0,
    this.iconType = MapIconType.circle,
    this.textStyle,
    this.showIcon = true,
    this.iconSize = const Size(8.0, 8.0),
    this.overflowMode = MapLegendOverflowMode.wrap,
    this.enableToggleInteraction = false,
    this.toggledItemColor,
    this.toggledItemStrokeColor,
    this.toggledItemStrokeWidth = 1.0,
    this.toggledItemOpacity = 1.0,
  })  : assert(itemsSpacing != null && itemsSpacing >= 0),
        assert(padding != null),
        assert(iconSize != null),
        assert(toggledItemStrokeWidth == null || toggledItemStrokeWidth >= 0),
        assert(toggledItemOpacity == null ||
            (toggledItemOpacity >= 0 && toggledItemOpacity <= 1));

  /// Sets the padding around the legend.
  ///
  /// Defaults to EdgeInsets.all(10.0).
  ///
  /// ```dart
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          showLegend: true,
  ///          legendSettings: MapLegendSettings(
  ///              padding: EdgeInsets.all(10)
  ///          ),
  ///          delegate: MapShapeLayerDelegate(
  ///              shapeFile: "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///              dataCount: bubbleData.length,
  ///              primaryValueMapper: (index) {
  ///                return bubbleData[index].country;
  ///              }),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  final EdgeInsetsGeometry padding;

  /// Arranges the legend items in either horizontal or vertical direction.
  ///
  /// Defaults to horizontal, if the [position] is top, bottom or null.
  /// Defaults to vertical, if the [position] is left or right.
  ///
  /// ```dart
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          showLegend: true,
  ///          legendSettings: MapLegendSettings(
  ///              direction: Axis.horizontal
  ///          ),
  ///          delegate: MapShapeLayerDelegate(
  ///              shapeFile: "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///              dataCount: bubbleData.length,
  ///              primaryValueMapper: (index) {
  ///                return bubbleData[index].country;
  ///              }),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  ///
  /// See also:
  /// * [position], to set the position of the legend.
  final Axis direction;

  /// Positions the legend in the different directions.
  ///
  /// Defaults to [MapLegendPosition.top].
  ///
  /// ```dart
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          showLegend: true,
  ///          legendSettings: MapLegendSettings(
  ///              position: MapLegendPosition.bottom
  ///          ),
  ///          delegate: MapShapeLayerDelegate(
  ///              shapeFile: "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///              dataCount: bubbleData.length,
  ///              primaryValueMapper: (index) {
  ///                return bubbleData[index].country;
  ///              }),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  /// See also:
  /// * [offset], to place the legend in custom position.
  final MapLegendPosition position;

  /// Places the legend in custom position.
  ///
  /// If the [offset] has been set and if the
  /// [position] is top, then the legend will be placed in top but with
  /// absolute position i.e. legend will not take dedicated position for it and
  /// will be drawn on the top of map.
  ///
  /// ```dart
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          showLegend: true,
  ///          legendSettings: MapLegendSettings(
  ///             offset: Offset(0, 5)
  ///          ),
  ///          delegate: MapShapeLayerDelegate(
  ///              shapeFile: "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///              dataCount: bubbleData.length,
  ///              primaryValueMapper: (index) {
  ///                return bubbleData[index].country;
  ///              }),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  ///
  /// See also:
  /// * [position], to set the position of the legend.
  final Offset offset;

  /// Specifies the space between the each legend items.
  ///
  /// Defaults to 10.0.
  ///
  /// ```dart
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          showLegend: true,
  ///          legendSettings: MapLegendSettings(
  ///              itemsSpacing: 10
  ///          ),
  ///          delegate: MapShapeLayerDelegate(
  ///              shapeFile: "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///              dataCount: bubbleData.length,
  ///              primaryValueMapper: (index) {
  ///                return bubbleData[index].country;
  ///              }),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  final double itemsSpacing;

  /// Specifies the shape of the legend icon.
  ///
  /// Defaults to [MapIconType.circle].
  ///
  /// ```dart
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          showLegend: true,
  ///          legendSettings: MapLegendSettings(
  ///              iconType: MapIconType.square
  ///           ),
  ///          delegate: MapShapeLayerDelegate(
  ///              shapeFile: "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///              dataCount: bubbleData.length,
  ///              primaryValueMapper: (index) {
  ///                return bubbleData[index].country;
  ///              }),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  ///
  /// See also:
  /// * [showIcon], to show or hide the icon for the legend items.
  /// * [iconSize], to set the size of the icon.
  final MapIconType iconType;

  /// Customizes the legend item's text style.
  ///
  /// ```dart
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          showLegend: true,
  ///          legendSettings: MapLegendSettings(
  ///              textStyle: TextStyle(color: Colors.red)
  ///          ),
  ///          delegate: MapShapeLayerDelegate(
  ///              shapeFile: "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///              dataCount: bubbleData.length,
  ///              primaryValueMapper: (index) {
  ///                return bubbleData[index].country;
  ///              }),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  final TextStyle textStyle;

  /// Shows or hides the legend icons.
  ///
  /// Defaults to `true`.
  ///
  /// ```dart
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          showLegend: true,
  ///          legendSettings: MapLegendSettings(
  ///              showIcon: true
  ///          ),
  ///          delegate: MapShapeLayerDelegate(
  ///              shapeFile: "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///              dataCount: bubbleData.length,
  ///              primaryValueMapper: (index) {
  ///                return bubbleData[index].country;
  ///              }),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  ///
  /// See also:
  /// * [iconType], to set the icon type for the legend items.
  /// * [iconSize], to set size of the icons.
  final bool showIcon;

  /// Wraps or scrolls the legend items when it overflows.
  ///
  /// In wrap mode, overflowed items will be wrapped in a new row and will
  /// be positioned from the start.
  ///
  /// If the legend position is left or right, scroll direction is vertical.
  /// If the legend position is top or bottom, scroll direction is horizontal.
  ///
  /// Defaults to [MapLegendOverflowMode.wrap].
  ///
  /// ```dart
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          showLegend: true,
  ///          legendSettings: MapLegendSettings(
  ///              overflowMode: MapLegendOverflowMode.scroll
  ///          ),
  ///          delegate: MapShapeLayerDelegate(
  ///              shapeFile: "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///              dataCount: bubbleData.length,
  ///              primaryValueMapper: (index) {
  ///                return bubbleData[index].country;
  ///              }),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  ///
  /// See also:
  /// * [position], to set the position of the legend.
  /// * [direction], to set the direction of the legend.
  final MapLegendOverflowMode overflowMode;

  /// Customizes the size of the icon.
  ///
  /// Defaults to Size(12.0, 12.0).
  ///
  /// ```dart
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          showLegend: true,
  ///          legendSettings: MapLegendSettings(
  ///              iconSize: Size(30, 10)
  ///          ),
  ///          delegate: MapShapeLayerDelegate(
  ///              shapeFile: "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///              dataCount: bubbleData.length,
  ///              primaryValueMapper: (index) {
  ///                return bubbleData[index].country;
  ///              }),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  ///
  /// See also:
  /// * [showIcon], to show or hide the icon for the legend items.
  /// * [iconType], to set the size of the icon.
  final Size iconSize;

  /// Enables the toggle interaction for the legend.
  ///
  /// Defaults to false.
  ///
  /// When this is enabled, respective shape for the legend item will be
  ///  toggled on tap or click.
  ///
  /// ```dart
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          showLegend: true,
  ///          legendSettings: MapLegendSettings(
  ///              enableToggleInteraction: true
  ///          ),
  ///          delegate: MapShapeLayerDelegate(
  ///              shapeFile: "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///              dataCount: bubbleData.length,
  ///              primaryValueMapper: (index) {
  ///                return bubbleData[index].country;
  ///              }),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  final bool enableToggleInteraction;

  /// Fills the toggled legend item's icon and the respective shape or bubble
  /// by this color.
  ///
  /// This snippet shows how to set toggledItemColor in [SfMaps].
  ///
  /// ```dart
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          showLegend: true,
  ///          legendSettings: MapLegendSettings(
  ///              enableToggleInteraction: true,
  ///              toggledItemColor: Colors.blueGrey
  ///          ),
  ///          delegate: MapShapeLayerDelegate(
  ///              shapeFile: "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///              dataCount: bubbleData.length,
  ///              primaryValueMapper: (index) {
  ///                return bubbleData[index].country;
  ///              }),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  ///
  /// See also:
  /// * [toggledItemStrokeColor], [toggledItemStrokeWidth], to set the stroke
  /// for the toggled legend item's shape or bubble.
  final Color toggledItemColor;

  /// Stroke color for the toggled legend item's respective shape or bubble.
  ///
  /// ```dart
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          showLegend: true,
  ///          legendSettings: MapLegendSettings(
  ///              enableToggleInteraction: true,
  ///              toggledItemColor: Colors.blueGrey,
  ///              toggledItemStrokeColor: Colors.white,
  ///              toggledItemStrokeWidth: 0.5
  ///          ),
  ///          delegate: MapShapeLayerDelegate(
  ///              shapeFile: "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///              dataCount: bubbleData.length,
  ///              primaryValueMapper: (index) {
  ///                return bubbleData[index].country;
  ///              }),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  ///
  /// See also:
  /// * [toggledItemStrokeWidth], to set the stroke width for the
  /// toggled legend item's shape.
  final Color toggledItemStrokeColor;

  /// Stroke width for the toggled legend item's respective shape or
  /// bubble.
  ///
  /// Defaults to 1.0.
  ///
  /// This snippet shows how to set toggledItemStrokeWidth in [SfMaps].
  ///
  /// ```dart
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          showLegend: true,
  ///          legendSettings: MapLegendSettings(
  ///              enableToggleInteraction: true,
  ///              toggledItemColor: Colors.blueGrey,
  ///              toggledItemStrokeColor: Colors.white,
  ///              toggledItemStrokeWidth: 0.5
  ///          ),
  ///          delegate: MapShapeLayerDelegate(
  ///              shapeFile: "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///              dataCount: bubbleData.length,
  ///              primaryValueMapper: (index) {
  ///                return bubbleData[index].country;
  ///              }),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  ///
  /// See also:
  /// * [toggledItemStrokeColor], to set the stroke color for the
  /// toggled legend item's shape.
  final double toggledItemStrokeWidth;

  /// Sets the toggled legend item's respective shape or
  /// bubble opacity.
  ///
  /// Defaults to 1.0.
  ///
  /// This snippet shows how to set toggledItemOpacity in [SfMaps].
  ///
  /// ```dart
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          showLegend: true,
  ///          legendSettings: MapLegendSettings(
  ///              enableToggleInteraction: true,
  ///              toggledItemColor: Colors.blueGrey,
  ///              toggledItemStrokeColor: Colors.white,
  ///              toggledItemStrokeWidth: 0.5,
  ///              toggledItemOpacity: 0.5
  ///          ),
  ///          delegate: MapShapeLayerDelegate(
  ///              shapeFile: "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///              dataCount: bubbleData.length,
  ///              primaryValueMapper: (index) {
  ///                return bubbleData[index].country;
  ///              }),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  ///
  final double toggledItemOpacity;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is MapLegendSettings &&
        other.padding == padding &&
        other.offset == offset &&
        other.showIcon == showIcon &&
        other.enableToggleInteraction == enableToggleInteraction &&
        other.iconSize == iconSize &&
        other.iconType == iconType &&
        other.itemsSpacing == itemsSpacing &&
        other.direction == direction &&
        other.overflowMode == overflowMode &&
        other.position == position &&
        other.textStyle == textStyle &&
        other.toggledItemColor == toggledItemColor &&
        other.toggledItemStrokeColor == toggledItemStrokeColor &&
        other.toggledItemStrokeWidth == toggledItemStrokeWidth &&
        other.toggledItemOpacity == toggledItemOpacity;
  }

  @override
  int get hashCode => hashValues(
      padding,
      offset,
      showIcon,
      enableToggleInteraction,
      iconSize,
      iconType,
      itemsSpacing,
      direction,
      overflowMode,
      position,
      textStyle,
      toggledItemColor,
      toggledItemStrokeColor,
      toggledItemStrokeWidth,
      toggledItemOpacity);

  /// Creates a copy of this class but with the given fields
  /// replaced with the new values.
  MapLegendSettings _copyWith({
    Axis direction,
    EdgeInsetsGeometry padding,
    MapLegendPosition position,
    Offset offset,
    double itemsSpacing,
    MapIconType iconType,
    TextStyle textStyle,
    bool showIcon,
    Size iconSize,
    MapLegendOverflowMode overflowMode,
    bool enableToggleInteraction,
    Color toggledItemColor,
    Color toggledItemStrokeColor,
    double toggledItemStrokeWidth,
    double toggledItemOpacity,
  }) {
    return MapLegendSettings(
      direction: direction ?? this.direction,
      padding: padding ?? this.padding,
      position: position ?? this.position,
      offset: offset ?? this.offset,
      itemsSpacing: itemsSpacing ?? this.itemsSpacing,
      iconType: iconType ?? this.iconType,
      textStyle: textStyle ?? this.textStyle,
      showIcon: showIcon ?? this.showIcon,
      iconSize: iconSize ?? this.iconSize,
      overflowMode: overflowMode ?? this.overflowMode,
      enableToggleInteraction:
          enableToggleInteraction ?? this.enableToggleInteraction,
      toggledItemColor: toggledItemColor ?? this.toggledItemColor,
      toggledItemStrokeColor:
          toggledItemStrokeColor ?? this.toggledItemStrokeColor,
      toggledItemStrokeWidth:
          toggledItemStrokeWidth ?? this.toggledItemStrokeWidth,
      toggledItemOpacity: toggledItemOpacity ?? this.toggledItemOpacity,
    );
  }
}

/// Customizes the appearance of the data labels.
///
/// It is possible to customize the style of the data labels, hide or trim the
/// data labels when it exceeds their respective shapes.
///
/// ```dart
///  @override
///  Widget build(BuildContext context) {
///    return
///      SfMaps(
///        layers: [
///          MapShapeLayer(
///            dataLabelSettings:
///                MapDataLabelSettings(
///                    textStyle: TextStyle(color: Colors.red)
///                ),
///            delegate: MapShapeLayerDelegate(
///                showDataLabels: true,
///                shapeFile: "assets/world_map.json",
///                shapeDataField: "continent",
///                dataCount: bubbleData.length,
///                primaryValueMapper: (index) {
///                  return bubbleData[index].country;
///                }),
///          )
///        ],
///    );
///  }
/// ```
@immutable
class MapDataLabelSettings {
  /// Creates a [MapDataLabelSettings].
  const MapDataLabelSettings({
    this.textStyle,
    this.overflowMode = MapLabelOverflowMode.none,
  });

  /// Customizes the data label's text style.
  ///
  /// This snippet shows how to set [textStyle] for the data labels in [SfMaps].
  ///
  /// ```dart
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return
  ///      SfMaps(
  ///        layers: [
  ///          MapShapeLayer(
  ///            dataLabelSettings:
  ///                MapDataLabelSettings(
  ///                    textStyle: TextStyle(color: Colors.red)
  ///                ),
  ///            delegate: MapShapeLayerDelegate(
  ///                showDataLabels: true,
  ///                shapeFile: "assets/world_map.json",
  ///                shapeDataField: "continent",
  ///                dataCount: bubbleData.length,
  ///                primaryValueMapper: (index) {
  ///                  return bubbleData[index].country;
  ///                }),
  ///          )
  ///        ],
  ///    );
  ///  }
  /// ```
  final TextStyle textStyle;

  /// Trim or removes the data label when it is overflowed from the shape.
  ///
  /// Defaults to [MapLabelOverflowMode.none].
  ///
  /// By default, the data labels will render even if it overflows form the
  /// shape. Using this property, it is possible to remove or trim the data
  /// labels based on the available space.
  ///
  /// This snippet shows how to set the [overflowMode] for the data labels in
  /// [SfMaps].
  ///
  /// ```dart
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return
  ///      SfMaps(
  ///        layers: [
  ///          MapShapeLayer(
  ///            dataLabelSettings:
  ///                MapDataLabelSettings(
  ///                    overflowMode: MapLabelOverflowMode.hide
  ///                ),
  ///            delegate: MapShapeLayerDelegate(
  ///                showDataLabels: true,
  ///                shapeFile: "assets/world_map.json",
  ///                shapeDataField: "continent",
  ///                dataCount: bubbleData.length,
  ///                primaryValueMapper: (index) {
  ///                  return bubbleData[index].country;
  ///                }),
  ///          )
  ///        ],
  ///    );
  ///  }
  /// ```
  final MapLabelOverflowMode overflowMode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is MapDataLabelSettings &&
        other.textStyle == textStyle &&
        other.overflowMode == overflowMode;
  }

  @override
  int get hashCode => hashValues(textStyle, overflowMode);
}

/// Customizes the appearance of the bubbles.
///
/// It is possible to customize the radius, color, opacity and stroke of the
/// bubbles.
///
/// ```dart
///  @override
///  Widget build(BuildContext context) {
///    return
///      SfMaps(
///        layers: [
///          MapShapeLayer(
///            bubbleSettings: MapBubbleSettings(maxRadius: 10, minRadius: 2),
///            delegate: MapShapeLayerDelegate(
///                shapeFile: "assets/world_map.json",
///                shapeDataField: "name",
///                showBubbles: true,
///                dataCount: bubbleData.length,
///                primaryValueMapper: (index) {
///                  return bubbleData[index].country;
///                },
///                bubbleSizeMapper: (index) {
///                  return bubbleData[index].usersCount;
///                }),
///        )
///      ],
///    );
///  }
/// ```
@immutable
class MapBubbleSettings {
  /// Creates a [MapBubbleSettings].
  const MapBubbleSettings({
    this.minRadius = 10.0,
    this.maxRadius = 50.0,
    this.color,
    this.opacity = 0.75,
    this.strokeWidth,
    this.strokeColor,
  });

  /// Minimum radius of the bubble.
  ///
  /// The radius of the bubble depends on the value returned in the
  /// [MapShapeLayerDelegate.bubbleSizeMapper]. From all the returned values,
  /// the lowest value will have [minRadius] and the highest value will have
  /// [maxRadius].
  ///
  /// ```dart
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return
  ///      SfMaps(
  ///        layers: [
  ///          MapShapeLayer(
  ///            bubbleSettings: MapBubbleSettings(maxRadius: 10, minRadius: 2),
  ///            delegate: MapShapeLayerDelegate(
  ///                shapeFile: "assets/world_map.json",
  ///                shapeDataField: "name",
  ///                showBubbles: true,
  ///                dataCount: bubbleData.length,
  ///                primaryValueMapper: (index) {
  ///                  return bubbleData[index].country;
  ///                },
  ///                bubbleSizeMapper: (index) {
  ///                  return bubbleData[index].usersCount;
  ///                }),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  final double minRadius;

  /// Maximum radius of the bubble.
  ///
  /// The radius of the bubble depends on the value returned in the
  /// [MapShapeLayerDelegate.bubbleSizeMapper]. From all the returned values,
  /// the lowest value will have [minRadius] and the highest value will have
  /// [maxRadius].
  ///
  /// ```dart
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return
  ///      SfMaps(
  ///        layers: [
  ///          MapShapeLayer(
  ///            bubbleSettings: MapBubbleSettings(maxRadius: 10, minRadius: 2),
  ///            delegate: MapShapeLayerDelegate(
  ///                shapeFile: "assets/world_map.json",
  ///                shapeDataField: "name",
  ///                showBubbles: true,
  ///                dataCount: bubbleData.length,
  ///                primaryValueMapper: (index) {
  ///                  return bubbleData[index].country;
  ///                },
  ///                bubbleSizeMapper: (index) {
  ///                  return bubbleData[index].usersCount;
  ///                }),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  final double maxRadius;

  /// Default color of the bubbles.
  ///
  /// ```dart
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return
  ///      SfMaps(
  ///        layers: [
  ///          MapShapeLayer(
  ///          bubbleSettings: MapBubbleSettings(
  ///              color: Colors.black),
  ///          delegate: MapShapeLayerDelegate(
  ///              shapeFile: "assets/world_map.json",
  ///              shapeDataField: "name",
  ///              showBubbles: true,
  ///              dataCount: bubbleData.length,
  ///              primaryValueMapper: (index) {
  ///                return bubbleData[index].country;
  ///              },
  ///              bubbleSizeMapper: (index) {
  ///                 return bubbleData[index].usersCount;
  ///              }),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  ///
  /// See also:
  /// * [MapShapeLayerDelegate.bubbleColorMappers] and
  /// [MapShapeLayerDelegate.bubbleColorValueMapper], to customize the bubble
  /// colors based on the data.
  final Color color;

  /// Opacity of the bubbles.
  ///
  /// ```dart
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return
  ///      SfMaps(
  ///        layers: [
  ///          MapShapeLayer(
  ///          bubbleSettings: MapBubbleSettings(
  ///              opacity: 0.5),
  ///          delegate: MapShapeLayerDelegate(
  ///              shapeFile: "assets/world_map.json",
  ///              shapeDataField: "name",
  ///              showBubbles: true,
  ///              dataCount: bubbleData.length,
  ///              primaryValueMapper: (index) {
  ///                return bubbleData[index].country;
  ///              },
  ///              bubbleSizeMapper: (index) {
  ///                 return bubbleData[index].usersCount;
  ///              }),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  final double opacity;

  /// Stroke width of the bubbles.
  ///
  /// ```dart
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return
  ///      SfMaps(
  ///        layers: [
  ///          MapShapeLayer(
  ///          bubbleSettings: MapBubbleSettings(
  ///              strokeColor: Colors.red,
  ///              strokeWidth: 2),
  ///          delegate: MapShapeLayerDelegate(
  ///              shapeFile: "assets/world_map.json",
  ///              shapeDataField: "name",
  ///              showBubbles: true,
  ///              dataCount: bubbleData.length,
  ///              primaryValueMapper: (index) {
  ///                return bubbleData[index].country;
  ///              },
  ///              bubbleSizeMapper: (index) {
  ///                 return bubbleData[index].usersCount;
  ///              }),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  ///
  /// See also:
  /// * [strokeColor], to set the stroke color.
  final double strokeWidth;

  /// Stroke color of the bubbles.
  ///
  /// ```dart
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return
  ///      SfMaps(
  ///        layers: [
  ///          MapShapeLayer(
  ///          bubbleSettings: MapBubbleSettings(
  ///              strokeColor: Colors.red,
  ///              strokeWidth: 2),
  ///          delegate: MapShapeLayerDelegate(
  ///              shapeFile: "assets/world_map.json",
  ///              shapeDataField: "name",
  ///              showBubbles: true,
  ///              dataCount: bubbleData.length,
  ///              primaryValueMapper: (index) {
  ///                return bubbleData[index].country;
  ///              },
  ///              bubbleSizeMapper: (index) {
  ///                 return bubbleData[index].usersCount;
  ///              }),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  ///
  /// See also:
  /// * [strokeWidth], to set the stroke width.
  final Color strokeColor;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is MapBubbleSettings &&
        other.color == color &&
        other.strokeWidth == strokeWidth &&
        other.strokeColor == strokeColor &&
        other.minRadius == minRadius &&
        other.maxRadius == maxRadius &&
        other.opacity == opacity;
  }

  @override
  int get hashCode => hashValues(
      color, strokeWidth, strokeColor, maxRadius, minRadius, opacity);

  /// Creates a copy of this class but with the given fields
  /// replaced with the new values.
  MapBubbleSettings _copyWith({
    double minRadius,
    double maxRadius,
    Color color,
    double opacity,
    double strokeWidth,
    Color strokeColor,
  }) {
    return MapBubbleSettings(
      minRadius: minRadius ?? this.minRadius,
      maxRadius: maxRadius ?? this.maxRadius,
      color: color ?? this.color,
      opacity: opacity ?? this.opacity,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      strokeColor: strokeColor ?? this.strokeColor,
    );
  }
}

/// Customizes the appearance of the selected shape.
///
/// ```dart
///   @override
///  Widget build(BuildContext context) {
///    return SfMaps(
///      layers: [
///        MapShapeLayer(
///          enableSelection: true,
///          selectionSettings: MapSelectionSettings(
///              color: Colors.black
///          ),
///          delegate: MapShapeLayerDelegate(
///              shapeFile: "assets/world_map.json",
///              shapeDataField: "name",
///              dataCount: bubbleData.length,
///              primaryValueMapper: (index) {
///                return bubbleData[index].country;
///              }),
///        )
///      ],
///    );
///  }
/// ```
@immutable
class MapSelectionSettings {
  /// Creates a [MapSelectionSettings].
  const MapSelectionSettings(
      {this.color, this.strokeColor, this.strokeWidth, this.opacity = 1.0});

  /// Fills the selected shape by this color.
  ///
  /// This snippet shows how to set selection color in [SfMaps].
  ///
  /// ```dart
  ///   @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          enableSelection: true,
  ///          selectionSettings: MapSelectionSettings(
  ///              color: Colors.black
  ///          ),
  ///          delegate: MapShapeLayerDelegate(
  ///              shapeFile: "assets/world_map.json",
  ///              shapeDataField: "name",
  ///              dataCount: bubbleData.length,
  ///              primaryValueMapper: (index) {
  ///                return bubbleData[index].country;
  ///              }),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  /// See also:
  /// * [strokeColor], to set stroke color for selected shape.
  final Color color;

  /// Applies stroke color for the selected shape.
  ///
  /// This snippet shows how to set stroke color for the selected shape.
  ///
  /// ```dart
  ///   @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          enableSelection: true,
  ///          selectionSettings: MapSelectionSettings(
  ///              strokeColor: Colors.white
  ///          ),
  ///          delegate: MapShapeLayerDelegate(
  ///              shapeFile: "assets/world_map.json",
  ///              shapeDataField: "name",
  ///              dataCount: bubbleData.length,
  ///              primaryValueMapper: (index) {
  ///                return bubbleData[index].country;
  ///              }),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  /// See also:
  /// * [Color], to set selected shape color.
  final Color strokeColor;

  /// Stroke width which applies to the selected shape.
  ///
  /// This snippet shows how to set stroke width for the selected shape.
  ///
  /// ```dart
  ///   @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          enableSelection: true,
  ///          selectionSettings: MapSelectionSettings(
  ///              strokeWidth: 2
  ///          ),
  ///          delegate: MapShapeLayerDelegate(
  ///              shapeFile: "assets/world_map.json",
  ///              shapeDataField: "name",
  ///              dataCount: bubbleData.length,
  ///              primaryValueMapper: (index) {
  ///                return bubbleData[index].country;
  ///              }),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  final double strokeWidth;

  /// Specifies the opacity of the selected shape.
  ///
  /// This snippet shows how to set opacity of the selected shape.
  ///
  /// ```dart
  ///   @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          enableSelection: true,
  ///          selectionSettings: MapSelectionSettings(
  ///              opacity: 0.5
  ///          ),
  ///          delegate: MapShapeLayerDelegate(
  ///              shapeFile: "assets/world_map.json",
  ///              shapeDataField: "name",
  ///              dataCount: bubbleData.length,
  ///              primaryValueMapper: (index) {
  ///                return bubbleData[index].country;
  ///              }),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  final double opacity;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is MapSelectionSettings &&
        other.color == color &&
        other.strokeWidth == strokeWidth &&
        other.strokeColor == strokeColor &&
        other.opacity == opacity;
  }

  @override
  int get hashCode => hashValues(color, strokeWidth, strokeColor, opacity);
}

/// Customizes the appearance of the bubble's or shape's tooltip.
///
/// ```dart
///  @override
///  Widget build(BuildContext context) {
///    return SfMaps(
///      layers: [
///        MapShapeLayer(
///          enableShapeTooltip: true,
///          tooltipSettings: MapTooltipSettings(
///              color: Colors.black
///          ),
///          delegate: MapShapeLayerDelegate(
///              shapeFile: "assets/world_map.json",
///              shapeDataField: "continent",
///              dataCount: bubbleData.length,
///              primaryValueMapper: (index) {
///                return bubbleData[index].country;
///              }),
///        )
///      ],
///    );
///  }
/// ```
///
/// See also:
/// * [MapShapeLayerDelegate.shapeTooltipTextMapper], for customizing the
/// tooltip text.
/// * [MapShapeLayer.shapeTooltipBuilder], for showing the completely
/// customized widget inside the tooltip.
@immutable
class MapTooltipSettings {
  /// Creates a [MapTooltipSettings].
  const MapTooltipSettings({
    this.color,
    this.textStyle,
    this.strokeWidth,
    this.strokeColor,
  });

  /// Fills the tooltip by this color.
  ///
  /// This snippet shows how to set the tooltip color in [SfMaps].
  ///
  /// ```dart
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          enableShapeTooltip: true,
  ///          tooltipSettings: MapTooltipSettings(
  ///              color: Colors.black
  ///          ),
  ///          delegate: MapShapeLayerDelegate(
  ///              shapeFile: "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///              dataCount: bubbleData.length,
  ///              primaryValueMapper: (index) {
  ///                return bubbleData[index].country;
  ///              }),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  /// See also:
  /// * [textStyle], for customizing the style of the tooltip text.
  final Color color;

  /// Customizes the tooltip text's style.
  ///
  /// This snippet shows how to customize the tooltip text style in [SfMaps].
  ///
  /// ```dart
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          enableShapeTooltip: true,
  ///          tooltipSettings: MapTooltipSettings(
  ///              textStyle: TextStyle(color: Colors.red)
  ///          ),
  ///          delegate: MapShapeLayerDelegate(
  ///              shapeFile: "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///              dataCount: bubbleData.length,
  ///              primaryValueMapper: (index) {
  ///                return bubbleData[index].country;
  ///              }),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  final TextStyle textStyle;

  /// Specifies the stroke width applies to the tooltip.
  ///
  /// This snippet shows how to customize the stroke width in [SfMaps].
  ///
  /// ```dart
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          enableShapeTooltip: true,
  ///          tooltipSettings: MapTooltipSettings(
  ///              strokeWidth: 2
  ///          ),
  ///          delegate: MapShapeLayerDelegate(
  ///              shapeFile: "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///              dataCount: bubbleData.length,
  ///              primaryValueMapper: (index) {
  ///                return bubbleData[index].country;
  ///              }),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  /// See also:
  /// * [strokeColor], for customizing the stroke color of the tooltip.
  final double strokeWidth;

  /// Specifies the stroke color applies to the tooltip.
  ///
  /// This snippet shows how to customize stroke color in [SfMaps].
  ///
  /// ```dart
  ///  @override
  ///  Widget build(BuildContext context) {
  ///    return SfMaps(
  ///      layers: [
  ///        MapShapeLayer(
  ///          enableShapeTooltip: true,
  ///          tooltipSettings: MapTooltipSettings(
  ///              strokeColor: Colors.white
  ///          ),
  ///          delegate: MapShapeLayerDelegate(
  ///              shapeFile: "assets/world_map.json",
  ///              shapeDataField: "continent",
  ///              dataCount: bubbleData.length,
  ///              primaryValueMapper: (index) {
  ///                return bubbleData[index].country;
  ///              }),
  ///        )
  ///      ],
  ///    );
  ///  }
  /// ```
  ///
  /// See also:
  /// * [strokeWidth] for customizing the stroke width of the tooltip.
  final Color strokeColor;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is MapTooltipSettings &&
        other.color == color &&
        other.strokeWidth == strokeWidth &&
        other.strokeColor == strokeColor &&
        other.textStyle == textStyle;
  }

  @override
  int get hashCode => hashValues(color, strokeWidth, strokeColor, textStyle);
}

/// Provides options for customizing the appearance of the toolbar in the web
/// platform.
class MapToolbarSettings {
  /// Creates a [MapToolbarSettings].
  const MapToolbarSettings({
    this.iconColor,
    this.itemBackgroundColor,
    this.itemHoverColor,
    this.direction = Axis.horizontal,
    this.position = MapToolbarPosition.topRight,
  });

  /// Specifies the color applies to the tooltip icons.
  final Color iconColor;

  /// Specifies the color applies to the tooltip icon's background.
  final Color itemBackgroundColor;

  /// Specifies the color applies to the tooltip icon's background on hovering.
  final Color itemHoverColor;

  /// Arranges the toolbar items in either horizontal or vertical direction.
  ///
  /// Defaults to [Axis.horizontal].
  final Axis direction;

  /// Option to position the toolbar in all the corners of the maps.
  ///
  /// Defaults to [MapToolbarPosition.topRight].
  final MapToolbarPosition position;
}

/// Creating MapModel class for adding map data in it.
class _MapModel {
  _MapModel({
    this.primaryKey,
    this.pixelPoints,
    this.rawPoints,
    this.actualIndex,
    this.dataIndex,
    this.legendMapperIndex,
    this.shapePath,
    this.isSelected = false,
    this.shapeColor,
    this.dataLabelText,
    this.visibleDataLabelText,
    this.bubbleColor,
    this.bubbleSizeValue,
    this.bubbleRadius,
    this.bubblePath,
    this.tooltipText,
  });

  /// Contains [sourceDataPath] values.
  final String primaryKey;

  /// Contains pixel points.
  List<List<Offset>> pixelPoints;

  /// Contains coordinate points.
  final List<List<dynamic>> rawPoints;

  /// Contains data Source index.
  int dataIndex;

  /// Contains the shape path.
  Path shapePath;

  /// Option to select the particular shape
  /// based on the position of the tap or click.
  ///
  /// Returns `true` when the shape is selected else it will be `false`.
  ///
  /// See also:
  /// * [MapSelectionSettings] option to customize the shape selection.
  bool isSelected = false;

  /// Contains data source color.
  Color shapeColor;

  /// Contains the actual shape color value.
  dynamic shapeColorValue;

  /// Contains data source Label text.
  String dataLabelText;

  /// Use this text while zooming.
  String visibleDataLabelText;

  /// Specifies an item index in the data source list.
  int actualIndex;

  /// Contains the index of the shape or bubble legend.
  int legendMapperIndex;

  /// Contains data source bubble color.
  Color bubbleColor;

  /// Contains data source bubble size.
  double bubbleSizeValue;

  /// Contains data source bubble radius.
  double bubbleRadius;

  /// Contains the bubble path.
  Path bubblePath;

  /// Contains the tooltip text.
  String tooltipText;

  // Center of shape path which is used to position the data labels.
  Offset shapePathCenter;

  // Width for smart position the data labels.
  double shapeWidth;

  void reset() {
    dataIndex = null;
    dataLabelText = null;
    shapeColor = null;
    shapeColorValue = null;
    bubbleColor = null;
    bubbleRadius = null;
    bubblePath = null;
    bubbleSizeValue = null;
    isSelected = false;
    tooltipText = null;
  }
}

class _ShapeBounds {
  _ShapeBounds(
      {this.minLongitude,
      this.minLatitude,
      this.maxLongitude,
      this.maxLatitude});

  num minLongitude;

  num minLatitude;

  num maxLongitude;

  num maxLatitude;

  _ShapeBounds get empty => _ShapeBounds(
      minLongitude: null,
      minLatitude: null,
      maxLongitude: null,
      maxLatitude: null);
}

class _ShapeFileData {
  Map<String, dynamic> decodedJsonData;

  Map<String, _MapModel> source;

  _ShapeBounds bounds;

  void reset() {
    decodedJsonData?.clear();
    source?.clear();
    bounds = bounds?.empty;
  }
}

class _ShapeLayerChildRenderBoxBase extends RenderProxyBox {
  // Invoked when a pointer has stopped,
  // contacting the screen at a particular location.
  void onTap(Offset position, {_MapModel model, _Layer layer}) {
    // Override it, if the child of _ShapeLayer need to handle tap event.
  }

  // Invoked when a mouse pointer has moved onto or within the region,
  // without buttons pressed.
  void onHover(Offset position, {_MapModel model, _Layer layer}) {
    // Override it, if the child of _ShapeLayer need to handle hover event.
  }

  /// Invoked when a mouse pointer has exited from the region.
  void onExit() {
    // Override it, if the child of _ShapeLayer need to handle exit event.
  }

  void refresh() {
    // Override it, if the child of _ShapeLayer need to handle end interaction.
  }
}
