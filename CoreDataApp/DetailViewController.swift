import UIKit
import Kingfisher

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postBody: UILabel!
    @IBOutlet weak var tableView: CollapsibleTableView!

    var post: Post?
    var albums: [Album] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        if let post = self.post {
            albums = getAlbums(post: post)
        }
    }

    func configureView() {

        postTitle.text = post?.title
        postBody.text = post?.body

        // Set automatic row high for table view cells
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300

        tableView.register(HeaderView.Nib, forHeaderFooterViewReuseIdentifier: HeaderView.CellIdentifier)

        tableView.dataSource = self
        tableView.delegate = self
    }

    // MARK: - UITableView delegate & data source methods

    func numberOfSections(in tableView: UITableView) -> Int {
        return albums.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let album = albums[section];
        return getPhotos(album: album).count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PhotoCell.CellIdentifier, for: indexPath) as? PhotoCell else {
            return UITableViewCell()
        }
        let album = albums[indexPath.section]
        let photo = getPhotos(album: album)[indexPath.row]
        guard let photoUrl = photo.url else {
            return UITableViewCell()
        }
        cell.photoImageView.kf.indicatorType = .activity
        cell.photoImageView.kf.setImage(with: URL(string: photoUrl))
        return cell
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? PhotoCell else {
            return
        }
        cell.photoImageView.kf.cancelDownloadTask()
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderView.CellIdentifier) as? HeaderView else {
            return UIView()
        }
        headerView.headerText.text = albums[section].title
        return headerView
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }

}

