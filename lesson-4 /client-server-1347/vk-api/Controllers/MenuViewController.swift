//
//  MenuViewController.swift
//  client-server-1347
//
//  Created by Марк Киричко on 15.07.2021.
//

import UIKit
import Firebase
import AVFoundation

class MenuViewController: UITabBarController {
    let authService = Auth.auth()
    var audioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "windows98", ofType: "mp3") ?? ""))
            audioPlayer.play()
        } catch {
            print(error)
        }
        navigationItem.hidesBackButton = true
    }
    
    
    private func showLoginVC() {
        guard let vc = storyboard?.instantiateViewController(identifier: "LoginViewController") else {return}
        guard let window = self.view.window else {return}
        window.rootViewController = vc
    }
    
    
    
    
}
