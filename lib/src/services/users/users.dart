import 'package:angel_framework/angel_framework.dart';
import 'package:angel_mongo/angel_mongo.dart';
import 'package:json_god/json_god.dart' as god;
import 'package:mongo_dart/mongo_dart.dart';
import 'schema.dart';

@god.WithSchema(UserSchema)
class User extends Model {
  Map<String, dynamic> google;

  User({this.google});
}
configureServer(Db db) {
  return (Angel app) async {
    // Removed original code - user system will not be an open API

    /*app.use("/api/users", new MongoTypedService<User>(db.collection("users")));

    HookedService service = app.service("api/users");

    // Place your hooks here!
    service.beforeCreated.listen(hashPassword);*/
  };
}
