//
//  FriendsTableViewController.swift
//  client-server-1347
//
//  Created by Марк Киричко on 20.07.2021.
//

import UIKit
import RealmSwift
import Firebase


class FriendTableViewController: UITableViewController {
    
    
    var friendItems: [FriendItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       getAllUsers()
            .done { users in
                print(users)
            }.catch { error in
                print(error)
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
