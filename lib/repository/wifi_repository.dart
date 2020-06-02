import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:setel_assessment/model/model.dart';

class WifiRepository {
  static const wifiBoxDbName = 'wifi_box';

  static Future init() async {
    await Hive.initFlutter();
    Hive.registerAdapter<WifiModel>(WifiModelAdapter());
    await Hive.openBox<WifiModel>(WifiRepository.wifiBoxDbName);
  }

  Box<WifiModel> wifiBox() =>
      Hive.box<WifiModel>(WifiRepository.wifiBoxDbName);

  void addWifi(WifiModel model) {
    final box = wifiBox();

    box.add(model);
  }
}
