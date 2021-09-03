//
//  RoundedImageView.swift
//  ys-client-server-1347
//
//  Created by Ярослав on 13.07.2021.
//

import UIKit
import AVFoundation

class RoundedImageView: UIImageView {
    
    var audioPlayer = AVAudioPlayer()
    
    override func layoutSubviews() {
        self.layer.cornerRadius = self.bounds.width / 2
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunction))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tap)
    }
    
    @IBAction func tapFunction(sender: UITapGestureRecognizer) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "spring", ofType: "mp3") ?? ""))
            audioPlayer.play()
        } catch {
            print(error)
        }
       
        UIView.animate(withDuration: 0.75,
                                    delay: 0,
                                    usingSpringWithDamping: 0.25,
                                    initialSpringVelocity: 0.75,
                                    options: [.allowUserInteraction],
                                    animations: {
                                        self.bounds = self.bounds.insetBy(dx: 20, dy: 20)
                                    },
                                    completion: nil)
    }
}
