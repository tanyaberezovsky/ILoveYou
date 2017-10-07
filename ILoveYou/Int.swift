//
//  Int.swift
//  ILoveYou
//
//  Created by Tania on 07/10/2017.
//  Copyright © 2017 Tania Berezovski. All rights reserved.
//

import Foundation

extension Int{
    /// Mutates a int:
    mutating func toggle() {
        self = self == mode.notPlaying ? mode.playing : mode.notPlaying
    }
}
