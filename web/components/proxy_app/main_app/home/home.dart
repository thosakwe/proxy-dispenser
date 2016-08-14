part of client;

@Component(
    selector: "app-home",
    directives: const [AccountInfoComponent],
    styles: const ['''
    .panel-default {
      cursor: pointer;
      text-align: center;
    }

    i.fa-lg {
      font-size: 3em;
    }
    '''],
    template: '''<!-- -->
    <div *ngIf="userService.user != null">
        <h5 class="page-header">
          <i class="fa fa-user"></i>
          {{userService.user["displayName"]}}
        </h5>
        <account-info [user]="userService.user"></account-info>
        <div class="row">
          <div class="col-xs-12 col-md-4">
            <div class="panel panel-default">
              <div class="panel-body">
                <i class="fa fa-cloud-download fa-lg"></i>
              </div>
              <div class="panel-footer">
                Get Proxies
              </div>
            </div>
          </div>
          <div class="col-xs-12 col-md-4">
            <div class="panel panel-default">
              <div class="panel-body">
                <i class="fa fa-flag-checkered fa-lg"></i>
              </div>
              <div class="panel-footer">
                Proxy Checker
              </div>
            </div>
          </div>
          <div class="col-xs-12 col-md-4">
            <div class="panel panel-default">
              <div class="panel-body">
                <i class="fa fa-cog fa-lg"></i>
              </div>
              <div class="panel-footer">
                Manage Account
              </div>
            </div>
          </div>
        </div>
    </div>
    ''')
class HomeComponent {
  UserService userService;

  HomeComponent(this.userService);
}
