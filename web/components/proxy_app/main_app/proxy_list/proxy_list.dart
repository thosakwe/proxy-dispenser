part of client;

@Component(
    selector: "proxy-list",
    styles: const [
      '''
    .col-md-4 {
        margin-bottom: 1em;
    }

    .panel-default {
      text-align: center;
    }

    .float-right {
      float: right;
    }
    '''
    ],
    directives: const [ProxyTrComponent, RouterLink],
    providers: const [ProxyService],
    template: '''
    <h5 class="page-header">
      <i class="fa fa-server"></i>
      My Proxies
    </h5>
    <div *ngIf="loading" class="alert alert-success">Loading...</div>
    <div *ngIf="!loading && proxies.isEmpty" class="alert alert-danger">You have not yet <a [routerLink]="['../Purchase']">purchased any proxy slots</a>. :(</div>
    <a *ngIf="!loading && proxies.isNotEmpty" href="/auth/proxies.txt" class="btn btn-default float-right">
      <i class="fa fa-share"></i>
      Export as .txt
    </a>
    <button *ngIf="!loading && proxies.isNotEmpty && !check_loading" (click)="checkProxies()" class="btn btn-default float-right">
      <i class="fa fa-retweet"></i>
      Check and Replace
    </button>
    <div *ngIf="!loading && proxies.isNotEmpty && check_loading" class="btn btn-default float-right">
      <i class="fa fa-circle-o-notch fa-spin"></i>
    </div>
    <br /><br />
    <div *ngIf="!loading && proxies.isNotEmpty" class="panel panel-default">
      <table class="table" style="text-align: left;">
        <tr>
            <th>IP</th>
            <th>Port</th>
            <!--<th>Copy</th>-->
        </tr>
        <tr class="proxy" *ngFor="let proxy of proxies" [proxy]="proxy"></tr>
      </table>
    </div>
    ''')
class ProxyListComponent implements OnInit {
  ProxyService _proxyService;

  List get proxies => _proxyService.proxies;
  bool loading = true, check_loading = false;

  ProxyListComponent(this._proxyService);

  @override
  ngOnInit() {
    loading = true;
    HttpRequest.getString("/auth/proxies").then((json) {
      loading = false;

      try {
        List _found = JSON.decode(json);
        proxies.addAll(_found);
      } catch (exc) {
        window.console.error("Could not fetch proxies: $exc");
      }
    });
  }

  checkProxies() {
    if (window.confirm("Are you sure you want to check these proxies? It may take a while.")) {
      check_loading = true;
      HttpRequest
          .request("/auth/check_proxies", method: "POST", responseType: "json")
          .then((request) {
        check_loading = false;
        if (request.response != null &&
            request.response is Map &&
            request.response["error"] == "success") {
          window.alert("Successfully checked and replaced proxies.");

          if (request.response["num"] != 0) ngOnInit();
        } else {
          window.alert(
              "Oops! Something went wrong, and we couldn't check your proxies.");
          window.console.error(request.response);
        }
      });
    }
  }
}
