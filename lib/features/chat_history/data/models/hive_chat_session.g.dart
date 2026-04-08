// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_chat_session.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveChatSessionAdapter extends TypeAdapter<HiveChatSession> {
  @override
  final int typeId = 1;

  @override
  HiveChatSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveChatSession(
      id: fields[0] as String,
      coachId: fields[1] as String,
      coachName: fields[2] as String,
      messages: (fields[3] as List).cast<HiveChatMessage>(),
      lastUpdated: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, HiveChatSession obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.coachId)
      ..writeByte(2)
      ..write(obj.coachName)
      ..writeByte(3)
      ..write(obj.messages)
      ..writeByte(4)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveChatSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
