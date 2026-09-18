import 'package:flutter_test/flutter_test.dart';
import 'package:temple_dash_game/app/app.dart';
import 'package:temple_dash_game/core/services/storage_service.dart';
import 'package:temple_dash_game/core/services/audio_service.dart';
import 'package:get/get.dart';

void main() {
  testWidgets('Temple Dash App smoke test', (WidgetTester tester) async {
    Get.put(StorageService());
    Get.put(AudioService());

    await tester.pumpWidget(const TempleDashApp());
    await tester.pumpAndSettle();
    expect(find.byType(TempleDashApp), findsOneWidget);
  });
}
