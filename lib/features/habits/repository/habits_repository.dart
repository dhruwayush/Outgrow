import 'package:hive_flutter/hive_flutter.dart';
import '../model/habit.dart';

class HabitsRepository {
  static const String _boxName = 'habits';

  Future<Box<Habit>> get _box async => await Hive.openBox<Habit>(_boxName);

  Future<List<Habit>> getHabits() async {
    final box = await _box;
    return box.values.toList();
  }

  Future<void> addHabit(Habit habit) async {
    final box = await _box;
    await box.put(habit.id, habit);
  }

  Future<void> updateHabit(Habit habit) async {
    final box = await _box;
    await box.put(habit.id, habit); // Hive update is same as put with same key
  }

  Future<void> deleteHabit(String id) async {
    final box = await _box;
    await box.delete(id);
  }
}
