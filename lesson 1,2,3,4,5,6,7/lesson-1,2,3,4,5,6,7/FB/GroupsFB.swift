//
//  GroupsFB.swift
//  client-server-1347
//
//  Created by Марк Киричко on 31.07.2021.
//

import Foundation
import Firebase


class GroupFB {
    
    let id: Int
    let name: String
    let groupDescription: String
    let imageURL: String
    let membersCount: Int
    
    let ref: DatabaseReference?
    
    init(id: Int, name: String, groupDescription: String?, imageURL: String, membersCount: Int) {
        self.id = id
        self.name = name
        self.groupDescription = groupDescription ?? ""
        self.imageURL = imageURL
        self.membersCount = membersCount
        
        self.ref = nil
    }
    
    init?(snapshot: DataSnapshot) {
        
        guard let value = snapshot.value as? [String: Any],
              let id = value["id"] as? Int,
              let name = value["name"] as? String,
              let groupdescription = value["groupDescription"] as? String,
              let imageURL = value["imageURL"] as? String,
              let membersCount = value["membersCount"] as? Int else {
            return nil
        }
        
        self.ref = snapshot.ref
        self.id = id
        self.name = name
        self.groupDescription = groupdescription
        self.membersCount = membersCount
        self.imageURL = imageURL
    }
    
    func toAnyObject() -> [AnyHashable: Any] {
        return ["id": id,
                "name": name,
                "groupDescription": groupDescription,
                "membersCount": membersCount,
                "imageURL": imageURL] as [AnyHashable: Any]
    }
}

