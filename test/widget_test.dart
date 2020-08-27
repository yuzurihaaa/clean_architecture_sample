import 'package:connectivity/connectivity.dart';
import 'package:data/data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong/latlong.dart' as latLong;
import 'package:location/location.dart';
import 'package:mockito/mockito.dart';
import 'package:setel_assessment/services/services.dart';
import 'package:setel_assessment/utilities/utilities.dart';

class LocationMock extends Mock implements Location {}

class ConnectivityMock extends Mock implements Connectivity {}

/// Unit test of GeofenceService
///
/// Most of the location is hardcoded based on Petronas Twin Tower area
/// (randomly selected point).
/// from https://www.latlong.net/

final startLocation = latLong.LatLng(3.157797, 101.711960);
final endLocation = latLong.LatLng(3.158524, 101.711472);
final endLocation2 = latLong.LatLng(3.159874, 101.712669);

void main() {
  test('Test convert meter to kilometer', () {
    final meter = 10000;
    expect(Utilities.meterToKm(meter), 10.0);

    final meter2 = 15000;
    expect(Utilities.meterToKm(meter2), 15.0);

    final meter3 = 500;
    expect(Utilities.meterToKm(meter3), 0.5);
  });

  test('Test convert kilometer to meter', () {
    final km1 = 1;
    expect(Utilities.kmToMeter(km1), 1000.0);

    final km2 = 1.5;
    expect(Utilities.kmToMeter(km2), 1500.0);

    final meter3 = .5;
    expect(Utilities.kmToMeter(meter3), 500.0);
  });

  test('test check location permission', () async {
    final location = LocationMock();

    final geoFenceUtil = GeofenceService(location: location);

    when(location.serviceEnabled()).thenAnswer((_) => Future.value(true));
    when(location.hasPermission())
        .thenAnswer((_) => Future.value(PermissionStatus.granted));

    expect(await geoFenceUtil.getLocationPermission(), true);
  });

  test('test check location permission service not available', () async {
    final location = LocationMock();

    final geoFenceUtil = GeofenceService(location: location);
    when(location.serviceEnabled()).thenAnswer((_) => Future.value(false));
    when(location.requestService()).thenAnswer((_) => Future.value(true));
    when(location.hasPermission())
        .thenAnswer((_) => Future.value(PermissionStatus.granted));

    expect(await geoFenceUtil.getLocationPermission(), true);
  });

  test(
    'test check location permission service not '
    'available and request fail',
    () async {
      final location = LocationMock();

      final geoFenceUtil = GeofenceService(location: location);
      when(location.serviceEnabled()).thenAnswer((_) => Future.value(false));
      when(location.requestService()).thenAnswer((_) => Future.value(false));

      verifyNever(location.hasPermission());

      expect(await geoFenceUtil.getLocationPermission(), false);
    },
  );

  test('test get current location to use argument if available', () async {
    final geoFenceUtil = GeofenceService();
    final model = WifiModel(
      latitude: 3.157797,
      longitude: 101.71196,
      radius: 200,
      wifiName: 'Some Wifi Name',
    );
    final currentLocation = await geoFenceUtil.getCurrentLocation(model);
    expect(currentLocation.latitude, 3.157797);
    expect(currentLocation.longitude, 101.71196);
  });

  test('test compare wifi name', () async {
    final connectivity = ConnectivityMock();
    when(connectivity.checkConnectivity())
        .thenAnswer((_) => Future.value(ConnectivityResult.wifi));

    when(connectivity.getWifiName())
        .thenAnswer((_) => Future.value('TestWifi'));

    final geoFenceUtil = GeofenceService(connectivity: connectivity);
    final isSameWifi = await geoFenceUtil.isConnectToSpecificWifi('TestWifi');
    expect(isSameWifi, true);
  });

  test('test check if connected to wifi', () async {
    final connectivity = ConnectivityMock();
    when(connectivity.checkConnectivity())
        .thenAnswer((_) => Future.value(ConnectivityResult.mobile));

    when(connectivity.getWifiName())
        .thenAnswer((_) => Future.value('TestWifi'));

    final geoFenceUtil = GeofenceService(connectivity: connectivity);
    final isSameWifi = await geoFenceUtil.isConnectToSpecificWifi('TestWifi');
    expect(isSameWifi, false);
  });

  test('test get distance', () {
    final geoFenceUtil = GeofenceService();
    final distance = geoFenceUtil.distanceInMeter(startLocation, endLocation);
    final expectedDistance = 97.0;
    expect(distance, expectedDistance);
  });

  test('test is in range', () async {
    final location = LocationMock();

    when(location.serviceEnabled()).thenAnswer((_) => Future.value(true));
    when(location.hasPermission())
        .thenAnswer((_) => Future.value(PermissionStatus.granted));

    when(location.getLocation())
        .thenAnswer((_) => Future.value(LocationData.fromMap({
              'latitude': startLocation.latitude,
              'longitude': startLocation.longitude,
            })));

    final geoFenceUtil = GeofenceService(location: location);

    final model = WifiModel(
      latitude: endLocation.latitude,
      longitude: endLocation.longitude,
      radius: 200,
      wifiName: 'Some Wifi Name',
    );

    final isInRange = await geoFenceUtil.verifyDistanceRange(model);
    expect(isInRange, true);
  });

  test('test is in not range', () async {
    final location = LocationMock();

    when(location.serviceEnabled()).thenAnswer((_) => Future.value(true));
    when(location.hasPermission())
        .thenAnswer((_) => Future.value(PermissionStatus.granted));

    when(location.getLocation())
        .thenAnswer((_) => Future.value(LocationData.fromMap({
              'latitude': startLocation.latitude,
              'longitude': startLocation.longitude,
            })));

    final geoFenceUtil = GeofenceService(location: location);

    final model = WifiModel(
      latitude: endLocation2.latitude,
      longitude: endLocation2.longitude,
      radius: 200,
      wifiName: 'Some Wifi Name',
    );

    final isInRange = await geoFenceUtil.verifyDistanceRange(model);
    expect(isInRange, false);
  });
}
