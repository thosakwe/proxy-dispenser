/// Declare services here!
library angel.services;

import 'package:angel_framework/angel_framework.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'proxies/proxies.dart' as Proxies;
import 'users/users.dart' as Users;

configureServer(Angel app) async {
  Db db = new Db(app.properties["mongo_db"]);
  await db.open();

  await app.configure(Proxies.configureServer);
  await app.configure(Users.configureServer(db));
}
