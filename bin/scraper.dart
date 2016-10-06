#!/usr/bin/env dart

import "dart:io";
import "package:http/http.dart" as http;
import "package:mongo_dart/mongo_dart.dart";
import "package:proxy_scraper/proxy_scraper.dart";
import "package:yaml/yaml.dart" as yaml;
import 'dart:convert';

final String orca = "https://orca.tech/community-proxy-list";
final RegExp rgxUrl = new RegExp(r"<a href='([^']+)'>[^<]*</a>");

main() async {
  var file = new File("config/default.yaml");
  var config = yaml.loadYaml(await file.readAsString());
  var db = new Db(config["mongo_db"]);
  await db.open();
  var Proxies = db.collection("proxies");

  var urls = [];

  await for (FileSystemEntity file in new Directory("proxy_lists").list()) {
    urls.add(file.path);
  }

  var scraper = new ProxyScraper(urls);
  var checker = new ProxyChecker([], 5000, null);
  scraper.fetch();

  var clean = await scraper.stream.transform(checker);

  await for (ProxyDef proxy in clean) {
    var matchingIp = await Proxies.find(where.eq("ip", proxy.ip));

    if (await matchingIp.length == 0) {
      await Proxies.insert({
        "ip": proxy.ip,
        "port": proxy.port
      });
      print("Found and inserted clean proxy: $proxy");
    }
  }
}

_orca(http.Client client) async {
  var result = [];
  var response = await client.get(orca);

  for (Match match in rgxUrl.allMatches(response.body)) {
    result.add("$orca/${match.group(1)}");
  }

  client.close();
  return result;
}