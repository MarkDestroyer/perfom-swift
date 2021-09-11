//
//  FeedItemTextTableViewCell.swift
//  client-server-1347
//
//  Created by Марк Киричко on 25.08.2021.
//

import UIKit
import ActiveLabel

class FeedItemTextTableViewCell: UITableViewCell {
    
    @IBOutlet weak var feedItemText: ActiveLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(text: String?, expanded: Bool, readMoreHandler: @escaping () -> ()) {
        
        guard let text = text else { return }

        feedItemText.customize { label in
            
            if text.byWords.count > maxWordsCount && !expanded {
                
                label.text = String(describing: text.firstLine!)
                label.text! += "\n\n" + readMore
                
            } else {
                label.text = text
            }
            
            let vkHashTag = ActiveType.custom(pattern: #"#\S+"#)
            let readMoreType = ActiveType.custom(pattern: readMore)
            
            label.urlMaximumLength = 22
            label.enabledTypes = [.url, vkHashTag, readMoreType]
            
            label.customColor[vkHashTag] = activeHashTagColor
            label.customSelectedColor[vkHashTag] = activeHashTagColorSelected
            
            label.customColor[readMoreType] = activeURLColor
            label.customSelectedColor[readMoreType] = activeURLColorSelected
            
            label.URLColor = activeURLColor
            label.URLSelectedColor = activeURLColorSelected
            
            label.handleURLTap { url in
                UIApplication.shared.open(url)
            }
            
            label.handleCustomTap(for: readMoreType) { _ in
                label.text = text
                readMoreHandler()
                  
            }
        }
    }
}


