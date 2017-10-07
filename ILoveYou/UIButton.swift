//
//  UIButton.swift
//  ILoveYou
//
//  Created by Tania on 07/10/2017.
//  Copyright © 2017 Tania Berezovski. All rights reserved.
//

import UIKit

extension UIButton{
    public func toggleImage(){
        self.tag.toggle()
        let imageName = icons.getImageNameBy(number: self.tag)
        self.setImage(UIImage(named: imageName), for: .normal)
    }
}
