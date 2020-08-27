import 'package:domain/entities/wifi_db_model.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

abstract class WifiRepository {
  ValueListenable<Box<Wifi>> listen();

  List<Wifi> get allWifi;

  void addWifi(Wifi model);

  void editWifi(Wifi model, int index);

  void deleteWifiByIndex(int index);

  Wifi getWifiByIndex(int index);
}
