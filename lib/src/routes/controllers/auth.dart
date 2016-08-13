part of angel.routes.controllers;

@Expose("/auth")
class AuthController extends Controller {
  ClientId get clientId => new ClientId(google["id"], google["secret"]);
  Map google = {};
  final List<String> googleScopes = [
    PlusApi.PlusMeScope,
    PlusApi.UserinfoEmailScope,
    PlusApi.UserinfoProfileScope
  ];

  @override
  call(Angel app) async {
    await super.call(app);

    this.google = app.properties["google"];

    app.registerMiddleware("auth", (req, res) async {
      if (req.session["token"] == null)
        throw new AngelHttpException.Forbidden();

      return true;
    });
  }

  @Expose("/me", middleware: const ["auth"])
  identity(RequestContext req) async => req.session["profile"];

  @Expose("/google")
  oauthRedirect(ResponseContext res) async {
    var url =
        "https://accounts.google.com/o/oauth2/v2/auth?response_type=code&include_granted_scopes=true";
    url += "&client_id=${Uri.encodeQueryComponent(google["id"])}";
    url += "&redirect_uri=${Uri.encodeQueryComponent(google["redirect_uri"])}";
    url += "&scope=${googleScopes.map(Uri.encodeQueryComponent).join("%20")}";
    return res.redirect(url);
  }

  @Expose("/google/callback")
  oauthCallback(RequestContext req) async {
    String code = req.query["code"];

    if (code == null || code.isEmpty) throw new AngelHttpException.BadRequest();

    var client = new http.Client();
    var response =
    await client.post("https://www.googleapis.com/oauth2/v4/token", body: {
      "code": code,
      "client_id": google["id"],
      "client_secret": google["secret"],
      "redirect_uri": google["redirect_uri"],
      "grant_type": "authorization_code"
    });
    var token = god.deserialize(response.body);

    req.session["token"] = token["access_token"];
    req.session["id_token"] = token["id_token"];

    var accessToken = new AccessToken(
        token["token_type"],
        token["access_token"],
        utils.expiryDate(token["expires_in"]));
    var credentials = new AccessCredentials(
        accessToken, token["refresh_token"], googleScopes);

    AuthClient authClient = authenticatedClient(client, credentials);
    var api = new PlusApi(authClient);
    Person me = await api.people.get("me");
    req.session["profile"] = me.toJson();
    client.close();

    return me.toJson();
  }
}
