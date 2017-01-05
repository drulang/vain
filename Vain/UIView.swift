//
//  UIView.swift
//  Vain
//
//  Created by Dru Lang on 12/12/16.
//  Copyright © 2016 Dru Lang. All rights reserved.
//

import UIKit

extension UIView {
    
    func applyShadow() {
        layer.cornerRadius = 30
        layer.shadowRadius = CGFloat(2)
        layer.shadowColor = Appearance.Palette.DarkGray.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowOpacity = 1
    }
    
    func box() {
        layer.borderColor = UIColor.green.cgColor
        layer.borderWidth = 1
    }
    
    func boxTheHellOutOfEverything() {
        box()
        for view in subviews {
            view.boxTheHellOutOfEverything()
        }
    }
}

