//
//  FriendsFB.swift
//  client-server-1347
//
//  Created by Марк Киричко on 31.07.2021.
//

import Foundation
import Firebase


class FriendFB {
    
    let id: Int
    let name: String
    let imageURL: String
    let lastname: String
    
    let ref: DatabaseReference?
    
    init(id:Int, name: String, imageURL: String, lastname: String) {
        self.name = name
        self.imageURL = imageURL
        self.id = id
        self.ref = nil
        self.lastname = lastname
    }
    
    init?(snapshot: DataSnapshot) {
        
        guard let value = snapshot.value as? [String: Any],
              let name = value["name"] as? String,
              let lastname = value["lastname"] as? String,
              let id = value["id"] as? Int,
              let imageURL = value["imageURL"] as? String else {
            return nil
        }
        
        self.ref = snapshot.ref
        self.name = name
        self.imageURL = imageURL
        self.id = id
        self.lastname = lastname
    }
    
    func toAnyObject() -> [AnyHashable: Any] {
        return [
            "name": name,
            "id": id,
            "lastname": lastname,
            "imageURL": imageURL] as [AnyHashable: Any]
    }
}

