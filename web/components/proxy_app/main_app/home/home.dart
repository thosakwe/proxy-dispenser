part of client;

@Component(
    selector: "app-home",
    directives: const [AccountInfoComponent],
    styles: const [
      '''
    .panel-default {
        text-align: center;
    }

    .clickable {
        cursor: pointer
    }

    .panel-default:not(.clickable) {
      cursor: not-allowed;
    }

    i.fa-lg {
        font-size: 3em;
    }
    '''
    ],
    template: '''<!-- -->
    <div *ngIf="userService.user != null">
        <h5 class="page-header">
          <i class="fa fa-user"></i>
          {{userService.user["displayName"]}}
        </h5>
        <account-info [user]="userService.user"></account-info>
        <div class="row">
          <div class="col-xs-12 col-md-4">
            <div class="panel panel-default clickable" (click)="goToBuyProxies()">
              <div class="panel-heading">
                Buy Slots
              </div>
              <div class="panel-body">
                <i class="fa fa-shopping-cart fa-lg"></i>
              </div>
              <div class="panel-footer">
                Best Bargain on the Net
              </div>
            </div>
          </div>
          <div class="col-xs-12 col-md-4" (click)="goToListProxies()">
            <div class="panel panel-default clickable">
              <div class="panel-heading">
                My Proxies
              </div>
              <div class="panel-body">
                <i class="fa fa-server fa-lg"></i>
              </div>
              <div class="panel-footer">
                Anonymity without the Hassle
              </div>
            </div>
          </div>
          <div *ngIf="false" class="col-xs-12 col-md-3">
            <div class="panel panel-default">
              <div class="panel-heading">
                Proxy Checker
              </div>
              <div class="panel-body">
                <i class="fa fa-flag-checkered fa-lg"></i>
              </div>
              <div class="panel-footer">
                Coming soon!
              </div>
            </div>
          </div>
          <div class="col-xs-12 col-md-4">
            <div class="panel panel-default">
              <div class="panel-heading">
                Manage Account
              </div>
              <div class="panel-body">
                <i class="fa fa-cog fa-lg"></i>
              </div>
              <div class="panel-footer">
                Coming soon!
              </div>
            </div>
          </div>
        </div>
    </div>
    ''')
class HomeComponent {
  Router router;
  UserService userService;

  HomeComponent(this.router, this.userService);

  goToBuyProxies() => router.navigate(["../Purchase"]);

  goToListProxies() => router.navigate(["../Proxies"]);
}
