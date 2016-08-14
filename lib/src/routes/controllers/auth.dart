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
  Service Users;

  @override
  call(Angel app) async {
    await super.call(app);

    this.google = app.properties["google"];
    this.Users = app.service("api/users");

    app.before.add((RequestContext req, res) async {
      if (req.session["userId"] != null && req.session["user"] == null)
        req.session["user"] = await Users.read(req.session["userId"]);
      return true;
    });

    app.registerMiddleware("auth", (req, res) async {
      if (req.session["userId"] == null)
        throw new AngelHttpException.Forbidden();

      return true;
    });
  }

  @Expose("/logout", middleware: const ["auth"])
  logout(RequestContext req, ResponseContext res) async {
    req.session.clear();
    return res.redirect("/#/app/login");
  }

  @Expose("/me", middleware: const ["auth"])
  identity(RequestContext req) async => req.session["user"] ?? {};

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
  oauthCallback(RequestContext req, ResponseContext res) async {
    // Google should send us an authorization code...
    String code = req.query["code"];
    if (code == null || code.isEmpty) throw new AngelHttpException.BadRequest();

    // Transform this into an access token
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

    // Put this in the session, because idk why but I felt like it :)
    req.session["token"] = token["access_token"];
    req.session["id_token"] = token["id_token"];

    var accessToken = new AccessToken(
        token["token_type"],
        token["access_token"],
        utils.expiryDate(token["expires_in"]));
    var credentials = new AccessCredentials(
        accessToken, token["refresh_token"], googleScopes);

    // Create an HTTP client that is prepped to access Google+ API
    AuthClient authClient = authenticatedClient(client, credentials);
    var api = new PlusApi(authClient);

    // Fetch info about the user
    Person me = await api.people.get("me");
    req.session["profile"] = me.toJson();
    client.close();

    // Check if we have a user with this Google ID
    var withId = await Users.index({"googleId": me.id});

    // If so, update their avatar, e-mail and displayName
    if (withId.isNotEmpty) {
      var user = await Users.modify(withId[0].id, {
        "avatar": me.image.url,
        "displayName": me.displayName,
        "email": me.emails[0].value
      });
      req.session["userId"] = user.id;
    }

    // Otherwise, create somebody new. :)
    else {
      var user = await Users.create({
        "avatar": me.image.url,
        "displayName": me.displayName,
        "email": me.emails[0].value,
        "googleId": me.id
      });
      req.session["userId"] = user.id;
    }

    // Regardless, set req.session["userId"] to this user's ID.

    // Send to client homepage
    return res.redirect("/#/app/home");
  }
}
