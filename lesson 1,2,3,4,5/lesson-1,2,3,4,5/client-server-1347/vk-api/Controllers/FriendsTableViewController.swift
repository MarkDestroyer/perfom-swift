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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        
        tableView.separatorStyle = .none
        
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



    // MARK: - Refresh table.
    @objc func refresh(sender:AnyObject)
    {
        FriendsAPI(Session.instance).get{ [weak self] friends in
            guard let self = self else { return }
            self.friendItems = friends!.response.items
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }


}
