import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:setel_assessment/add_wifi.dart';

import 'repository/wifi_repository.dart';
import 'utilities/utilities.dart';

Future main() async {
  await WifiRepository.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/addWifi': (_) => AddWifi(),
      },
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends HookWidget {
  final repository = WifiRepository();

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      getPermission();
      return null;
    }, [false]);

    final hiveValue = useValueListenable(repository.wifiBox().listenable());

    return Scaffold(
      appBar: AppBar(
        title: Text('Setel Assessment'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              'Location status: ',
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
