// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:connectivity/connectivity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong/latlong.dart' as latLong;
import 'package:location/location.dart';
import 'package:mockito/mockito.dart';
import 'package:setel_assessment/model/model.dart';
import 'package:setel_assessment/utilities/utilities.dart';

class LocationMock extends Mock implements Location {}

class ConnectivityMock extends Mock implements Connectivity {}

/// Unit test of GeoFenceUtil
///
/// Most of the location is hardcoded based on Petronas Twin Tower area
/// (randomly selected point).
/// from https://www.latlong.net/

final startLocation = latLong.LatLng(3.157797, 101.711960);
final endLocation = latLong.LatLng(3.158524, 101.711472);
final endLocation2 = latLong.LatLng(3.159874, 101.712669);

void main() {
  test('Test convert meter to kilometer', () {
    final location = LocationMock();

    final geoFenceUtil = GeoFenceUtil(location: location);

    final meter = 10000;
    expect(geoFenceUtil.meterToKm(meter), 10.0);

    final meter2 = 15000;
    expect(geoFenceUtil.meterToKm(meter2), 15.0);

    final meter3 = 500;
    expect(geoFenceUtil.meterToKm(meter3), 0.5);
  });

  test('Test convert kilometer to meter', () {
    final location = LocationMock();

    final geoFenceUtil = GeoFenceUtil(location: location);

    final km1 = 1;
    expect(geoFenceUtil.kmToMeter(km1), 1000.0);

    final km2 = 1.5;
    expect(geoFenceUtil.kmToMeter(km2), 1500.0);

    final meter3 = .5;
    expect(geoFenceUtil.kmToMeter(meter3), 500.0);
  });

  test('test check location permission', () async {
    final location = LocationMock();

    final geoFenceUtil = GeoFenceUtil(location: location);

    when(location.serviceEnabled()).thenAnswer((_) => Future.value(true));
    when(location.hasPermission())
        .thenAnswer((_) => Future.value(PermissionStatus.granted));

    expect(await geoFenceUtil.getLocationPermission(), true);
  });

  test('test check location permission service not available', () async {
    final location = LocationMock();

    final geoFenceUtil = GeoFenceUtil(location: location);
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

      final geoFenceUtil = GeoFenceUtil(location: location);
      when(location.serviceEnabled()).thenAnswer((_) => Future.value(false));
      when(location.requestService()).thenAnswer((_) => Future.value(false));

      verifyNever(location.hasPermission());

      expect(await geoFenceUtil.getLocationPermission(), false);
    },
  );

  test('test get current location to use argument if available', () async {
    final geoFenceUtil = GeoFenceUtil();
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

    final geoFenceUtil = GeoFenceUtil(connectivity: connectivity);
    final isSameWifi = await geoFenceUtil.isConnectToSpecificWifi('TestWifi');
    expect(isSameWifi, true);
  });

  test('test check if connected to wifi', () async {
    final connectivity = ConnectivityMock();
    when(connectivity.checkConnectivity())
        .thenAnswer((_) => Future.value(ConnectivityResult.mobile));

    when(connectivity.getWifiName())
        .thenAnswer((_) => Future.value('TestWifi'));

    final geoFenceUtil = GeoFenceUtil(connectivity: connectivity);
    final isSameWifi = await geoFenceUtil.isConnectToSpecificWifi('TestWifi');
    expect(isSameWifi, false);
  });

  test('test get distance', () {
    final geoFenceUtil = GeoFenceUtil();
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

    final geoFenceUtil = GeoFenceUtil(location: location);

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

    final geoFenceUtil = GeoFenceUtil(location: location);

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
