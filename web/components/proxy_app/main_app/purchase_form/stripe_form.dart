part of client;

@Component(
    selector: "stripe-form",
    template: '''
    <div class="panel panel-default" style="text-align: center;">
      <div class="panel-heading">
        <i class="fa fa-cc-stripe"></i>
        Payment Information
      </div>
      <div class="panel-body">
        <p>Please fill in the form completely.</p>
        <form (ngSubmit)="handleSubmit()">
          <div class="row">
            <div class="col-xs-12 col-md-6">
              <div class="input-group">
                <div class="input-group-addon">
                  <i class="fa fa-credit-card"></i>
                </div>
                <input class="form-control" maxlength="19" type="text" placeholder="Card Number" [(ngModel)]="card">
              </div>
            </div>
            <div class="col-xs-12 col-md-6">
              <div class="input-group">
                <div class="input-group-addon">
                  <i class="fa fa-lock"></i>
                </div>
                <input class="form-control" maxlength="4" type="text" placeholder="CVC" [(ngModel)]="cvc">
              </div>
            </div>
          </div>
          <div class="row">
            <div class="col-xs-12 col-md-6">
              <div class="input-group">
                <div class="input-group-addon">
                  <i class="fa fa-moon-o"></i>
                </div>
                <input class="form-control" type="number" placeholder="Exp. Month" [(ngModel)]="mo">
              </div>
            </div>
            <div class="col-xs-12 col-md-6">
              <div class="input-group">
                <div class="input-group-addon">
                  <i class="fa fa-calendar"></i>
                </div>
                <input class="form-control" min="{{now.year}}" type="number" placeholder="Exp. Year" [(ngModel)]="yr">
              </div>
            </div>
          </div>
          <br />
          <button class="btn btn-success" style="float: right; margin-right: 1em;" type="submit">
            <i class="fa fa-check"></i>
            Submit Payment
          </button>
        </form>
      </div>
    </div>
    '''
)
class StripeFormComponent {
  final String _stripeKey = "pk_test_cMQHEOoT4uV3juAvB1crd0tD";

  @Input() num amount = 0;
  @Output() EventEmitter token = new EventEmitter();

  String card, cvc;
  num mo, yr;
  DateTime now = new DateTime.now();

  StripeFormComponent() {
    mo = now.month;
    yr = now.year;
  }

  handleSubmit() {
    var data = [
      "amount=$amount",
      "card[number]=$card",
      "card[cvc]=$cvc",
      "card[exp_month]=${mo.round()}",
      "card[exp_year]=${yr.round()}",
      "key=$_stripeKey"
    ];

    var request = new HttpRequest();
    request.open("POST", "https://api.stripe.com/v1/tokens");
    request.responseType = "json";
    request.setRequestHeader("Accept", "application/json");
    request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    request.onLoadEnd.listen((_) {
      token..emit(request.response["id"]);
    });
    request.send(data.join("&"));
  }
}