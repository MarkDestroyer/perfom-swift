//
//  FriendsPromise.swift
//  client-server-1347
//
//  Created by Марк Киричко on 28.08.2021.
//

import Foundation
import Alamofire
import PromiseKit
import SwiftyJSON



func getAllUsers() -> Promise<[Friends]> {
    let baseUrl = "https://api.vk.com/method"
    let method = "/friends.get"
      
       let params: Parameters = [
        "client_id": Session.instance.cliendId,
        "user_id": Session.instance.userId,
        "access_token": Session.instance.token,
        "v": Session.instance.version,
        //"extended": "1",
        "fields": "online,first_name, photo_max, sex, bdate",
       ]
    
    let (promise, resolver) = Promise<[Friends]>.pending()
    
    let url = baseUrl + method
    
    AF.request(url, method: .get, parameters: params).responseData { response in
        
        print(response.request!)
        
        guard let data = response.data else { return }
        
        do {
           let friends = try JSONDecoder().decode([Friends].self, from: data)
            resolver.fulfill(friends)
        } catch {
            print(error)
        }
        
    }
return promise

}
