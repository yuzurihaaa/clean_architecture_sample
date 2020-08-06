// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ms_MY locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ms_MY';

  static m0(distance) => "${distance}m dari lokasi sekarang";

  static m1(radius) => "Radius: ${radius}";

  static m2(status) => "Status tempat: ${status}";

  static m3(currentStatus) => "Status: ${currentStatus}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "add" : MessageLookupByLibrary.simpleMessage("Tambah"),
    "addWifi" : MessageLookupByLibrary.simpleMessage("Tambah Wifi"),
    "distanceFromLocation" : m0,
    "edit" : MessageLookupByLibrary.simpleMessage("Tukar"),
    "enterAWifiName" : MessageLookupByLibrary.simpleMessage("Isi nama WIFI"),
    "inside" : MessageLookupByLibrary.simpleMessage("dalam"),
    "outside" : MessageLookupByLibrary.simpleMessage("luar"),
    "radius" : m1,
    "setWifiLocation" : MessageLookupByLibrary.simpleMessage("Tetapkan lokasi WIFI"),
    "setWifiRadius" : MessageLookupByLibrary.simpleMessage("Tetapkan radius Wifi"),
    "status" : m2,
    "statusCurrentstatusvalue" : m3,
    "title" : MessageLookupByLibrary.simpleMessage("Ujian Setel"),
    "wifiName" : MessageLookupByLibrary.simpleMessage("Nama Wifi")
  };
}
