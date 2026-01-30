// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slip_event.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SlipEventAdapter extends TypeAdapter<SlipEvent> {
  @override
  final int typeId = 1;

  @override
  SlipEvent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SlipEvent(
      date: fields[0] as DateTime,
      triggers: fields[1] as String,
      note: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SlipEvent obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.triggers)
      ..writeByte(2)
      ..write(obj.note);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SlipEventAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
