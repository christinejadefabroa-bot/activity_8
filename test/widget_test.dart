
import 'package:flutter_test/flutter_test.dart';
import 'package:fabroa_project/app.dart';

void main() {
  testWidgets(
    'FabroaProjectApp builds successfully',
    (WidgetTester tester) async {
      // Launch the application.
      await tester.pumpWidget(const FabroaProjectApp());

      // Check that the main app widget exists.
      expect(find.byType(FabroaProjectApp), findsOneWidget);

      // Check that no exception occurred during the initial build.
      expect(tester.takeException(), isNull);
    },
  );
}
