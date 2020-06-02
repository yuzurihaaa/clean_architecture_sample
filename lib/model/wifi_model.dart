import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'wifi_model.g.dart';

@HiveType(typeId: 0)
class WifiModel extends HiveObject with EquatableMixin {

  @HiveField(0)
  final String wifiName;

  @HiveField(1)
  final double latitude;

  @HiveField(2)
  final double longitude;

  @HiveField(3)
  final double radius;

  WifiModel({
    this.wifiName = '',
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.radius = 0.0,
  });

  @override
  List<Object> get props => [
        wifiName,
        latitude,
        longitude,
        radius,
      ];
}
