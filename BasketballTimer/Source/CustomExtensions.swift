//
//  CustomExtensions.swift
//  BasketballTimer
//
//  Created by Crisler on 7/6/18.
//  Copyright © 2018 Crisler. All rights reserved.
//

import UIKit

extension UIView {
    public func setCornerRadius(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    public func addBorder(width: CGFloat, color: UIColor) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
        layer.masksToBounds = true
    }
    
    public func makeCircular() {
        setCornerRadius(radius: self.frame.width / 2)
    }
}

