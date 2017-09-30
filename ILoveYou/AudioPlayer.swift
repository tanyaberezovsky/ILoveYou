//
//  AudioPlayer.swift
//  ILoveYou
//
//  Created by Tania on 14/07/2017.
//  Copyright © 2017 Tania Berezovski. All rights reserved.
//

import UIKit
import AVFoundation

protocol AudioPlayerProtocol{
    func play(_ fileName: String)
    func stop()
}

/// **must** define instance variable outside, because .play() will deallocate AVAudioPlayer
/// immediately and you won't hear a thing
//var player: AVAudioPlayer?

class MyAudioPlayer: NSObject, AudioPlayerProtocol{
    var player: AVAudioPlayer?
    var isPlayingInLoop:Bool = false
    
    override init(){
        super.init()
    }
   
    func play(_ fileName: String) {
        prepareSound(soundName: fileName)
        play()
    }
    
    func prepareSound(soundName: String) {
      
        stop()
        
        isPlayingInLoop = true
        
        guard let sound = NSDataAsset(name: soundName) else {
            print("asset not found")
            return
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(data: sound.data, fileTypeHint: AVFileTypeMPEGLayer3)
            player?.delegate = self
        //    player.numberOfLoops = -1
            player?.prepareToPlay()
            
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
    }
    
    func play() {
        if player?.isPlaying == false {
            player?.play()
        }
    }
    
    func stop() {
        isPlayingInLoop = false
        if (player?.isPlaying == true){
                player?.stop()
        }
    }
    
}
extension MyAudioPlayer : AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        let when = DispatchTime.now() + 2 // change 2 to desired number of seconds to wait
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: when) { [weak self] in
            // Your code with delay
            if (self?.isPlayingInLoop)! {
                self?.play()
            }
        }
//        DispatchQueue.main.asyncAfter(deadline: when) { [weak self] in
//            // Your code with delay
//            if (self?.isPlayingInLoop)! {
//                self?.play()
//            }
//        }
        
    }
}
