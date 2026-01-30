import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'slip_event.dart';

part 'habit.g.dart';

@HiveType(typeId: 0)
class Habit extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String category; // 'smoking', 'instagram', etc. for icon mapping

  @HiveField(3)
  final DateTime startDate;

  @HiveField(4)
  final int currentStreak;

  @HiveField(5)
  final int bestStreak;

  @HiveField(6)
  final List<DateTime> checkInDates; // Dates where user said "I didn't do it" (Success)

  @HiveField(7)
  final List<DateTime> slipDates; // Dates where user slipped

  @HiveField(8)
  final DateTime? lastActivityDate;

  @HiveField(9, defaultValue: [])
  final List<SlipEvent> slipEvents;

  Habit({
    required this.id,
    required this.name,
    required this.category,
    required this.startDate,
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.checkInDates = const [],
    this.slipDates = const [],
    this.lastActivityDate,
    this.slipEvents = const [],
  });

  factory Habit.create({required String name, required String category}) {
    return Habit(
      id: const Uuid().v4(),
      name: name,
      category: category,
      startDate: DateTime.now(),
    );
  }

  Habit copyWith({
    String? name,
    String? category,
    int? currentStreak,
    int? bestStreak,
    List<DateTime>? checkInDates,
    List<DateTime>? slipDates,
    DateTime? lastActivityDate,
    List<SlipEvent>? slipEvents,
  }) {
    return Habit(
      id: id,
      name: name ?? this.name,
      category: category ?? this.category,
      startDate: startDate,
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      checkInDates: checkInDates ?? this.checkInDates,
      slipDates: slipDates ?? this.slipDates,
      lastActivityDate: lastActivityDate ?? this.lastActivityDate,
      slipEvents: slipEvents ?? this.slipEvents,
    );
  }
}
