#!/usr/bin/env dart

import 'dart:async';
import 'dart:io';
import 'package:angel/angel.dart';
import 'package:angel_diagnostics/angel_diagnostics.dart';
import 'package:angel_framework/angel_framework.dart';

main() async {
  runZoned(startServer, onError: onError);
}

dumpRoutes(Angel app) {
  for (Route route in app.routes) {
    print("${route.method} ${route.path} -> ${route.handlers}");
  }
}

startServer() async {
  Angel app = await createServer();
  InternetAddress host = new InternetAddress(app.properties['host']);
  int port = app.properties['port'];

  var diagnostics = new DiagnosticsServer(app, new File("logs/log.txt"));
  dumpRoutes(diagnostics);

  await diagnostics.startServer(host, port);
}

onError(error, [StackTrace stackTrace]) {
  stderr.writeln("Unhandled error occurred: $error");
  if (stackTrace != null) {
    stderr.writeln(stackTrace);
  }
}
