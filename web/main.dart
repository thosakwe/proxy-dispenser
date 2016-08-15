library client;

import "dart:convert" show JSON;
import "dart:html";
import "package:angular2/platform/browser.dart";
import "package:angular2/platform/common.dart";
import "package:angular2/angular2.dart";
import "package:angular2/router.dart";
import "package:money/money.dart";
part "components/proxy_app/proxy_app.dart";
part "components/proxy_app/main_app/main_app.dart";
part "components/proxy_app/main_app/account_info/account_info.dart";
part "components/proxy_app/main_app/home/home.dart";
part "components/proxy_app/main_app/log_in/log_in.dart";
part "components/proxy_app/main_app/purchase_form/purchase_form.dart";
part "components/proxy_app/main_app/purchase_form/stripe_form.dart";
part "services/user.dart";

main() => bootstrap(ProxyAppComponent, [ROUTER_PROVIDERS, provide(LocationStrategy, useClass: HashLocationStrategy), UserService]);