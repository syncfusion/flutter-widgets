import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

void main() {
  return runApp(MapsApp());
}

/// This widget will be the root of application.
class MapsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Maps Demo',
      home: MyHomePage(),
    );
  }
}

/// This widget is the home page of the application.
class MyHomePage extends StatefulWidget {
  /// Initialize the instance of the [MyHomePage] class.
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState();

  late List<Model> _data;
  late MapShapeSource _mapSource;
  late MapZoomPanBehavior _zoomPanBehavior;
  late MapTileLayerController _mapController;

  @override
  void initState() {
    super.initState();
    _data = const <Model>[
      Model('New South Wales', Color.fromRGBO(255, 215, 0, 1.0),
          '       New\nSouth Wales'),
      Model('Queensland', Color.fromRGBO(72, 209, 204, 1.0), 'Queensland'),
      Model('Northern Territory', Color.fromRGBO(255, 78, 66, 1.0),
          'Northern\nTerritory'),
      Model('Victoria', Color.fromRGBO(171, 56, 224, 0.75), 'Victoria'),
      Model('South Australia', Color.fromRGBO(126, 247, 74, 0.75),
          'South Australia'),
      Model('Western Australia', Color.fromRGBO(79, 60, 201, 0.7),
          'Western Australia'),
      Model('Tasmania', Color.fromRGBO(99, 164, 230, 1), 'Tasmania'),
      Model('Australian Capital Territory', Colors.teal, 'ACT')
    ];

    _mapSource = MapShapeSource.asset(
      'assets/australia.json',
      shapeDataField: 'STATE_NAME',
      dataCount: _data.length,
      primaryValueMapper: (int index) => _data[index].state,
      dataLabelMapper: (int index) => _data[index].stateCode,
      shapeColorValueMapper: (int index) => _data[index].color,
    );

    _mapController = MapTileLayerController();
    _zoomPanBehavior = MapZoomPanBehavior(
      minZoomLevel: 2,
      maxZoomLevel: 10,
      zoomLevel: 6,
      enableDoubleTapZooming: true,
    );
  }

  Widget? map;

  @override
  Widget build(BuildContext context) {
    map ??= _map(context);
    return Scaffold(
      body: SizedBox(
        height: 520,
        child: Flex(
          direction: MediaQuery.of(context).size.width < 1000
              ? Axis.vertical
              : Axis.horizontal,
          children: <Widget>[
            if (MediaQuery.of(context).size.width < 1000) const Text('min'),
            Expanded(
              child: map!,
            ),
            if (MediaQuery.of(context).size.width > 1000) const Text('max'),
          ],
        ),
      ),
    );
  }

  Widget _map(BuildContext context) {
    return SfMaps(
      // key: const ValueKey('map_cards'),
      layers: <MapLayer>[
        MapTileLayer(
          /// URL to request the tiles from the providers.
          ///
          /// The [urlTemplate] accepts the URL in WMTS format i.e. {z} —
          /// zoom level, {x} and {y} — tile coordinates.
          ///
          /// We will replace the {z}, {x}, {y} internally based on the
          /// current center point and the zoom level.
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          zoomPanBehavior: _zoomPanBehavior,
          controller: _mapController,
          tooltipSettings: const MapTooltipSettings(
            color: Colors.transparent,
          ),
        )
      ],
    );
    // return SfMaps(
    //   layers: <MapShapeLayer>[
    //     MapShapeLayer(
    //       source: _mapSource,
    //       showDataLabels: true,
    //       controller: _mapController,
    //       zoomPanBehavior: _zoomPanBehavior,
    //       legend: const MapLegend(MapElement.shape),
    //       tooltipSettings: MapTooltipSettings(
    //         color: Colors.grey[700],
    //         strokeColor: Colors.white,
    //         strokeWidth: 2,
    //       ),
    //       strokeColor: Colors.white,
    //       strokeWidth: 0.5,
    //       shapeTooltipBuilder: (BuildContext context, int index) {
    //         return Padding(
    //           padding: const EdgeInsets.all(8.0),
    //           child: Text(
    //             _data[index].stateCode,
    //             style: const TextStyle(color: Colors.white),
    //           ),
    //         );
    //       },
    //       dataLabelSettings: MapDataLabelSettings(
    //         textStyle: TextStyle(
    //             color: Colors.black,
    //             fontWeight: FontWeight.bold,
    //             fontSize: Theme.of(context).textTheme.bodySmall!.fontSize),
    //       ),
    //     ),
    //   ],
    // );
  }
}

/// Collection of Australia state code data.
class Model {
  /// Initialize the instance of the [Model] class.
  const Model(this.state, this.color, this.stateCode);

  /// Represents the Australia state name.
  final String state;

  /// Represents the Australia state color.
  final Color color;

  /// Represents the Australia state code.
  final String stateCode;
}
