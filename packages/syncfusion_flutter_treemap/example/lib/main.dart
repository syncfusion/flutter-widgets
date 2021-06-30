import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_treemap/treemap.dart';

void main() {
  return runApp(TreemapApp());
}

/// This widget will be the root of application.
class TreemapApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Treemap Demo',
      home: MyHomePage(),
    );
  }
}

/// This widget is the home page of the application.
class MyHomePage extends StatefulWidget {
  /// Initialize the instance of the [MyHomePage] class.
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<SocialMediaUsers> _source;

  @override
  void initState() {
    _source = const <SocialMediaUsers>[
      SocialMediaUsers('India', 'Facebook', 25.4),
      SocialMediaUsers('USA', 'Instagram', 19.11),
      SocialMediaUsers('Japan', 'Facebook', 13.3),
      SocialMediaUsers('Germany', 'Instagram', 10.65),
      SocialMediaUsers('France', 'Twitter', 7.54),
      SocialMediaUsers('UK', 'Instagram', 4.93),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Treemap demo')),
      body: SfTreemap(
        dataCount: _source.length,
        weightValueMapper: (int index) {
          return _source[index].usersInMillions;
        },
        levels: <TreemapLevel>[
          TreemapLevel(
            groupMapper: (int index) {
              return _source[index].country;
            },
            labelBuilder: (BuildContext context, TreemapTile tile) {
              return Padding(
                padding: const EdgeInsets.all(2.5),
                child: Text(
                  tile.group,
                  style: const TextStyle(color: Colors.black),
                ),
              );
            },
            tooltipBuilder: (BuildContext context, TreemapTile tile) {
              return Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                    '''Country          : ${tile.group}\nSocial media : ${tile.weight}M''',
                    style: const TextStyle(color: Colors.black)),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Represents the class for social media users.
class SocialMediaUsers {
  /// Constructor of [SocialMediaUsers].
  const SocialMediaUsers(this.country, this.socialMedia, this.usersInMillions);

  /// Specifies the country.
  final String country;

  /// Specifies the type of social media.
  final String socialMedia;

  /// Specifies the users count.
  final double usersInMillions;
}
