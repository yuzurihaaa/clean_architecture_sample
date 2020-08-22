import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_it/get_it.dart';
import 'package:location/location.dart';
import 'package:setel_assessment/datas/repositories/repository.dart';
import 'package:setel_assessment/datas/sources/locals/local.dart';
import 'package:setel_assessment/services/geofence.dart';

/// We're using GetIt for Injection(Service locator) so that we don't have to
/// initialize the injected class every time required.
GetIt getIt = GetIt.instance;

/// Function to gather all required class for injection.
void initInjection() {
  getIt.registerSingleton<WifiRepository>(WifiRepository(WifiDao()));
  getIt.registerSingleton<GeofenceService>(GeofenceService.init());
}

Future initDatabase() async {
  await WifiDao.init();
}

/// Lazy var for calling injected [GeoFenceUtil]
final GeofenceService geoFenceUtil = getIt<GeofenceService>();

/// Most probably we're going to use this padding everywhere
const kDefaultPadding = const EdgeInsets.all(8.0);

STATE useBlocListener<BLOC extends Bloc, STATE>({Bloc<Object, STATE> bloc}) {
  final context = useContext();
  // ignore: close_sinks
  final blocObj = bloc ?? BlocProvider.of<BLOC>(context);

  final state = useMemoized(() => blocObj, [blocObj.state]);
  return useStream(state, initialData: blocObj.state).data;
}

LocationData useCurrentLocation() {
  final currentLocation = geoFenceUtil.listenCurrentLocation;

  final state = useMemoized(() => currentLocation);
  return useStream(state, initialData: null)?.data;
}

class Utilities {
  static num kmToMeter(num input) => input * 1000;

  static num meterToKm(num input) => input / 1000;
}
