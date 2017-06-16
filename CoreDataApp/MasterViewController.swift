import UIKit
import Sync
import DATASource

class MasterViewController: UITableViewController {

    // Data stack is passed down from AppDelegate.
    // Using ! here, beacuse without data stack, there's no point.
    var dataStack: DataStack!

    var dataSource: DATASource?

    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up data source
        dataSource = newDataSource(entryName: "Post", sortAttributeName: "id", cellIdentifier: MasterViewCell.CellIdentifier, configureCell: MasterViewCell.configureCell)

        // Add Edit button for editing list of posts
        navigationItem.leftBarButtonItem = editButtonItem

        // Prevent list from hiding
        splitViewController?.preferredDisplayMode = .allVisible

        // Set automatic row high for table view cells
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44

        setupSearchViewController()

        // Set up tablew view data source
        self.tableView.dataSource = self.dataSource
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else {
                return
            }
            guard let post = self.dataSource?.object(indexPath) as? Post else {
                return
            }
            guard let controller = (segue.destination as? UINavigationController)?.topViewController as? DetailViewController else {
                return
            }
            controller.post = post
        }
    }
}

extension MasterViewController: UISearchResultsUpdating {

    // This extension adds search functionality and acts as search UI delegate.

    func setupSearchViewController() {
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }

    func updateSearchResults(for searchController: UISearchController) {
        var predicate:NSPredicate? = nil
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            predicate = NSCompoundPredicate(type: .or, subpredicates: [
                NSPredicate(format: "title contains [cd] %@", searchText),
                NSPredicate(format: "user.name contains[cd] %@", searchText),
                NSPredicate(format: "user.email contains[cd] %@", searchText)
            ])
        }
        dataSource?.predicate = predicate
    }
}

extension MasterViewController: DATASourceDelegate {

    // This extension acts as DATASource delegate and adds a convenience data source initialization method.

    typealias ConfigureCellFunction = (_ cell: UITableViewCell, _ item: NSManagedObject, _ indexPath: IndexPath) -> ()

    func newDataSource(entryName: String, sortAttributeName: String, cellIdentifier: String, configureCell: @escaping ConfigureCellFunction) -> DATASource {
        let request: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entryName)
        request.sortDescriptors = [NSSortDescriptor(key: sortAttributeName, ascending: true)]

        let dataSource = DATASource(tableView: self.tableView, cellIdentifier: cellIdentifier, fetchRequest: request, mainContext: self.dataStack.mainContext, configuration: configureCell)

        dataSource.delegate = self

        return dataSource
    }

    func dataSource(_ dataSource: DATASource, tableView: UITableView, canEditRowAtIndexPath indexPath: IndexPath) -> Bool {
        return true
    }

    func dataSource(_ dataSource: DATASource, tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            guard let item = self.dataSource?.object(indexPath) else {
                return
            }
            dataStack.viewContext.delete(item)
            try? dataStack.viewContext.save()
        default: break
        }
    }
}

