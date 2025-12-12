import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';

void main() {
  return runApp(const ThemeSample());
}

class ThemeSample extends StatelessWidget {
  const ThemeSample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SfTheme(
          data: SfThemeData(
            // Add the corresponding theme data here to customize the default appearance
            // of the Syncfusion® Flutter widget, which you are using.
          ),
          child: Container(
            // Replace this container with any Syncfusion® Flutter widgets according to your needs.
          ),
        ),
      ),
    );
  }
}
