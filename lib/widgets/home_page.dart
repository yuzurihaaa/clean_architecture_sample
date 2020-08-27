import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:setel_assessment/bloc/wifi_bloc.dart' hide AddWifi;
import 'package:setel_assessment/generated/l10n.dart';
import 'package:setel_assessment/utilities/utilities.dart';
import 'package:setel_assessment/widgets/widget.dart';

class MyHomePage extends HookWidget {
  static const screenName = '/homePage';

  @override
  Widget build(BuildContext context) {
    final blocState = useBlocListener<WifiBloc, WifiState>();

    // Set default to be the first wifi.
    final selected = useState(0);

    useEffect(() {
      // ignore: close_sinks
      final _bloc = context.bloc<WifiBloc>();
      _bloc.add(UpdateStatus(selectedId: selected.value));
      return null;
    }, [
      selected.value,
      blocState,
      blocState.wifi,
    ]);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).title),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: Text(
                blocState.status,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: blocState.wifi.length,
              shrinkWrap: true,
              itemBuilder: (_, index) {
                final item = blocState.wifi[index];
                if (blocState.currentLocation == null) {
                  return Container();
                }
                return _ListItem(
                  currentLocation: blocState.currentLocation,
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
  final Wifi item;
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
          context.bloc<WifiBloc>().add(DeleteWifi(
                id: index,
              ));
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
                onPressed: () async {
                  await Navigator.of(context).pushNamed(
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
