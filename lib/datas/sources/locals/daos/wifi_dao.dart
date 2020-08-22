import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:setel_assessment/datas/sources/locals/models/wifi_db_model.dart';

class WifiDao {
  static const wifiBoxDbName = 'wifi_box';

  /// Hive is needed to be init in [main] function.
  /// Boxes are also required to be open before usage.
  /// Since our first screen is using Hive, we open it before [runApp]
  /// is called.
  ///
  /// Refer https://docs.hivedb.dev/
  static Future init() async {
    await Hive.initFlutter();
    Hive.registerAdapter<WifiDbModel>(WifiModelAdapter());
    await Hive.openBox<WifiDbModel>(WifiDao.wifiBoxDbName);
  }

  Box<WifiDbModel> wifiBox() => Hive.box<WifiDbModel>(WifiDao.wifiBoxDbName);

  WifiDbModel getWifiByIndex(int index) {
    return wifiBox().getAt(index);
  }

  void addWifi(WifiDbModel model) {
    final box = wifiBox();

    box.add(model);
  }

  void editWifi(WifiDbModel model, int index) {
    final box = wifiBox();
    final oldData = box.getAt(index);
    oldData.radius = model.radius;
    oldData.wifiName = model.wifiName;
    oldData.longitude = model.longitude;
    oldData.latitude = model.latitude;
    oldData.save();
  }

  void delete(int index) {
    wifiBox().deleteAt(index);
  }
}
