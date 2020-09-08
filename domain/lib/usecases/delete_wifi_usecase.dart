part of domain;

class DeleteWifiUseCase {
  final WifiRepository _repository;

  DeleteWifiUseCase({WifiRepository repository}) : _repository = repository;

  void call(int index) => _repository.deleteWifiByIndex(index);
}
