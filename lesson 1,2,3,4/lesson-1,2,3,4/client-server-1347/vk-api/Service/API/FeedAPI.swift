//
//  FeedAPI.swift
//  client-server-1347
//
//  Created by Марк Киричко on 08.08.2021.
//

import Foundation
import Alamofire

// === ЛЕНТА НОВОСТЕЙ ===

class FeedAPI {
    
    let baseUrl = "https://api.vk.com/method"
    let method = "/newsfeed.get"
    
    var params: Parameters
    
    init(_ session: Session) {
        
        self.params = [
            "client_id": session.cliendId,
            "user_id": session.userId,
            "access_token": session.token,
            "v": session.version,
            "filters": "post",
            "count": "100",
        ]
        
    }
    
    func get(_ completion: @escaping (Feed?) -> ()) {
        
        let url = baseUrl + method
        
        AF.request(url, method: .get, parameters: params).responseData { response in
            
            //print(response.request)
            
            guard let data = response.data else { return }
            
            do {
                var feed: Feed
                feed = try JSONDecoder().decode(Feed.self, from: data)
                completion(feed)
            } catch {
                print(error)
            }
            
        }
    }
}

