import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:setel_assessment/generated/l10n.dart';
import 'package:setel_assessment/widgets/widget.dart';

import 'bloc/wifi_bloc.dart' hide AddWifi;
import 'utilities/utilities.dart';

Future main() async {
  await initDatabase();
  initInjection();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<WifiBloc>(
      create: (_) => WifiBloc.initial(),
      child: MaterialApp(
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
          MyHomePage.screenName: (_) => MyHomePage(),
          AddWifi.screenName: (_) => AddWifi(),
        },
        initialRoute: MyHomePage.screenName,
      ),
    );
  }
}
