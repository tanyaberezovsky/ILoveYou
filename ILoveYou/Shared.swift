//
//  Shared.swift
//  ILoveYou
//
//  Created by Tania on 05/10/2017.
//  Copyright © 2017 Tania Berezovski. All rights reserved.
//

import Foundation

enum icons: String{
    case play = "triangle.png"
    case stop = "square.png"
    
    static func getImageNameBy(number: Int)->String{
        if (number == 0){
            return icons.stop.rawValue
        } else {
            return icons.play.rawValue
        }
    }
}

struct mode {
    static let playing = 0
    static let notPlaying = 1
}
