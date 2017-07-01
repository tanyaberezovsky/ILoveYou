//
//  ViewController.swift
//  ILoveYou
//
//  Created by Tania on 26/06/2017.
//  Copyright © 2017 Tania Berezovski. All rights reserved.
//

import UIKit
import AVFoundation

/// **must** define instance variable outside, because .play() will deallocate AVAudioPlayer
/// immediately and you won't hear a thing
var player: AVAudioPlayer?

class ViewController: UIViewController {

    @IBOutlet weak var buttonSlow: UIButton!
    @IBOutlet weak var buttonRegular: UIButton!
    var slowTriangleImg = true
    var regularTriangleImg = true
    var imgNameTriangle = "triangle.png"
    var imgNameSquare = "square.png"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }

    func initialize(){
        buttonSlow.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        buttonRegular.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        let color2 = UIColor(red: 67/255, green: 148/255, blue: 227/255, alpha: 1.0)
        let color1 = UIColor(red: 98/255, green: 216/255, blue: 202/255, alpha: 1.0)
        self.view.applyGradient(colours: [color1 , color2])
    }
    
    @IBAction func buttonSlow(_ sender: UIButton) {
        let imageName = getImageNameBy(flag: slowTriangleImg)
        slowTriangleImg.toggle()
        buttonSlow.setImage(UIImage(named: imageName), for: .normal)
        playSound(soundName: "loveWordSlow")
    }
   
    @IBAction func buttonRegularTouch(_ sender: UIButton) {
        let imageName = getImageNameBy(flag: regularTriangleImg)
        regularTriangleImg.toggle()
        buttonRegular.setImage(UIImage(named: imageName), for: .normal)
        playSound(soundName: "loveWordVoiceRegular")
    }
    
    func getImageNameBy(flag: Bool)->String{
        if flag{
            return imgNameSquare
        } else {
            return imgNameTriangle
        }
    }
    
    func playSound(soundName: String) {
        guard let sound = NSDataAsset(name: soundName) else {
            print("asset not found")
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(data: sound.data, fileTypeHint: AVFileTypeMPEGLayer3)
            
            player!.play()
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }
}
extension Bool{
    /// Mutates a boolean:
    mutating func toggle() {
        self = !self
    }
}

