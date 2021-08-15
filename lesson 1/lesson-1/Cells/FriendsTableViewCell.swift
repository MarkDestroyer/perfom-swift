//
//  FriendsTableViewCell.swift
//  client-server-1347
//
//  Created by Марк Киричко on 11.08.2021.
//

import UIKit
import Alamofire
import AlamofireImage

class FriendsTableViewCell: UITableViewCell {
        
    
    @IBOutlet weak var FriendPhoto: RoundedImageView!
    @IBOutlet weak var FriendName: UILabel!
    @IBOutlet weak var isOnline: UILabel!
    @IBOutlet weak var sex: UILabel!
    
    var cell = UITableViewCell()

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(_ friendItem: FriendItem) {
        if friendItem.online == 1 {
            isOnline.textColor = UIColor.green
            isOnline.text = "онлайн ●"
        } else if friendItem.online == 0 && friendItem.sex == 1 {
            isOnline.textColor = UIColor.darkGray
            isOnline.text = "заходила в"
        } else if friendItem.online == 0 && friendItem.sex == 2 {
            isOnline.textColor = UIColor.darkGray
            isOnline.text = "заходил в"
        }
        
        if friendItem.sex == 1 {
            sex.textColor = UIColor.purple
            sex.text = "♀"
            FriendPhoto.layer.borderWidth = 3
            FriendPhoto.layer.borderColor = UIColor.systemPink.cgColor
            FriendName.textColor = UIColor.systemPink
            
        } else if friendItem.sex == 2 {
            sex.textColor = UIColor.blue
            sex.text = "♂"
            FriendPhoto.layer.borderWidth = 3
            FriendPhoto.layer.borderColor = UIColor.blue.cgColor
            FriendName.textColor = UIColor.blue
        }
        

        
        FriendName.text = ("\(friendItem.first_name) \(friendItem.last_name)")
        
        AF.request(friendItem.photo_max!, method: .get).responseImage { response in
            guard let image = response.value else { return }
            self.FriendPhoto.image = image

      }
        
    }
}


extension Int {
    var formatteds: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: "RU")
        
        let number = NSNumber(value: self)
        let formattedValue = formatter.string(from: number)!
        return "\(formattedValue)"
    }

}
