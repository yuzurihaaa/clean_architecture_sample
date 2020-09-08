import 'dart:async';

import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:setel_assessment/bloc/wifi_bloc.dart' as wifi_bloc;
import 'package:setel_assessment/generated/l10n.dart';
import 'package:setel_assessment/utilities/utilities.dart';

class AddWifiArgs {
  final WifiEntities model;
  final int index;

  AddWifiArgs({this.model, this.index});
}

/// Custom Hook to get initial data. Preferably to stay within same file usage.
useInitialArg(Function(AddWifiArgs args) onHasData) {
  final context = useContext();
  useEffect(() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final AddWifiArgs args = ModalRoute.of(context).settings.arguments;

      if (args != null) {
        onHasData(args);
      }
    });
    return null;
  }, [false]);
}

class AddWifi extends HookWidget {
  static const screenName = '/addWifi';

  @override
  Widget build(BuildContext context) {
    final radius = useState(0.1);

    final circles = useState<Set<Circle>>(Set.from(<Circle>[]));

    final textController = useTextEditingController.call(text: '');

    final locale = S.current;

    final currentStatus = useState(locale.outside);

    final isEditing = useState(false);

    Future updateStatus() async {
      bool isSameWifi =
          await geoFenceUtil.isConnectToSpecificWifi(textController.text);
      if (isSameWifi) {
        currentStatus.value = locale.inside;
      } else {
        if (circles.value.isEmpty) {
          currentStatus.value = locale.outside;
          return;
        }
        final model = WifiEntities(
          radius: Utilities.kmToMeter(radius?.value),
          latitude: circles.value.first?.center?.latitude,
          longitude: circles.value.first?.center?.longitude,
          wifiName: textController.text,
        );

        bool inArea = await geoFenceUtil.verifyDistanceRange(model);
        currentStatus.value = inArea ? locale.inside : locale.outside;
      }
    }

    useInitialArg((args) {
      isEditing.value = true;
      textController.text = args.model.wifiName;
      radius.value = Utilities.meterToKm(args.model.radius);
      circles.value = Set.from([
        Circle(
          circleId: CircleId('selected'),
          center: LatLng(args.model.latitude, args.model.longitude),
          radius: Utilities.kmToMeter(radius.value),
          fillColor: Colors.green.withOpacity(.2),
          strokeWidth: 2,
          strokeColor: Colors.green,
        )
      ]);
    });

    /// Initializing listener when text change.
    useEffect(() {
      textController.addListener(() async {
        updateStatus();
      });
      return null;
    }, [false]);

    /// Listen to circles and radius change to update status.
    useEffect(() {
      updateStatus();
      return null;
    }, [circles.value, radius.value]);

    useEffect(() {
      if (circles.value.isNotEmpty) {
        circles.value = Set.from([
          circles.value.first.copyWith(
            radiusParam: radius.value * 1000,
          )
        ]);
      }
      return null;
    }, [radius.value, circles.value]);

    void _addOrEditWifi() {
      final model = WifiEntities(
        radius: Utilities.kmToMeter(radius.value),
        latitude: circles.value.first.center.latitude,
        longitude: circles.value.first.center.longitude,
        wifiName: textController.text,
      );
      final AddWifiArgs args = ModalRoute.of(context).settings.arguments;
      // ignore: close_sinks
      final bloc = context.bloc<wifi_bloc.WifiBloc>();
      if (args != null) {
        bloc.add(wifi_bloc.EditWifi(wifi: model, id: args.index));
      } else {
        bloc.add(wifi_bloc.AddWifi(
          wifi: model,
        ));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(locale.addWifi),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(locale.status(currentStatus.value)),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: kDefaultPadding,
            child: Text(locale.wifiName),
          ),
          Padding(
            padding: kDefaultPadding,
            child: TextField(
              controller: textController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: locale.enterAWifiName,
              ),
            ),
          ),
          Padding(
            padding: kDefaultPadding,
            child: Text(locale.setWifiLocation),
          ),
          Expanded(
            child: MapSample(
              circles: circles.value,
              radius: radius.value,
              onTapMap: (latLng) {
                circles.value = Set.from([
                  Circle(
                    circleId: CircleId('selected'),
                    center: LatLng(latLng.latitude, latLng.longitude),
                    radius: radius.value * 1000,
                    fillColor: Colors.green.withOpacity(.2),
                    strokeWidth: 2,
                    strokeColor: Colors.green,
                  )
                ]);
              },
            ),
          ),
          Padding(
            padding: kDefaultPadding,
            child: Text(locale.setWifiRadius),
          ),
          Slider(
            value: radius.value,
            onChanged: circles.value.isEmpty
                ? null
                : (newValue) => radius.value = newValue,
          ),
          Padding(
            padding: kDefaultPadding,
            child: MaterialButton(
              onPressed: () {
                if (circles.value.isEmpty || textController.text.isEmpty) {
                  return;
                }
                try {
                  _addOrEditWifi();
                  Navigator.pop(context);
                } on Error catch (_) {}
              },
              color: Colors.green,
              child: Text(isEditing.value ? locale.edit : locale.add),
            ),
          )
        ],
      ),
    );
  }
}

class MapSample extends HookWidget {
  final double radius;
  final Set<Circle> circles;
  final Function(LatLng location) onTapMap;

  static final CameraPosition _defaultPosition = CameraPosition(
    target: LatLng(0, 0),
  );

  MapSample({
    this.radius,
    this.circles,
    this.onTapMap,
  });

  @override
  Widget build(BuildContext context) {
    final completer = useState(Completer());

    Future jumpToCurrentLocation() async {
      final AddWifiArgs args = ModalRoute.of(context).settings.arguments;
      var focusedLocation = await geoFenceUtil.getCurrentLocation(args?.model);

      final currentPosition = CameraPosition(
        target: LatLng(focusedLocation.latitude, focusedLocation.longitude),
        zoom: 17,
      );

      final GoogleMapController controller = await completer.value.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(currentPosition));
    }

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        jumpToCurrentLocation();
      });
      return null;
    }, [false]);
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _defaultPosition,
      circles: circles,
      onMapCreated: (GoogleMapController controller) {
        completer.value.complete(controller);
      },
      onTap: onTapMap,
    );
  }
}
