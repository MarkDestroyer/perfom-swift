//
//  FeedTableViewController.swift
//  client-server-1347
//
//  Created by Марк Киричко on 08.08.2021.
//

import UIKit

class FeedTableViewController: UITableViewController {
    
    var feedItems: [Item] = []
    var feedProfiles: [Profile] = []
    var feedGroups: [Group] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        FeedAPI(Session.instance).get{ [weak self] feed in
            guard let self = self else { return }
            self.feedItems = feed!.response.items
            self.feedProfiles = feed!.response.profiles
            self.feedGroups = feed!.response.groups
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! FeedTableViewCell
        //cell.textLabel?.text = feedItems[indexPath.row].text
        
        let currentFeedItem = feedItems[indexPath.row]
        
        switch feedItems[indexPath.row].sourceID.signum() {
        
        case 1: // Пост пользователя
            let currentFeedItemProfile = feedProfiles.filter{ $0.id == currentFeedItem.sourceID }[0]
            cell.configure(item: currentFeedItem, profile: currentFeedItemProfile)
            
        case -1: // Пост группы
            let currentFeedItemGroup = feedGroups.filter{ $0.id == abs(currentFeedItem.sourceID) }[0]
            cell.configure(item: currentFeedItem, group: currentFeedItemGroup)
            
        default: break
        }
        
        return cell
    }
}
