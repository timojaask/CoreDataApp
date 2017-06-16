import UIKit
import Sync

class MasterViewCell: UITableViewCell {
    static let CellIdentifier = "Cell"
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var firstNameLastName: UILabel!

    static func configureCell(cell: UITableViewCell, item: NSManagedObject, indexPath: IndexPath) {
        guard let cell = cell as? MasterViewCell else {
            return
        }
        guard let user = item.value(forKey: "user") as? User else {
            return
        }
        cell.title.text = item.value(forKey: "title") as? String
        cell.email.text = user.email
        cell.firstNameLastName.text = user.name

        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor(red: 118.0/256.0, green: 184.0/256.0, blue: 255.0/256.0, alpha: 1)
        cell.selectedBackgroundView = bgColorView
    }
}
