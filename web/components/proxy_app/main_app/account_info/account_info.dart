part of client;

@Component(
    selector: "account-info",
    template: '''
    <div class="panel panel-default">
      <div class="panel-heading">
        <i class="fa fa-info-circle"></i>
        Account Overview
      </div>
      <table class="table">
        <tr>
          <th>E-mail</th>
          <th>Subscription</th>
        </tr>
        <tr>
          <td>{{user["email"]}}</td>
          <td *ngIf="user['plan'] == null">
            <a class="btn btn-primary">
              <i class="fa fa-user add"></i>
              Upgrade Account
            </a>
          </td>
        </tr>
      </table>
    </div>
    '''
)
class AccountInfoComponent {
  @Input()
  Map user = {};
}
