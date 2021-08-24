//
//  UserFB.swift
//  client-server-1347
//
//  Created by Марк Киричко on 01.08.2021.
//

import Foundation
import Firebase

class UserFB {
    
    let id: Int
    let firstName: String
    let lastName: String
    let city: String
    let country: String
    let imageURL: String?
    
    let ref: DatabaseReference?
    
    init(id: Int, firstName: String, lastName: String, city: String, country: String, imageURL: String?) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.city = city
        self.country = country
        self.imageURL = imageURL
        
        self.ref = nil
    }
    
    init?(snapshot: DataSnapshot) {
        
        guard let value = snapshot.value as? [String: Any],
              let id = value["id"] as? Int,
              let firstName = value["firstName"] as? String,
              let lastName = value["lastName"] as? String,
              let city = value["city"] as? String,
              let country = value["country"] as? String,
              let imageURL = value["imageURL"] as? String else {
            return nil
        }
        
        self.ref = snapshot.ref
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.city = city
        self.country = country
        self.imageURL = imageURL
    }
    
    func toAnyObject() -> [AnyHashable: Any] {
        return ["id": id,
                "firstName": firstName,
                "lastName": lastName,
                "city": city,
                "country": country,
                "imageURL": imageURL!] as [AnyHashable: Any]
    }
}
