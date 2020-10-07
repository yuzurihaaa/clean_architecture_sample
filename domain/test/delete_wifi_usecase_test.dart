import 'package:domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class WifiRepositoryMock extends Mock implements WifiRepository {}

void main() {
  test('Test delete wifi by index', () {
    final wifiRepo = WifiRepositoryMock();
    final deleteWifiUseCase = DeleteWifiUseCase(repository: wifiRepo);
    deleteWifiUseCase(1);
    verify(wifiRepo.deleteWifiByIndex(1)).called(1);
  });
}
