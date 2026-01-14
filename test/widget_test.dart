import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:workoutwiz/main.dart';
import 'package:workoutwiz/models/user_profile.dart';
import 'package:workoutwiz/services/theme_service.dart';

void main() {
  testWidgets('Setup screen loading test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeService()),
          ChangeNotifierProvider(create: (_) => UserProfileProvider()),
        ],
        child: const WorkoutWizApp(),
      ),
    );

    // Verify that setup screen message is present.
    expect(find.text('Setup Profile'), findsOneWidget);
  });
}
