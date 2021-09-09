//
//  FeedItemTextTableViewCell.swift
//  client-server-1347
//
//  Created by Марк Киричко on 25.08.2021.
//

import UIKit
import TTTAttributedLabel

class FeedItemTextTableViewCell: UITableViewCell {
    
    let kCharacterBeforReadMore =  50
    let kReadMoreText           =  "...ReadMore"
    let kReadLessText           =  "...ReadLess"
    
    @IBOutlet weak var feedItemText: TTTAttributedLabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    
    func readMore(readMore: Bool) {
        feedItemText.showTextOnTTTAttributeLable(str: feedItemText.text as! String, readMoreText: kReadMoreText, readLessText: kReadLessText, font: nil, charatersBeforeReadMore: kCharacterBeforReadMore, activeLinkColor: UIColor.blue, isReadMoreTapped: readMore, isReadLessTapped: false)
          }
          func readLess(readLess: Bool) {
            feedItemText.showTextOnTTTAttributeLable(str: feedItemText.text as! String, readMoreText: kReadMoreText, readLessText: kReadLessText, font: nil, charatersBeforeReadMore: kCharacterBeforReadMore, activeLinkColor: UIColor.blue, isReadMoreTapped: readLess, isReadLessTapped: true)
          }

    func configure(text: String?) {
        feedItemText.text = text
        feedItemText.showTextOnTTTAttributeLable(str: text!, readMoreText: kReadMoreText, readLessText: kReadLessText, font: UIFont.init(name: "Helvetica-Bold", size: 24.0)!, charatersBeforeReadMore: kCharacterBeforReadMore, activeLinkColor: UIColor.blue, isReadMoreTapped: false, isReadLessTapped: false)
        feedItemText.delegate = self
    }
}

extension TTTAttributedLabel {
      func showTextOnTTTAttributeLable(str: String, readMoreText: String, readLessText: String, font: UIFont?, charatersBeforeReadMore: Int, activeLinkColor: UIColor, isReadMoreTapped: Bool, isReadLessTapped: Bool) {

        let text = str + readLessText
        let attributedFullText = NSMutableAttributedString.init(string: text)
        let rangeLess = NSString(string: text).range(of: readLessText, options: String.CompareOptions.caseInsensitive)
//Swift 5
       // attributedFullText.addAttributes([NSAttributedStringKey.foregroundColor : UIColor.blue], range: rangeLess)
        attributedFullText.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.blue], range: rangeLess)

        var subStringWithReadMore = ""
        if text.count > charatersBeforeReadMore {
          let start = String.Index(encodedOffset: 0)
          let end = String.Index(encodedOffset: charatersBeforeReadMore)
          subStringWithReadMore = String(text[start..<end]) + readMoreText
        }

        let attributedLessText = NSMutableAttributedString.init(string: subStringWithReadMore)
        let nsRange = NSString(string: subStringWithReadMore).range(of: readMoreText, options: String.CompareOptions.caseInsensitive)
        //Swift 5
       // attributedLessText.addAttributes([NSAttributedStringKey.foregroundColor : UIColor.blue], range: nsRange)
        attributedLessText.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.blue], range: nsRange)
      //  if let _ = font {// set font to attributes
      //   self.font = font
      //  }
        self.attributedText = attributedLessText
        self.activeLinkAttributes = [NSAttributedString.Key.foregroundColor : UIColor.blue]
        //Swift 5
       // self.linkAttributes = [NSAttributedStringKey.foregroundColor : UIColor.blue]
        self.linkAttributes = [NSAttributedString.Key.foregroundColor : UIColor.blue]
                self.addLink(toTransitInformation: ["ReadMore":"1"], with: nsRange)

                if isReadMoreTapped {
                  self.numberOfLines = 0
                  self.attributedText = attributedFullText
                  self.addLink(toTransitInformation: ["ReadLess": "1"], with: rangeLess)
                }
                if isReadLessTapped {
                  self.numberOfLines = 3
                  self.attributedText = attributedLessText
                }
              }
            }

extension FeedItemTextTableViewCell: TTTAttributedLabelDelegate {
  func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWithTransitInformation components: [AnyHashable : Any]!) {
    if let _ = components as? [String: String] {
      if let value = components["ReadMore"] as? String, value == "1" {
        self.readMore(readMore: true)
      }
      if let value = components["ReadLess"] as? String, value == "1" {
        self.readLess(readLess: false)
      }
    }
  }
}

