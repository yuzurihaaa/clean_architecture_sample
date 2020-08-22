// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wifi_db_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WifiModelAdapter extends TypeAdapter<WifiDbModel> {
  @override
  final typeId = 0;

  @override
  WifiDbModel read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WifiDbModel(
      wifiName: fields[0] as String,
      latitude: fields[1] as double,
      longitude: fields[2] as double,
      radius: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, WifiDbModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.wifiName)
      ..writeByte(1)
      ..write(obj.latitude)
      ..writeByte(2)
      ..write(obj.longitude)
      ..writeByte(3)
      ..write(obj.radius);
  }
}
