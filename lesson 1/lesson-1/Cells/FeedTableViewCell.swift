//
//  FeedTableViewCell.swift
//  client-server-1347
//
//  Created by Марк Киричко on 08.08.2021.
//

import UIKit
import Alamofire

class FeedTableViewCell: UITableViewCell {

    @IBOutlet weak var postUserGroupImage: RoundedImageView!
    @IBOutlet weak var postUserGroupName: UILabel!
    @IBOutlet weak var postDate: UILabel!
    @IBOutlet weak var postText: UILabel!
    @IBOutlet weak var postPhoto: UIImageView!
    @IBOutlet weak var likesViewsReposts: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(item: Item, profile: Profile? = nil, group: Group? = nil) {
        
        if let group = group {
            postUserGroupName.text = group.name
            
            AF.request(group.photo200, method: .get).responseImage { response in
                guard let image = response.value else { return }
                self.postUserGroupImage.image = image
            }
            
        } else {
            if let profile = profile {
                
                postUserGroupName.text = "\(profile.firstName) \(profile.lastName)"
                
                AF.request(profile.photo100, method: .get).responseImage { response in
                    guard let image = response.value else { return }
                    self.postUserGroupImage.image = image
                }
            }
        }
        
        postDate.text = item.date.getDateStringFromUTC()
        postText.text = item.text
        likesViewsReposts.text = "♡ \(item.likes.count!), ➪ \(item.reposts.count!), 👀 \(item.views.count),  💬 \(item.comments!.count!)"
        
        if item.attachments != nil {
            if let firstAttachment = item.attachments?[0] {
                
                switch firstAttachment.type {
                
                case "video":
                    
                    postPhoto.image = UIImage(named: "hz")
                
                case "link":
                    
                    //postText.text! += "\n[--link--]"
                    
                    if let photo604 = firstAttachment.link?.photo?.photo604 {
                        AF.request(photo604, method: .get).responseImage { response in
                            guard let image = response.value else { return }
                            self.postPhoto.image = image
                        }
                    }
                    
                case "photo":
                    
                    //postText.text! += "\n[--photo--]"
                    
                    if let photo604 = firstAttachment.photo?.photo604 {
                        AF.request(photo604, method: .get).responseImage { response in
                            guard let image = response.value else { return }
                            self.postPhoto.image = image
                        }
                    }
                    
                    if let photo807 = firstAttachment.photo?.photo807 {
                        AF.request(photo807, method: .get).responseImage { response in
                            guard let image = response.value else { return }
                            self.postPhoto.image = image
                        }
                    }
                    
                    if let photo1280 = firstAttachment.photo?.photo1280 {
                        AF.request(photo1280, method: .get).responseImage { response in
                            guard let image = response.value else { return }
                            self.postPhoto.image = image
                        }
                    }

                    
                default:
                    
                    postPhoto.image = UIImage(named: "defaultimage")
                }
            }
        }
        
    }
}

extension Double {
    func getDateStringFromUTC() -> String {
        let date = Date(timeIntervalSince1970: self)
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        return dateFormatter.string(from: date)
    }

}
