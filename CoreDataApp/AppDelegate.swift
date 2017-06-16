import UIKit
import Sync

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var dataStack: DataStack = DataStack(modelName: "CoreDataApp")

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        if hasCachedPosts() {
            instantiateMainViewController()
        } else {
            instantiateFirstSyncViewController()
        }

        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        fetchAllData {
            if self.window?.rootViewController is FirstSyncViewController {
                self.instantiateMainViewController()
            }
        }
    }

    func instantiateMainViewController() {
        let splitViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SplitViewController") as! UISplitViewController
        let masterNavigationController = splitViewController.viewControllers[0] as! UINavigationController
        let controller = masterNavigationController.topViewController as! MasterViewController
        controller.dataStack = self.dataStack
        self.window?.rootViewController = splitViewController
    }

    func instantiateFirstSyncViewController() {
        window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FirstSyncViewController")
    }

    func hasCachedPosts() -> Bool {
        guard let posts: [Post] = try? dataStack.viewContext.fetch(Post.fetchRequest()) else {
            return false
        }
        return posts.count > 0
    }

}

