import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class WifiRepositoryMock extends Mock implements WifiRepository {}

void main() {
  test('Test edit wifi', () {
    final wifiRepo = WifiRepositoryMock();
    final editWifi = EditWifiUseCase(repository: wifiRepo);
    editWifi(WifiEntities(), 1);
    verify(wifiRepo.editWifi(WifiEntities(), 1)).called(1);
  });
}
