//
//  UIView.swift
//  Vain
//
//  Created by Dru Lang on 12/12/16.
//  Copyright © 2016 Dru Lang. All rights reserved.
//

import UIKit

extension UIView {
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

