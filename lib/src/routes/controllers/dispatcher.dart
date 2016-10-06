part of angel.routes.controllers;

Future<num> assignProxies(String userId, String transactionId, num numProxies, Service Proxies, Service Purchases) async {
  num made = 0;
  var proxies = await Proxies.index();

  for (var proxy in proxies) {
    var purchases = await Purchases.index({"query": where.eq("proxyId", proxy["id"])});

    if (purchases.isEmpty) {
      await Purchases.create({
        "userId": userId,
        "proxyId": proxy["id"],
        "transactionId": transactionId
      });
      made++;
    }

    if (made >= numProxies)
      return made;
  }

  return made;
}