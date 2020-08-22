import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:location/location.dart';
import 'package:setel_assessment/datas/repositories/repository.dart';
import 'package:setel_assessment/generated/l10n.dart';
import 'package:setel_assessment/models/models.dart';
import 'package:setel_assessment/services/geofence.dart';
import 'package:setel_assessment/utilities/utilities.dart';

part 'wifi_event.dart';
part 'wifi_state.dart';

class WifiBloc extends Bloc<WifiEvent, WifiState> {
  final WifiRepository repository;
  final GeofenceService geoFenceUtil;

  WifiBloc({
    this.repository,
    this.geoFenceUtil,
  }) : super(WifiState.initial()) {
    add(GetWifi());
    geoFenceUtil.listenCurrentLocation.listen((data) {
      add(UpdateLocation(currentLocation: data));
    });
  }

  factory WifiBloc.initial() => WifiBloc(
        geoFenceUtil: getIt.get<GeofenceService>(),
        repository: getIt.get<WifiRepository>(),
      );

  @override
  Stream<WifiState> mapEventToState(
    WifiEvent event,
  ) async* {
    if (event is AddWifi) {
      repository.addWifi(event.wifi);
      add(GetWifi());
    }

    if (event is EditWifi) {
      repository.editWifi(event.wifi, event.id);
      add(GetWifi());
    }

    if (event is DeleteWifi) {
      repository.deleteWifiByIndex(event.id);
      add(GetWifi());
    }

    if (event is GetWifi) {
      final List<WifiModel> wifis = repository.allWifi;

      yield state.copyWith(wifi: wifis);
    }

    if (event is UpdateStatus) {
      final allWifis = repository.allWifi;

      String status = S.current.outside;

      if (allWifis.isEmpty) {
        yield state.copyWith(
          status: status,
        );
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
