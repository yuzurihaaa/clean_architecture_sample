part of 'wifi_bloc.dart';

abstract class WifiEvent extends Equatable {
  const WifiEvent();
}

class GetWifi extends WifiEvent {
  @override
  List<Object> get props => [];
}

class AddWifi extends WifiEvent {
  final WifiModel wifi;

  AddWifi({this.wifi});

  @override
  List<Object> get props => [this.wifi];
}

class EditWifi extends WifiEvent {
  final WifiModel wifi;
  final int id;

  EditWifi({this.wifi, this.id});

  @override
  List<Object> get props => [
        wifi,
        id,
      ];
}

class DeleteWifi extends WifiEvent {
  final int id;

  DeleteWifi({this.id});

  @override
  List<Object> get props => [id];
}

class UpdateStatus extends WifiEvent {
  final int selectedId;

  UpdateStatus({this.selectedId});

  @override
  List<Object> get props => [selectedId];
}

class UpdateLocation extends WifiEvent {
  final LocationData currentLocation;

  UpdateLocation({this.currentLocation});

  @override
  List<Object> get props => [currentLocation];
}
