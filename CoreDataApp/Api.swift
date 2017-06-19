import Foundation
import Sync
import Alamofire
import PromiseKit

let baseUrl = "https://jsonplaceholder.typicode.com"

typealias JsonData = [[String: Any]]

struct Entity {
    let name: String
    let endpoint: String
    var url: String { return "\(baseUrl)/\(endpoint)" }
}

struct Entities {
    static let Users = Entity(name: "User", endpoint: "users")
    static let Albums = Entity(name: "Album", endpoint: "albums")
    static let Posts = Entity(name: "Post", endpoint: "posts")
    static let Photos = Entity(name: "Photo", endpoint: "photos")
}

enum ApiError: Error {
    case JsonParsingError
}

func fetch(_ entity: Entity) -> Promise<JsonData> {
    return Alamofire
        .request(entity.url)
        .responseJSON()
        .then { json -> JsonData in
            guard let jsonData = json as? JsonData else {
                throw ApiError.JsonParsingError
            }
            return jsonData
    }
}

func save(_ entity: Entity, jsonData: JsonData) -> Promise<Void> {
    return Promise { fullfill, reject in
        let dataStack = (UIApplication.shared.delegate as! AppDelegate).dataStack
        dataStack.sync(jsonData, inEntityNamed: entity.name) { error in
            if let error = error { return reject(error) }
            return fullfill()
        }
    }
}

func sync(_ entity: Entity) -> Promise<Void> {
    return fetch(entity)
        .then { save(entity, jsonData: $0) }
}

func syncAll() -> Promise<Void> {
    return sync(Entities.Users)
        .then { sync(Entities.Albums) }
        .then { sync(Entities.Posts) }
        .then { sync(Entities.Photos) }
}
