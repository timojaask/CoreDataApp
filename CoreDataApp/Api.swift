import Foundation
import Sync

let baseUrl = "https://jsonplaceholder.typicode.com"

typealias JsonData = [[String: Any]]
typealias EntityFetchInfo = (name: String, endpoint: String)

func fetchAllData(completion: @escaping ()->()) {

    var entitiesToFetch = [
        (name: "User", endpoint: "users"),
        (name: "Album", endpoint: "albums"),
        (name: "Post", endpoint: "posts"),
        (name: "Photo", endpoint: "photos"),
    ]

    func fetchNext() {
        if entitiesToFetch.count == 0 {
            completion()
            return
        }
        let entity = entitiesToFetch.removeFirst()
        fetchItems(endpoint: entity.endpoint) { (data) in
            syncItems(data: data, entity: entity)
        }

    }

    func syncItems(data: JsonData?, entity: EntityFetchInfo) {
        guard let json = data else { return }

        let dataStack = (UIApplication.shared.delegate as! AppDelegate).dataStack

        dataStack.sync(json, inEntityNamed: entity.name) { error in
            if let error = error {
                print("SYNC ERROR: \(error.localizedDescription)")
                return
            }
            print("synced \(entity.endpoint)")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                fetchNext()
            }
        }
    }

    fetchNext()
}

func fetchItems(endpoint: String, completion: @escaping (_ json: JsonData?) -> ()) {
    let url = URL(string: "\(baseUrl)/\(endpoint)")!
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let data = data else {
            completion(nil)
            return
        }
        guard let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) else {
            completion(nil)
            return
        }
        guard let json = jsonData as? JsonData else {
            completion(nil)
            return
        }
        completion(json)
    }.resume()
}
