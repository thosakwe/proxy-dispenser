import "dart:async";
import "package:angel_framework/angel_framework.dart";
import "package:angel_mongo/angel_mongo.dart";
import "package:mongo_dart/mongo_dart.dart";

configureServer(Db db) {
  return (Angel app) async {
    app.all("/api/proxies*", (req, res) async => "Access denied");
    app.use("/api/proxies", new ProxyDispenserService(db.collection("proxies")),
        hooked: false);
  };
}

@Middleware(const ["auth"])
class ProxyDispenserService extends MongoService {
  ProxyDispenserService(DbCollection collection) : super(collection);
}
