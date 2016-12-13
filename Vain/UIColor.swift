//
//  UIColor.swift
//  Vain
//
//  Created by Dru Lang on 12/12/16.
//  Copyright © 2016 Dru Lang. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(r:Int, g:Int, b:Int) {
        self.init(r:r, g:g, b:b, a:1)
    }
    
    convenience init(r:Int, g:Int, b:Int, a:CGFloat) {
        self.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: a)
    }
}
