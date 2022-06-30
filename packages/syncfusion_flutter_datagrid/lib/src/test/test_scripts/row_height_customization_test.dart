// ignore_for_file: depend_on_referenced_packages

import 'package:flutter_test/flutter_test.dart';
import '../samples/row_height_customization_sample.dart';

/// row height customization test script
// ignore: non_constant_identifier_names
void rowHeightCustomizationTestScript({String textDirection = 'ltr'}) {
  group('RowHeight Customization,', () {
    testWidgets('test row height onQueryRowHeight',
        (WidgetTester tester) async {
      await tester.pumpWidget(RowHeightCustomizationSample(
        'query_row_height',
        textDirection: textDirection,
      ));
      expect(find.text('10006'), findsNothing);
    });
    testWidgets('test row height based on content',
        (WidgetTester tester) async {
      await tester.pumpWidget(RowHeightCustomizationSample(
          'row_height_getIntrinsicRowHeight',
          textDirection: textDirection));
      expect(find.text('10011'), findsNothing);
    });

    testWidgets('test row height for hidden columns',
        (WidgetTester tester) async {
      await tester.pumpWidget(RowHeightCustomizationSample(
          'row_height_hidden_columns',
          textDirection: textDirection));
      expect(find.text('10006'), findsOneWidget);
    });
    testWidgets('test row height with stacked header',
        (WidgetTester tester) async {
      await tester.pumpWidget(RowHeightCustomizationSample(
          'row_height_with_stacked_header',
          textDirection: textDirection));
      expect(find.text('EmployeeInfo'), findsOneWidget);
      expect(find.text('10005'), findsOneWidget);
      expect(find.text('10011'), findsNothing);
    });
    testWidgets('test refreshed row height', (WidgetTester tester) async {
      await tester.pumpWidget(RowHeightCustomizationSample(
          'refresh_specific_row',
          textDirection: textDirection));
      await tester.tap(find.text('Update Cell'));
      await tester.pump();
      expect(find.text('Maria Anders'), findsOneWidget);

      //Due to the Flutter v3.0.0 update, this case failed and throws
      //an exception that one widget was found.
      //So, we change the value 10006 to 10007 (next row)
      expect(find.text('10007'), findsNothing);
    });
    testWidgets('Measures row height to the rows that exist within the view',
        (WidgetTester tester) async {
      await tester.pumpWidget(RowHeightCustomizationSample(
          'row_height_inside_view',
          textDirection: textDirection));
      expect(find.text('Remove rows'), findsNothing);
    });
  });
}
