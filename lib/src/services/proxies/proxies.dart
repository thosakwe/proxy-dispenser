import "dart:async";
import "package:angel_framework/angel_framework.dart";

configureServer(Angel app) async {
  app.use("/api/proxies", new ProxyDispenserService());
}

@Middleware(const ["auth"])
class ProxyDispenserService extends Service {

  // Todo: Update this to fetch proxies
  @override
  Future<List> index([Map params]) async => [];
}