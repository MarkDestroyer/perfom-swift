//
//  FriendsViewController.swift
//  client-server-1347
//
//  Created by Artur Igberdin on 12.07.2021.
//

import UIKit
import Alamofire
import AlamofireImage
import PromiseKit




class UserInfoViewController: UIViewController {
    
    @IBOutlet weak var userImage: RoundedImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var pinIcon: UIImageView!
    @IBOutlet weak var userLocation: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FetchUserData().then { [self] user in
            ParseUsePhoto(user).map {($0, user)}
        }.done { [self] image,user  in
            display(user, image: image)
        }.catch { error in
            print(error)
        }
    }
    
    
    func FetchUserData() -> Promise<User> {
        
        return Promise<User> { seal in
            
            UserAPI(Session.instance).get{ [weak self] user in
                guard self == self else {
                    seal.reject(UserAPI.ApplicationError.unknownError)
                    return
                }
                
                seal.fulfill(user!)
            }
        }
    }
    
    
    
    func ParseUsePhoto(_ user: User) -> Promise<UIImage> {
        return Promise<UIImage> { seal in
            guard let imageURL = user.response[0].photo_200  else  {
                seal.reject(UserAPI.ApplicationError.noPhotoUrls)
                return
            }
            
            AF.request(imageURL, method: .get).responseImage { response in
                
                guard let image = response.value else {return}
                seal.fulfill(image)
            }
            
        }
    }
    
    
    
    func display(_ user: User, image: UIImage) {
        
        userName.text = "\(user.response[0].firstName) \(user.response[0].lastName)"
        userImage.image = image
        userLocation.text = "\(user.response[0].city.title) \(user.response[0].country.title)"
    }
    
    
    
}

