import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/shared/widgets/copyable_id.dart';

void main() {
  testWidgets('tapping copies the value to the clipboard and confirms', (
    tester,
  ) async {
    final calls = <MethodCall>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') calls.add(call);
        return null;
      },
    );
    addTearDown(() {
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      );
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: CopyableId(value: 'PHY-20260613-1001')),
      ),
    );

    expect(find.text('PHY-20260613-1001'), findsOneWidget);

    await tester.tap(find.byType(CopyableId));
    await tester.pump(); // let the clipboard call + snackbar settle

    expect(calls, hasLength(1));
    expect(
      (calls.single.arguments as Map)['text'],
      'PHY-20260613-1001',
    );
    expect(find.text('Copied'), findsOneWidget);
  });
}
