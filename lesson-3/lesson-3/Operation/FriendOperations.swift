import Foundation
import RealmSwift
import Alamofire

class FetchFriends: Operation {
    
    var data: Data?
    
    override func main() {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.vk.com"
        components.path = "/method/groups.get"
        components.queryItems = [
            URLQueryItem(name: "client_id", value: Session.instance.cliendId),
            URLQueryItem(name: "user_id", value: String(Session.instance.userId)),
            URLQueryItem(name: "access_token", value: String(Session.instance.token)),
            URLQueryItem(name: "v", value: Session.instance.version),
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "fields", value: "first_name"),
        ]
        
        guard let url = components.url else { return }
        guard let data = try? Data(contentsOf: url) else { return }
        self.data = data
    }
}

class ParseFriends: Operation {
    
    var friends: [FriendItem]? = []
    
    override func main() {
        guard let fdata = dependencies.first as? FetchFriends,
              let data = fdata.data else { return }
        do {
            var friends: Friends
            friends = try JSONDecoder().decode(Friends.self, from: data)
            self.friends = friends.response.items
        } catch {
            print(error)
        }
    }
}


class SaveFriends: Operation {
    
    let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    lazy var mainRealm = try! Realm(configuration: config)
    var friends: [FriendItem]? = []
    
    override func main() {
        guard let bd = dependencies.first as? ParseFriends,
              let data = bd.friends else { return }
        do {
            mainRealm.beginWrite()
            friends!.forEach{ mainRealm.add($0, update: .all) }
            try mainRealm.commitWrite()
            print("сохранены друзья в Realm")
            
        } catch {
            print(error)
        }
    }
}


class DisplayFriends: Operation {
    
    var controller = FriendTableViewController()
    
    override func main() {
        guard let parsefriends = dependencies.first as? SaveFriends,
              let fItems = parsefriends.friends else { return }
        controller.friendItems = fItems
        controller.tableView.reloadData()
        print("показаны друзья на экране")
    }
    
    init(_ controller: FriendTableViewController) {
        
        self.controller = controller
    }

}

