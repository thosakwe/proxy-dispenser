part of angel.routes.controllers;

@Expose("/api/paypal")
class PayPalController extends Controller {
  String ENDPOINT;
  final http.Client client = new http.Client();

  Map get headers => {
    HttpHeaders.AUTHORIZATION: "Bearer ${paypal["secret"]}",
    HttpHeaders.CONTENT_TYPE: ContentType.JSON.mimeType
  };
  Map paypal;
  Service Proxies, Purchases, Transactions;

  @override
  call(Angel app) async {
    await super.call(app);

    ENDPOINT = app.properties["debug"] == true ? "https://api.sandbox.paypal.com/v1": "https://api.paypal.com/v1";
    paypal = app.properties["paypal"];
    Proxies = app.service("api/proxies");
    Purchases = app.service("api/purchases");
    Transactions = app.service("api/transactions");
  }

  /* curl -v https://api.sandbox.paypal.com/v1/oauth2/token \
  -H "Accept: application/json" \
  -H "Accept-Language: en_US" \
  -u "EOJ2S-Z6OoN_le_KS1d75wsZ6y0SFdVsY9183IvxFyZp:EClusMEUk8e9ihI7ZdVLF5cZ6y0SFdVsY9183IvxFyZp" \
  -d "grant_type=client_credentials"
  */

  createAccessToken() async {
    var response = await client.post("$ENDPOINT/oauth2/token", body: "grant_type=client_credentials", headers: {
      HttpHeaders.ACCEPT: ContentType.JSON.mimeType,
      HttpHeaders.ACCEPT_LANGUAGE: "en_US",
      HttpHeaders.CONTENT_TYPE: "application/x-www-form-urlencoded"
    });
    var data = JSON.decode(response.body);
  }
}