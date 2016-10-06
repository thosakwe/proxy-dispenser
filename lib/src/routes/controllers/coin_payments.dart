part of angel.routes.controllers;

@Expose("/api/coin_payments")
class CoinPaymentsController extends Controller {
  String baseUrl, ipnSecret, merchantId;
  CoinClient client;
  Map coinPayments;
  Service Proxies, Purchases, Transactions, PaymentNotifications;
  final RegExp _basic = new RegExp(r"^(B|b)asic\s*");

  @override
  call(Angel app) async {
    await super.call(app);

    coinPayments = app.properties["coin_payments"];
    client = new CoinClient(coinPayments["public"], coinPayments["private"],
        app.properties["base_url"]);
    ipnSecret = coinPayments["ipn_secret"];
    merchantId = coinPayments["merchant_id"];
    baseUrl = app.properties["base_url"];
    Proxies = app.service("api/proxies");
    Purchases = app.service("api/purchases");
    Transactions = app.service("api/transactions");

    // Set up a tiny notification service
    app.use("/api/payment_notifications", new CoinPaymentsNotificationService());
    PaymentNotifications = app.service("api/payment_notifications");
  }

  @Expose("/pay", method: "POST", middleware: const ["auth"])
  pay(RequestContext req) {
    var amount = req.body["amount"];

    if (amount == null || amount is! num)
      throw new AngelHttpException.BadRequest(
          message: "Amount must be a number.");

    return client.createTransaction(
        amount, req.session["user"].email, req.session["userId"]);
  }

  @Expose("/ipn_callback", method: "POST")
  ipnCallback(RequestContext req) async {
    var authHeader = req.headers.value(HttpHeaders.AUTHORIZATION);

    if (authHeader == null || authHeader.isEmpty)
      throw new AngelHttpException.BadRequest();
    else
      authHeader = authHeader.replaceAll(_basic, "");
    String authString = new String.fromCharCodes(BASE64.decode(authHeader));
    var split = authString.split(":");

    if (split == null || split is! List || split.length < 2)
      throw new AngelHttpException.BadRequest();

    if (!(split[0] == merchantId && split[1] == ipnSecret)) {
      throw new AngelHttpException.NotAuthenticated();
    }

    if (req.body["status"] == null ||
        req.body["subtotal"] == null ||
        req.body["txn_id"] == null ||
        req.body["buyer_name"] == null)
      throw new AngelHttpException.BadRequest(
          message: "Status, txn_id, buyer_name and subtotal required.");

    /*var status = req.body["status"] is num
        ? req.body["status"]
        : num.parse(req.body["status"]);*/
    var amount = req.body["subtotal"] is num
        ? req.body["subtotal"]
        : num.parse(req.body["subtotal"]);
    var txnId = req.body["txn_id"];
    var userId = req.body["buyer_name"];

    if (req.body["status"].toString() != "100")
      return {"error": "Payment incomplete"};

    num numProxies = howManyProxies(amount);

    var transactionData = {
      "amount": amount,
      "gateway": "paypal",
      "paymentId": txnId,
      "charge": req.body,
      "userId": userId
    };

    var transaction = await Transactions.create(transactionData);

    num made = await assignProxies(userId,
        transaction["id"], numProxies, Proxies, Purchases);

    if (made >= numProxies) {
      PaymentNotifications.create({"userId": userId});
      return {"error": "success"};
    }
    else
      return {"error": notEnoughProxies(numProxies, made)};
  }
}

class CoinClient extends http.BaseClient {
  String publicKey, privateKey, baseUrl;
  http.Client _inner = new http.Client();

  CoinClient(this.publicKey, this.privateKey, this.baseUrl);

  _buildHmac(queryString) async {
    var node =
        await Process.start("node", ["make_hmac.js", privateKey, queryString]);
    await node.exitCode;
    return (await node.stdout.transform(UTF8.decoder).join()).trim();
  }

  _makeQuery(Map data) {
    var result = [];

    for (var key in data.keys) {
      result.add("$key=${Uri.encodeQueryComponent(data[key].toString())}");
    }

    return result.join("&");
  }

  @override
  send(request) {
    print("Sending ${request.method} to: ${request.url}");
    print("Found headers: ${request.headers}");
    print("Found body: ${request.body}");
    return _inner.send(request);
  }

  createTransaction(num amount, String buyerEmail, String userId) async {
    var data = new SplayTreeMap.from({
      "version": 1,
      "key": publicKey,
      "amount": amount,
      "cmd": "create_transaction",
      "currency1": "USD",
      "currency2": "BTC",
      "buyer_email": buyerEmail,
      "buyer_name": userId,
      "ipn_url": "$baseUrl/api/coin_payments/ipn_callback"
    });

    var queryString = _makeQuery(data);
    var hmac = await _buildHmac(queryString);
    var response = await post("https://www.coinpayments.net/api.php",
        body: queryString, headers: {"HMAC": hmac, HttpHeaders.CONTENT_TYPE: "application/x-www-form-urlencoded"});
    print("Coin Payments response: ${response.body}");
    return JSON.decode(response.body);
  }
}

class CoinPaymentsNotificationService extends Service {
  @override
  Future create(data, [Map params]) async => data;
}
