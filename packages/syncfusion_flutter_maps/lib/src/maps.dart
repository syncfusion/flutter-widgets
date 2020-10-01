part of maps;

/// Renders the GeoJSON data as a geographical area.
///
/// The maps has the following elements and features,
///
/// * The "data labels", to provide information to users about the respective
/// shape.
/// * The "markers", which denotes a location with built-in symbols and allows
/// displaying custom widgets at a specific latitude and longitude on a map.
/// * The "bubbles", which adds information to shapes such as population
/// density, number of users, and more. Bubbles can be rendered in different
/// colors and sizes based on the data values of their assigned shape.
/// * The "legend", to provide clear information on the data plotted in the map.
/// You can use the legend toggling feature to visualize only the shapes to
/// which needs to be visualized.
/// * The "color mapping", to categorize the shapes on a map by customizing
/// their color based on the underlying value. It is possible to set the shape
/// color for a specific value or for a range of values.
/// * The "tooltip", to display additional information about shapes and bubbles
/// using the customizable tooltip on a map.
/// * Along with this, the selection feature helps to highlight that area on a
/// map on interaction. You can use the callback for performing any action
/// during shape selection.
///
/// The [SfMaps.layers] is a collection of [MapLayer]. It contains either
/// [MapShapeLayer] and [MapTileLayer].
///
/// ## Shape layer
///
/// The actual geographical rendering is done in each [MapShapeLayer] using the
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
/// ## Example
///
/// This snippet shows how to create the [SfMaps].
/// ```dart
///   @override
///  Widget build(BuildContext context) {
///    return Container(
///        child: const SfMaps(
///          layers: [
///            const MapShapeLayer(
///              delegate: const MapShapeLayerDelegate(
///                  shapeFile: "assets/world_map.json",
///                  shapeDataField: "continent"),
///            )
///          ],
///        ));
///     }
/// ```
///
/// ## Tile layer
///
/// Tile layer which renders the tiles returned from the Web Map Tile
/// Services (WMTS) like OpenStreetMap, Bing Maps, Google Maps, TomTom etc.
///
/// The [MapTileLayer.urlTemplate] accepts the URL in WMTS format 
/// i.e. {z} — zoom level, {x} and {y} — tile coordinates.
///
/// This URL might vary slightly depends on the providers. The formats can be,
/// https://exampleprovider/{z}/{x}/{y}.png,
/// https://exampleprovider/z={z}/x={x}/y={y}.png,
/// https://exampleprovider/z={z}/x={x}/y={y}.png?key=subscription_key, etc.
///
/// We will replace the {z}, {x}, {y} internally based on the
/// current center point and the zoom level.
///
/// The subscription key may be needed for some of the providers. Please include
/// them in the [MapTileLayer.urlTemplate] itself as mentioned in above example.
/// Please note that the format may vary between the each map providers. 
/// You can check the exact URL format needed for the providers in their 
/// official websites.
///
/// Regarding the tile rendering, at the lowest zoom level (Level 0), the map is
/// 256 x 256 pixels and the
/// whole world map renders as a single tile. At each increase in level, the map
/// width and height grow by a factor of 2 i.e. Level 1 is 512 x 512 pixels with
/// 4 tiles ((0, 0), (0, 1), (1, 0), (1, 1) where 0 and 1 are {x} and {y} in
/// [MapTileLayer.urlTemplate]), Level 2 is 2048 x 2048 pixels with 8
/// tiles (from (0, 0) to (3, 3)), and so on.
/// (These details are just for your information and all these calculation are
/// done internally.)
///
/// However, based on the size of the [SfMaps] widget,
/// [MapTileLayer.initialFocalLatLng] and [MapTileLayer.initialZoomLevel] number
/// of initial tiles needed in the view port alone will be rendered. 
/// While zooming and panning, new tiles will be requested and rendered on 
/// demand based on the current zoom level and focal point.
/// The current zoom level and focal point can be obtained from the
/// [MapZoomPanBehavior.zoomLevel] and [MapZoomPanBehavior.focalLatLng]
/// respectively. Once the particular tile is rendered, it will be stored in the
/// cache and it will be used from it next time for better performance.
///
/// Regarding the cache and clearing it, please check the APIs in [imageCache]
/// (https://api.flutter.dev/flutter/painting/imageCache.html).
///
/// ```dart
///   @override
///   Widget build(BuildContext context) {
///     return SfMaps(
///       layers: [
///         MapTileLayer(
///           urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
///           initialFocalLatLng: MapLatLng(-23.698042, 133.880753),
///           initialZoomLevel: 3
///         ),
///       ],
///     );
///   }
/// ```
/// See also:
///
/// * [MapShapeLayer], for enabling the features like data labels, tooltip,
/// bubbles, legends, selection etc.
/// * [MapShapeLayerDelegate], for providing the data for the elements like data
/// labels, tooltip, bubbles, legends etc.
/// * For enabling zooming and panning, set [MapTileLayer.zoomPanBehavior] 
/// with the instance of [MapZoomPanBehavior].

class SfMaps extends StatefulWidget {
  /// Creates a [SfMaps].
  const SfMaps({
    Key key,
    this.title,
    this.layers,
  }) : super(key: key);

  /// Title for the [SfMaps].
  ///
  /// It can define and customize the title for the [SfMaps]. The text
  /// property of the [MapTitle] is used to set the text of the title.
  ///
  /// It also provides option for customizing text style, alignment, decoration,
  /// background color, margin and padding of the title.
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
  final MapTitle title;

  /// The collection of map shape layer in which geographical rendering is done.
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
  /// * [MapShapeLayer.delegate], to provide data for the elements of the
  /// [SfMaps] like data labels, bubbles, tooltip, shape colors, and legend.
  final List<MapLayer> layers;

  @override
  _SfMapsState createState() => _SfMapsState();
}

class _SfMapsState extends State<SfMaps> {
  @override
  Widget build(BuildContext context) {
    assert(widget.layers != null && widget.layers.isNotEmpty);
    return _MapsRenderObjectWidget(
      child: widget.title != null && widget.title.text != null
          ? Column(
              children: <Widget>[
                _title(context),
                Expanded(
                  child: LayoutBuilder(builder:
                      (BuildContext context, BoxConstraints constraints) {
                    return Stack(
                      alignment: Alignment.center,
                      children: <Widget>[widget.layers.last],
                    );
                  }),
                ),
              ],
            )
          : Stack(
              alignment: Alignment.center,
              children: <Widget>[widget.layers.last],
            ),
    );
  }

  /// Returns the title of the [SfMaps].
  Widget _title(BuildContext context) {
    final SfMapsThemeData themeData = SfMapsTheme.of(context);
    return Align(
      alignment: widget.title.alignment ?? Alignment.center,
      child: Container(
        child: Text(
          widget.title.text,
          style: widget.title.textStyle ??
              themeData.titleTextStyle ??
              Theme.of(context).textTheme.subtitle1,
        ),
        color: widget.title.color,
        decoration: widget.title.decoration,
        margin: widget.title.margin,
        padding:
            widget.title.padding ?? const EdgeInsets.symmetric(vertical: 8),
      ),
    );
  }
}

class _MapsRenderObjectWidget extends SingleChildRenderObjectWidget {
  const _MapsRenderObjectWidget({Key key, Widget child})
      : super(key: key, child: child);

  @override
  _RenderMaps createRenderObject(BuildContext context) {
    return _RenderMaps();
  }
}

class _RenderMaps extends RenderProxyBox {
  @override
  void performLayout() {
    final double width =
        constraints.hasBoundedWidth ? constraints.maxWidth : 300;
    final double height =
        constraints.hasBoundedHeight ? constraints.maxHeight : 300;
    child.layout(BoxConstraints.loose(Size(width, height)),
        parentUsesSize: true);
    size = child.size;
  }
}
