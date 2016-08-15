part of client;

@Component(
    selector: "purchase-form",
    styles: const [
      '''
    .col-md-4 {
        margin-bottom: 1em;
    }

    .panel-default {
      text-align: center;
    }
    '''
    ],
    directives: const [StripeFormComponent],
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
      <div class="col-xs-12 col-md-4">
        <a class="btn btn-primary" style="background-color: #009cde; color: white;">
            <i class="fa fa-paypal"></i>
            Buy with PayPal
        </a>
      </div>
      <div class="col-xs-12 col-md-4">
        <div class="btn btn-danger" (click)="showStripe()">
            <i class="fa fa-cc-stripe"></i>
            Buy with Credit/Debit
        </div>
        <br /><br />
        <i>Payments are securely handled via <a href="https://stripe.com">Stripe</a>.</i>
      </div>
      <div class="col-xs-12 col-md-4">
        <div class="btn btn-warning" (click)="showBtc()">
            <i class="fa fa-btc"></i>
            Buy with Bitcoin
        </div>
      </div>
    </div>
    <stripe-form *ngIf="stripe" [amount]="computeAmount()" (token)="handleStripeToken(\$event)"></stripe-form>
    ''')
class PurchaseFormComponent {
  int numProxies = 5;
  bool btc = false, stripe = false;
  Currency _usd = new Currency("USD");

  Money _makeMoney() => new Money.fromDouble((numProxies ?? 0) * 0.8, _usd);

  computeAmount() => _makeMoney().amount;
  computePrice() => _makeMoney().toString();

  showBtc() {
    btc = true;
    stripe = false;
  }

  showStripe() {
    btc = false;
    stripe = true;
  }

  handleStripeToken(token) {
    var request = new HttpRequest();
    request
      ..open("POST", "/api/stripe/pay")
      ..setRequestHeader("Content-Type", "application/json");
    request.onLoadEnd.listen((_) {
      print(request.response);
    });
    request
        .send(JSON.encode({"amount": (numProxies ?? 0) * 0.8, "stripeToken": token}));
  }
}
