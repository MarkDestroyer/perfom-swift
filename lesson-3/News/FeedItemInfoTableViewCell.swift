//
//  FeedItemInfoTableViewCell.swift
//  ys-client-server-1347
//
//  Created by Ярослав on 15.08.2021.
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(profile: Profile? = nil, group: Group? = nil, postDate: Double) {
        
        if let group = group {
            feedItemUserGroupName.text = group.name
            
            AF.request(group.photo100, method: .get).responseImage { response in
                guard let image = response.value else { return }
                self.feedItemUserGroupImage.image = image
            }
            
        } else {
            
            if let profile = profile {
                
                feedItemUserGroupName.text = "\(profile.firstName) \(profile.lastName)"
                
                AF.request(profile.photo100, method: .get).responseImage { response in
                    guard let image = response.value else { return }
                    self.feedItemUserGroupImage.image = image
                }
            }
        }
        
        feedItemPostDate.text = postDate.getDateStringFromUTC()
    }
}
