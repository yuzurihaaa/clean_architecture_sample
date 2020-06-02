import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:latlong/latlong.dart';
import 'package:setel_assessment/generated/l10n.dart';
import 'package:setel_assessment/repository/repository.dart';
import 'package:setel_assessment/utilities/utilities.dart';

class MyHomePage extends HookWidget {
  final repository = WifiRepository();

  @override
  Widget build(BuildContext context) {
    final locale = S.of(context);
    final hiveValue = useValueListenable(repository.wifiBox().listenable());

    // Set default to outside.
    final status = useState(locale.outside);

    Future getData() async {
      if (hiveValue.isEmpty) {
        status.value = locale.outside;
        return;
      }

      final hasPermission = await getPermission();

      if (hasPermission) {
        final currentLocation = await getCurrentLocation();

        final storedLocation = hiveValue.get('0');

        // From https://pub.dev/packages/latlong#-readme-tab-
        final Distance distanceObject = Distance();
        final distanceInMeter = distanceObject(
          LatLng(currentLocation.latitude, currentLocation.longitude),
          LatLng(storedLocation.latitude, storedLocation.longitude),
        );

        status.value = distanceInMeter < storedLocation.radius
            ? locale.inside
            : locale.outside;
      }
    }

    useEffect(() {
      getData();
      return null;
    }, [hiveValue.length]);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              S.of(context).status(status.value),
            ),
            ListView.builder(
              itemCount: hiveValue.length,
              shrinkWrap: true,
              itemBuilder: (_, index) => Dismissible(
                direction: DismissDirection.endToStart,
                key: Key('$index'),
                onDismissed: (direction) {
                  if (direction == DismissDirection.endToStart) {
                    repository.wifiBox().delete('$index');
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
                child: Padding(
                  padding: kDefaultPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(hiveValue.get('$index').wifiName),
                      Text('${hiveValue.get('$index').radius} km')
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed('/addWifi'),
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
