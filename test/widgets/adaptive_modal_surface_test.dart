import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sked/widgets/adaptive_modal_surface.dart';

Future<void> _pumpHostPage(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (context) {
          return Scaffold(
            body: Center(
              child: FilledButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const _SurfaceHostPage(),
                    ),
                  );
                },
                child: const Text('Open host'),
              ),
            ),
          );
        },
      ),
    ),
  );
}

class _SurfaceHostPage extends StatelessWidget {
  const _SurfaceHostPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FilledButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const _SurfaceRoutePage(),
              ),
            );
          },
          child: const Text('Open surface'),
        ),
      ),
    );
  }
}

class _SurfaceRoutePage extends StatelessWidget {
  const _SurfaceRoutePage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AdaptiveModalSurface(
        maxWidth: 420,
        dismissOnOutsideTap: true,
        child: SizedBox(
          height: 160,
          child: Center(child: Text('Surface content')),
        ),
      ),
    );
  }
}

Future<void> _pumpRouteTransition(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
}

void main() {
  testWidgets('outside tap dismisses only the sheet on rapid duplicate taps', (
    tester,
  ) async {
    await _pumpHostPage(tester);

    await tester.tap(find.text('Open host'));
    await _pumpRouteTransition(tester);

    await tester.tap(find.text('Open surface'));
    await _pumpRouteTransition(tester);

    expect(find.text('Surface content'), findsOneWidget);

    await tester.tapAt(const Offset(20, 20));
    await tester.tapAt(const Offset(20, 20));
    await _pumpRouteTransition(tester);

    expect(find.text('Surface content'), findsNothing);
    expect(find.text('Open surface'), findsOneWidget);
    expect(find.text('Open host'), findsNothing);
    expect(find.text('Open host', skipOffstage: false), findsOneWidget);
  });
}
