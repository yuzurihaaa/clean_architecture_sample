part of data;

class WifiRepositoryImpl implements WifiRepository {
  final WifiLocalDatasource _wifiData;

  WifiRepositoryImpl(this._wifiData);

  @override
  List<WifiEntities> get allWifi => _wifiData.allWifi;

  @override
  void addWifi(WifiEntities model) {
    final db = WifiHiveModel(
      wifiName: model.wifiName,
      longitude: model.longitude,
      latitude: model.latitude,
      radius: model.radius,
    );
    _wifiData.addWifi(db);
  }

  @override
  void editWifi(WifiEntities model, int index) {
    final db = WifiHiveModel(
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
}
