// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderModelAdapter extends TypeAdapter<OrderModel> {
  @override
  final int typeId = 1;

  @override
  OrderModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderModel(
      name: fields[1] as String,
      type: fields[2] as String,
      contact: fields[3] as String,
      address: fields[4] as String?,
      notes: fields[5] as String?,
      id: fields[0] as int?,
      completed: fields[6] as bool,
      measurements: (fields[7] as Map).cast<String, String>(),
      date: fields[8] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, OrderModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.contact)
      ..writeByte(4)
      ..write(obj.address)
      ..writeByte(5)
      ..write(obj.notes)
      ..writeByte(6)
      ..write(obj.completed)
      ..writeByte(7)
      ..write(obj.measurements)
      ..writeByte(8)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class IncomeModelAdapter extends TypeAdapter<IncomeModel> {
  @override
  final int typeId = 2;

  @override
  IncomeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IncomeModel(
      orderId: fields[1] as int,
      amount: fields[2] as double,
      date: fields[3] as DateTime,
      id: fields[0] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, IncomeModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.orderId)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IncomeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
