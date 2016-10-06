/// Your very own web application!
library angel;

import 'dart:async';
import "dart:io";
import 'package:angel_framework/angel_framework.dart';
import "package:json_god/json_god.dart" as god;
import 'src/config/config.dart' as configuration;
import 'src/routes/routes.dart' as routes;
import 'src/services/services.dart' as services;

/// Creates and configures the server instance.
Future<Angel> createServer() async {
  Angel app = new ProxySlots();

  await app.configure(configuration.configureServer);
  await app.configure(services.configureServer);
  await app.configure(routes.configureServer);

  return app;
}

class ProxySlots extends Angel {}
