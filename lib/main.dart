import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:setel_assessment/widget/add_wifi.dart';

import 'repository/wifi_repository.dart';
import 'widget/home_page.dart';

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
