import 'package:angel_framework/angel_framework.dart';
import 'package:angel_mongo/angel_mongo.dart';
import 'package:json_god/json_god.dart' as god;
import 'package:mongo_dart/mongo_dart.dart';

class Transaction extends Model {
  double amount;
  String gateway, paymentId, userId;
  Map charge;

  Transaction(
      {this.amount, this.gateway, this.paymentId, this.userId, this.charge});
}

configureServer(Db db) {
  return (Angel app) async {
    // Lock the service to HTTP
    app.all("/api/transactions",
        (req, res) async => throw new AngelHttpException.Forbidden());
    app.use(
        "/api/transactions", new MongoService(db.collection("transactions")), hooked: false);
  };
}
