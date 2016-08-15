part of client;

@Injectable()
class UserService {
  Router router;
  Map user = null;

  UserService(this.router) {
    var request = new HttpRequest();
    request.open("GET", "/auth/me");
    request.onLoadEnd.listen((_) {
      if (request.status == 200) {
        user = JSON.decode(request.responseText);
      } else {
        window.location.hash = "#/app/login";
      }
    });
    request.send();
  }
}
