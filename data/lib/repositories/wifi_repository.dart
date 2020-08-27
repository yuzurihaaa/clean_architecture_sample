import 'package:domain/domain.dart';
import 'package:domain/repositories/wifi_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../datasources/local/local.dart';

class WifiRepositoryImpl implements WifiRepository {
  final WifiLocalDatasource _wifiData;

  WifiRepositoryImpl(this._wifiData);

  @override
  List<Wifi> get allWifi => _wifiData.allWifi;

  @override
  ValueListenable<Box<Wifi>> listen() => _wifiData.listenToData();

  @override
  void addWifi(Wifi model) {
    final db = Wifi(
      wifiName: model.wifiName,
      longitude: model.longitude,
      latitude: model.latitude,
      radius: model.radius,
    );
    _wifiData.addWifi(db);
  }

  @override
  void editWifi(Wifi model, int index) {
    final db = Wifi(
      wifiName: model.wifiName,
      longitude: model.longitude,
      latitude: model.latitude,
      radius: model.radius,
    );
    _wifiData.editWifi(db, index);
  }

  @override
  void deleteWifiByIndex(int index) {
    _wifiData.delete(index);
  }

  @override
  Wifi getWifiByIndex(int index) => _wifiData.getWifiByIndex(index);
}
