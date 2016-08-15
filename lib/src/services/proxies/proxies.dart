import "dart:async";
import "package:angel_framework/angel_framework.dart";
import "package:mongo_dart/mongo_dart.dart";

configureServer(Db db) {
  return (Angel app) async {
    app.use("/api/proxies", new ProxyDispenserService(db.collection("proxies")), hooked: false);
  };
}

@Middleware(const ["auth"])
class ProxyDispenserService extends Service {
  DbCollection _collection;

  ProxyDispenserService(this._collection) :super();

  // Todo: Update this to fetch proxies
  @override
  Future<List> index([Map params]) {
    if (params["provider"] != null)
      throw new AngelHttpException.NotFound();

    var limit = params["limit"];

    if (limit == null || !(limit is int))
      throw new AngelHttpException.BadRequest(message: "Invalid limit: must be an integer");

    return _collection.find(where.limit(limit)).toList();
  }
}
