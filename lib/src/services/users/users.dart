import 'package:angel_framework/angel_framework.dart';
import 'package:angel_mongo/angel_mongo.dart';
import 'package:json_god/json_god.dart' as god;
import 'package:mongo_dart/mongo_dart.dart';
import 'schema.dart';

@god.WithSchema(UserSchema)
class User extends Model {
  String avatar, displayName, email, googleId, plan, braintreeId;

  User(
      {this.avatar,
      this.braintreeId,
      this.displayName,
      this.email,
      this.googleId,
      this.plan});
}

configureServer(Db db) {
  return (Angel app) async {
    // Lock the service to HTTP
    app.all("/api/users",
        (req, res) async => throw new AngelHttpException.Forbidden());
    app.use("/api/users", new MongoTypedService<User>(db.collection("users")));
  };
}
