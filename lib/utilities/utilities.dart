import 'package:flutter/widgets.dart';
import 'package:location/location.dart';

const kDefaultPadding = const EdgeInsets.all(8.0);

Future<bool> getPermission() async {
  Location location = Location();
  bool _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return false;
    }
  }

  PermissionStatus _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return false;
    }
  }

  return true;
}

Future<LocationData> getCurrentLocation() async {
  final location = Location();
  return await location.getLocation();
}
