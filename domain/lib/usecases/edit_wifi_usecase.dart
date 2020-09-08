part of domain;

class EditWifiUseCase {
  final WifiRepository _repository;

  EditWifiUseCase({WifiRepository repository}) : _repository = repository;

  void call(WifiEntities model, int index) =>
      _repository.editWifi(model, index);

  void deleteWifiByIndex(int index) => _repository.deleteWifiByIndex(index);
}
