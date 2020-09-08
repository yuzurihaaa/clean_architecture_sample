import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:domain/domain.dart';
import 'package:equatable/equatable.dart';
import 'package:location/location.dart';
import 'package:setel_assessment/generated/l10n.dart';
import 'package:setel_assessment/services/geofence.dart';
import 'package:setel_assessment/utilities/utilities.dart';

part 'wifi_event.dart';
part 'wifi_state.dart';

class WifiBloc extends Bloc<WifiEvent, WifiState> {
  final AddWifiUseCase addWifiUseCase;
  final GetWifiUseCase getWifiUseCase;
  final EditWifiUseCase editWifiUseCase;
  final DeleteWifiUseCase deleteWifiUseCase;
  final GeofenceService geoFenceUtil;

  WifiBloc({
    this.addWifiUseCase,
    this.getWifiUseCase,
    this.editWifiUseCase,
    this.deleteWifiUseCase,
    this.geoFenceUtil,
  }) : super(WifiState.initial()) {
    add(GetWifi());
    geoFenceUtil.listenCurrentLocation.listen((data) {
      add(UpdateLocation(currentLocation: data));
    });
  }

  factory WifiBloc.initial() => WifiBloc(
        geoFenceUtil: getIt.get<GeofenceService>(),
        addWifiUseCase: getIt.get<AddWifiUseCase>(),
        getWifiUseCase: getIt.get<GetWifiUseCase>(),
        editWifiUseCase: getIt.get<EditWifiUseCase>(),
        deleteWifiUseCase: getIt.get<DeleteWifiUseCase>(),
      );

  @override
  Stream<WifiState> mapEventToState(
    WifiEvent event,
  ) async* {
    if (event is AddWifi) {
      addWifiUseCase(event.wifi);
      add(GetWifi());
    }

    if (event is EditWifi) {
      editWifiUseCase(event.wifi, event.id);
      add(GetWifi());
    }

    if (event is DeleteWifi) {
      deleteWifiUseCase(event.id);
      add(GetWifi());
    }

    if (event is GetWifi) {
      final List<WifiEntities> wifis = getWifiUseCase();

      yield state.copyWith(wifi: wifis);
    }

    if (event is UpdateStatus) {
      final allWifis = getWifiUseCase();

      String status = S.current.outside;

      if (allWifis.isEmpty) {
        yield state.copyWith(
          status: status,
        );
        return;
      }

      final storedItem = allWifis[event.selectedId];

      final isSameWifi =
          await geoFenceUtil.isConnectToSpecificWifi(storedItem.wifiName);

      if (isSameWifi) {
        status = S.current.inside;
      } else {
        final isInsideBoundary =
            await geoFenceUtil.verifyDistanceRange(storedItem);

        status = isInsideBoundary ? S.current.inside : S.current.outside;
      }

      yield state.copyWith(
        status: status,
      );
    }

    if (event is UpdateLocation) {
      yield state.copyWith(
        currentLocation: event.currentLocation,
      );
    }
  }
}
