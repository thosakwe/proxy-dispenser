part of client;

@Component(
    selector: "proxy-landing",
    template: '''
    <nav class="navbar navbar-default" role="navigation" style="margin: 0;">
      <div class="container">
          <div class="navbar-header">
              <a class="navbar-brand" href="">Proxy Slots</a>
          </div>
      </div>
    </nav>
  <div class="jumbotron city" style="color: white; background-image: url('/bg.jpg'); background-size: cover; padding-bottom: 2em; padding-top: 2em; text-align: center;">
    <div class="container">
      <h1 style="color: white;">Proxy Slots</h1>
      <p>The best proxies in existence.</p>
      <br />
      <a [routerLink]="['../App']" class="btn btn-primary btn-lg">
        Enter Site
        <i class="fa fa-arrow-right"></i>
      </a>
    </div>
  </div>
  <div class="container">
    <h3 class="page-header" style="font-size: 2em;">
      About
    </h3>
    <p>
      Are you looking for high quality proxies that are replaced if they die? Well then, Proxy Slots is for you! You can purchase a slot for \$0.75!
      Or, if you are looking to purchase in bulk, we offer huge discounts ranging down to \$0.55.
    </p>
  </div>''',
    directives: const[RouterLink])
class LandingComponent {
}