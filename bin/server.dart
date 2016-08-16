import 'dart:async';
import 'dart:io';
import 'package:angel/angel.dart';
import 'package:angel_framework/angel_framework.dart';
import "package:http/http.dart" as http;
import "package:json_god/json_god.dart" as god;
import "package:paypal_rest_api/paypal_rest_api.dart";
import "package:paypal_rest_api/paypal_client.dart";

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

  var paypal = app.properties["paypal"];
  var client = new PayPalClient(new http.Client(), paypal["id"], paypal["secret"], paypalEndpoint: "https://api.sandbox.paypal.com");

  dumpRoutes(app);
}

onError(error, [StackTrace stackTrace]) {
  stderr.writeln("Unhandled error occurred: $error");
  if (stackTrace != null) {
    stderr.writeln(stackTrace);
  }
}
