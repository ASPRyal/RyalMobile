import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
    private var blurView: UIVisualEffectView?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    // Called when app is about to become inactive (app switcher, incoming call, etc.)
    override func applicationWillResignActive(_ application: UIApplication) {
        addBlurView()
    }
    
    // Called when app becomes active again
    override func applicationDidBecomeActive(_ application: UIApplication) {
        removeBlurView()
    }
    
    private func addBlurView() {
        guard let window = self.window else { return }
        
        // Remove existing blur view if any
        blurView?.removeFromSuperview()
        
        // Create blur effect
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = window.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        window.addSubview(blurEffectView)
        self.blurView = blurEffectView
    }
    
    private func removeBlurView() {
        UIView.animate(withDuration: 0.2, animations: {
            self.blurView?.alpha = 0
        }) { _ in
            self.blurView?.removeFromSuperview()
            self.blurView = nil
        }
    }
}