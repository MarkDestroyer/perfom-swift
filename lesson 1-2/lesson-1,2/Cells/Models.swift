//
//  Models.swift
//  client-server-1347
//
//  Created by Марк Киричко on 17.08.2021.
//

import Foundation

struct CommonResponseNews: Codable {
    let response: ResponseNews
}

struct ResponseNews: Codable {
    let items: [NewsVK]
    let profiles: [UserVK]
    let groups: [GroupVK]
    let nextFrom: String?

    enum CodingKeys: String, CodingKey {
        case items, profiles, groups
        case nextFrom = "next_from"
    }
}

struct NewsVK: Codable {
    let id: Int?
    let ownerId: Int?
    let sourceId: Int?
    let fromId: Int?
    let date: Int
    let text: String
    let attachments: [Attachments]?
    let comments: CommentsNews2
    let likes: LikesNews
    let reposts: RepostsNews
    let views: ViewsNews?

    enum CodingKeys: String, CodingKey {
        case id
        case ownerId = "owner_id"
        case sourceId = "source_id"
        case fromId = "from_id"
        case date
        case text
        case attachments
        case comments, likes, reposts, views
    }
}

struct Attachments: Codable {
    let type: String
    let photo: PhotoNews?
}

struct PhotoNews: Codable {
    let sizes: [Size]?
}

struct CommentsNews2: Codable {
    let count: Int

    enum CodingKeys: String, CodingKey {
        case count
    }
}

struct LikesNews: Codable {
    let count, userLikes: Int?

    enum CodingKeys: String, CodingKey {
        case count
        case userLikes = "user_likes"
    }
}

struct RepostsNews: Codable {
    let count, userReposted: Int?

    enum CodingKeys: String, CodingKey {
        case count
        case userReposted = "user_reposted"
    }
}

struct ViewsNews: Codable {
    let count: Int
}

struct UserVK: Codable {
    let id: Int
    let firstName, lastName: String
    var fullname: String { return firstName + " " + lastName }
    let isClosed, canAccessClosed: Bool?
    let photo100: String
    let online: Int
    let deactivated: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case isClosed = "is_closed"
        case canAccessClosed = "can_access_closed"
        case photo100 = "photo_100"
        case online
        case deactivated
    }
}

struct GroupVK: Codable {
    let id: Int
    let name, screenName: String
    let isClosed: Int
    let type: String
    let isAdmin, isMember, isAdvertiser: Int?
    let activity: String?
    let membersCount: Int?
    let photo100: String
    let adminLevel: Int?

    enum CodingKeys: String, CodingKey {
        case id, name
        case screenName = "screen_name"
        case isClosed = "is_closed"
        case type
        case isAdmin = "is_admin"
        case isMember = "is_member"
        case isAdvertiser = "is_advertiser"
        case activity
        case membersCount = "members_count"
        case photo100 = "photo_100"
        case adminLevel = "admin_level"
    }
}


struct ResponseAdvancedUser: Codable {
    let response: [AdvancedUserVK]
}

struct AdvancedUserVK: Codable {
    let id: Int
    let firstName, lastName: String
    var fullname: String { return firstName + " " + lastName }
    let city: City?
    let hasPhoto, online: Int
    let status: String?
    let lastSeen: LastSeen
    let cropPhoto: CropPhoto?
    let counters: Counters
    let career: [Career]?
    
    enum CodingKeys: String, CodingKey {
           case id
           case firstName = "first_name"
           case lastName = "last_name"
           case city
           case hasPhoto = "has_photo"
           case online, status
           case lastSeen = "last_seen"
           case cropPhoto = "crop_photo"
           case counters, career
       }
}

struct City: Codable {
    let title: String?
}

struct LastSeen: Codable {
    let time, platform: Int
}

struct CropPhoto: Codable {
    let photo: Photos
    let crop, rect: Crop
}

struct Photos: Codable {
    let sizes: [Size]?
}

struct Crop: Codable {
    let x, y, x2, y2: Double
}

struct Counters: Codable {
    let photos: Int?
    let friends: Int?
    let mutualFriends: Int?
    let followers: Int?
    
    enum CodingKeys: String, CodingKey {
        case photos
        case friends
        case mutualFriends = "mutual_friends"
        case followers
    }
}
    
struct Career: Codable {
    let company: String?
}

struct Size: Codable {
    let type: String
    let url: String
    let width, height: Int
}
