part of data;

abstract class WifiLocalDatasource {
  Stream<List<WifiHiveModel>> listenToData();

  List<WifiHiveModel> get allWifi;

  WifiHiveModel getWifiByIndex(int index);

  void addWifi(WifiHiveModel model);

  void editWifi(WifiHiveModel model, int index);

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
    Hive.registerAdapter<WifiHiveModel>(WifiHiveModelAdapter());
    await Hive.openBox<WifiHiveModel>(WifiLocalDatasourceImpl.wifiBoxDbName);
  }

  final StreamController<List<WifiHiveModel>> _wifiStream = StreamController<
      List<WifiHiveModel>>();

  WifiLocalDatasourceImpl() {
    _wifiBox().listenable().addListener(() {
      _wifiStream.add(_wifiBox().values.toList());
    });
  }

  Box<WifiHiveModel> _wifiBox() =>
      Hive.box<WifiHiveModel>(WifiLocalDatasourceImpl.wifiBoxDbName);

  @override
  WifiHiveModel getWifiByIndex(int index) {
    return _wifiBox().getAt(index);
  }

  @override
  void addWifi(WifiHiveModel model) {
    final box = _wifiBox();

    box.add(model);
  }

  @override
  void editWifi(WifiHiveModel model, int index) {
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
  Stream<List<WifiHiveModel>> listenToData() => _wifiStream.stream;

  @override
  List<WifiHiveModel> get allWifi =>
      _wifiBox()
          .values
          .map((e) =>
          WifiHiveModel(
            radius: e.radius,
            latitude: e.latitude,
            longitude: e.longitude,
            wifiName: e.wifiName,
          ))
          .toList();
}
