import Flutter
import UIKit

public class SwiftFlutterLaunchPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_launch", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterLaunchPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        if ("launchApp" == call.method) {
            let args = call.arguments as! Dictionary<String, String>
            let app = args["app"]
            let phone = args["phone"]
            let message = args["message"]
            var urlString: String;
            if (app == "whatsapp") {
                urlString = "whatsapp-consumer://"
            } else if (app == "whatsapp_business") {
                urlString = "whatsapp-smb://"
            } else {
                // unsupported
                return
            }
            if ((phone ?? "").isEmpty) {
                urlString += "app"
            } else {
                urlString += "send?phone=\(phone ?? "0")&message=\(message ?? "0")"
            }
            let urlStringEncoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            let URL = NSURL(string: urlStringEncoded!)
            
            if UIApplication.shared.canOpenURL(URL! as URL) {
                UIApplication.shared.openURL(URL! as URL)
            }
        }
        
        if ("hasApp" == call.method) {
            let args = call.arguments as! Dictionary<String, String>
            let name = args["name"]
            
            switch name ?? "0" {
            case "whatsapp":
                result(schemeAvailable(scheme: "whatsapp-consumer://send"))
                break
            case "whatsapp_business":
                result(schemeAvailable(scheme: "whatsapp-smb://send"))
                // result(schemeAvailable(scheme: "w4b://send")) // TODO when W4B for iOS is available, fix this
                result(false)
                break
            default:
                result(false)
                break
            }
        }
    }
    
    public func schemeAvailable(scheme: String) -> Bool {
        let urlStringEncoded = scheme.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let URL = NSURL(string: urlStringEncoded!)
        
        if UIApplication.shared.canOpenURL(URL! as URL) {
            return true
        }
        
        return false
    }
}
