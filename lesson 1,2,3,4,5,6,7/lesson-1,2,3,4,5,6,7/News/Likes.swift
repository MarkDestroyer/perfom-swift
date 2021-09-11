//
//  Likes.swift
//  client-server-1347
//
//  Created by Марк Киричко on 12.09.2021.
//

import Foundation

// MARK: - Likes
struct Likes: Codable {
    let response: Response
}

// MARK: - Response
struct Response: Codable {
    let likes: Int
}

