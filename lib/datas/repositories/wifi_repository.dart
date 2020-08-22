import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:setel_assessment/datas/sources/locals/local.dart';
import 'package:setel_assessment/models/models.dart';

class WifiRepository {
  final WifiDao _wifiData;

  WifiRepository(this._wifiData);

  List<WifiModel> get allWifi => _wifiData
      .wifiBox()
      .values
      .map((e) => WifiModel(
            radius: e.radius,
            latitude: e.latitude,
            longitude: e.longitude,
            wifiName: e.wifiName,
          ))
      .toList();

  ValueListenable<Box<WifiDbModel>> listen() =>
      _wifiData.wifiBox().listenable();

  void addWifi(WifiModel model) {
    final db = WifiDbModel(
      wifiName: model.wifiName,
      longitude: model.longitude,
      latitude: model.latitude,
      radius: model.radius,
    );
    _wifiData.addWifi(db);
  }

  void editWifi(WifiModel model, int index) {
    final db = WifiDbModel(
      wifiName: model.wifiName,
      longitude: model.longitude,
      latitude: model.latitude,
      radius: model.radius,
    );
    _wifiData.editWifi(db, index);
  }

  void deleteWifiByIndex(int index) {
    _wifiData.delete(index);
  }

  WifiDbModel getWifiByIndex(int index) => _wifiData.getWifiByIndex(index);
}
