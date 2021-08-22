//
//  MenuViewController.swift
//  client-server-1347
//
//  Created by Марк Киричко on 15.07.2021.
//

import UIKit
import Firebase
import AVFoundation

class MenuViewController: UITabBarController, UITabBarControllerDelegate {
    let authService = Auth.auth()
    var audioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.delegate = self
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "windows98", ofType: "mp3") ?? ""))
            audioPlayer.play()
        } catch {
            print(error)
        }
        navigationItem.hidesBackButton = true
    }
}
    

