// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Setel Assessment`
  String get title {
    return Intl.message(
      'Setel Assessment',
      name: 'title',
      desc: '',
      args: [],
    );
  }

  /// `Location status: {status}`
  String status(Object status) {
    return Intl.message(
      'Location status: $status',
      name: 'status',
      desc: '',
      args: [status],
    );
  }

  /// `outside`
  String get outside {
    return Intl.message(
      'outside',
      name: 'outside',
      desc: '',
      args: [],
    );
  }

  /// `inside`
  String get inside {
    return Intl.message(
      'inside',
      name: 'inside',
      desc: '',
      args: [],
    );
  }

  /// `{distance}m from current location`
  String distanceFromLocation(Object distance) {
    return Intl.message(
      '${distance}m from current location',
      name: 'distanceFromLocation',
      desc: '',
      args: [distance],
    );
  }

  /// `Radius: {radius}`
  String radius(Object radius) {
    return Intl.message(
      'Radius: $radius',
      name: 'radius',
      desc: '',
      args: [radius],
    );
  }

  /// `Add`
  String get add {
    return Intl.message(
      'Add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Set Wifi radius`
  String get setWifiRadius {
    return Intl.message(
      'Set Wifi radius',
      name: 'setWifiRadius',
      desc: '',
      args: [],
    );
  }

  /// `Add Wifi`
  String get addWifi {
    return Intl.message(
      'Add Wifi',
      name: 'addWifi',
      desc: '',
      args: [],
    );
  }

  /// `Status: {currentStatus}`
  String statusCurrentstatusvalue(Object currentStatus) {
    return Intl.message(
      'Status: $currentStatus',
      name: 'statusCurrentstatusvalue',
      desc: '',
      args: [currentStatus],
    );
  }

  /// `Wifi Name`
  String get wifiName {
    return Intl.message(
      'Wifi Name',
      name: 'wifiName',
      desc: '',
      args: [],
    );
  }

  /// `Enter a wifi name`
  String get enterAWifiName {
    return Intl.message(
      'Enter a wifi name',
      name: 'enterAWifiName',
      desc: '',
      args: [],
    );
  }

  /// `Set Wifi Location`
  String get setWifiLocation {
    return Intl.message(
      'Set Wifi Location',
      name: 'setWifiLocation',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ms', countryCode: 'MY'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}