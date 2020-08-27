import 'package:domain/domain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class WifiLocalDatasource {
  ValueListenable<Box<Wifi>> listenToData();

  List<Wifi> get allWifi;

  Wifi getWifiByIndex(int index);

  void addWifi(Wifi model);

  void editWifi(Wifi model, int index);

  void delete(int index);
}

class WifiLocalDatasourceImpl implements WifiLocalDatasource {
  static const wifiBoxDbName = 'wifi_box';

  /// Hive is needed to be init in [main] function.
  /// Boxes are also required to be open before usage.
  /// Since our first screen is using Hive, we open it before [runApp]
  /// is called.
  ///
  /// Refer https://docs.hivedb.dev/
  static Future init() async {
    await Hive.initFlutter();
    Hive.registerAdapter<Wifi>(WifiModelAdapter());
    await Hive.openBox<Wifi>(WifiLocalDatasourceImpl.wifiBoxDbName);
  }

  Box<Wifi> _wifiBox() => Hive.box<Wifi>(WifiLocalDatasourceImpl.wifiBoxDbName);

  @override
  Wifi getWifiByIndex(int index) {
    return _wifiBox().getAt(index);
  }

  @override
  void addWifi(Wifi model) {
    final box = _wifiBox();

    box.add(model);
  }

  @override
  void editWifi(Wifi model, int index) {
    final box = _wifiBox();
    final oldData = box.getAt(index);
    oldData.radius = model.radius;
    oldData.wifiName = model.wifiName;
    oldData.longitude = model.longitude;
    oldData.latitude = model.latitude;
    oldData.save();
  }

  @override
  void delete(int index) {
    _wifiBox().deleteAt(index);
  }

  @override
  ValueListenable<Box<Wifi>> listenToData() => _wifiBox().listenable();

  @override
  List<Wifi> get allWifi => _wifiBox()
      .values
      .map((e) => Wifi(
            radius: e.radius,
            latitude: e.latitude,
            longitude: e.longitude,
            wifiName: e.wifiName,
          ))
      .toList();
}
