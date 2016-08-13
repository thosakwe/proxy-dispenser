import 'dart:async';
import 'dart:io';
import 'package:angel/angel.dart';
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

  await app.startServer(host, port);
  print("Angel server listening on ${host.address}:${port}");

  dumpRoutes(app);
}

onError(error, [StackTrace stackTrace]) {
  stderr.writeln("Unhandled error occurred: $error");
  if (stackTrace != null) {
    stderr.writeln(stackTrace);
  }
}
