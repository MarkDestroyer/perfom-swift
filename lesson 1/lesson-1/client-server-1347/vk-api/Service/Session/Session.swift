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
    
    var userId: String = ""
    var token: String = ""
    
    let cliendId = "7900300"
    var version = "5.68"
}
