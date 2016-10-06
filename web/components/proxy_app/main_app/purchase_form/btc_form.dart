part of client;

@Component(
    selector: "btc-form",
    template: '''
    <div class="panel panel-default" style="text-align: center;">
      <div class="panel-heading">
        <i class="fa fa-btc"></i>
        Payment Information
      </div>
      <div class="panel-body">
        <div class="alert alert-info">Please send BTC to {{result["address"]}}.</div>
        <img src="{{result['qrcode_url']}}" />
        <br />
        Click <a target="_blank" href="{{result['status_url']}}">here</a> to check payment status.
      </div>
    </div>
    '''
)
class BtcFormComponent {
  @Input() Map result = {};
}