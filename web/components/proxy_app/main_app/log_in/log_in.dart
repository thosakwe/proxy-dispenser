part of client;

@Component(
    selector: "log-in",
    template: '''
    <div class="panel panel-default text-center">
        <div class="panel-heading">
            <i class="fa fa-user"></i>
            Restricted Access
        </div>
        <div class="panel-body">
            Please click the button below to log in or sign up with Google:
            <br /><br />
            <a class="btn btn-primary" href="/auth/google">
                <i class="fa fa-google"></i>
                Log in with Google
            </a>
        </div>
    </div>''')
class LogInComponent implements OnInit {
  String username, password;
  UserService userService;
  Router router;

  LogInComponent(this.userService, this.router);

  @override
  ngOnInit() {
    if (userService.user != null) {
      router.navigate(["../Home"]);
    }
  }
}
