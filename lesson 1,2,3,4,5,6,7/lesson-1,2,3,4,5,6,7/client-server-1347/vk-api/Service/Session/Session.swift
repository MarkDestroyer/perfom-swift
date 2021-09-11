//
//  Session.swift
//  client-server-1347
//
//  Created by Artur Igberdin on 12.07.2021.
//

import Foundation

class Session {
    
    static let instance = Session()
    
    private init() {}
    
    var userId: Int = 0
    var token: String = ""
    
    // My Client ID's
    // 7937012 (main)
    // 7938282 (reserve)
    
    let cliendId = "7938282"
    let version = "5.131"
}
