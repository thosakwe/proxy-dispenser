part of client;

@Component(
    selector: "tr.proxy",
    template: '''
    <td>{{proxy["ip"]}}</td>
    <td>{{proxy["port"]}}</td>
    <!--<td><i class="fa fa-clone" style="cursor: pointer;" (click)="copyInfo()"></i></td>-->
    ''')
class ProxyTrComponent {
  @Input()
  Map proxy = {};

  copyInfo() {
    var input = new InputElement();
    input.select();
    input.text = "${proxy['ip']}:${proxy['port']}";
    input.style.display = "none";
    document.append(input);
    window.document.execCommand("copy");
    input.blur();
    input.remove();
  }
}
