part of domain;

class WifiEntities with EquatableMixin {
  final String wifiName;

  final double latitude;

  final double longitude;

  final double radius;

  WifiEntities({
    this.wifiName,
    this.latitude,
    this.longitude,
    this.radius,
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
