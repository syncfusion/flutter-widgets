part of maps;

///Base class for the [MapShapeLayer].
///
/// See also:
/// * [MapShapeLayer], for adding in [SfMaps.layers].
abstract class MapLayer extends StatelessWidget {
  /// Creates a [MapLayer].
  const MapLayer({
    Key key,
    this.initialMarkersCount,
    this.markerBuilder,
    this.zoomPanBehavior,
    this.onWillZoom,
    this.onWillPan,
  }) : super(key: key);

  /// Option to set markers count initially. It cannot be be updated
  /// dynamically.
  ///
  /// The [MapLayer.markerBuilder] callback will be called number of times equal
  /// to the value specified in the [MapLayer.initialMarkersCount] property.
  /// The default value of the of this property is null.
  ///
  /// See also:
  /// * [markerBuilder], for returning the [MapMarker].
  /// * [MapShapeLayer.controller], for dynamically updating the markers
  /// collection.
  final int initialMarkersCount;

  /// Returns the [MapMarker] for the given index.
  ///
  /// Markers which be used to denote the locations on the map.
  ///
  /// It is possible to use the built-in symbols or display a custom widget at a
  /// specific latitude and longitude on a map.
  ///
  /// The [MapLayer.markerBuilder] callback will be called number of times equal
  /// to the value specified in the [MapLayer.initialMarkersCount] property.
  /// The default value of the of this property is null.
  ///
  /// For rendering the custom widget for the marker, pass the required widget
  /// for child in [MapMarker] constructor.
  ///
  /// ```dart
  /// List<Model> data;
  ///
  /// @override
  /// void initState() {
  ///    data = const <Model>[
  ///      Model('Brazil', -14.235004, -51.92528),
  ///      Model('Germany', 51.16569, 10.451526),
  ///      Model('Australia', -25.274398, 133.775136),
  ///      Model('India', 20.593684, 78.96288),
  ///      Model('Russia', 61.52401, 105.318756)
  ///    ];
  ///
  ///    super.initState();
  /// }
  ///
  ///  @override
  /// Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      body: Center(
  ///          child: Container(
  ///            height: 350,
  ///            child: Padding(
  ///              padding: EdgeInsets.only(left: 15, right: 15),
  ///              child: SfMaps(
  ///                layers: <MapLayer>[
  ///                  MapShapeLayer(
  ///                    delegate: MapShapeLayerDelegate(
  ///                      shapeFile: 'assets/world_map.json',
  ///                      shapeDataField: 'name',
  ///                      dataCount: data.length,
  ///                      primaryValueMapper: (index) => data[index].country,
  ///                    ),
  ///                    initialMarkersCount: 5,
  ///                    markerBuilder: (BuildContext context, int index){
  ///                      return MapMarker(
  ///                        latitude: data[index].latitude,
  ///                        longitude: data[index].longitude,
  ///                      );
  ///                    },
  ///                  ),
  ///                ],
  ///              ),
  ///            ),
  ///          )
  ///      ),
  ///    );
  ///  }
  ///
  /// class Model {
  ///  const Model(this.country, this.latitude, this.longitude);
  ///
  ///  final String country;
  ///  final double latitude;
  ///  final double longitude;
  /// }
  /// ```
  /// See also:
  /// * [MapShapeLayerController], for dynamically updating the markers.
  /// * [MapMarker], to create a map marker.
  final MapMarkerBuilder markerBuilder;

  /// Enables zooming and panning in [MapShapeLayer] and [MapTileLayer].
  ///
  /// Zooming and panning will start working when the new instance of
  /// [MapZoomPanBehavior] is set to [MapShapeLayer.zoomPanBehavior]. However,
  /// if you need to restrict pinch zooming or panning for any specific
  /// requirements, you can set the [MapZoomPanBehavior.enablePinching] and
  /// [MapZoomPanBehavior.enablePanning] properties to false respectively.
  ///
  /// The [MapZoomPanBehavior.focalLatLng] is the focal point of the map layer
  /// based on which zooming happens.
  ///
  /// The default [MapZoomPanBehavior.zoomLevel] value is 1 which will show the
  /// whole map in the viewport for [MapShapeLayer] and the possible bounds for
  /// the [MapTileLayer] based on the [MapZoomPanBehavior.focalLatLng]
  /// (Please check the documentation
  /// of [MapTileLayer] to know more details about how
  /// [MapZoomPanBehavior.zoomLevel] works in it).
  ///
  /// You can also get the current zoom level and focal position of the
  /// map layer using the [MapZoomPanBehavior.zoomLevel] and
  /// [MapZoomPanBehavior.focalLatLng] after the interaction.
  ///
  /// The minimum and maximum zooming levels can be restricted using the
  /// [MapZoomPanBehavior.minZoomLevel] and [MapZoomPanBehavior.maxZoomLevel]
  /// properties respectively. The default values of
  /// [MapZoomPanBehavior.minZoomLevel] and [MapZoomPanBehavior.maxZoomLevel]
  /// are 0 and 15 respectively. However, for [MapTileLayer],
  /// the [MapZoomPanBehavior.maxZoomLevel] may slightly vary depends
  /// on the providers. Kindly check the respective official website of the map
  /// tile providers to know about the maximum zoom level it supports.
  ///
  /// Toolbar with the the options for changing the visible bound for the web
  /// platform will be enabled by default. However, you can use the
  /// [MapZoomPanBehavior.showToolbar] property to changes its visibility.
  ///
  /// The procedure and the behavior are similar for both the [MapShapeLayer]
  /// and [MapTileLayer].
  ///
  /// ```dart
  ///   MapZoomPanBehavior _zoomPanBehavior;
  ///
  ///   @override
  ///   void initState() {
  ///     _zoomPanBehavior = MapZoomPanBehavior()
  ///       ..zoomLevel = 4
  ///       ..focalLatLng = MapLatLng(19.0759837, 72.8776559);
  ///     super.initState();
  ///   }
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///       appBar: AppBar(
  ///         title: Text('Zoom pan'),
  ///       ),
  ///       body: SfMaps(
  ///         layers: [
  ///           MapShapeLayer(
  ///             delegate: MapShapeLayerDelegate(
  ///               shapeFile: 'assets/world_map.json',
  ///               shapeDataField: 'continent',
  ///             ),
  ///             zoomPanBehavior: _zoomPanBehavior,
  ///           ),
  ///         ],
  ///       ),
  ///     );
  ///   }
  /// ```
  final MapZoomPanBehavior zoomPanBehavior;

  /// Called whenever zooming is happening.
  ///
  /// If it returns false, zooming will not happen.
  ///
  /// [MapZoomDetails] contains following properties.
  ///  * [MapZoomDetails.previousVisibleBounds] - provides the visible bounds
  ///   before the current zooming operation completes i.e. current visible
  ///   bounds.
  ///  * [MapZoomDetails.newVisibleBounds] - provides the new visible bounds
  ///   when the current zoom completes. Hence, if it returns false,
  ///   there will be no changes in the UI.
  ///  * [MapZoomDetails.previousZoomLevel] - provides the zoom level
  ///   before the current zooming operation completes i.e. current zoom
  ///   level.
  ///  * [MapZoomDetails.newZoomLevel] - provides the new zoom level
  ///   when the current zoom completes. Hence, if it returns false, there will
  ///   be no changes in the UI.
  ///  * [MapZoomDetails.globalFocalPoint] - The global focal point of the
  ///  pointers in contact with the screen.
  ///  * [MapZoomDetails.localFocalPoint] - The local focal point of the
  ///   pointers in contact with the screen.
  final WillZoomCallback onWillZoom;

  /// Called whenever panning is happening.
  ///
  /// If it returns false, panning will not happen.
  ///
  /// [MapPanDetails] contains following properties.
  ///  * [MapPanDetails.previousVisibleBounds] - provides the visible bounds
  ///   before the current panning operation completes i.e. current visible
  ///   bounds.
  ///  * [MapPanDetails.newVisibleBounds] - provides the new visible bounds
  ///   when the current pan completes. Hence, if it returns false,
  ///   there will be no changes in the UI.
  ///  * [MapPanDetails.zoomLevel] - provides the current zoom level.
  ///  * [MapPanDetails.delta] - The difference in pixels between touch start
  ///  and current touch position.
  ///  * [MapPanDetails.globalFocalPoint] - The global focal point of the
  ///  pointers in contact with the screen.
  ///  * [MapPanDetails.localFocalPoint] - The local focal point of the
  ///   pointers in contact with the screen.
  final WillPanCallback onWillPan;
}

/// The shape layer in which geographical rendering is done.
///
/// The actual geographical rendering is done here using the
/// [MapShapeLayer.delegate]. The path of the .json file which contains the
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
/// The snippet below shows how to render the basic world map using the data
/// from .json file.
///
/// ```dart
///   @override
///  Widget build(BuildContext context) {
///    return SfMaps(
///      layers: [
///        MapShapeLayer(
///          delegate: MapShapeLayerDelegate(
///              shapeFile: "assets/world_map.json",
///              shapeDataField: "name",
///           ),
///        )
///      ],
///    );
///  }
/// ```
/// See also:
/// * [delegate], to provide data for the elements of the [SfMaps] like data
/// labels, bubbles, tooltip, shape colors, and legend.
class MapShapeLayer extends MapLayer {
  /// Creates a [MapShapeLayer].
  const MapShapeLayer({
    Key key,
    @required this.delegate,
    this.loadingBuilder,
    this.controller,
    int initialMarkersCount = 0,
    MapMarkerBuilder markerBuilder,
    this.shapeTooltipBuilder,
    this.bubbleTooltipBuilder,
    this.showDataLabels = false,
    this.showBubbles = false,
    this.enableShapeTooltip = false,
    this.enableBubbleTooltip = false,
    this.enableSelection = false,
    this.color,
    this.strokeColor,
    this.strokeWidth,
    this.palette,
    this.legendSource = MapElement.none,
    this.legendSettings = const MapLegendSettings(),
    this.dataLabelSettings = const MapDataLabelSettings(),
    this.bubbleSettings = const MapBubbleSettings(),
    this.selectionSettings = const MapSelectionSettings(),
    this.tooltipSettings = const MapTooltipSettings(),
    this.initialSelectedIndex = -1,
    MapZoomPanBehavior zoomPanBehavior,
    this.onSelectionChanged,
    WillZoomCallback onWillZoom,
    WillPanCallback onWillPan,
  }) : super(
          key: key,
          initialMarkersCount: initialMarkersCount,
          markerBuilder: markerBuilder,
          zoomPanBehavior: zoomPanBehavior,
          onWillZoom: onWillZoom,
          onWillPan: onWillPan,
        );

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
  final MapShapeLayerDelegate delegate;

  /// A builder that specifies the widget to display to the user while the
  /// map is still loading.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///      body: Padding(
  ///        padding: EdgeInsets.all(15),
  ///        child: SfMaps(
  ///          layers: <MapLayer>[
  ///            MapShapeLayer(
  ///              delegate: MapShapeLayerDelegate(
  ///                shapeFile: 'assets/world_map.json',
  ///                shapeDataField: 'continent',
  ///              ),
  ///              loadingBuilder: (BuildContext context) {
  ///                return Container(
  ///                  height: 25,
  ///                  width: 25,
  ///                  child: const CircularProgressIndicator(
  ///                    strokeWidth: 3,
  ///                  ),
  ///                );
  ///              },
  ///            ),
  ///          ],
  ///        ),
  ///      ),
  ///   );
  /// }
  /// ```
  final MapLoadingBuilder loadingBuilder;

  /// Returns a widget for the shape tooltip based on the index.
  ///
  /// A shape tooltip displays additional information about
  /// the shapes on a map. To enable tooltip for the shape, set
  /// [MapShapeLayer.enableShapeTooltip] to `true`. By default, the text
  /// returned in the [MapShapeLayerDelegate.shapeTooltipTextMapper] will be
  /// shown in the tooltip. The [MapShapeLayer.shapeTooltipBuilder] can be used
  /// to return a completely customized widget. This widget will then be wrapped
  /// in the existing tooltip shape which comes with the nose at the bottom. It
  /// is still possible to customize the stroke appearance using the
  /// [MapTooltipSettings.strokeColor] and [MapTooltipSettings.strokeWidth]. To
  /// customize the corners, use [SfMapsThemeData.tooltipBorderRadius].
  ///
  /// The [MapShapeLayer.shapeTooltipBuilder] callback will be called when the
  /// user interacts with the shapes.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///      body: Padding(
  ///        padding: EdgeInsets.all(15),
  ///        child: SfMaps(
  ///          layers: <MapLayer>[
  ///            MapShapeLayer(
  ///              delegate: MapShapeLayerDelegate(
  ///                shapeFile: 'assets/world_map.json',
  ///                shapeDataField: 'continent',
  ///                dataCount: worldMapData.length,
  ///                primaryValueMapper: (index) =>
  ///                             worldMapData[index].primaryKey,
  ///              ),
  ///              shapeTooltipBuilder: (BuildContext context, int index) {
  ///                if(index == 0) {
  ///                  return Container(
  ///                    child: Icon(Icons.airplanemode_inactive),
  ///                  );
  ///                }
  ///                else
  ///                {
  ///                  return Container(
  ///                       child: Icon(Icons.airplanemode_active),
  ///                  );
  ///                }
  ///              },
  ///              enableShapeTooltip: true,
  ///            ),
  ///          ],
  ///        ),
  ///      ),
  ///   );
  /// }
  /// ```
  final IndexedWidgetBuilder shapeTooltipBuilder;

  /// Returns a widget for the bubble tooltip based on the index.
  ///
  /// A bubble tooltip displays additional information about
  /// the bubble on a map. To enable tooltip for the bubble, set
  /// [MapShapeLayer.enableBubbleTooltip] to `true`. By default, the text
  /// returned in the [MapShapeLayerDelegate.bubbleTooltipTextMapper] will be
  /// shown in the tooltip. The [MapShapeLayer.bubbleTooltipBuilder] can be used
  /// to return a completely customized widget. This widget will then be wrapped
  /// in the existing tooltip shape which comes with the nose at the bottom. It
  /// is still possible to customize the stroke appearance using the
  /// [MapTooltipSettings.strokeColor] and [MapTooltipSettings.strokeWidth]. To
  /// customize the corners, use [SfMapsThemeData.tooltipBorderRadius].
  ///
  /// The [MapShapeLayer.bubbleTooltipBuilder] callback will be called when the
  /// user interacts with the bubbles.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///   return Scaffold(
  ///      body: Padding(
  ///        padding: EdgeInsets.all(15),
  ///        child: SfMaps(
  ///          layers: <MapLayer>[
  ///            MapShapeLayer(
  ///              delegate: MapShapeLayerDelegate(
  ///                shapeFile: 'assets/world_map.json',
  ///                shapeDataField: 'continent',
  ///                dataCount: worldMapData.length,
  ///                primaryValueMapper: (index) =>
  ///                             worldMapData[index].primaryKey,
  ///              ),
  ///              bubbleTooltipBuilder: (BuildContext context, int index) {
  ///                if(index == 0) {
  ///                  return Container(
  ///                    child: Icon(Icons.airplanemode_inactive),
  ///                  );
  ///                }
  ///                else
  ///                {
  ///                  return Container(
  ///                       child: Icon(Icons.airplanemode_active),
  ///                  );
  ///                }
  ///              },
  ///              enableBubbleTooltip: true,
  ///            ),
  ///          ],
  ///        ),
  ///      ),
  ///   );
  /// }
  /// ```
  final IndexedWidgetBuilder bubbleTooltipBuilder;

  /// Provides option for adding, removing, deleting and updating marker
  /// collection.
  ///
  /// You can also get the current markers count and selected shape's index from
  /// this.
  ///
  /// ```dart
  /// List<Model> data;
  /// MapShapeLayerController controller;
  /// Random random = Random();
  ///
  /// @override
  /// void initState() {
  ///     data = <Model>[
  ///       Model(-14.235004, -51.92528),
  ///       Model(51.16569, 10.451526),
  ///       Model(-25.274398, 133.775136),
  ///       Model(20.593684, 78.96288),
  ///       Model(61.52401, 105.318756)
  ///     ];
  ///
  ///    controller = MapShapeLayerController();
  ///    super.initState();
  /// }
  ///
  /// @override
  /// Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      body: Center(
  ///          child: Container(
  ///            height: 350,
  ///            child: Padding(
  ///              padding: EdgeInsets.only(left: 15, right: 15),
  ///              child: Column(
  ///                children: [
  ///                  SfMaps(
  ///                    layers: <MapLayer>[
  ///                      MapShapeLayer(
  ///                       delegate: MapShapeLayerDelegate(
  ///                          shapeFile: 'assets/world_map.json',
  ///                          shapeDataField: 'name',
  ///                        ),
  ///                        initialMarkersCount: 5,
  ///                        markerBuilder: (BuildContext context, int index) {
  ///                          return MapMarker(
  ///                            latitude: data[index].latitude,
  ///                            longitude: data[index].longitude,
  ///                            child: Icon(Icons.add_location),
  ///                          );
  ///                        },
  ///                        controller: controller,
  ///                      ),
  ///                    ],
  ///                  ),
  ///                  RaisedButton(
  ///                    child: Text('Add marker'),
  ///                    onPressed: () {
  ///                      data.add(Model(
  ///                          -180 + random.nextInt(360).toDouble(),
  ///                          -55 + random.nextInt(139).toDouble()));
  ///                      controller.insertMarker(5);
  ///                    },
  ///                  ),
  ///                ],
  ///              ),
  ///            ),
  ///         )
  ///      ),
  ///   );
  /// }
  ///
  /// class Model {
  ///  Model(this.latitude, this.longitude);
  ///
  ///  final double latitude;
  ///  final double longitude;
  /// }
  /// ```
  final MapShapeLayerController controller;

  /// Enables or disables tooltip for the shapes.
  ///
  /// Defaults to `false`.
  ///
  /// See also:
  /// * [MapTooltipSettings], to customize the tooltip.
  /// * [MapShapeLayerDelegate.shapeTooltipTextMapper], for customizing the
  /// tooltip text.
  final bool enableShapeTooltip;

  /// Enables or disables tooltip for the bubbles.
  ///
  /// Defaults to false.
  ///
  /// See also:
  /// * [MapTooltipSettings], to customize the tooltip.
  /// * [MapShapeLayerDelegate.bubbleTooltipTextMapper], for customizing the
  /// tooltip text.
  final bool enableBubbleTooltip;

  /// Shows legend for the bubbles or shapes.
  ///
  /// Information provided in the legend helps to identify the data rendered in
  /// the map shapes or bubbles.
  ///
  /// Defaults to `MapElement.none`.
  ///
  /// By default, legend will not be shown.
  ///
  /// ## Legend for shape
  ///
  /// [MapElement.shape] shows legend for the shapes.
  ///
  /// If [MapShapeLayerDelegate.shapeColorMappers] is not null, then
  /// [MapColorMapper.color] and [MapColorMapper.text] will be used for the
  /// legend item's icon and the legend item's text respectively.
  ///
  /// If [MapShapeLayerDelegate.shapeColorMappers] is null, the color returned
  /// in the [MapShapeLayerDelegate.shapeColorValueMapper] will be applied to
  /// the legend item's icon and the legend item's text will be taken from the
  /// [MapShapeLayerDelegate.shapeDataField].
  ///
  /// In a rare case, if both the [MapShapeLayerDelegate.shapeColorMappers] and
  /// the [MapShapeLayerDelegate.shapeColorValueMapper] properties are null,
  /// the legend item's text will be taken from the
  /// [MapShapeLayerDelegate.shapeDataField] property and the legend item's
  /// icon will have the default color.
  ///
  /// ## Legend for bubbles
  ///
  /// [MapElement.bubble] shows legend for the bubbles.
  ///
  /// If [MapShapeLayerDelegate.bubbleColorMappers] is not null, then
  /// [MapColorMapper.color] and [MapColorMapper.text] will be used for the
  /// legend item's icon and the legend item's text respectively.
  ///
  /// If [MapShapeLayerDelegate.bubbleColorMappers] is null, the color returned
  /// in the [MapShapeLayerDelegate.bubbleColorValueMapper] will be applied to
  /// the legend item's icon and the legend item's text will be taken from the
  /// [MapShapeLayerDelegate.shapeDataField].
  ///
  /// In a rare case, if both the [MapShapeLayerDelegate.bubbleColorMappers] and
  /// the [MapShapeLayerDelegate.bubbleColorValueMapper] properties are null,
  /// the legend item's text will be taken from the
  /// [MapShapeLayerDelegate.shapeDataField] property and the legend item's
  /// icon will have the default color.
  ///
  /// See also:
  /// * [legendSettings], to enable the legend toggle interaction and customize
  /// the appearance of the legend items.
  final MapElement legendSource;

  /// Shows or hides the data labels.
  ///
  /// Defaults to `false`.
  ///
  /// See also:
  /// * [MapDataLabelSettings], to customize the tooltip.
  /// * [MapShapeLayerDelegate.dataLabelMapper], for customizing the
  /// data label's text.
  final bool showDataLabels;

  /// Shows or hides the bubbles.
  ///
  /// Defaults to `false`.
  ///
  /// See also:
  /// * [MapBubbleSettings], to customize the appearance of the bubbles.
  /// * [MapShapeLayerDelegate.bubbleSizeMapper],
  /// [MapShapeLayerDelegate.bubbleColorMappers],
  /// [MapShapeLayerDelegate.bubbleColorValueMapper] for customizing the
  /// bubbles based on the data.
  ///
  /// See also:
  /// * [legendSource], to enable legend for bubbles.
  final bool showBubbles;

  /// Allows selecting a shape in maps.
  ///
  /// Defaults to `false`.
  ///
  /// See also:
  /// * [MapShapeLayer.onSelectionChanged], for actions to be done during the
  /// shape's selection change.
  /// * [MapSelectionSettings], to customize the selected shape's appearance.
  final bool enableSelection;

  /// Color which is used to paint the shapes.
  final Color color;

  /// Color which is used to paint the stroke of the shapes.
  final Color strokeColor;

  /// Sets the stroke width of the shapes.
  final double strokeWidth;

  /// Paints the shape based on this list of color in a sequential order.
  ///
  /// If the number of shapes exceeds the length of this collections, once the
  /// last color is used for a shape, color in the 0th index will be used for
  /// the next shape and so on.
  ///
  /// ```dart
  /// @override
  /// Widget build(BuildContext context) {
  ///    return Scaffold(
  ///      body: Padding(
  ///        padding: EdgeInsets.all(15),
  ///        child: SfMaps(
  ///          layers: <MapLayer>[
  ///            MapShapeLayer(
  ///              delegate: MapShapeLayerDelegate(
  ///                shapeFile: 'assets/world_map.json',
  ///                shapeDataField: 'continent',
  ///              ),
  ///              palette: [
  ///                Colors.blue[200],
  ///                Colors.orange[200],
  ///                Colors.red[200],
  ///                Colors.green[200],
  ///                Colors.purple[200],
  ///                Colors.lime[200]
  ///              ],
  ///            ),
  ///          ],
  ///        ),
  ///      ),
  ///   );
  /// }
  /// ```
  final List<Color> palette;

  /// Customizes the appearance of the data labels.
  final MapDataLabelSettings dataLabelSettings;

  /// Customizes the appearance of the bubbles.
  ///
  /// See also:
  /// * [MapShapeLayer.showBubbles], to show the bubbles.
  final MapBubbleSettings bubbleSettings;

  /// Customizes the appearance of the the legend.
  ///
  /// See also:
  /// * [legendSource], to enable legend for shape or bubbles.
  final MapLegendSettings legendSettings;

  /// Customizes the appearance of the selected shape.
  ///
  /// See also:
  /// * [MapShapeLayer.enableSelection], for allowing shape selection.
  final MapSelectionSettings selectionSettings;

  /// Customizes the bubble and shape tooltips appearance.
  ///
  /// See also:
  /// * [MapShapeLayer.enableBubbleTooltip], for enabling tooltip for the
  /// bubbles.
  /// * [MapShapeLayer.enableShapeTooltip], for enabling tooltip for the
  /// shapes.
  final MapTooltipSettings tooltipSettings;

  /// Option to select a shape initially.
  ///
  /// See also:
  /// * [enableSelection], to enable shape's selection.
  /// * [MapSelectionSettings], to customize the selected shape's appearance.
  /// * [MapShapeLayer.onSelectionChanged], for actions to be done during the
  /// shape's selection change.
  final int initialSelectedIndex;

  /// Called when the user is selecting a shape by tapping or clicking.
  ///
  /// It passes the index of the selected shape. If the selected shape is
  /// tapped or clicked again, the index will be passed as -1. It means that,
  /// the shape is unselected.
  ///
  /// This snippet shows how to use onSelectionChanged callback in [SfMaps].
  ///
  /// ```dart
  /// SfMaps(
  ///   layers: [MultiChildMapShapeLayer(
  ///       delegate: delegate,
  ///       onSelectionChanged: (int index) {
  ///           print('The selected region is ${data[index].labelText}');
  ///         },
  ///       )]
  /// )
  ///
  /// ```
  final ValueChanged<int> onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    return _MapsShapeLayer(
      key: key,
      delegate: delegate,
      loadingBuilder: loadingBuilder,
      controller: controller,
      initialMarkersCount: initialMarkersCount,
      markerBuilder: markerBuilder,
      shapeTooltipBuilder: shapeTooltipBuilder,
      bubbleTooltipBuilder: bubbleTooltipBuilder,
      showDataLabels: showDataLabels,
      showBubbles: showBubbles,
      enableShapeTooltip: enableShapeTooltip,
      enableBubbleTooltip: enableBubbleTooltip,
      enableSelection: enableSelection,
      color: color,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      palette: palette,
      legendSource: legendSource,
      legendSettings: legendSettings,
      dataLabelSettings: dataLabelSettings,
      bubbleSettings: bubbleSettings,
      selectionSettings: selectionSettings,
      tooltipSettings: tooltipSettings,
      initialSelectedIndex: initialSelectedIndex,
      zoomPanBehavior: zoomPanBehavior,
      onSelectionChanged: onSelectionChanged,
      onWillZoom: onWillZoom,
      onWillPan: onWillPan,
    );
  }
}

class _MapsShapeLayer extends StatefulWidget {
  const _MapsShapeLayer({
    Key key,
    this.delegate,
    this.loadingBuilder,
    this.controller,
    this.initialMarkersCount,
    this.markerBuilder,
    this.shapeTooltipBuilder,
    this.bubbleTooltipBuilder,
    this.enableShapeTooltip,
    this.enableBubbleTooltip,
    this.enableSelection,
    this.showDataLabels,
    this.showBubbles,
    this.color,
    this.strokeColor,
    this.strokeWidth,
    this.palette,
    this.legendSource,
    this.legendSettings,
    this.dataLabelSettings,
    this.bubbleSettings,
    this.selectionSettings,
    this.tooltipSettings,
    this.initialSelectedIndex,
    this.zoomPanBehavior,
    this.onSelectionChanged,
    this.onWillZoom,
    this.onWillPan,
  }) : super(key: key);

  final MapShapeLayerDelegate delegate;
  final MapLoadingBuilder loadingBuilder;
  final MapShapeLayerController controller;
  final int initialMarkersCount;
  final MapMarkerBuilder markerBuilder;
  final IndexedWidgetBuilder shapeTooltipBuilder;
  final IndexedWidgetBuilder bubbleTooltipBuilder;
  final bool enableShapeTooltip;
  final bool enableBubbleTooltip;
  final MapElement legendSource;
  final bool showDataLabels;
  final bool showBubbles;
  final bool enableSelection;
  final Color color;
  final Color strokeColor;
  final double strokeWidth;
  final List<Color> palette;
  final MapDataLabelSettings dataLabelSettings;
  final MapLegendSettings legendSettings;
  final MapBubbleSettings bubbleSettings;
  final MapSelectionSettings selectionSettings;
  final MapTooltipSettings tooltipSettings;
  final int initialSelectedIndex;
  final MapZoomPanBehavior zoomPanBehavior;
  final ValueChanged<int> onSelectionChanged;
  final WillZoomCallback onWillZoom;
  final WillPanCallback onWillPan;

  @override
  _MapsShapeLayerState createState() => _MapsShapeLayerState();
}

class _MapsShapeLayerState extends State<_MapsShapeLayer>
    with TickerProviderStateMixin {
  bool _isShapeFileDecoded = false;
  int paletteLength;
  bool _shouldUpdateMapDataSource = true;
  List<Widget> _markers;
  MapLegendSettings _legendSettings;
  int _initialSelectedIndex;
  SfMapsThemeData _themeData;
  double minBubbleValue;
  double maxBubbleValue;
  _ShapeFileData shapeFileData;

  _DefaultController _defaultController;
  AnimationController bubbleAnimationController;
  AnimationController dataLabelAnimationController;
  AnimationController selectionAnimationController;
  AnimationController toggleAnimationController;
  AnimationController hoverShapeAnimationController;
  AnimationController hoverBubbleAnimationController;

  @override
  void initState() {
    super.initState();
    assert(widget.delegate != null);
    shapeFileData = _ShapeFileData()
      ..source = <String, _MapModel>{}
      ..bounds = _ShapeBounds();
    dataLabelAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 750));
    bubbleAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    selectionAnimationController = AnimationController(
        vsync: this, value: 1.0, duration: const Duration(milliseconds: 200));
    toggleAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));

    hoverShapeAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
    hoverBubbleAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));

    if (widget.controller != null) {
      widget.controller._markersCount = widget.initialMarkersCount;
      widget.controller._selectedIndex = widget.initialSelectedIndex;
    }

    _initialSelectedIndex = widget.initialSelectedIndex;
    paletteLength = widget.palette != null ? widget.palette.length : 0;

    MapMarker marker;
    _markers = <Widget>[];
    for (int i = 0; i < widget.initialMarkersCount; i++) {
      marker = widget.markerBuilder(context, i);
      assert(marker != null);
      _markers.add(marker);
    }

    widget.controller?.addListener(refreshMarkers);

    _defaultController = _DefaultController();
    widget.zoomPanBehavior?._controller = _defaultController;
  }

  @override
  void dispose() {
    dataLabelAnimationController?.dispose();
    bubbleAnimationController?.dispose();
    selectionAnimationController?.dispose();
    toggleAnimationController?.dispose();
    hoverShapeAnimationController?.dispose();
    hoverBubbleAnimationController.dispose();

    _markers?.clear();
    widget.controller?.removeListener(refreshMarkers);
    _defaultController?.dispose();

    shapeFileData?.reset();
    super.dispose();
  }

  @override
  void didUpdateWidget(_MapsShapeLayer oldWidget) {
    assert(widget.delegate != null);
    _shouldUpdateMapDataSource = oldWidget.delegate != widget.delegate;
    if (oldWidget.palette != widget.palette) {
      paletteLength = widget.palette != null ? widget.palette.length : 0;
    }

    if (oldWidget.delegate.shapeFile != widget.delegate.shapeFile) {
      _isShapeFileDecoded = false;
      shapeFileData?.reset();
    }

    if (oldWidget.zoomPanBehavior != widget.zoomPanBehavior) {
      widget.zoomPanBehavior._controller = _defaultController;
    }

    if (oldWidget.controller != widget.controller) {
      widget.controller._parentBox = context.findRenderObject();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    assert(!widget.showDataLabels ||
        (widget.showDataLabels && widget.delegate.shapeDataField != null));
    assert(!widget.showBubbles ||
        widget.showBubbles &&
            widget.delegate.primaryValueMapper != null &&
            widget.delegate.bubbleSizeMapper != null);
    assert(widget.delegate.dataLabelMapper == null ||
        (widget.delegate.dataLabelMapper != null && widget.showDataLabels));
    assert(widget.delegate.bubbleSizeMapper == null ||
        (widget.delegate.bubbleSizeMapper != null && widget.showBubbles));
    assert(widget.delegate.shapeColorMappers == null ||
        widget.delegate.shapeColorMappers.isNotEmpty);
    assert(widget.legendSource == MapElement.none ||
        (widget.legendSource == MapElement.shape &&
            widget.delegate.shapeDataField != null) ||
        (widget.legendSource == MapElement.bubble && widget.showBubbles));
    assert(widget.bubbleTooltipBuilder == null ||
        (widget.bubbleTooltipBuilder != null && widget.enableBubbleTooltip));
    assert(widget.shapeTooltipBuilder == null ||
        (widget.shapeTooltipBuilder != null && widget.enableShapeTooltip));

    _updateThemeData(context);
    _legendSettings = widget.legendSettings._copyWith(
        textStyle: _themeData.legendTextStyle,
        toggledItemColor: _themeData.toggledItemColor,
        toggledItemStrokeColor: _themeData.toggledItemStrokeColor,
        toggledItemStrokeWidth: _themeData.toggledItemStrokeWidth);

    return FutureBuilder<_ShapeFileData>(
      future: _retrieveDataFromShapeFile(widget.delegate.shapeFile,
          widget.delegate.shapeDataField, shapeFileData, _isShapeFileDecoded),
      builder: (BuildContext context, AsyncSnapshot<_ShapeFileData> snapshot) {
        if (snapshot.hasData && _isShapeFileDecoded) {
          shapeFileData = snapshot.data;
          if (_shouldUpdateMapDataSource) {
            minBubbleValue = null;
            maxBubbleValue = null;
            shapeFileData.source.values
                .forEach((_MapModel model) => model.reset());
            _bindMapsSourceIntoDataSource();
            _shouldUpdateMapDataSource = false;
          }
          return _actualChild;
        } else {
          _isShapeFileDecoded = true;
          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final Size size = _getBoxSize(constraints);
              return Container(
                width: size.width,
                height: size.height,
                alignment: Alignment.center,
                child: widget.loadingBuilder?.call(context),
              );
            },
          );
        }
      },
    );
  }

  void _updateThemeData(BuildContext context) {
    _themeData = SfMapsTheme.of(context);
    _themeData = _themeData.copyWith(
      layerColor: widget.color ?? _themeData.layerColor,
      layerStrokeColor: widget.strokeColor ?? _themeData.layerStrokeColor,
      layerStrokeWidth: widget.strokeWidth ?? _themeData.layerStrokeWidth,
      shapeHoverStrokeWidth:
          _themeData.shapeHoverStrokeWidth ?? _themeData.layerStrokeWidth,
      legendTextStyle: widget.legendSettings.textStyle ??
          _themeData.legendTextStyle ??
          Theme.of(context).textTheme.caption.copyWith(
              color:
                  Theme.of(context).textTheme.caption.color.withOpacity(0.87)),
      bubbleColor: widget.bubbleSettings.color ?? _themeData.bubbleColor,
      bubbleStrokeColor:
          widget.bubbleSettings.strokeColor ?? _themeData.bubbleStrokeColor,
      bubbleStrokeWidth:
          widget.bubbleSettings.strokeWidth ?? _themeData.bubbleStrokeWidth,
      bubbleHoverStrokeWidth:
          _themeData.bubbleHoverStrokeWidth ?? _themeData.bubbleStrokeWidth,
      selectionColor:
          widget.selectionSettings.color ?? _themeData.selectionColor,
      selectionStrokeColor: widget.selectionSettings.strokeColor ??
          _themeData.selectionStrokeColor,
      selectionStrokeWidth: widget.selectionSettings.strokeWidth ??
          _themeData.selectionStrokeWidth,
      tooltipTextStyle: widget.tooltipSettings.textStyle ??
          _themeData.tooltipTextStyle ??
          Theme.of(context)
              .textTheme
              .caption
              .copyWith(color: Theme.of(context).colorScheme.surface),
      tooltipColor: widget.tooltipSettings.color ?? _themeData.tooltipColor,
      tooltipStrokeColor:
          widget.tooltipSettings.strokeColor ?? _themeData.tooltipStrokeColor,
      tooltipStrokeWidth:
          widget.tooltipSettings.strokeWidth ?? _themeData.tooltipStrokeWidth,
      tooltipBorderRadius:
          _themeData.tooltipBorderRadius.resolve(Directionality.of(context)),
      toggledItemColor:
          widget.legendSettings.toggledItemColor ?? _themeData.toggledItemColor,
      toggledItemStrokeColor: widget.legendSettings.toggledItemStrokeColor ??
          _themeData.toggledItemStrokeColor,
      toggledItemStrokeWidth: widget.legendSettings.toggledItemStrokeWidth ??
          _themeData.toggledItemStrokeWidth,
    );
  }

  Widget get _shapeLayerRenderObjectWidget {
    final List<Widget> children = <Widget>[];
    if (widget.showBubbles) {
      children.add(
        _MapBubble(
          delegate: widget.delegate,
          mapDataSource: shapeFileData.source,
          bubbleSettings: widget.bubbleSettings._copyWith(
              color: _themeData.bubbleColor,
              strokeColor: _themeData.bubbleStrokeColor,
              strokeWidth: _themeData.bubbleStrokeWidth),
          legendSettings: _legendSettings,
          themeData: _themeData,
          defaultController: _defaultController,
          state: this,
        ),
      );
    }

    if (widget.showDataLabels) {
      children.add(
        _MapDataLabel(
          mapDataSource: shapeFileData.source,
          settings: widget.dataLabelSettings,
          effectiveTextStyle: Theme.of(context).textTheme.caption.merge(
              widget.dataLabelSettings.textStyle ??
                  _themeData.dataLabelTextStyle),
          themeData: _themeData,
          defaultController: _defaultController,
          state: this,
        ),
      );
    }

    if (_markers != null && _markers.isNotEmpty) {
      children.add(
        ClipRect(
          child: _MarkerContainer(
            children: _markers,
            defaultController: _defaultController,
            state: this,
          ),
        ),
      );
    }

    if (widget.zoomPanBehavior != null) {
      children.add(
        _BehaviorViewRenderObjectWidget(
          defaultController: _defaultController,
          zoomPanBehavior: widget.zoomPanBehavior,
        ),
      );

      if (widget.zoomPanBehavior.showToolbar && kIsWeb) {
        children.add(
          _MapToolbar(
            onWillZoom: widget.onWillZoom,
            zoomPanBehavior: widget.zoomPanBehavior,
            defaultController: _defaultController,
          ),
        );
      }
    }

    if (widget.enableBubbleTooltip || widget.enableShapeTooltip) {
      children.add(
        _MapTooltip(
          mapDelegate: widget.delegate,
          defaultController: _defaultController,
          enableShapeTooltip: widget.enableShapeTooltip,
          enableBubbleTooltip: widget.enableBubbleTooltip,
          tooltipSettings: widget.tooltipSettings,
          shapeTooltipBuilder: widget.shapeTooltipBuilder,
          bubbleTooltipBuilder: widget.bubbleTooltipBuilder,
          themeData: _themeData,
        ),
      );
    }

    return _MapShapeLayerRenderObjectWidget(
      key: widget.key,
      children: children,
      mapDataSource: shapeFileData.source,
      mapDelegate: widget.delegate,
      enableShapeTooltip: widget.enableShapeTooltip,
      enableBubbleTooltip: widget.enableBubbleTooltip,
      enableSelection: widget.enableSelection,
      legendSettings: _legendSettings,
      selectionSettings: widget.selectionSettings,
      zoomPanBehavior: widget.zoomPanBehavior,
      bubbleSettings: widget.bubbleSettings._copyWith(
          color: _themeData.bubbleColor,
          strokeColor: _themeData.bubbleStrokeColor,
          strokeWidth: _themeData.bubbleStrokeWidth),
      themeData: _themeData,
      defaultController: _defaultController,
      state: this,
    );
  }

  Widget get _actualChild {
    if (widget.legendSource != MapElement.none) {
      if (_legendSettings.offset == null) {
        switch (_legendSettings.position) {
          case MapLegendPosition.top:
            return Column(
              children: <Widget>[
                _legend,
                _expandedShapeLayer,
              ],
            );
          case MapLegendPosition.bottom:
            return Column(
              children: <Widget>[
                _expandedShapeLayer,
                _legend,
              ],
            );
          case MapLegendPosition.left:
            return Row(
              children: <Widget>[
                _legend,
                _expandedShapeLayer,
              ],
            );
          case MapLegendPosition.right:
            return Row(
              children: <Widget>[
                _expandedShapeLayer,
                _legend,
              ],
            );
        }
      } else {
        return _stackedLegendAndShapeLayer;
      }
    }

    return _shapeLayerRenderObjectWidget;
  }

  _MapLegend get _legend => _MapLegend(
        dataSource: _getLegendSource() ?? shapeFileData.source,
        source: widget.legendSource,
        palette: widget.palette,
        settings: _legendSettings,
        themeData: _themeData,
        defaultController: _defaultController,
        toggleAnimationController: toggleAnimationController,
      );

  List<MapColorMapper> _getLegendSource() {
    switch (widget.legendSource) {
      case MapElement.bubble:
        return widget.delegate.bubbleColorMappers;
        break;
      case MapElement.shape:
        return widget.delegate.shapeColorMappers;
        break;
      case MapElement.none:
        break;
    }
    return null;
  }

  Widget get _expandedShapeLayer => Expanded(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[_shapeLayerRenderObjectWidget],
        ),
      );

  /// Returns the legend and map overlapping widget.
  Widget get _stackedLegendAndShapeLayer => Stack(
        children: <Widget>[
          _shapeLayerRenderObjectWidget,
          Align(
            alignment: _getActualLegendAlignment(_legendSettings.position),
            // Padding widget is used to set the custom position to the legend.
            child: Padding(
              padding: _getActualLegendOffset(context),
              child: _legend,
            ),
          ),
        ],
      );

  /// Returns the alignment for the legend if we set the legend offset.
  AlignmentGeometry _getActualLegendAlignment(MapLegendPosition position) {
    switch (position) {
      case MapLegendPosition.top:
        return Alignment.topCenter;
        break;
      case MapLegendPosition.bottom:
        return Alignment.bottomCenter;
        break;
      case MapLegendPosition.left:
        return Alignment.centerLeft;
        break;
      case MapLegendPosition.right:
        return Alignment.centerRight;
        break;
    }
    return Alignment.topCenter;
  }

  /// Returns the padding value to render the legend based on offset value.
  EdgeInsetsGeometry _getActualLegendOffset(BuildContext context) {
    final Offset offset = _legendSettings.offset;
    final MapLegendPosition legendPosition =
        _legendSettings.position ?? MapLegendPosition.top;
    // Here the default alignment is center for all the positions.
    // So need to handle the offset by multiplied it by 2.
    switch (legendPosition) {
      // Returns the insets for the offset if the legend position is top.
      case MapLegendPosition.top:
        return EdgeInsets.only(
            left: offset.dx > 0 ? offset.dx * 2 : 0,
            right: offset.dx < 0 ? offset.dx.abs() * 2 : 0,
            top: offset.dy > 0 ? offset.dy : 0);
        break;
      // Returns the insets for the offset if the legend position is left.
      case MapLegendPosition.left:
        return EdgeInsets.only(
            top: offset.dy > 0 ? offset.dy * 2 : 0,
            bottom: offset.dy < 0 ? offset.dy.abs() * 2 : 0,
            left: offset.dx > 0 ? offset.dx : 0);
        break;
      // Returns the insets for the offset if the legend position is right.
      case MapLegendPosition.right:
        return EdgeInsets.only(
            top: offset.dy > 0 ? offset.dy * 2 : 0,
            bottom: offset.dy < 0 ? offset.dy.abs() * 2 : 0,
            right: offset.dx < 0 ? offset.dx.abs() : 0);
        break;
      // Returns the insets for the offset if the legend position is bottom.
      case MapLegendPosition.bottom:
        return EdgeInsets.only(
            left: offset.dx > 0 ? offset.dx * 2 : 0,
            right: offset.dx < 0 ? offset.dx.abs() * 2 : 0,
            bottom: offset.dy < 0 ? offset.dy.abs() : 0);
        break;
    }
    return EdgeInsets.zero;
  }

  /// Updating [modelSource] data index based on [dataMapper]
  /// value and data color based on [colorValueMapper] value.
  void _bindMapsSourceIntoDataSource() {
    if (widget.delegate.dataCount != null &&
        widget.delegate.dataCount > 0 &&
        widget.delegate.primaryValueMapper != null) {
      final bool hasShapeColorValueMapper =
          widget.delegate.shapeColorValueMapper != null;
      final bool hasDataLabelMapper = widget.delegate.dataLabelMapper != null;
      final bool hasBubbleColorValueMapper =
          widget.delegate.bubbleColorValueMapper != null;
      final bool hasBubbleSizeMapper = widget.delegate.bubbleSizeMapper != null;

      for (int i = 0; i < widget.delegate.dataCount; i++) {
        final _MapModel mapModel =
            shapeFileData.source[widget.delegate.primaryValueMapper(i)];
        if (mapModel != null) {
          mapModel.dataIndex = i;
          _updateShapeColor(hasShapeColorValueMapper, i, mapModel);
          if (hasDataLabelMapper) {
            mapModel.dataLabelText = widget.delegate.dataLabelMapper(i);
          }

          _updateBubbleColor(hasBubbleColorValueMapper, i, mapModel);
          _validateBubbleSize(hasBubbleSizeMapper, i, mapModel);
          if (widget.enableSelection &&
              mapModel.dataIndex == _initialSelectedIndex) {
            mapModel.isSelected = true;
            _initialSelectedIndex = -1;
          }
        }
      }
    }
  }

  void _updateShapeColor(
      bool hasShapeColorValueMapper, int index, _MapModel mapModel) {
    if (hasShapeColorValueMapper) {
      mapModel.shapeColor = _getActualColor(
          widget.delegate.shapeColorValueMapper(index),
          widget.delegate.shapeColorMappers,
          mapModel);
    }
  }

  void _updateBubbleColor(
      bool hasBubbleColorValueMapper, int index, _MapModel mapModel) {
    if (hasBubbleColorValueMapper) {
      mapModel.bubbleColor = _getActualColor(
          widget.delegate.bubbleColorValueMapper(index),
          widget.delegate.bubbleColorMappers,
          mapModel);
    }
  }

  void _validateBubbleSize(
      bool hasBubbleSizeMapper, int index, _MapModel mapModel) {
    if (hasBubbleSizeMapper) {
      mapModel.bubbleSizeValue = widget.delegate.bubbleSizeMapper(index);
      if (mapModel.bubbleSizeValue != null) {
        if (minBubbleValue == null) {
          minBubbleValue = mapModel.bubbleSizeValue;
          maxBubbleValue = mapModel.bubbleSizeValue;
        } else {
          minBubbleValue = min(mapModel.bubbleSizeValue, minBubbleValue);
          maxBubbleValue = max(mapModel.bubbleSizeValue, maxBubbleValue);
        }
      }
    }
  }

  /// Returns color from [MapColorMapper] based on the data source value.
  Color _getActualColor(Object colorValue, List<MapColorMapper> colorMappers,
      _MapModel mapModel) {
    MapColorMapper mapper;
    final int length = colorMappers != null ? colorMappers.length : 0;
    // Handles equal color mapping.
    if (colorValue is String) {
      for (int i = 0; i < length; i++) {
        mapper = colorMappers[i];
        assert(mapper.value != null && mapper.color != null);
        if (mapper.value == colorValue) {
          mapModel?.legendMapperIndex = i;
          return mapper.color;
        }
      }
    }

    // Handles range color mapping.
    if (colorValue is num) {
      for (int i = 0; i < length; i++) {
        mapper = colorMappers[i];
        assert(
            mapper.from != null && mapper.to != null && mapper.color != null);
        if (mapper.from <= colorValue && mapper.to >= colorValue) {
          mapModel?.legendMapperIndex = i;
          if (mapper.minOpacity != null && mapper.maxOpacity != null) {
            return mapper.color.withOpacity(lerpDouble(
                mapper.minOpacity,
                mapper.maxOpacity,
                (colorValue - mapper.from) / (mapper.to - mapper.from)));
          }
          return mapper.color;
        }
      }
    }

    return colorValue;
  }

  void refreshMarkers() {
    MapMarker marker;
    switch (widget.controller._markerAction) {
      case _MarkerAction.insert:
        marker = widget.markerBuilder(context, widget.controller._index);
        if (widget.controller._index < widget.controller._markersCount) {
          _markers.insert(widget.controller._index, marker);
        } else if (widget.controller._index ==
            widget.controller._markersCount) {
          _markers.add(marker);
        }
        widget.controller._markersCount++;
        break;
      case _MarkerAction.removeAt:
        assert(widget.controller._index < widget.controller._markersCount);
        _markers.removeAt(widget.controller._index);
        widget.controller._markersCount--;
        break;
      case _MarkerAction.replace:
        for (final int index in widget.controller._replaceableIndices) {
          assert(index < widget.controller._markersCount);
          marker = widget.markerBuilder(context, index);
          assert(marker != null);
          _markers[index] = marker;
        }
        break;
      case _MarkerAction.clear:
        _markers.clear();
        widget.controller._markersCount = 0;
        break;
      case _MarkerAction.none:
        break;
    }

    widget.controller._index = -1;

    setState(() {
      // Rebuilds to visually update the markers when it was updated or added.
    });
  }
}

class _MapShapeLayerRenderObjectWidget extends Stack {
  _MapShapeLayerRenderObjectWidget({
    Key key,
    List<Widget> children,
    this.mapDataSource,
    this.mapDelegate,
    this.enableShapeTooltip,
    this.enableBubbleTooltip,
    this.enableSelection,
    this.legendSettings,
    this.bubbleSettings,
    this.selectionSettings,
    this.zoomPanBehavior,
    this.themeData,
    this.defaultController,
    this.state,
  }) : super(
          key: key,
          children: children ?? <Widget>[],
        );

  final Map<String, _MapModel> mapDataSource;
  final MapShapeLayerDelegate mapDelegate;
  final bool enableShapeTooltip;
  final bool enableBubbleTooltip;
  final bool enableSelection;
  final MapLegendSettings legendSettings;
  final MapBubbleSettings bubbleSettings;
  final MapSelectionSettings selectionSettings;
  final MapZoomPanBehavior zoomPanBehavior;
  final SfMapsThemeData themeData;
  final _DefaultController defaultController;
  final _MapsShapeLayerState state;

  @override
  RenderStack createRenderObject(BuildContext context) {
    return _RenderShapeLayer(
      mapDataSource: mapDataSource,
      mapDelegate: mapDelegate,
      enableShapeTooltip: enableShapeTooltip,
      enableBubbleTooltip: enableBubbleTooltip,
      enableSelection: enableSelection,
      legendSettings: legendSettings,
      bubbleSettings: bubbleSettings,
      selectionSettings: selectionSettings,
      zoomPanBehavior: zoomPanBehavior,
      themeData: themeData,
      defaultController: defaultController,
      context: context,
      state: state,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, _RenderShapeLayer renderObject) {
    renderObject
      ..mapDataSource = mapDataSource
      ..mapDelegate = mapDelegate
      ..enableShapeTooltip = enableShapeTooltip
      ..enableBubbleTooltip = enableBubbleTooltip
      ..enableSelection = enableSelection
      ..legendSettings = legendSettings
      ..bubbleSettings = bubbleSettings
      ..selectionSettings = selectionSettings
      ..zoomPanBehavior = zoomPanBehavior
      ..themeData = themeData
      ..context = context;
  }
}
