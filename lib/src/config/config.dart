/// Configuration for this Angel instance.
library angel.config;

import 'dart:io';
import 'package:angel_configuration/angel_configuration.dart';
import 'package:angel_framework/angel_framework.dart';
import 'package:angel_mustache/angel_mustache.dart';
import "package:angel_websocket/server.dart";

/// This is a perfect place to include configuration and load plug-ins.
configureServer(Angel app) async {
  await app.configure(loadConfigurationFile());
  await app.configure(mustache(new Directory('views')));
  await app.configure(new AngelWebSocket("/ws"));
}
