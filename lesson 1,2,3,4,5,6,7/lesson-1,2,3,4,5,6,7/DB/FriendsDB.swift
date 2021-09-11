//
//  FriendsDB.swift
//  client-server-1347
//
//  Created by Марк Киричко on 24.07.2021.
//

import Foundation
import RealmSwift

protocol FriendDBProtocol {
    
    func get() -> Results<FriendItem>
    func addUpdate(_ groups: [FriendItem])
}

class FriendDB: FriendDBProtocol {
    
    let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
    lazy var mainRealm = try! Realm(configuration: config)
    
    func get() -> Results<FriendItem> {
        
        let friends = mainRealm.objects(FriendItem.self)
        return friends
    }
    
    func addUpdate(_ groups: [FriendItem]) {
        
        do {
            mainRealm.beginWrite()
            groups.forEach{ mainRealm.add($0, update: .all) }
            try mainRealm.commitWrite()
        } catch {
            print(error)
        }
    }
}
