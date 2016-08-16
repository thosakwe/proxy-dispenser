library angel.routes.controllers;

import "dart:io";
import 'package:angel_framework/angel_framework.dart';
import "package:googleapis/plus/v1.dart";
import "package:googleapis_auth/auth_io.dart";
import "package:googleapis_auth/src/utils.dart" as utils;
import "package:http/http.dart" as http;
import "package:json_god/json_god.dart" as god;
import 'dart:convert';
part 'auth.dart';
part "coin_payments.dart";
part "paypal.dart";
part "stripe.dart";

configureServer(Angel app) async {
  await app.configure(new AuthController());
  await app.configure(new StripeController());
}
