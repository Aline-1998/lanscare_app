import 'package:flutter_test/flutter_test.dart';
import 'package:lanscare_app/main.dart';

void main() {
  testWidgets('LansCare App onboarding smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the onboarding screen renders successfully.
    // It should have onboarding text or buttons like "Selanjutnya".
    expect(find.textContaining('LansCare'), findsWidgets);
    expect(find.text('Selanjutnya'), findsOneWidget);
  });
}
