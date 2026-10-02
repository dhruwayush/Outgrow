import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:outgrow/features/gamification/badges_provider.dart';
import 'package:outgrow/features/habits/model/habit.dart';
import 'package:outgrow/features/habits/model/slip_event.dart';
import 'package:outgrow/features/habits/provider/habits_provider.dart';

void main() {
  late Directory tempDir;
  late ProviderContainer container;

  setUpAll(() {
    Hive.registerAdapter(HabitAdapter());
    Hive.registerAdapter(SlipEventAdapter());
  });

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('outgrow_test');
    Hive.init(tempDir.path);
    await Hive.openBox<Habit>('habits');
    await Hive.openBox('settings');
    container = ProviderContainer();
  });

  tearDown(() async {
    container.dispose();
    await Hive.deleteFromDisk();
    await tempDir.delete(recursive: true);
  });

  HabitsNotifier notifier() => container.read(habitsProvider.notifier);
  Future<Habit> onlyHabit() async => (await container.read(habitsProvider.future)).single;

  Future<Habit> createHabit() async {
    await container.read(habitsProvider.future);
    await notifier().addHabit('Smoking', 'smoking');
    return onlyHabit();
  }

  test('checking in twice on the same day only counts once', () async {
    final habit = await createHabit();

    await notifier().checkIn(habit.id);
    await notifier().checkIn(habit.id);

    final updated = await onlyHabit();
    expect(updated.checkInDates, hasLength(1));
    expect(updated.activeStreak, 1);
    expect(updated.currentStreak, 1);
    expect(container.read(badgesProvider), contains('first_step'));
  });

  test('a slip replaces a check-in from earlier the same day', () async {
    final habit = await createHabit();

    await notifier().checkIn(habit.id);
    await notifier().slip(habit.id, 'Stress', note: '  after work  ');

    final updated = await onlyHabit();
    expect(updated.checkInDates, isEmpty);
    expect(updated.slipDates, hasLength(1));
    expect(updated.activeStreak, 0);
    expect(updated.slipEvents.single.triggers, 'Stress');
    expect(updated.slipEvents.single.note, 'after work');
  });

  test('cannot check in after slipping the same day', () async {
    final habit = await createHabit();

    await notifier().slip(habit.id, 'Boredom');
    await notifier().checkIn(habit.id);

    expect((await onlyHabit()).checkInDates, isEmpty);
  });

  test('an empty slip note is stored as null', () async {
    final habit = await createHabit();

    await notifier().slip(habit.id, 'Tired', note: '   ');

    expect((await onlyHabit()).slipEvents.single.note, isNull);
  });

  test('renameHabit trims and ignores blank names', () async {
    final habit = await createHabit();

    await notifier().renameHabit(habit.id, '  Cigarettes ');
    expect((await onlyHabit()).name, 'Cigarettes');

    await notifier().renameHabit(habit.id, '   ');
    expect((await onlyHabit()).name, 'Cigarettes');
  });

  test('actions on an unknown habit id are ignored', () async {
    await createHabit();

    await notifier().checkIn('missing');
    await notifier().slip('missing', 'Stress');

    final habit = await onlyHabit();
    expect(habit.checkInDates, isEmpty);
    expect(habit.slipDates, isEmpty);
  });
}
