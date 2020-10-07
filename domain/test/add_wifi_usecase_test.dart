import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class WifiRepositoryMock extends Mock implements WifiRepository {}

void main() {
  test('Test add wifi', () {
    final wifiRepo = WifiRepositoryMock();
    final addWifiUseCase = AddWifiUseCase(repository: wifiRepo);
    addWifiUseCase(WifiEntities());
    verify(wifiRepo.addWifi(WifiEntities())).called(1);
  });
}
