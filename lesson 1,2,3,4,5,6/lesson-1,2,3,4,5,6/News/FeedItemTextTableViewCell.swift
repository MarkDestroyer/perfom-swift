//
//  FeedItemTextTableViewCell.swift
//  client-server-1347
//
//  Created by Марк Киричко on 25.08.2021.
//

import UIKit


class FeedItemTextTableViewCell: UITableViewCell {
    
    @IBOutlet weak var feedItemText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(text: String?) {
        feedItemText.text = text
        //let str = "This is a Very Long Label"
        let nsString = text as! NSString
        if nsString.length >= 200
        {
            feedItemText.text = nsString.substring(with: NSRange(location: 0, length: nsString.length > 10 ? 10 : nsString.length))
        }
    }
}
