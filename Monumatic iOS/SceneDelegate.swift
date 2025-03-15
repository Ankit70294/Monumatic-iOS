import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene

        // Check authentication state and set the initial view controller
        if let _ = Auth.auth().currentUser {
            // User is logged in, go to tab bar
            goToTabBar()
        } else {
            // User is not logged in, show WelcomeViewController
            let welcomeVC = WelcomeViewController()
            let navController = UINavigationController(rootViewController: welcomeVC)
            window?.rootViewController = navController
            window?.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}

    // Function to switch to the tab bar controller
    func goToTabBar() {
        let exploreVC = ExploreViewController()
        exploreVC.tabBarItem = UITabBarItem(
            title: "Explore",
            image: UIImage(systemName: "globe.asia.australia"),
            selectedImage: UIImage(systemName: "globe.asia.australia.fill")
        )

        let landingVC = LandingViewController()
        landingVC.tabBarItem = UITabBarItem(
            title: "Nearby",
            image: UIImage(systemName: "paperplane"),
            selectedImage: UIImage(systemName: "paperplane.fill")
        )

        let monumentListVC = MonumentListViewController()
        monumentListVC.tabBarItem = UITabBarItem(
            title: "Timeline",
            image: UIImage(systemName: "timeline.selection"),
            selectedImage: UIImage(systemName: "timeline.selection")
        )

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [
            UINavigationController(rootViewController: exploreVC),
            UINavigationController(rootViewController: landingVC),
            UINavigationController(rootViewController: monumentListVC)
        ]

        // Customize the tab bar appearance
        let tabBar = tabBarController.tabBar
        tabBar.tintColor = .systemBlue
        tabBar.unselectedItemTintColor = .gray

        // Set the tab bar controller as the root view controller
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
}
