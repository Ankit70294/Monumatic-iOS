import UIKit
import FirebaseCore
import FirebaseAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Initialize Firebase
        FirebaseApp.configure()

        // Set up the main window
        window = UIWindow(frame: UIScreen.main.bounds)

        // Check authentication state and set the initial view controller
        setupInitialViewController()

        return true
    }

    private func setupInitialViewController() {
        // Check if a user is logged in
        if let _ = Auth.auth().currentUser {
            // User is logged in, go to the tab bar interface
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                sceneDelegate.goToTabBar()
            }
        } else {
            // User is not logged in, show the WelcomeViewController
            let welcomeVC = WelcomeViewController()
            let navigationController = UINavigationController(rootViewController: welcomeVC)
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
        }
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}
