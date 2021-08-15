//
//  PhotoApi.swift
//  client-server-1347
//
//  Created by Марк Киричко on 14.07.2021.
//

import Foundation
import Alamofire

// === СПИСОК ГРУПП (КОДАБЛ) ===

class FriendsAPI {
    
    let baseUrl = "https://api.vk.com/method"
    let method = "/friends.get"
    
    var params: Parameters
    
    init(_ session: Session) {
        
        self.params = [
            "client_id": session.cliendId,
            "user_id": session.userId,
            "access_token": session.token,
            "v": session.version,
            //"extended": "1",
            "fields": "online,first_name, photo_max, sex, bdate, last_seen",
            
        ]
        
    }
    
    func get(_ completion: @escaping (Friends?) -> ()) {
        
        let url = baseUrl + method
        
        AF.request(url, method: .get, parameters: params).responseData { response in
            
            print(response.request!) 
            
            guard let data = response.data else { return }
            
            do {
                var friends: Friends
                friends = try JSONDecoder().decode(Friends.self, from: data)
                completion(friends)
            } catch {
                print(error)
            }
            
        }
    }
}
