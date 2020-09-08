part of domain;

abstract class WifiRepository {
  List<WifiEntities> get allWifi;

  void addWifi(WifiEntities model);

  void editWifi(WifiEntities model, int index);

  void deleteWifiByIndex(int index);
}
