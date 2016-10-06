part of angel.routes.controllers;

@Expose("/api/stripe", middleware: const ["auth"])
class StripeController extends Controller {
  final String ENDPOINT = "https://api.stripe.com/v1";
  final http.Client client = new http.Client();

  Map get headers => {
        HttpHeaders.AUTHORIZATION: "Bearer ${stripe["secret"]}",
        HttpHeaders.CONTENT_TYPE:
            new ContentType("application", "x-www-form-urlencoded").mimeType
      };
  Map stripe;
  Service Proxies, Purchases, Transactions;

  @override
  call(Angel app) async {
    await super.call(app);

    stripe = app.properties["stripe"];
    Proxies = app.service("api/proxies");
    Purchases = app.service("api/purchases");
    Transactions = app.service("api/transactions");
  }

  @Expose("/pay", method: "POST")
  pay(RequestContext req, ResponseContext res) async {
    var stripeToken = req.body["stripeToken"], amount = req.body["amount"];

    if (stripeToken == null || stripeToken is! String)
      throw new AngelHttpException.BadRequest(
          message: "Stripe token is required.");

    if (amount == null || amount is! num)
      throw new AngelHttpException.BadRequest(
          message: "Amount must be a number.");

    num numProxies = howManyProxies(amount);
    var chargeData = [
      "amount=${(amount * 100).round()}",
      "currency=usd",
      "source=$stripeToken",
      "description=${Uri.encodeQueryComponent("Purchase of $numProxies proxy(ies) for ${req.session["user"].displayName}")}"
    ];

    var response = await client.post("$ENDPOINT/charges",
        body: chargeData.join("&"), headers: headers);

    if (response.statusCode != 200) {
      res.status(HttpStatus.INTERNAL_SERVER_ERROR);
      return (res..write(response.body)).end();
    }

    var charge = JSON.decode(response.body);
    var transactionData = {
      "amount": amount,
      "gateway": "stripe",
      "paymentId": charge["id"],
      "charge": charge,
      "userId": req.session["userId"]
    };

    var transaction = await Transactions.create(transactionData);
    var proxies = await Proxies.index({"limit": numProxies.round()});

    for (var proxy in proxies) {
      await Purchases.create({
        "userId": req.session["userId"],
        "proxyId": proxy["_id"].toHexString(),
        "transactionId": transaction["_id"].toHexString()
      });
    }

    return {"success": true};
  }
}
