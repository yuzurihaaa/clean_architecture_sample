import 'package:connectivity/connectivity.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:setel_assessment/model/model.dart';

/// Most probably we're going to use this padding everywhere
const kDefaultPadding = const EdgeInsets.all(8.0);

/// This function is basically a copy paste from
/// https://pub.dev/packages/location#usage
///
/// but only for permission handling.
Future<bool> getLocationPermission() async {
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

/// Part of https://pub.dev/packages/location#usage
Future<LocationData> getCurrentLocation([WifiModel arg]) async {
  if (arg != null) {
    return LocationData.fromMap({
      'latitude': arg.latitude,
      'longitude': arg.longitude,
    });
  }
  final location = Location();
  return await location.getLocation();
}

/// Part of https://pub.dev/packages/location#usage
///
/// This should be paired for hook.
Stream<LocationData> listenCurrentLocation() => Location().onLocationChanged;

/// One of the requirement for geofencing is
/// > specific Wifi network name
///
/// refer:
///     Geofence area is defined as a combination of some geographic point,
///     radius, and specific Wifi network name. A device is considered to be
///     inside of the geofence area if the device is connected to the specified
///     WiFi network or remains geographically inside the defined circle.
/// paragraph 2.
Future<bool> isConnectToSpecificWifi(String wifiNameArg) async {
  final connectivity = Connectivity();
  var connectivityResult = await connectivity.checkConnectivity();
  if (connectivityResult != ConnectivityResult.wifi) {
    return false;
  }

  final wifiName = await connectivity.getWifiName();
  return wifiName == wifiNameArg;
}

/// From https://pub.dev/packages/latlong#-readme-tab-
/// Function to calculate the distance based on meter.
/// This [Distance] library do the calculation, hence we can ignore the testing.
num distanceInMeter(LatLng start, LatLng end) {
  final distanceObject = Distance();
  return distanceObject(start, end);
}

/// Function to check distance based on item.
/// Refer [_distanceInMeter] on getting the distance.
/// This function merely check permission, get current location and
/// use [Distance] to get the range.
Future<bool> verifyDistanceRange(WifiModel arg) async {
  final hasPermission = await getLocationPermission();

  if (hasPermission) {
    final currentLocation = await getCurrentLocation();

    final distance = distanceInMeter(
      LatLng(currentLocation.latitude, currentLocation.longitude),
      LatLng(arg.latitude, arg.longitude),
    );

    return distance < arg.radius;
  }

  return false;
}

num toKm(num input) => input * 1000;
num fromKm(num input) => input / 1000;

GetIt getIt = GetIt.instance;
