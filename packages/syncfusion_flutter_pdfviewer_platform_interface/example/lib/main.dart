import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'Syncfusion PDF Viewer Demo for Web',
    theme: ThemeData(
      useMaterial3: false,
    ),
    home: const HomePage(),
  ));
}

/// Represents Homepage for Navigation
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Syncfusion Flutter PDF Viewer'),
      ),
      body: const Text('PDF Viewer'),
    );
  }
}
