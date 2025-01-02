import 'package:flutter/services.dart';

class TimeZoneHelper {
  static const MethodChannel _channel = MethodChannel('timezone_helper');

  // Method to get the timezone name
  static Future<String> getTimeZoneName() async {
    try {
      final String timeZoneName = await _channel.invokeMethod('getTimeZoneName');
      return timeZoneName;
    } catch (e) {
      return 'Unknown';
    }
  }
}