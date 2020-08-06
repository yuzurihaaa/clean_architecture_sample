import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:setel_assessment/generated/l10n.dart';
import 'package:setel_assessment/model/model.dart';
import 'package:setel_assessment/repository/repository.dart';
import 'package:setel_assessment/utilities/utilities.dart';

import 'add_wifi.dart';

class MyHomePage extends HookWidget {
  final repository = getIt<WifiRepository>();

  @override
  Widget build(BuildContext context) {
    final locale = S.current;
    final hiveValue = useValueListenable(repository.wifiBox().listenable());

    final currentLocation = useStream(geoFenceUtil.listenCurrentLocation());

    // Set default to outside.
    final status = useState(locale.outside);

    // Set default to be the first wifi.
    final selected = useState(0);

    // Note that if device coordinates are reported outside of the zone,
    // but the device still connected to the specific Wifi network,
    // then the device is treated as being inside the geofence area.
    Future getData() async {
      if (hiveValue.isEmpty) {
        status.value = locale.outside;
        return;
      }

      final storedItem = hiveValue.getAt(selected.value);

      final isSameWifi =
          await geoFenceUtil.isConnectToSpecificWifi(storedItem.wifiName);

      if (isSameWifi) {
        status.value = locale.inside;
      } else {
        final isInsideBoundary =
            await geoFenceUtil.verifyDistanceRange(storedItem);

        status.value = isInsideBoundary ? locale.inside : locale.outside;
      }
    }

    useEffect(() {
      getData();
      return null;
    }, [hiveValue.length, selected.value, currentLocation.data]);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).title),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: Text(
                S.of(context).status(status.value),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: hiveValue.length,
              shrinkWrap: true,
              itemBuilder: (_, index) {
                final item = hiveValue.getAt(index);
                if (!currentLocation.hasData) {
                  return Container();
                }
                return _ListItem(
                  currentLocation: currentLocation.data,
                  selected: selected.value,
                  index: index,
                  item: item,
                  onTap: () => selected.value = index,
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed('/addWifi'),
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class _ListItem extends StatelessWidget {
  final int index;
  final int selected;
  final WifiModel item;
  final Function onTap;
  final LocationData currentLocation;

  const _ListItem({
    Key key,
    this.index,
    this.selected,
    this.item,
    this.onTap,
    this.currentLocation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentCoordinate = LatLng(
      currentLocation.latitude,
      currentLocation.longitude,
    );
    final itemCoordinate = LatLng(item.latitude, item.longitude);

    final distance =
        geoFenceUtil.distanceInMeter(currentCoordinate, itemCoordinate);

    return Dismissible(
      direction: DismissDirection.endToStart,
      key: UniqueKey(),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          getIt<WifiRepository>().wifiBox().deleteAt(index);
        }
      },
      secondaryBackground: Container(
        padding: kDefaultPadding,
        child: Row(
          children: <Widget>[
            Spacer(),
            Icon(Icons.delete),
          ],
        ),
        color: Colors.red,
      ),
      background: Container(),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: kDefaultPadding,
          color: selected == index
              ? Colors.lightBlueAccent.withOpacity(.5)
              : Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(item?.wifiName ?? ''),
                  Text(S.of(context).radius(item?.radius?.toStringAsFixed(2))),
                  Text(S.of(context).distanceFromLocation(distance)),
                ],
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    AddWifi.screenName,
                    arguments: AddWifiArgs(
                      model: item,
                      index: index,
                    ),
                  );
                },
                icon: Icon(Icons.edit),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
