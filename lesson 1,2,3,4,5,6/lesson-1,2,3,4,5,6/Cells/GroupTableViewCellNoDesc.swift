//
//  GroupTableViewCellNoDesc.swift
//  ys-client-server-1347
//
//  Created by Ярослав on 13.07.2021.
//

import UIKit
import Alamofire

class GroupTableViewCellNoDesc: UITableViewCell {
    
    @IBOutlet weak var groupImage: RoundedImageView!
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var membersCount: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(_ groupItem: GroupItem) {
        
        groupName.text = groupItem.name
        
        membersCount.text =  "\(groupItem.membersCount.formatted) подписчиков"
        
        AF.request(groupItem.imageURL, method: .get).responseImage { response in
            guard let image = response.value else { return }
            self.groupImage.image = image
        }
    }
}
