import 'dart:convert';

import 'package:flutter/services.dart';

class AppConfig {
  final String businessId;

  AppConfig({required this.businessId});

  static Future<AppConfig> forEnvironment(String env) async {
    // set default to dev if nothing was passed
    env = env;

    // load the json file
    final contents = await rootBundle.loadString(
      'assets/config/$env.json',
    );

    // decode our json
    final json = jsonDecode(contents);

    // convert our JSON into an instance of our AppConfig class
    return AppConfig(businessId: json['businessId']);
  }
}
