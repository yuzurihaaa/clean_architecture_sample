part of domain;

class AddWifiUseCase {
  final WifiRepository _repository;

  AddWifiUseCase({WifiRepository repository}) : _repository = repository;

  void call(WifiEntities model) => _repository.addWifi(model);
}
