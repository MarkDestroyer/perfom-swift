//
//  GroupsOperations.swift
//  client-server-1347
//
//  Created by Марк Киричко on 22.08.2021.
//

import Foundation
import RealmSwift
import Alamofire

class FetchGroups: Operation {
    
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
            URLQueryItem(name: "fields", value: "members_count"),
        ]
        
        guard let url = components.url else { return }
        guard let data = try? Data(contentsOf: url) else { return }
        self.data = data
    }
}

class ParseGroups: Operation {
    
    var groups: [GroupItem]? = []
    
    override func main() {
        guard let fdata = dependencies.first as? FetchGroups,
              let data = fdata.data else { return }
        do {
            var groups: Groups
            groups = try JSONDecoder().decode(Groups.self, from: data)
            self.groups = groups.response.items
        } catch {
            print(error)
        }
    }
}


class SaveGroups: Operation {
    
    let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    lazy var mainRealm = try! Realm(configuration: config)
    var groups: [GroupItem]? = []
    
    override func main() {
        guard let bd = dependencies.first as? ParseGroups,
              let data = bd.groups else { return }
              
        func get() -> Results<GroupItem> {
            
            let groups = mainRealm.objects(GroupItem.self)
            print("группы получены")
            return groups
        }
        
        func addUpdate(_ friends: [GroupItem]) {
            
            do {
                mainRealm.beginWrite()
                friends.forEach{ mainRealm.add($0, update: .all) }
                try mainRealm.commitWrite()
            } catch {
                print(error)
            }
        
        }
    }
}


class DisplayGroups: Operation {
    
    var controller = GroupTableViewController()
    
    override func main() {
        guard let parsegroups = dependencies.first as? SaveGroups,
              let groupItems = parsegroups.groups else { return }
        controller.groupItems = groupItems
        controller.tableView.reloadData()
        print("показаны группы на экране")
    }
    
    init(_ controller: GroupTableViewController) {
        
        self.controller = controller
    }

}
