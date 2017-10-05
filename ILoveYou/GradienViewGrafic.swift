//
//  GradienViewGrafic.swift
//  ILoveYou
//
//  Created by Tania on 05/10/2017.
//  Copyright © 2017 Tania Berezovski. All rights reserved.
//

import UIKit

@IBDesignable
open class GradientViewGrafic: UIView {
    @IBInspectable
    public var startColor: UIColor = .white {
        didSet {
            gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
            setNeedsDisplay()
        }
    }
    @IBInspectable
    public var endColor: UIColor = .white {
        didSet {
            gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
            setNeedsDisplay()
        }
    }
    
    private lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [self.startColor.cgColor, self.endColor.cgColor]
        return gradientLayer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    open override func layoutSubviews() {
        gradientLayer.frame = bounds
    }
}
