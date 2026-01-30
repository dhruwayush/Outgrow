import 'package:hive/hive.dart';

part 'slip_event.g.dart';

@HiveType(typeId: 1)
class SlipEvent extends HiveObject {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final String triggers; // Comma separated string or specific trigger

  @HiveField(2)
  final String? note;

  SlipEvent({
    required this.date,
    required this.triggers,
    this.note,
  });
}
