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

    baseUrl = app.properties["base_url"];
    client =
        new PayPalClient(new http.Client(), paypal["id"], paypal["secret"]);
    if (app.properties["debug"] == true)
      client.paypalEndpoint = "https://api.sandbox.paypal.com/v1";
    api = new PayPalRestApi(client);

    Proxies = app.service("api/proxies");
    Purchases = app.service("api/purchases");
    Transactions = app.service("api/transactions");
  }

  @Expose("/callback")
  callback() {}

  @Expose("/cancel")
  cancel() {}

  @Expose("/pay", method: "POST", middleware: const ["auth"])
  pay(RequestContext req, ResponseContext res) async {
    var amount = req.body["amount"];

    if (amount == null || amount is! num || amount < 4)
      throw new AngelHttpException.BadRequest(
          message: "Amount must be a number greater than or equal to \$4.");

    num numProxies = (amount % 0.8).round();

    var payer = new Payer(paymentMethod: "paypal");
    var transactions = [
      {
        "amount": {"currency": "USD", "total": amount},
        "description":
            "Purchase of $numProxies proxy(ies) for ${req.session["user"].displayName}",
        "item_list": {
          "items": [
            {
              "name": "Proxy",
              "currency": "USD",
              "quantity": numProxies.round(),
              "price": 0.8
            }
          ]
        },
        "invoice_number": ""
      }
    ];
    var payment = new Payment(
        intent: "sale",
        payer: payer,
        redirectUrls: {
          "return_url": "$baseUrl/api/paypal/callback",
          "cancel_url": "$baseUrl/api/paypal/cancel"
        },
        transactions: transactions);

    var response = await client.post("/payments/payment",
        body: JSON.encode(payment.toJson()),
        headers: {
          HttpHeaders.ACCEPT: ContentType.JSON.mimeType,
          HttpHeaders.CONTENT_TYPE: ContentType.JSON.mimeType
        });
    Map created = JSON.decode(response.body);
    for (var link in created["links"]) {
      if (link["rel"] == "approval_url")
        return res.redirect(link["href"]);
    }

    return "No approval link???";
  }
}
