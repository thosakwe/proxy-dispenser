import "dart:convert";
import "package:http/http.dart" as http;
import "package:intl/intl.dart";

main() async {
  var now = new DateTime.now();
  print(new DateFormat("y-MM-dd").format(now));
  print(JSON.encode(new Poop()));
}

main2() async {
  var client = new http.Client();
  var response = await client.get("https://proxyslots.com");
  print(response.headers);
}

class Poop {
  toJson() => {"foo": ["bar", "baz"]};
}