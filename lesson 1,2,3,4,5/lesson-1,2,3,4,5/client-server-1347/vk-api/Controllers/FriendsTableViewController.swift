//
//  FriendsTableViewController.swift
//  client-server-1347
//
//  Created by Марк Киричко on 20.07.2021.
//

import UIKit
import RealmSwift
import Firebase
import PromiseKit
import Alamofire

class FriendTableViewController: UITableViewController {
    
    
    var friendItems: [FriendItem] = []
    
//    func ParseFriendPhoto(_ user: Friends) -> Promise<UIImage> {
//        return Promise<UIImage> { seal in
//            guard let imageURL = user.response  else  {
//                seal.reject(Error.self as! Error)
//                return
//            }
//           
//            AF.request(imageURL, method: .get).responseImage { response in
//                
//                guard let image = response.value else {return}
//                seal.fulfill(image)
//            }
//            
//        }
//    }
    
    
    func DisplayFriendData() {
        
    }
    
    
    func FetchFriendData() -> Promise<Friends> {
        
        return Promise<Friends> { seal in
            
            FriendsAPI(Session.instance).get{ [weak self] user in
                guard self == self else {
                    seal.reject(Error.self as! Error)
                    return
                }
                
                seal.fulfill(user!)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FriendsAPI(Session.instance).get{ [weak self] friends in
            guard let self = self else { return }
            self.friendItems = friends!.response.items
            self.tableView.reloadData()
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsTableViewCell") as? FriendsTableViewCell
        else { return UITableViewCell() }
        
        cell.configure(friendItems[indexPath.row])
        return cell
        
    }
}
