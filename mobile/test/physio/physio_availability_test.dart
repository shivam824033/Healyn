import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healyn/features/availability/data/availability_api.dart';
import 'package:healyn/features/availability/data/availability_repository.dart';
import 'package:healyn/features/availability/data/models/availability_models.dart';
import 'package:healyn/features/availability/presentation/availability_format.dart';
import 'package:healyn/features/availability/presentation/screens/availability_blackout_form_screen.dart';
import 'package:healyn/features/availability/presentation/screens/availability_rule_form_screen.dart';
import 'package:healyn/features/physio/presentation/screens/physio_availability_screen.dart';
import 'package:healyn/features/shared/network/api_exception.dart';

final _dummyRule = AvailabilityRule(
  id: 'r',
  physiotherapistId: 'p',
  dayOfWeek: 1,
  startTime: '09:00:00',
  endTime: '17:00:00',
  slotMinutes: 30,
  timezone: 'Asia/Kolkata',
  effectiveFrom: DateTime(2026, 1, 1),
);

final _dummyBlackout = BlackoutWindow(
  id: 'b',
  physiotherapistId: 'p',
  startsAt: DateTime.utc(2026, 6, 15, 10),
  endsAt: DateTime.utc(2026, 6, 15, 11),
);

AvailabilityRule _rule({
  required String id,
  required int dayOfWeek,
  String startTime = '09:00:00',
  String endTime = '13:00:00',
  DateTime? effectiveTo,
}) => AvailabilityRule(
  id: id,
  physiotherapistId: 'p',
  dayOfWeek: dayOfWeek,
  startTime: startTime,
  endTime: endTime,
  slotMinutes: 30,
  timezone: 'Asia/Kolkata',
  effectiveFrom: DateTime(2026, 1, 1),
  effectiveTo: effectiveTo,
);

/// Captures the request objects so the real repository's wire formatting is
/// exercised end to end.
class _RecordingApi extends AvailabilityApi {
  _RecordingApi() : super(Dio());

  CreateRuleRequest? ruleReq;
  CreateBlackoutRequest? blackoutReq;

  @override
  Future<AvailabilityRule> createRule(CreateRuleRequest body) async {
    ruleReq = body;
    return _dummyRule;
  }

  @override
  Future<BlackoutWindow> createBlackout(CreateBlackoutRequest body) async {
    blackoutReq = body;
    return _dummyBlackout;
  }
}

class _FakeRepo extends AvailabilityRepository {
  _FakeRepo({this.rules = const [], this.blackouts = const []})
    : super(AvailabilityApi(Dio()));

  final List<AvailabilityRule> rules;
  final List<BlackoutWindow> blackouts;
  String? deletedRuleId;
  String? deletedBlackoutId;

  @override
  Future<List<AvailabilityRule>> listRules() async => rules;

  @override
  Future<List<BlackoutWindow>> listBlackouts() async => blackouts;

  @override
  Future<void> deleteRule(String id) async => deletedRuleId = id;

  @override
  Future<void> deleteBlackout(String id) async => deletedBlackoutId = id;
}

class _RecordingRepo extends AvailabilityRepository {
  _RecordingRepo() : super(AvailabilityApi(Dio()));

  Map<String, Object?>? lastRule;

  @override
  Future<List<AvailabilityRule>> listRules() async => const [];

  @override
  Future<List<BlackoutWindow>> listBlackouts() async => const [];

  @override
  Future<AvailabilityRule> createRule({
    required int dayOfWeek,
    required String startTime,
    required String endTime,
    required int slotMinutes,
    required String timezone,
    required DateTime effectiveFrom,
    DateTime? effectiveTo,
  }) async {
    lastRule = {
      'dayOfWeek': dayOfWeek,
      'startTime': startTime,
      'endTime': endTime,
      'slotMinutes': slotMinutes,
      'timezone': timezone,
      'effectiveFrom': effectiveFrom,
    };
    return _dummyRule;
  }
}

class _OverlapRepo extends AvailabilityRepository {
  _OverlapRepo() : super(AvailabilityApi(Dio()));

  @override
  Future<BlackoutWindow> createBlackout({
    required DateTime startsAt,
    required DateTime endsAt,
    String? reason,
  }) async {
    throw const ApiException(
      code: 'availability.blackout_overlap',
      message: 'Blackout overlaps an existing window for this physiotherapist',
      statusCode: 409,
    );
  }
}

void _useTallSurface(WidgetTester tester) {
  tester.view.physicalSize = const Size(1000, 2200);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Future<void> _pumpHub(WidgetTester tester, _FakeRepo repo) async {
  _useTallSurface(tester);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [availabilityRepositoryProvider.overrideWithValue(repo)],
      child: const MaterialApp(home: PhysioAvailabilityScreen()),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _pumpOverLauncher(
  WidgetTester tester,
  Widget screen,
  AvailabilityRepository repo,
) async {
  _useTallSurface(tester);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [availabilityRepositoryProvider.overrideWithValue(repo)],
      child: MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (_) => screen),
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}

void main() {
  group('format', () {
    test('dayOfWeekLabel maps the 0=Sun..6=Sat wire convention', () {
      expect(dayOfWeekLabel(0), 'Sunday');
      expect(dayOfWeekLabel(1), 'Monday');
      expect(dayOfWeekLabel(6), 'Saturday');
    });

    test('dayDisplayOrder sorts Monday-first, Sunday last', () {
      expect(dayDisplayOrder(1), 0); // Mon
      expect(dayDisplayOrder(6), 5); // Sat
      expect(dayDisplayOrder(0), 6); // Sun
    });

    test('formatClockTime renders 12-hour wire strings', () {
      expect(formatClockTime('09:00:00'), '9:00 AM');
      expect(formatClockTime('13:30'), '1:30 PM');
      expect(formatClockTime('00:00:00'), '12:00 AM');
    });

    test('formatTimeRange joins start and end', () {
      expect(formatTimeRange('09:00:00', '13:00:00'), '9:00 AM – 1:00 PM');
    });

    test('formatBlackoutRange collapses a same-day window', () {
      final s = DateTime(2026, 6, 15, 9);
      final e = DateTime(2026, 6, 15, 11);
      expect(formatBlackoutRange(s, e), contains('9:00 AM – 11:00 AM'));
      expect(formatBlackoutRange(s, e), contains('·'));
    });

    test('formatBlackoutRange spans two days with an arrow', () {
      final s = DateTime(2026, 6, 15, 22);
      final e = DateTime(2026, 6, 16, 8);
      expect(formatBlackoutRange(s, e), contains('→'));
    });
  });

  group('repository wire formatting', () {
    test('createRule sends date-only effectiveFrom and omits effectiveTo', () async {
      final api = _RecordingApi();
      final repo = AvailabilityRepository(api);

      await repo.createRule(
        dayOfWeek: 1,
        startTime: '09:00:00',
        endTime: '13:00:00',
        slotMinutes: 30,
        timezone: 'Asia/Kolkata',
        effectiveFrom: DateTime(2026, 6, 5, 14, 30),
      );

      expect(api.ruleReq!.effectiveFrom, '2026-06-05');
      expect(api.ruleReq!.effectiveTo, isNull);
      expect(api.ruleReq!.startTime, '09:00:00');
      expect(api.ruleReq!.dayOfWeek, 1);
    });

    test('createBlackout converts instants to UTC and trims/drops reason', () async {
      final api = _RecordingApi();
      final repo = AvailabilityRepository(api);

      await repo.createBlackout(
        startsAt: DateTime(2026, 6, 15, 10),
        endsAt: DateTime(2026, 6, 15, 11),
        reason: '  Personal  ',
      );
      expect(api.blackoutReq!.startsAt.isUtc, isTrue);
      expect(api.blackoutReq!.endsAt.isUtc, isTrue);
      expect(api.blackoutReq!.reason, 'Personal');

      await repo.createBlackout(
        startsAt: DateTime(2026, 6, 16, 10),
        endsAt: DateTime(2026, 6, 16, 11),
        reason: '   ',
      );
      expect(api.blackoutReq!.reason, isNull);
    });
  });

  group('availability hub', () {
    testWidgets('lists active working hours and time off, hiding archived rules', (
      tester,
    ) async {
      await _pumpHub(
        tester,
        _FakeRepo(
          rules: [
            _rule(id: 'r1', dayOfWeek: 3), // Wednesday
            _rule(id: 'r2', dayOfWeek: 1), // Monday
            _rule(
              id: 'r3',
              dayOfWeek: 5,
              effectiveTo: DateTime(2026, 1, 2),
            ), // archived → hidden
          ],
          blackouts: [_dummyBlackout],
        ),
      );

      expect(find.text('Monday'), findsOneWidget);
      expect(find.text('Wednesday'), findsOneWidget);
      expect(find.text('Friday'), findsNothing); // archived rule hidden
      // Monday sorts above Wednesday.
      expect(
        tester.getTopLeft(find.text('Monday')).dy,
        lessThan(tester.getTopLeft(find.text('Wednesday')).dy),
      );
      // The blackout window is shown.
      expect(find.textContaining('–'), findsWidgets);
    });

    testWidgets('shows empty hints when nothing is configured', (tester) async {
      await _pumpHub(tester, _FakeRepo());
      expect(find.textContaining('No working hours yet'), findsOneWidget);
      expect(find.text('No time off scheduled.'), findsOneWidget);
    });

    testWidgets('removing working hours confirms then calls deleteRule', (
      tester,
    ) async {
      final repo = _FakeRepo(rules: [_rule(id: 'r1', dayOfWeek: 1)]);
      await _pumpHub(tester, repo);

      await tester.tap(find.byTooltip('Remove working hours'));
      await tester.pumpAndSettle();
      expect(find.text('Remove working hours?'), findsOneWidget);

      await tester.tap(find.text('Remove'));
      await tester.pumpAndSettle();
      expect(repo.deletedRuleId, 'r1');
    });
  });

  group('rule form', () {
    testWidgets('saving adds working hours with the chosen wire values', (
      tester,
    ) async {
      final repo = _RecordingRepo();
      await _pumpOverLauncher(
        tester,
        const AvailabilityRuleFormScreen(),
        repo,
      );

      await tester.tap(
        find.widgetWithText(ElevatedButton, 'Add working hours'),
      );
      await tester.pumpAndSettle(const Duration(seconds: 5));

      expect(repo.lastRule, isNotNull);
      expect(repo.lastRule!['dayOfWeek'], 1);
      expect(repo.lastRule!['startTime'], '09:00:00');
      expect(repo.lastRule!['endTime'], '17:00:00');
      // The grid defaults to 15-minute cells (V25); 9–17 aligns on them.
      expect(repo.lastRule!['slotMinutes'], 15);
      expect(repo.lastRule!['timezone'], 'Asia/Kolkata');
    });

    testWidgets('a misaligned slot length blocks saving', (tester) async {
      await _pumpOverLauncher(
        tester,
        const AvailabilityRuleFormScreen(),
        _RecordingRepo(),
      );

      // 9:00–17:00 does not sit on 45-minute boundaries. The grid defaults to
      // 15-minute cells, so open the dropdown from there.
      await tester.tap(find.text('15 minutes'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('45 minutes').last);
      await tester.pumpAndSettle();

      expect(find.textContaining('45-minute boundaries'), findsOneWidget);
      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Add working hours'),
      );
      expect(button.onPressed, isNull);
    });
  });

  group('blackout form', () {
    testWidgets('an overlapping window surfaces the server message', (
      tester,
    ) async {
      await _pumpOverLauncher(
        tester,
        const AvailabilityBlackoutFormScreen(),
        _OverlapRepo(),
      );

      await tester.tap(find.widgetWithText(ElevatedButton, 'Add time off'));
      await tester.pumpAndSettle();

      expect(
        find.text(
          'Blackout overlaps an existing window for this physiotherapist',
        ),
        findsOneWidget,
      );
    });
  });
}
