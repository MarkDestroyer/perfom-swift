//
//  User1.swift
//  client-server-1347
//
//  Created by Artur Igberdin on 12.07.2021.
//

import Foundation
import RealmSwift

class User: Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var imageURL: String?
    @objc dynamic var country: String = ""
    @objc dynamic var city: String = ""
   
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
