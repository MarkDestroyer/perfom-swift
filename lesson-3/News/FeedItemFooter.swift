//
//  FeedItemFooter.swift
//  ys-client-server-1347
//
//  Created by Ярослав on 16.08.2021.
//


import Foundation
import UIKit

class FeedItemFooter: UITableViewHeaderFooterView {
    
    var likes = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureContents() {
        
        likes.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(likes)
        
        likes.font = UIFont.preferredFont(forTextStyle: .footnote)
        likes.textColor = UIColor.secondaryLabel
        
        NSLayoutConstraint.activate([
            likes.heightAnchor.constraint(equalToConstant: 50),
            likes.leadingAnchor.constraint(equalTo:  contentView.layoutMarginsGuide.leadingAnchor),
            likes.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            likes.centerYAnchor.constraint(equalTo:  contentView.centerYAnchor)
        ])
    }
}
