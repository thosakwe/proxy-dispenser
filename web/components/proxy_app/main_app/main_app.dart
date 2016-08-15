part of client;

@Component(
    selector: "main-app",
    directives: const [ROUTER_DIRECTIVES],
    template: '''
    <nav class="navbar navbar-default" role="navigation">
    <div class="container">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle" data-toggle="collapse"
                    data-target="#bs-example-navbar-collapse-1">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="">Proxy Dispenser</a>
        </div>
        <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
            <ul class="nav navbar-nav">
            </ul>
            <ul class="nav navbar-nav navbar-right">
                <li *ngIf="userService.user == null">
                    <a href="/auth/google">
                        <i class="fa fa-google"></i>
                        Log in with Google
                    </a>
                </li>
                <li *ngIf="userService.user != null" class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                        <img src="{{userService.user['avatar']}}" style="max-width: 25px;" />
                        {{userService.user["displayName"]}}
                        <span class="caret"></span>
                    </a>
                    <ul class="dropdown-menu">
                        <li>
                            <a [routerLink]="['Purchase']">
                                <i class="fa fa-shopping-cart"></i>
                                Buy Proxies
                            </a>
                        </li>
                        <li>
                            <a>
                                <i class="fa fa-server"></i>
                                My Proxies
                            </a>
                        </li>
                        <li *ngIf="false">
                            <a href="#">
                                <i class="fa fa-flag-checkered"></i>
                                Check Proxies
                            </a>
                        </li>
                        <li *ngIf="false">
                            <a href="#">
                                <i class="fa fa-cog"></i>
                                My Account
                            </a>
                        </li>
                        <li role="separator" class="divider"></li>
                        <li>
                            <a href="/auth/logout">
                                <i class="fa fa-sign-out"></i>
                                Log out
                            </a>
                        </li>
                    </ul>
                </li>
            </ul>
        </div>
    </div>
</nav>
<div class="container">
    <router-outlet></router-outlet>
</div>''')
@RouteConfig(const [
  const Route(path: "/login", name: "Login", component: LogInComponent),
  const Route(
      path: "/purchase", name: "Purchase", component: PurchaseFormComponent),
  const Route(
      path: "/home", name: "Home", component: HomeComponent, useAsDefault: true)
])
class MainAppComponent {
  String loginUrl;
  UserService userService;

  MainAppComponent(this.userService);
}
