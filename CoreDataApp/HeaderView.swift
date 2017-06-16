import UIKit
import FZAccordionTableView

class HeaderView: FZAccordionTableViewHeaderView {
    @IBOutlet weak var headerText: UILabel!
    static let CellIdentifier = "HeaderView"
    static var Nib: UINib {
        return UINib(nibName: "HeaderView", bundle: nil)
    }
}
