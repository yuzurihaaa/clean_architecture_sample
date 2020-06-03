import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:setel_assessment/generated/l10n.dart';
import 'package:setel_assessment/widget/add_wifi.dart';

import 'repository/wifi_repository.dart';
import 'utilities/utilities.dart';
import 'widget/home_page.dart';

Future main() async {
  initInjection();
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
      localizationsDelegates: [
        // ... app-specific localization delegate[s] here
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        S.delegate,
      ],
      supportedLocales: [...S.delegate.supportedLocales],
      routes: {
        AddWifi.screenName: (_) => AddWifi(),
      },
      home: MyHomePage(),
    );
  }
}
