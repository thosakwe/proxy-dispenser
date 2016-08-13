part of client;

@Component(
    selector: "main-app",
    directives: const [ROUTER_DIRECTIVES],
    providers: const [UserService],
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
                        <i class="fa fa-user"></i>
                        Dropdown
                        <span class="caret"></span>
                    </a>
                    <ul class="dropdown-menu">
                        <li>
                            <a href="#">
                                <i class="fa fa-cloud-download"></i>
                                Get Proxies
                            </a>
                        </li>
                        <li>
                            <a href="#">
                                <i class="fa fa-flag-checkered"></i>
                                Check Proxies
                            </a>
                        </li>
                        <li>
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
  const Route(
      path: "/login",
      name: "Login",
      component: LogInComponent,
      useAsDefault: true)
])
class MainAppComponent {
  String loginUrl;
  UserService userService;

  MainAppComponent(this.userService);
}
