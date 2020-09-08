library data;

import 'dart:async';

import 'package:data/models/wifi_hive_model.dart';
import 'package:domain/domain.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

export 'models/wifi_hive_model.dart';

part 'datasources/local/wifi_local_datasources.dart';
part 'repositories/wifi_repository.dart';
