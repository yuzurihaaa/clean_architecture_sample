import 'package:equatable/equatable.dart';

class WifiModel extends Equatable {
  final String wifiName;

  final double latitude;

  final double longitude;

  final double radius;

  const WifiModel({
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

  @override
  String toString() => '''WifiModel(wifiName: $wifiName,
          latitude: $latitude,
          longitude: $longitude,
          radius: $radius,
       )''';
}
