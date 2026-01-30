// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HabitAdapter extends TypeAdapter<Habit> {
  @override
  final int typeId = 0;

  @override
  Habit read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Habit(
      id: fields[0] as String,
      name: fields[1] as String,
      category: fields[2] as String,
      startDate: fields[3] as DateTime,
      currentStreak: fields[4] as int,
      bestStreak: fields[5] as int,
      checkInDates: (fields[6] as List).cast<DateTime>(),
      slipDates: (fields[7] as List).cast<DateTime>(),
      lastActivityDate: fields[8] as DateTime?,
      slipEvents:
          fields[9] == null ? [] : (fields[9] as List).cast<SlipEvent>(),
    );
  }

  @override
  void write(BinaryWriter writer, Habit obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.startDate)
      ..writeByte(4)
      ..write(obj.currentStreak)
      ..writeByte(5)
      ..write(obj.bestStreak)
      ..writeByte(6)
      ..write(obj.checkInDates)
      ..writeByte(7)
      ..write(obj.slipDates)
      ..writeByte(8)
      ..write(obj.lastActivityDate)
      ..writeByte(9)
      ..write(obj.slipEvents);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
