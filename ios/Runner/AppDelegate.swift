import Flutter
import UIKit
import flutter_local_notifications


@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      if #available(iOS 10.0, *) {
           UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
         }
    let controller = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "timezone_helper", binaryMessenger: controller.binaryMessenger)

    channel.setMethodCallHandler { (call, result) in
      if call.method == "getTimeZoneName" {
        result(TimeZone.current.identifier) // Returns full name like Asia/Kolkata
      } else {
        result(FlutterMethodNotImplemented)
      }
    }
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}