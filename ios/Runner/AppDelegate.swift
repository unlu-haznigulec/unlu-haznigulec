import UIKit
import Flutter
import PPEnQualifyModule
import Firebase

@main
@objc class AppDelegate: FlutterAppDelegate {
    var navigationController: UINavigationController!
    var storyboard: UIStoryboard!
    let appGroup = "group.com.unluco.piapiri"

    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        GeneratedPluginRegistrant.register(with: self)
        UNUserNotificationCenter.current().delegate = self
        let controller = window.rootViewController as! FlutterViewController
        self.storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.navigationController = UINavigationController(rootViewController: controller)
        self.navigationController.isNavigationBarHidden = true

        self.window.rootViewController = self.navigationController
        self.navigationController.setNavigationBarHidden(true, animated: false)
        self.navigationController.setToolbarHidden(true, animated: false)
        self.window.makeKeyAndVisible()

        let piapiriChannel = FlutterMethodChannel(
            name: "PIAPIRI_CHANNEL",
            binaryMessenger: controller.binaryMessenger)

        piapiriChannel.setMethodCallHandler({(call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            if (call.method == "initEnqura") {
                let enquraView = self.storyboard.instantiateViewController(withIdentifier: "enqura") as! EnquraViewController
                enquraView.overrideUserInterfaceStyle = .light  
                self.navigationController.pushViewController(enquraView, animated: true)
                enquraView.navigationController?.overrideUserInterfaceStyle = .light
                result(true)
                return
            } else if (call.method == "marketRedirect") {
                var iTunesLink: String? = "itms-apps://itunes.apple.com/xy/app/foo/id1605946348"
                if let iTunesLink = iTunesLink, let url = URL(string: iTunesLink) {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
                result(true)
                return
            } else {
                result(FlutterMethodNotImplemented)
                return
            } 
        })

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
