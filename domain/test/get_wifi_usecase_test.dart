import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class WifiRepositoryMock extends Mock implements WifiRepository {}

void main() {
  test('Test get wifi', () {
    final wifiRepo = WifiRepositoryMock();
    final getWifiUseCase = GetWifiUseCase(repository: wifiRepo);
    getWifiUseCase();
    verify(wifiRepo.allWifi).called(1);
  });
}
