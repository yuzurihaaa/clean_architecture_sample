// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wifi_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WifiModelAdapter extends TypeAdapter<WifiModel> {
  @override
  final typeId = 0;

  @override
  WifiModel read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WifiModel(
      wifiName: fields[0] as String,
      latitude: fields[1] as double,
      longitude: fields[2] as double,
      radius: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, WifiModel obj) {
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
