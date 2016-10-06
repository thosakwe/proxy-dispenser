part of client;

@Component(
    selector: "proxy-app",
    directives: const [ROUTER_DIRECTIVES],
    template: "<router-outlet></router-outlet>")
@RouteConfig(const [
  const Route(path: "/", name: "Landing", component: LandingComponent),
  const Route(path: "/app/...", name: "App", component: MainAppComponent)
])
class ProxyAppComponent {}
