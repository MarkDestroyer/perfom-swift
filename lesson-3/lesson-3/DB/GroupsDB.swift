//
//  GroupsDB.swift
//  client-server-1347
//
//  Created by Марк Киричко on 24.07.2021.
//

import Foundation
import RealmSwift

protocol GroupDBProtocol {
    
    func get() -> Results<GroupItem>
    func addUpdate(_ groups: [GroupItem])
}

class GroupDB: GroupDBProtocol {
    
    let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    lazy var mainRealm = try! Realm(configuration: config)
    
    func get() -> Results<GroupItem> {
        
        let groups = mainRealm.objects(GroupItem.self)
        return groups
    }
    
    func addUpdate(_ groups: [GroupItem]) {
        
        do {
            mainRealm.beginWrite()
            groups.forEach{ mainRealm.add($0, update: .all) }
            try mainRealm.commitWrite()
        } catch {
            print(error)
        }
    }
}
