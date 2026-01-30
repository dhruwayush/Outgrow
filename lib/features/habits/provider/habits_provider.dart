import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/habit.dart';
import '../model/slip_event.dart';
import '../repository/habits_repository.dart';
import '../../gamification/badges_provider.dart';

final habitsRepositoryProvider = Provider((ref) => HabitsRepository());

final habitsProvider = AsyncNotifierProvider<HabitsNotifier, List<Habit>>(() {
  return HabitsNotifier();
});

class HabitsNotifier extends AsyncNotifier<List<Habit>> {
  late final HabitsRepository _repository;

  @override
  Future<List<Habit>> build() async {
    _repository = ref.watch(habitsRepositoryProvider);
    return _repository.getHabits();
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

  Future<void> checkIn(String habitId) async {
    // Logic for "I didn't do this today" (Success)
    // Update streak, add checkInDate
    // This is business logic, maybe belongs here or in separate use case.
    // For MVP, here is fine.
    
    final currentList = state.asData?.value;
    if (currentList == null) return;
    
    final habit = currentList.firstWhere((h) => h.id == habitId);
    final now = DateTime.now();
    
    // Check if already checked in today?
    // TODO: Implement check
    
    final newHabit = habit.copyWith(
      currentStreak: habit.currentStreak + 1,
      bestStreak: (habit.currentStreak + 1 > habit.bestStreak) 
          ? habit.currentStreak + 1 
          : habit.bestStreak,
      checkInDates: [...habit.checkInDates, now],
      lastActivityDate: now,
    );
    
    // Badge Logic
    final newStreak = habit.currentStreak + 1;
    if (newStreak >= 1) ref.read(badgesProvider.notifier).unlock('first_step');
    if (newStreak >= 7) ref.read(badgesProvider.notifier).unlock('week_warrior');
    
    await _repository.updateHabit(newHabit);
    state = AsyncValue.data(await _repository.getHabits()); 
  }

  Future<void> slip(String habitId, String trigger) async {
     // Logic for Slip
     // Reset current streak, but keep best. Log slip date.
     final currentList = state.asData?.value;
    if (currentList == null) return;
    
    final habit = currentList.firstWhere((h) => h.id == habitId);
    final now = DateTime.now();

    final newHabit = habit.copyWith(
      currentStreak: 0,
      slipDates: [...habit.slipDates, now],
      lastActivityDate: now,
      slipEvents: [...habit.slipEvents, SlipEvent(date: now, triggers: trigger)],
    );

    // Badge Logic
    ref.read(badgesProvider.notifier).unlock('honest_tracker');

    await _repository.updateHabit(newHabit);
    state = AsyncValue.data(await _repository.getHabits());
  }

  Future<void> deleteHabit(String habitId) async {
    await _repository.deleteHabit(habitId);
    state = AsyncValue.data(await _repository.getHabits());
  }
}
