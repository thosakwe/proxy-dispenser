import 'package:angel_framework/angel_framework.dart';
import 'package:angel_mongo/angel_mongo.dart';
import 'package:json_god/json_god.dart' as god;
import 'package:mongo_dart/mongo_dart.dart';

class Purchase extends Model {
  String userId, proxyId, transactionId;

  Purchase({this.userId, this.proxyId, this.transactionId});
}

configureServer(Db db) {
  return (Angel app) async {
    // Lock the service to HTTP
    app.all("/api/purchases",
        (req, res) async => throw new AngelHttpException.Forbidden());
    app.use("/api/purchases", new MongoTypedService<Purchase>(db.collection("purchases")));
  };
}
