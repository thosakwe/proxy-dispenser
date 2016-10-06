part of angel.routes.controllers;

@Expose("/api/paypal")
class PayPalController extends Controller {
  String baseUrl;
  PayPalClient client;
  PayPalRestApi api;
  Map paypal;
  Service Proxies, Purchases, Transactions;

  @override
  call(Angel app) async {
    await super.call(app);

    paypal = app.properties["paypal"];
    baseUrl = app.properties["base_url"];
    client = new PayPalClient(new http.Client(), paypal["id"], paypal["secret"],
        debug: true);
    if (app.properties["debug"] == true)
      client.paypalEndpoint = "https://api.sandbox.paypal.com";
    api = new PayPalRestApi(client);

    Proxies = app.service("api/proxies");
    Purchases = app.service("api/purchases");
    Transactions = app.service("api/transactions");
  }

  @Expose("/callback")
  callback(RequestContext req, ResponseContext res) async {
    if (!req.query.containsKey("PayerID") ||
        !req.query.containsKey("paymentId"))
      throw new AngelHttpException.BadRequest();

    var payerId = req.query["PayerID"], paymentId = req.query["paymentId"];
    var response = await client.post("/payments/payment/$paymentId/execute",
        headers: {HttpHeaders.CONTENT_TYPE: ContentType.JSON.mimeType},
        body: JSON.encode({"payer_id": payerId}));

    var sale = JSON.decode(response.body);
    var amount = num.parse(sale["transactions"][0]["amount"]["total"]);

    var transactionData = {
      "amount": amount,
      "gateway": "paypal",
      "paymentId": sale["id"],
      "charge": sale,
      "userId": req.session["userId"]
    };

    var transaction = await Transactions.create(transactionData);
    print("Created transaction from PayPal: $transaction");
    num numProxies = howManyProxies(amount);

    num made = await assignProxies(req.session["userId"], transaction["id"],
        numProxies, Proxies, Purchases);

    if (made >= numProxies)
      return res.redirect("/#/app/proxies");
    else
      return notEnoughProxies(numProxies, made);
  }

  @Expose("/cancel")
  cancel(ResponseContext res) async => res.redirect("/#/app/home");

  @Expose("/pay", method: "POST", middleware: const ["auth"])
  pay(RequestContext req, ResponseContext res) async {
    var amount = req.body["amount"];

    if (amount == null || amount is! num)
      throw new AngelHttpException.BadRequest(
          message: "Amount must be a number.");

    int numProxies = howManyProxies(amount);

    if (req.session["userId"] == "PAYPAL") {
      var fakeTransaction = await Transactions.create({
        "amount": amount,
        "gateway": "paypal",
        "paymentId": "NONE",
        "charge": {},
        "userId": req.session["userId"]
      });

      num made = await assignProxies(req.session["userId"],
          fakeTransaction["id"], numProxies, Proxies, Purchases);

      if (made >= numProxies)
        return {"redirect": "/#/app/proxies"};
      else
        return notEnoughProxies(numProxies, made);
    }

    var payer = new Payer(paymentMethod: "paypal");

    var transactions = [
      {
        "amount": {"currency": "USD", "total": amount},
        "description":
            "Purchase of $numProxies proxy(ies) for ${req.session["user"]
            .displayName}"
      }
    ];

    try {
      /*var created = await api.payments.createPayment(new Payment(
          intent: "sale",
          payer: payer,
          transactions: transactions,
          redirectUrls: {
            "return_url": "$baseUrl/api/paypal/callback",
            "cancel_url": "$baseUrl/api/paypal/cancel"
          }));

      print("PayPal response: ${created.toJson()}");

      for (var link in created.links) {
        if (link["rel"] == "approval_url")
          return {"redirect": res.redirect(link["href"])};
      }*/

      var response = await client.post("/payments/payment",
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/json"
          },
          body: JSON.encode({
            "intent": "sale",
            "payer": {"payment_method": "paypal"},
            "transactions": transactions,
            "redirect_urls": {
              "return_url": "$baseUrl/api/paypal/callback",
              "cancel_url": "$baseUrl/api/paypal/cancel"
            }
          }));
      print("PayPal response: ${response.body}");
      var created = JSON.decode(response.body);

      for (var link in created["links"]) {
        if (link["rel"] == "approval_url") return {"redirect": link["href"]};
      }

      throw new AngelHttpException.NotProcessable(
          message: "PayPal payment produced no approval URL.");
    } catch (exc) {
      if (exc is PayPalException) {
        stderr.writeln(god.serialize(exc));
        res.status(exc.statusCode);
        return exc;
      }

      rethrow;
    }
  }
}
