import 'package:domain/domain.dart';
import 'package:equatable/equatable.dart';

class WifiModel extends Wifi with EquatableMixin {
  WifiModel({
    String wifiName = '',
    double latitude = 0.0,
    double longitude = 0.0,
    double radius = 0.0,
  }) : super(
          wifiName: wifiName,
          latitude: latitude,
          longitude: longitude,
          radius: radius,
        );

  @override
  List<Object> get props => [
        wifiName,
        latitude,
        longitude,
        radius,
      ];

  @override
  String toString() => '''WifiModel(wifiName: $wifiName,
          latitude: $latitude,
          longitude: $longitude,
          radius: $radius,
       )''';
}
