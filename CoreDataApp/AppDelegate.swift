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
        syncAll()
            .then { self.instantiateMainViewController() }
            .catch { self.handleSyncError($0) }
    }

    func instantiateMainViewController() {
        guard self.window?.rootViewController is FirstSyncViewController else {
            return
        }
        let splitViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SplitViewController") as! UISplitViewController
        let masterNavigationController = splitViewController.viewControllers[0] as! UINavigationController
        let controller = masterNavigationController.topViewController as! MasterViewController
        controller.dataStack = self.dataStack
        self.window?.rootViewController = splitViewController
    }

    func instantiateFirstSyncViewController() {
        window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FirstSyncViewController")
    }

    func handleSyncError(_ error: Error) {
        print("Failed to sync entities. Error: \(error.localizedDescription)")
    }

    func hasCachedPosts() -> Bool {
        guard let posts: [Post] = try? dataStack.viewContext.fetch(Post.fetchRequest()) else {
            return false
        }
        return posts.count > 0
    }

}

