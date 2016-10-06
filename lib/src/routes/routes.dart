/// This app's route configuration.
library angel.routes;

import "dart:io";
import 'package:angel_framework/angel_framework.dart';
import 'package:angel_static/angel_static.dart';
import 'controllers/controllers.dart' as Controllers;

configureBefore(Angel app) async {}

/// Put your app routes here!
configureRoutes(Angel app) async {
  app.get('*', serveStatic());
}

configureAfter(Angel app) async {
  // Push state
  /*
  print("Current ANGEL_ENV: ${Platform.environment['ANGEL_ENV']}");
  String public = Platform.environment["ANGEL_ENV"] == "production" ? "build/web": "web";
  var index = new File("$public/index.html");
  app.after.add((HttpRequest req) async {
    await index.openRead().pipe(req.response);
  });
  */
}

configureServer(Angel app) async {
  await configureBefore(app);
  await app.configure(Controllers.configureServer);
  await configureRoutes(app);
  await configureAfter(app);
}
