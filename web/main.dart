library client;

import "package:angular2/platform/browser.dart";
import "package:angular2/platform/common.dart";
import "package:angular2/angular2.dart";
import "package:angular2/router.dart";
part "components/proxy_app/proxy_app.dart";
part "components/proxy_app/main_app/main_app.dart";
part "components/proxy_app/main_app/log_in/log_in.dart";
part "services/user.dart";

main() => bootstrap(ProxyAppComponent, [ROUTER_PROVIDERS, provide(LocationStrategy, useClass: HashLocationStrategy)]);