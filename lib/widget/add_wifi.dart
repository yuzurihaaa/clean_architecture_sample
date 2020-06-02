import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:setel_assessment/model/model.dart';
import 'package:setel_assessment/utilities/utilities.dart';

import '../repository/wifi_repository.dart';

class AddWifiArgs {
  final WifiModel model;
  final int index;

  AddWifiArgs({this.model, this.index});
}

class AddWifi extends HookWidget {

  static const screenName = '/addWifi';
  @override
  Widget build(BuildContext context) {
    final radius = useState(0.1);

    final circles = useState<Set<Circle>>(Set.from(<Circle>[]));

    final textController = useTextEditingController();

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        final AddWifiArgs args = ModalRoute.of(context).settings.arguments;

        if (args != null) {
          textController.text = args.model.wifiName;
          print(radius.value);

          radius.value = fromKm(args.model.radius);

          circles.value = Set.from([
            Circle(
              circleId: CircleId('selected'),
              center: LatLng(args.model.latitude, args.model.longitude),
              radius: toKm(radius.value),
              fillColor: Colors.green.withOpacity(.2),
              strokeWidth: 2,
              strokeColor: Colors.green,
            )
          ]);
        }
      });
      return null;
    }, [false]);

    useEffect(() {
      if (circles.value.isNotEmpty) {
        circles.value = Set.from([
          circles.value.first.copyWith(
            radiusParam: radius.value * 1000,
          )
        ]);
      }
      return null;
    }, [radius.value]);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Wifi'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text('Wifi Name'),
          TextField(
            controller: textController,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Enter a wifi name',
            ),
          ),
          Text('Set Wifi Location'),
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
          Text('Set Wifi radius'),
          Slider(
            value: radius.value,
            onChanged: (newValue) => radius.value = newValue,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MaterialButton(
              onPressed: () {
                if (circles.value.isEmpty || textController.text.isEmpty) {
                  return;
                }
                try {
                  final model = WifiModel(
                    radius: toKm(radius.value),
                    latitude: circles.value.first.center.latitude,
                    longitude: circles.value.first.center.longitude,
                    wifiName: textController.text,
                  );
                  final AddWifiArgs args =
                      ModalRoute.of(context).settings.arguments;
                  final repository = getIt<WifiRepository>();
                  if (args != null) {
                    repository.editWifi(model, args.index);
                  } else {
                    repository.addWifi(model);
                  }

                  Navigator.pop(context);
                } on Error catch (_) {}
              },
              color: Colors.green,
              child: Text('Add'),
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
      var focusedLocation = await getCurrentLocation(args?.model);

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
