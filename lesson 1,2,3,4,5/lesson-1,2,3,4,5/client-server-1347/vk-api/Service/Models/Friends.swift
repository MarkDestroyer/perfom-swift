//
//  Photo.swift
//  client-server-1347
//
//  Created by Марк Киричко on 14.07.2021.
//

import Foundation
import RealmSwift

// MARK: - Main
struct Friends: Codable {
    let response: ResponseFriend
}

// MARK: - Response
struct ResponseFriend: Codable {
    let count: Int
    let items: [FriendItem]
}

// MARK: - Item
class FriendItem: Object, Codable {
    @objc dynamic var first_name: String = ""
    @objc dynamic var last_name: String = ""
    @objc dynamic var photo_max: String?
    @objc dynamic var id: Int = 0
    @objc dynamic var online: Int = 0
    @objc dynamic var sex: Int = 0
    @objc dynamic var bdate: String?

    
    enum CodingKeys: String, CodingKey {
        case id
        case first_name = "first_name"
        case last_name = "last_name"
        case photo_max = "photo_max"
        case online
        case sex
        case bdate

    }

    override static func primaryKey() -> String? {
        return "id"
    }
}





