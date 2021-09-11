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
    
    let instets: CGFloat = 10.0
    
    
    @IBOutlet weak var FriendPhoto: RoundedImageView! {
        didSet {
            FriendPhoto.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    @IBOutlet weak var FriendName: UILabel! {
        didSet {
            FriendName.translatesAutoresizingMaskIntoConstraints = false
        }
        
    }
    @IBOutlet weak var isOnline: UILabel! {
        didSet {
            isOnline.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    @IBOutlet weak var sex: UILabel! {
        didSet {
            sex.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
            super.layoutSubviews()
            
        NameLabelFrame()
        onlineLabelFrame()
        photoFrame()
    }
    
    func getLabelSize(text: String, font: UIFont) -> CGSize {
            // определяем максимальную ширину текста - это ширина ячейки минус отступы слева и справа
            let maxWidth = bounds.width - instets * 2
            // получаем размеры блока под надпись
            // используем максимальную ширину и максимально возможную высоту
            let textBlock = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
            // получаем прямоугольник под текст в этом блоке и уточняем шрифт
        let rect = text.boundingRect(with: textBlock, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
            // получаем ширину блока, переводим её в Double
            let width = Double(rect.size.width)
            // получаем высоту блока, переводим её в Double
            let height = Double(rect.size.height)
            // получаем размер, при этом округляем значения до большего целого числа
            let size = CGSize(width: ceil(width), height: ceil(height))
            return size
    }
    
    func NameLabelFrame() {
            // получаем размер текста, передавая сам текст и шрифт
            let weaterLabelSize = getLabelSize(text: FriendName.text!, font: FriendName.font)
            // рассчитываем координату по оси Х
            let weaterLabelX = (bounds.width - weaterLabelSize.width) / 2
            // получаем точку верхнего левого угла надписи
            let weaterLabelOrigin =  CGPoint(x: weaterLabelX, y: instets)
            // получаем фрейм и устанавливаем его UILabel
        FriendName.frame = CGRect(origin: weaterLabelOrigin, size: weaterLabelSize)
    }
    
    func onlineLabelFrame() {
            // получаем размер текста, передавая сам текст и шрифт
            let timeLabelSize = getLabelSize(text: isOnline.text!, font: isOnline.font)
            // рассчитываем координату по оси Х
            let timeLabelX = (bounds.width - timeLabelSize.width) / 2
            // рассчитываем координату по оси Y
            let timeLabelY = bounds.height - timeLabelSize.height - instets
            // получаем точку верхнего левого угла надписи
            let timeLabelOrigin =  CGPoint(x: timeLabelX, y: timeLabelY)
            // получаем фрейм и устанавливаем UILabel
            isOnline.frame = CGRect(origin: timeLabelOrigin, size: timeLabelSize)
    }
    
    func photoFrame() {
            let iconSideLinght: CGFloat = 50
            let iconSize = CGSize(width: iconSideLinght, height: iconSideLinght)
            let iconOrigin = CGPoint(x: bounds.midX - iconSideLinght / 2, y: bounds.midY - iconSideLinght / 2)
            FriendPhoto.frame = CGRect(origin: iconOrigin, size: iconSize)
        }
    
    func configure(_ friendItem: FriendItem) {
        
        if friendItem.online == 1 {
            isOnline.textColor = UIColor.green
            isOnline.text = "онлайн ●"
        } else if friendItem.online == 0 && friendItem.sex == 1 {
            isOnline.textColor = UIColor.darkGray
            isOnline.text = "заходила \(friendItem.lastSeen?.time.getRelativeDateStringFromUTC().lowercased() ?? "")"
        } else if friendItem.online == 0 && friendItem.sex == 2 {
            isOnline.textColor = UIColor.darkGray
            isOnline.text = "заходил \(friendItem.lastSeen?.time.getRelativeDateStringFromUTC().lowercased() ?? "") "
        }
        
        if friendItem.sex == 1 {
            sex.textColor = UIColor.systemPink
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
                NameLabelFrame()
                onlineLabelFrame()
                photoFrame()
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
