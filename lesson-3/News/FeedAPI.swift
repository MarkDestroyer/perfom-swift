import Foundation
import Alamofire
import SwiftyJSON

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
            //"count": "1",
        ]
        
    }
    
    func get(_ completion: @escaping (Feed?) -> ()) {
        
        let url = baseUrl + method
        
        AF.request(url, method: .get, parameters: params).responseData { response in
            
            guard let data = response.data else { return }
            
            let decoder = JSONDecoder()
            let json = JSON(data)
            let dispatchGroup = DispatchGroup()
            
            let vkItemsJSONArr = json["response"]["items"].arrayValue
            let vkProfilesJSONArr = json["response"]["profiles"].arrayValue
            let vkGroupsJSONArr = json["response"]["groups"].arrayValue
            
            var vkItemsArray: [Item] = []
            var vkProfilesArray: [Profile] = []
            var vkGroupsArray: [Group] = []
            
            // decoding items
            DispatchQueue.global().async(group: dispatchGroup) {
                for (index, items) in vkItemsJSONArr.enumerated() {
                    do {
                        let decodedItem = try decoder.decode(Item.self, from: items.rawData())
                        vkItemsArray.append(decodedItem)
                        
                    } catch(let errorDecode) {
                        print("Item decoding error at index \(index), err: \(errorDecode)")
                    }
                }
                //print("items")
            }

            
            // decoding profiles
            DispatchQueue.global().async(group: dispatchGroup) {
                for (index, profiles) in vkProfilesJSONArr.enumerated() {
                    do {
                        let decodedItem = try decoder.decode(Profile.self, from: profiles.rawData())
                        vkProfilesArray.append(decodedItem)
                        
                    } catch(let errorDecode) {
                        print("Profile decoding error at index \(index), err: \(errorDecode)")
                    }
                }
                //print("profiles")
            }
            
            // decoding groups
            DispatchQueue.global().async(group: dispatchGroup) {
                for (index, groups) in vkGroupsJSONArr.enumerated() {
                    do {
                        let decodedItem = try decoder.decode(Group.self, from: groups.rawData())
                        vkGroupsArray.append(decodedItem)
                        
                    } catch(let errorDecode) {
                        print("Group decoding error at index \(index), err: \(errorDecode)")
                    }
                }
                //print("groups")
            }
            
            dispatchGroup.notify(queue: DispatchQueue.main) {
                let response = FeedResponse(items: vkItemsArray,
                                            profiles: vkProfilesArray,
                                            groups: vkGroupsArray)
                let feed = Feed(response: response)
                
                completion(feed)
            }
        }
    }
}


