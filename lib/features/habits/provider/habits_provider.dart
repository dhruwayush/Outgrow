import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/habit.dart';
import '../model/slip_event.dart';
import '../model/streak.dart';
import '../repository/habits_repository.dart';
import '../../gamification/badges_provider.dart';

final habitsRepositoryProvider = Provider((ref) => HabitsRepository());

final habitsProvider = AsyncNotifierProvider<HabitsNotifier, List<Habit>>(() {
  return HabitsNotifier();
});

class HabitsNotifier extends AsyncNotifier<List<Habit>> {
  HabitsRepository get _repository => ref.read(habitsRepositoryProvider);

  @override
  Future<List<Habit>> build() async {
    return ref.watch(habitsRepositoryProvider).getHabits();
  }

  Habit? _findHabit(String habitId) =>
      state.asData?.value.where((h) => h.id == habitId).firstOrNull;

  Future<void> _save(Habit habit) async {
    await _repository.updateHabit(habit);
    state = AsyncValue.data(await _repository.getHabits());
  }

  Future<void> addHabit(String name, String category) async {
    state = const AsyncValue.loading();
    try {
      final habit = Habit.create(name: name, category: category);
      await _repository.addHabit(habit);
      // Refresh list
      state = AsyncValue.data(await _repository.getHabits());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Logs "I avoided it today". Only one log per day: does nothing if today
  /// already has a check-in or a slip.
  Future<void> checkIn(String habitId) async {
    final habit = _findHabit(habitId);
    if (habit == null) return;

    final now = DateTime.now();
    if (habit.hasCheckedInOn(now) || habit.hasSlippedOn(now)) return;

    final checkInDates = [...habit.checkInDates, now];
    final streak = calculateCurrentStreak(checkInDates, habit.slipDates, now);

    final newHabit = habit.copyWith(
      currentStreak: streak,
      bestStreak: calculateLongestStreak(checkInDates, habit.slipDates),
      checkInDates: checkInDates,
      lastActivityDate: now,
    );

    // Badge Logic
    final badges = ref.read(badgesProvider.notifier);
    if (streak >= 1) badges.unlock('first_step');
    if (streak >= 7) badges.unlock('week_warrior');

    await _save(newHabit);
  }

  /// Logs a slip. Resets the current streak but keeps the best one. A slip
  /// replaces a check-in made earlier the same day, since the day wasn't clean.
  Future<void> slip(String habitId, String trigger, {String? note}) async {
    final habit = _findHabit(habitId);
    if (habit == null) return;

    final now = DateTime.now();
    final checkInDates =
        habit.checkInDates.where((d) => !isSameDay(d, now)).toList();
    final slipDates = [...habit.slipDates, now];
    final trimmedNote = note?.trim();

    final newHabit = habit.copyWith(
      currentStreak: 0,
      bestStreak: calculateLongestStreak(checkInDates, slipDates),
      checkInDates: checkInDates,
      slipDates: slipDates,
      lastActivityDate: now,
      slipEvents: [
        ...habit.slipEvents,
        SlipEvent(
          date: now,
          triggers: trigger,
          note: (trimmedNote == null || trimmedNote.isEmpty) ? null : trimmedNote,
        ),
      ],
    );

    // Badge Logic
    ref.read(badgesProvider.notifier).unlock('honest_tracker');

    await _save(newHabit);
  }

  Future<void> renameHabit(String habitId, String name) async {
    final habit = _findHabit(habitId);
    final trimmed = name.trim();
    if (habit == null || trimmed.isEmpty) return;
    await _save(habit.copyWith(name: trimmed));
  }

  Future<void> deleteHabit(String habitId) async {
    await _repository.deleteHabit(habitId);
    state = AsyncValue.data(await _repository.getHabits());
  }
}
