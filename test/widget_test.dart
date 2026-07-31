import 'package:flutter_test/flutter_test.dart';
import 'package:pose_snap_ai/app.dart';

void main() {
  testWidgets('PoseSnap AI app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const PoseSnapApp());
  });
}
