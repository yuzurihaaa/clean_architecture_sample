part of domain;

class GetWifiUseCase {
  final WifiRepository _repository;

  GetWifiUseCase({WifiRepository repository}) : _repository = repository;

  List<WifiEntities> call()=> _repository.allWifi;
}
