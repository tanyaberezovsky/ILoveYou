//
//  UIView.swift
//  ILoveYou
//
//  Created by Tania on 30/06/2017.
//  Copyright © 2017 Tania Berezovski. All rights reserved.
//

import UIKit


extension UIView {
    func applyGradient(colours: [UIColor]) -> Void {
        clipsToBounds = true
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 1, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        layer.insertSublayer(gradient, at: 0)
    }
}
