part of client;

@Component(
    selector: "purchase-form",
    styles: const ['''
    .col-md-4 {
        margin-bottom: 1em;
    }

    .panel-default {
      text-align: center;
    }
    '''
    ],
    directives: const [StripeFormComponent, BtcFormComponent],
    template: '''
    <h5 class="page-header">
      <i class="fa fa-shopping-cart"></i>
      Purchase Proxies
    </h5>
    <div class="panel panel-default">
        <div class="panel-body">
            <div class="row">
                <div class="col-xs-12 col-md-6">
                    <div class="input-group">
                        <div class="input-group-addon">
                            <i class="fa fa-server"></i>
                            Number of Proxies
                        </div>
                        <input class="form-control" type="number" min="5" step="1" [(ngModel)]="numProxies" />
                    </div>
                </div>
                <div class="col-xs-12 col-md-6">
                    <h5 class="text-success">
                        <i class="fa fa-usd"></i>
                        {{computePrice()}}
                    </h5>
                </div>
            </div>
        </div>
    </div>
    <div class="row text-center">
      <div class="col-xs-12 col-md-6">
        <div *ngIf="!paypal_loading" class="btn btn-primary" (click)="submitPayPal()" style="background-color: #009cde; color: white;">
            <i class="fa fa-paypal"></i>
            Buy with PayPal
        </div>
        <div *ngIf="paypal_loading" class="btn btn-primary" style="background-color: #009cde; color: white;">
            <i class="fa fa-circle-o-notch fa-spin"></i>
        </div>
        <br /><br />
        <i>PayPal employees: Purchases are free for you, go ahead and click the 'Buy with PayPal' button to see.</i>
      </div>
      <div class="col-xs-12 col-md-4" *ngIf="1 == 2">
        <div class="btn btn-danger" (click)="showStripe()">
            <i class="fa fa-cc-stripe"></i>
            Buy with Credit/Debit
        </div>
        <br /><br />
        <i>Payments are securely handled via <a href="https://stripe.com">Stripe</a>.</i>
      </div>
      <div class="col-xs-12 col-md-6">
        <div *ngIf="!btc_loading" class="btn btn-warning" (click)="showBtc()">
            <i class="fa fa-btc"></i>
            Buy with Bitcoin
        </div>
        <div *ngIf="btc_loading" class="btn btn-warning">
            <i class="fa fa-circle-o-notch fa-spin"></i>
        </div>
      </div>
    </div>
    <br />
    <stripe-form *ngIf="stripe" [amount]="computeAmount()" (token)="handleStripeToken(\$event)"></stripe-form>
    <btc-form *ngIf="btc" [result]="coinResult"></btc-form>
    ''')
class PurchaseFormComponent {
  int numProxies = 5;
  bool btc = false, stripe = false, btc_loading = false, paypal_loading = false;
  Router router;
  Map coinResult = {};

  PurchaseFormComponent(this.router);

  num computeAmount() => computeCost(numProxies ?? 0);
  String computePrice() => computeCost(numProxies ?? 0).toString();

  showBtc() {
    btc_loading = true;
    var request = new HttpRequest()..responseType = "json";
    request
      ..open("POST", "/api/coin_payments/pay")
      ..setRequestHeader("Content-Type", "application/json");
    request.onLoadEnd.listen((_) {
      btc_loading = false;
      print(request.response);
      if (request.status == 200) {
        coinResult = request.response["result"];
        btc = true;
        stripe = false;
      }
    });
    request.send(
        JSON.encode({"amount": computeAmount()}));
  }

  showStripe() {
    return;
    btc = false;
    stripe = true;
  }

  submitPayPal() {
    paypal_loading = true;
    var request = new HttpRequest();
    request.responseType = "json";
    request.open("POST", "/api/paypal/pay");
    request.setRequestHeader("Accept", "application/json");
    request.setRequestHeader(
        "Content-Type", "application/x-www-form-urlencoded");
    request.send("amount=${computePrice()}");
    request.onLoadEnd.listen((_) {
      if (request.response != null && request.response["redirect"] != null)
        window.location.href = request.response["redirect"];
    });
  }

  handleStripeToken(token) {
    var request = new HttpRequest();
    request
      ..open("POST", "/api/stripe/pay")
      ..setRequestHeader("Content-Type", "application/json");
    request.onLoadEnd.listen((_) {
      print(request.response);
      if (request.status == 200) {
        router.navigate(["../Proxies"]);
      }
    });
    request.send(
        JSON.encode({"amount": computeAmount(), "stripeToken": token}));
  }
}
