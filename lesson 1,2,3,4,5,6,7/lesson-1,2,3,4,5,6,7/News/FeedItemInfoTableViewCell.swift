//
//  FeedItemInfoTableViewCell.swift
//  client-server-1347
//
//  Created by Марк Киричко on 25.08.2021.
//

import UIKit
import Alamofire

class FeedItemInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var feedItemPostDate: UILabel!
    @IBOutlet weak var feedItemUserGroupName: UILabel!
    @IBOutlet weak var feedItemUserGroupImage: RoundedImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        feedItemUserGroupImage.image = nil
    }
    
    func configure(profile: Profile? = nil, group: Group? = nil, postDate: Double) {
        
        if let group = group {
            feedItemUserGroupName.text = group.name
            feedItemUserGroupImage.asyncLoadImageUsingCache(withUrl: group.photo100)
        } else if let profile = profile {
            feedItemUserGroupName.text = "\(profile.firstName) \(profile.lastName)"
            feedItemUserGroupImage.asyncLoadImageUsingCache(withUrl: profile.photo100)
        }
        
        feedItemPostDate.text = postDate.getRelativeDateStringFromUTC()
    }
}
