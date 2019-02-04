import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class FlutterLaunch {
  static const MethodChannel _channel = const MethodChannel('flutter_launch');

  static Future<Null> launchApp({@required String app, @required String phone, @required String message}) async {
    final Map<String, dynamic> params = <String, dynamic>{'app': app, 'phone': phone, 'message': message};
    await _channel.invokeMethod('launchApp', params);
  }

  static Future<bool> hasApp({@required String name}) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'name': name,
    };
    return await _channel.invokeMethod('hasApp', params);
  }
}

class App {
  static const String WHATSAPP = 'whatsapp';
  static const String WHATSAPP_BUSINESS = 'whatsapp_business';
}
