//
//  FeedItemFooter.swift
//  client-server-1347
//
//  Created by Марк Киричко on 25.08.2021.
//

import Foundation
import UIKit

class FeedItemFooter: UITableViewHeaderFooterView {
    
    var postInfo = UILabel()
    var likeButton = LikeButton()
    var stackView = UIStackView()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureContents() {
        
        postInfo.font = UIFont.preferredFont(forTextStyle: .footnote)
        postInfo.textColor = UIColor.secondaryLabel
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 10
        
        stackView.insertArrangedSubview(likeButton, at: 0)
        stackView.insertArrangedSubview(postInfo, at: 1)
        
        contentView.addSubview(stackView)

        
        NSLayoutConstraint.activate([
            
            stackView.heightAnchor.constraint(equalToConstant: 50),
            stackView.leadingAnchor.constraint(equalTo:  contentView.layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            stackView.centerYAnchor.constraint(equalTo:  contentView.centerYAnchor),
        ])
    }
}
