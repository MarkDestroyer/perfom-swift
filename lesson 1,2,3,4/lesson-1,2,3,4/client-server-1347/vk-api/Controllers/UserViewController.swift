//
//  FriendsViewController.swift
//  client-server-1347
//
//  Created by Artur Igberdin on 12.07.2021.
//

import UIKit
import Alamofire
import AlamofireImage
import Firebase

class UserInfoViewController: UIViewController {
    
    @IBOutlet weak var userImage: RoundedImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var pinIcon: UIImageView!
    @IBOutlet weak var userLocation: UILabel!
    
    let userDB = UserDB()
    
    let ref = Database.database().reference(withPath: "userinfo/users")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let localUser = UserDB().get()
        
        if localUser != nil {
            display(localUser!)
        }
        
        UserAPI(Session.instance).get{ user in
            guard let user = user else { return }
            if user != localUser {
                self.update(user)
                self.addUpdateRemote(user)
            }
        }
    }
    
    private func display(_ user: User) {
        
        self.userName.text = "\(user.firstName) \(user.lastName)"
        self.userLocation.text = "\(user.city), \(user.country)."
        
        if let imageURL = user.imageURL {
            AF.request(imageURL, method: .get).responseImage { response in
                guard let image = response.value else { return }
                self.userImage.image = image
                self.userImage.layer.borderWidth = 3
                self.userImage.layer.borderColor = UIColor.black.cgColor
            }
        }
    }
    
    private func update(_ user: User) {
        
        userDB.addUpdate(user)
        self.display(user)
    }
    
    private func addUpdateRemote(_ user: User) {
        
        let remoteUser = UserFB(id: user.id,
                                firstName: user.firstName,
                                lastName: user.lastName,
                                city: user.city,
                                country: user.country,
                                imageURL: user.imageURL ?? "")
        
        let userRef = ref.child(user.firstName)
        userRef.setValue(remoteUser.toAnyObject())
        
        let alert = UIAlertController(title: "Успех!",
                                      message: "Пользователь \(user.firstName) \(user.lastName) успешно добавлен в Firebase.",
                                      preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Ну дык!",
                                      style: UIAlertAction.Style.default,
                                      handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    
        
    
    }
}

