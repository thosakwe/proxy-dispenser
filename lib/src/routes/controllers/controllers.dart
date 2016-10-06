library angel.routes.controllers;

import "dart:async";
import "dart:collection";
import "dart:io";
import 'package:angel_framework/angel_framework.dart';
import "package:crypto/crypto.dart";
import "package:googleapis/plus/v1.dart";
import "package:googleapis_auth/auth_io.dart";
import "package:googleapis_auth/src/utils.dart" as utils;
import "package:http/http.dart" as http;
import "package:intl/intl.dart";
import "package:json_god/json_god.dart" as god;
import "package:mongo_dart/mongo_dart.dart";
import "package:paypal_rest_api/src/paypal_exception.dart";
import "package:paypal_rest_api/paypal_rest_api.dart";
import "package:paypal_rest_api/paypal_client.dart";
import "package:paypal_rest_api/src/apis/payments.dart";
import "package:proxy_scraper/proxy_scraper.dart";
import 'dart:convert';
import "../../../pricing.dart";
import '../../services/users/users.dart' show User;
part 'auth.dart';
part "coin_payments.dart";
part "dispatcher.dart";
part "paypal.dart";
part "stripe.dart";

String notEnoughProxies(num numProxies, num made) => "You ordered $numProxies proxy(ies), but we only had $made available. Please notify us. Apologies for the inconvenience.";

configureServer(Angel app) async {
  await app.configure(new AuthController());
  await app.configure(new StripeController());
  await app.configure(new PayPalController());
  await app.configure(new CoinPaymentsController());
}
