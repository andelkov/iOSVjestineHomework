import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        
        //overriding the authorization step 
        let vc = TabBarViewController() //AuthorizationUtils.isUserLoggedIn() ? TabBarViewController() : LoginViewController()
        
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func switchToLoginController() {
        self.window?.rootViewController = LoginViewController()
    }
    
    func switchToTabBarController() {
        self.window?.rootViewController = TabBarViewController()
    }

}

