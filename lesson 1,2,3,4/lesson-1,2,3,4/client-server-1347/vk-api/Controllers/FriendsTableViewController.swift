//
//  FriendsTableViewController.swift
//  client-server-1347
//
//  Created by Марк Киричко on 20.07.2021.
//

import UIKit
import RealmSwift
import Firebase
import AVFoundation

class FriendTableViewController: UITableViewController {
    
    var audioPlayer = AVAudioPlayer()
    var friendItems: [FriendItem] = []
    let friendDB = FriendDB()
    let ref = Database.database().reference(withPath: "userinfo/friends")
    var token: NotificationToken?
    
    @IBAction func Play(_ sender: Any) {
        audioPlayer.play()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "spring", ofType: "mp3") ?? ""))
            audioPlayer.prepareToPlay()
        } catch {
            print(error)
        }
        
        let localFriendsResults = friendDB.get()
        
        token = localFriendsResults.observe { (changes: RealmCollectionChange) in
            
            switch changes {
            
            case .initial(let results):
                self.friendItems = Array(results)
                self.tableView.reloadData()
                
            case .update(let results, _, _, _):
                self.friendItems = Array(results)
                self.tableView.reloadData()
                
            case .error(let error):
                print("Error: ", error)
            }
        }
        
        FriendsAPI(Session.instance).get{ [weak self] friends in
            guard let self = self else { return }
            self.friendDB.addUpdate(friends!.response.items)
            friends!.response.items.forEach { self.addUpdateRemoteFriend($0) }

            let alert = UIAlertController(title: "Успех!",
                                          message: "Друзья пользователя успешно добавлены в Firebase.",
                                         preferredStyle: UIAlertController.Style.alert)

           alert.addAction(UIAlertAction(title: "Ну дык!",
                                         style: UIAlertAction.Style.default,
                                          handler: nil))

            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsTableViewCell") as? FriendsTableViewCell
        
        cell!.configure(friendItems[indexPath.row])
        
        
        return cell!
    }
    
    private func addUpdateRemoteFriend(_ friend: FriendItem) {
        let remoteFriend = FriendFB(id: friend.id, name: friend.first_name, imageURL: friend.photo_max!, lastname: friend.last_name)
        
        let groupRef = ref.child(String(friend.id))
        groupRef.setValue(remoteFriend.toAnyObject())
    }
}
