//
//  GroupTableViewCell.swift
//  ys-client-server-1347
//
//  Created by Ярослав on 13.07.2021.
//

import UIKit
import Alamofire
import AlamofireImage

class GroupTableViewCell: UITableViewCell {
    
    @IBOutlet weak var groupImage: RoundedImageView!
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var groupDescription: UILabel!
    @IBOutlet weak var groupMemebersCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(_ groupItem: GroupItem) {
        
        groupName.text = groupItem.name
        
        if let description = groupItem.groupDescription {
            groupDescription.text = description
        }
        
        groupMemebersCount.text =  "\(groupItem.membersCount.formatted) подписчиков"
        
        AF.request(groupItem.imageURL, method: .get).responseImage { response in
            guard let image = response.value else { return }
            self.groupImage.image = image
        }
    }
}

extension Int {
    var formatted: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: "RU")
        
        let number = NSNumber(value: self)
        let formattedValue = formatter.string(from: number)!
        return "\(formattedValue)"
    }
}
